import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/isar_provider.dart';
import '../../../../core/network/ai_report_service.dart';
import '../../../../core/network/ai_report_service_provider.dart';
import '../../../journal/data/repositories/journal_repository_impl.dart';
import '../../../journal/domain/repositories/journal_repository.dart';
import '../../../user/data/models/user_model.dart';
import '../../domain/entities/commitment.dart';
import '../../domain/repositories/aftercare_repository.dart';
import '../models/commitment_model.dart';

part 'aftercare_repository_impl.g.dart';

/// Repository responsible for extracting and managing user commitments from journal entries.
///
/// This repository orchestrates the commitment extraction process by:
/// 1. Checking if commitments are already cached in the User model
/// 2. If not cached, fetching all user journal data from [JournalRepository]
/// 3. Constructing a specialized prompt for AI to extract commitments
/// 4. Sending the request to Google's Gemini API via [AiReportService]
/// 5. Parsing the JSON response into [Commitment] objects
/// 6. Caching the results in the User model to avoid redundant AI calls
class AftercareRepositoryImpl implements AftercareRepository {
  /// The service for communicating with the Gemini API.
  final AiReportService _aiReportService;

  /// The repository for accessing user journal data.
  final JournalRepository _journalRepository;

  /// The Isar database instance for caching commitments.
  final Isar _isar;

  /// Creates an instance of [AftercareRepositoryImpl].
  ///
  /// [aiReportService] Service for making API calls to Gemini
  /// [journalRepository] Repository for fetching user journal data
  /// [isar] Database instance for caching commitments
  const AftercareRepositoryImpl({
    required AiReportService aiReportService,
    required JournalRepository journalRepository,
    required Isar isar,
  }) : _aiReportService = aiReportService,
       _journalRepository = journalRepository,
       _isar = isar;

  @override
  Future<List<Commitment>> extractCommitmentsFromJournal({
    bool forceRefresh = false,
  }) async {
    debugPrint('[AftercareRepository] === STARTING COMMITMENT EXTRACTION ===');
    debugPrint('[AftercareRepository] Force refresh: $forceRefresh');

    // Step 1: Check if commitments are already cached (unless force refresh)
    if (!forceRefresh) {
      debugPrint('[AftercareRepository] Checking cache...');
      final cachedCommitments = await _getCachedCommitments();
      if (cachedCommitments.isNotEmpty) {
        debugPrint('[AftercareRepository] Found ${cachedCommitments.length} cached commitments. Returning cache.');
        return cachedCommitments;
      }
      debugPrint('[AftercareRepository] No cached commitments found.');
    } else {
      debugPrint('[AftercareRepository] Skipping cache check (force refresh enabled).');
    }

    // Step 2: Retrieve all user data from the journal repository
    debugPrint('[AftercareRepository] Fetching user journal data...');
    final userData = await _journalRepository.getAllUserData();
    debugPrint('[AftercareRepository] User data retrieved:');
    debugPrint('[AftercareRepository] ${_formatUserDataAsJson(userData)}');

    // Check if user data is empty
    if (userData.isEmpty) {
      debugPrint('[AftercareRepository] ⚠️ WARNING: User data is empty! No journal entries found.');
      return [];
    }

    // Step 3: Construct the specialized prompt for commitment extraction
    debugPrint('[AftercareRepository] Building extraction prompt...');
    final extractionPrompt = _buildCommitmentExtractionPrompt();

    // Step 4: Combine the prompt with user data
    debugPrint('[AftercareRepository] Combining prompt with user data...');
    final fullPrompt = _combinePromptWithUserData(extractionPrompt, userData);

    // Step 5: Format the request body for Gemini API
    debugPrint('[AftercareRepository] Formatting API request...');
    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': fullPrompt},
          ],
        },
      ],
      'generationConfig': {
        'temperature': 0.7,
        'topK': 40,
        'topP': 0.95,
        'maxOutputTokens': 2048,
      },
    };

    // Step 6: Call the AI service and parse the response
    debugPrint('[AftercareRepository] Calling Gemini API...');
    final httpResponse = await _aiReportService.generateReport(requestBody);
    debugPrint('[AftercareRepository] API call successful.');

    // Extract the response data
    final response = httpResponse.data as Map<String, dynamic>;

    // Step 7: Extract the generated text from the response
    debugPrint('[AftercareRepository] Parsing API response...');
    final generatedText = _parseGeneratedText(response);
    debugPrint('[AftercareRepository] Generated text length: ${generatedText.length} characters');

    // Step 8: Parse the JSON response into Commitment objects
    debugPrint('[AftercareRepository] Parsing commitments from JSON...');
    final commitments = _parseCommitmentsFromJson(generatedText);
    debugPrint('[AftercareRepository] Successfully parsed ${commitments.length} commitments.');

    // Step 9: Cache the commitments in the User model
    debugPrint('[AftercareRepository] Caching commitments...');
    await _cacheCommitments(commitments);
    debugPrint('[AftercareRepository] Commitments cached successfully.');

    debugPrint('[AftercareRepository] === COMMITMENT EXTRACTION COMPLETED ===');
    return commitments;
  }

  /// Retrieves cached commitments from the User model if they exist.
  ///
  /// Returns a list of [Commitment] entities if cached, or an empty list if not.
  Future<List<Commitment>> _getCachedCommitments() async {
    final user = await _isar.users.where().findFirst();
    if (user == null || user.commitments.isEmpty) {
      return [];
    }

    return user.commitments.map((model) => model.toEntity()).toList();
  }

  /// Caches the extracted commitments in the User model.
  ///
  /// If no User exists in the local database, this method creates one first.
  /// This ensures backward compatibility and handles the case where users
  /// authenticated via Supabase but don't have a local User record yet.
  ///
  /// [commitments] The list of commitments to cache
  Future<void> _cacheCommitments(List<Commitment> commitments) async {
    debugPrint('[AftercareRepository] Caching commitments...');

    var user = await _isar.users.where().findFirst();

    // If no user exists in local database, create one
    if (user == null) {
      debugPrint('[AftercareRepository] No local user found. Creating new user record...');
      user = User();
      await _isar.writeTxn(() async {
        await _isar.users.put(user!);
      });
      debugPrint('[AftercareRepository] Local user record created successfully.');
    }

    final commitmentModels = commitments
        .map((c) => CommitmentModel.fromEntity(c))
        .toList();

    await _isar.writeTxn(() async {
      user!.commitments = commitmentModels;
      await _isar.users.put(user);
    });

    debugPrint('[AftercareRepository] Successfully cached ${commitmentModels.length} commitments.');
  }

  /// Builds the specialized prompt for extracting commitments from journal data.
  ///
  /// The prompt instructs the AI to:
  /// - Act as an analyst specialized in identifying actionable commitments
  /// - Read through all journal entries carefully
  /// - Extract 3-5 key, specific, actionable commitments the user made
  /// - Return the results as a structured JSON array
  String _buildCommitmentExtractionPrompt() {
    return '''
You are an expert analyst specializing in identifying actionable commitments from personal journal entries.

Your task is to carefully read through the user's journal entries from their 3-day EverGlow Rebirth Protocol and extract 3-5 key, actionable commitments they have made.

IMPORTANT GUIDELINES:
1. Focus on SPECIFIC, ACTIONABLE commitments (e.g., "I will meditate 15 minutes daily", "I will not check work emails on weekends")
2. If the journal entries are brief or simple words (like "love", "peace", "healing"), interpret them as VALUES or INTENTIONS and transform them into actionable commitments (e.g., "love" → "I will practice self-love daily", "peace" → "I will create peaceful moments each day")
3. Look for commitments related to:
   - Daily practices or habits
   - Behavioral changes
   - Lifestyle modifications
   - Relationship boundaries
   - Personal growth actions
   - Emotional or spiritual practices
4. Each commitment should be stated as an actionable "I will..." statement
5. Note which day (1, 2, or 3) each commitment came from
6. ALWAYS extract at least 3 commitments, even if you need to infer them from the user's values and intentions

OUTPUT FORMAT:
You MUST return ONLY a valid JSON array with this exact structure:
[
  {
    "id": "commitment_1",
    "commitmentText": "I will practice self-love through daily affirmations",
    "sourceDay": 1
  },
  {
    "id": "commitment_2",
    "commitmentText": "I will create peaceful moments by meditating each morning",
    "sourceDay": 2
  },
  {
    "id": "commitment_3",
    "commitmentText": "I will prioritize my healing journey by setting healthy boundaries",
    "sourceDay": 3
  }
]

CRITICAL:
- Return ONLY the JSON array, no additional text, no markdown code blocks, no explanations
- Ensure the JSON is valid and properly formatted
- Extract EXACTLY 3 to 5 commitments (never return an empty array)
- Use sequential IDs: commitment_1, commitment_2, etc.
- If entries are unclear, interpret them positively as intentions and create meaningful commitments

--- USER DATA ---
{user_data_json_string}
--- END OF USER DATA ---

Extract the commitments now and return ONLY the JSON array:
''';
  }

  /// Combines the extraction prompt with user data into a single prompt string.
  ///
  /// [extractionPrompt] The instruction prompt for the AI containing the placeholder
  /// [userData] The structured user data from the journal repository
  ///
  /// Returns the complete formatted prompt with user data injected.
  String _combinePromptWithUserData(
    String extractionPrompt,
    Map<String, dynamic> userData,
  ) {
    final userDataJsonString = _formatUserDataAsJson(userData);
    return extractionPrompt.replaceAll(
      '{user_data_json_string}',
      userDataJsonString,
    );
  }

  /// Serializes user data into a clean JSON string for the AI prompt.
  ///
  /// [userData] The structured user data from the journal repository
  ///
  /// Returns a JSON string representation of the user's journey data.
  String _formatUserDataAsJson(Map<String, dynamic> userData) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(userData);
  }

  /// Parses the generated text from the Gemini API response.
  ///
  /// [response] The raw response map from the API
  ///
  /// Returns the extracted text content.
  ///
  /// Throws [StateError] if the response structure doesn't match expectations.
  String _parseGeneratedText(Map<String, dynamic> response) {
    try {
      final candidates = response['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        throw StateError('No candidates in API response');
      }

      final firstCandidate = candidates[0] as Map<String, dynamic>;
      final content = firstCandidate['content'] as Map<String, dynamic>?;
      if (content == null) {
        throw StateError('No content in API response candidate');
      }

      final parts = content['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        throw StateError('No parts in API response content');
      }

      final firstPart = parts[0] as Map<String, dynamic>;
      final text = firstPart['text'] as String?;
      if (text == null || text.isEmpty) {
        throw StateError('No text in API response part');
      }

      return text;
    } catch (e) {
      throw StateError('Failed to parse API response: $e');
    }
  }

  /// Parses the AI-generated JSON text into a list of [Commitment] objects.
  ///
  /// The AI is instructed to return a JSON array with the following structure:
  /// ```json
  /// [
  ///   {
  ///     "id": "commitment_1",
  ///     "commitmentText": "I will meditate 15 minutes daily",
  ///     "sourceDay": 1
  ///   }
  /// ]
  /// ```
  ///
  /// [jsonText] The raw JSON text from the AI
  ///
  /// Returns a list of [Commitment] entities.
  ///
  /// Throws [FormatException] if the JSON is invalid.
  /// Throws [StateError] if the JSON structure doesn't match expectations.
  List<Commitment> _parseCommitmentsFromJson(String jsonText) {
    try {
      // Clean the text: remove markdown code blocks if present
      String cleanedText = jsonText.trim();
      if (cleanedText.startsWith('```json')) {
        cleanedText = cleanedText.substring(7);
      }
      if (cleanedText.startsWith('```')) {
        cleanedText = cleanedText.substring(3);
      }
      if (cleanedText.endsWith('```')) {
        cleanedText = cleanedText.substring(0, cleanedText.length - 3);
      }
      cleanedText = cleanedText.trim();

      // Debug: log the cleaned text to understand what AI returned
      debugPrint('[AftercareRepository] Cleaned AI response text:');
      debugPrint(cleanedText);

      // Parse the JSON
      final decoded = json.decode(cleanedText);

      if (decoded is! List) {
        throw StateError(
          'Expected JSON array, got ${decoded.runtimeType}. Content: $decoded',
        );
      }

      final commitments = <Commitment>[];
      final errors = <String>[];

      for (int i = 0; i < decoded.length; i++) {
        final item = decoded[i];

        if (item is! Map<String, dynamic>) {
          errors.add('Item $i: Expected JSON object, got ${item.runtimeType}');
          continue;
        }

        final id = item['id'] as String?;
        final commitmentText = item['commitmentText'] as String?;
        final sourceDay = item['sourceDay'] as int?;

        if (id == null || commitmentText == null || sourceDay == null) {
          errors.add(
            'Item $i: Missing required fields. '
            'id=${id != null ? 'present' : 'missing'}, '
            'commitmentText=${commitmentText != null ? 'present' : 'missing'}, '
            'sourceDay=${sourceDay != null ? 'present' : 'missing'}',
          );
          continue;
        }

        commitments.add(
          Commitment(
            id: id,
            commitmentText: commitmentText,
            sourceDay: sourceDay,
          ),
        );
      }

      // Log any parsing errors
      if (errors.isNotEmpty) {
        debugPrint('[AftercareRepository] Parsing errors:');
        for (final error in errors) {
          debugPrint('  - $error');
        }
      }

      // If no commitments were found, log the reason and return empty list
      // The UI will handle the empty state gracefully
      if (commitments.isEmpty) {
        if (errors.isNotEmpty) {
          debugPrint(
            '[AftercareRepository] No valid commitments parsed. '
            'Errors: ${errors.join('; ')}',
          );
        } else {
          debugPrint(
            '[AftercareRepository] AI returned an empty commitments array. '
            'The user may not have made any specific commitments in their '
            'journal entries yet.',
          );
        }
      }

      return commitments;
    } catch (e) {
      if (e is StateError) {
        rethrow; // Preserve StateError messages
      }
      throw FormatException(
        'Failed to parse commitments from JSON. Error: $e. '
        'Raw text (first 500 chars): ${jsonText.substring(0, jsonText.length > 500 ? 500 : jsonText.length)}',
      );
    }
  }
}

/// Provides an instance of [AftercareRepository].
///
/// This provider creates and manages the [AftercareRepositoryImpl] instance,
/// injecting the required dependencies ([AiReportService], [JournalRepository], and [Isar]).
///
/// Usage example:
/// ```dart
/// final aftercareRepo = await ref.read(aftercareRepositoryProvider.future);
/// final commitments = await aftercareRepo.extractCommitmentsFromJournal();
/// ```
@riverpod
Future<AftercareRepository> aftercareRepository(
  AftercareRepositoryRef ref,
) async {
  final aiReportService = ref.watch(aiReportServiceProvider);
  final journalRepository = await ref.watch(journalRepositoryProvider.future);
  final isar = await ref.watch(isarProvider.future);

  return AftercareRepositoryImpl(
    aiReportService: aiReportService,
    journalRepository: journalRepository,
    isar: isar,
  );
}
