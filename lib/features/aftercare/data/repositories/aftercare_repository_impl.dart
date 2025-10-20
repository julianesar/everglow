import 'dart:convert';

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
  })  : _aiReportService = aiReportService,
        _journalRepository = journalRepository,
        _isar = isar;

  @override
  Future<List<Commitment>> extractCommitmentsFromJournal() async {
    // Step 1: Check if commitments are already cached
    final cachedCommitments = await _getCachedCommitments();
    if (cachedCommitments.isNotEmpty) {
      return cachedCommitments;
    }

    // Step 2: Retrieve all user data from the journal repository
    final userData = await _journalRepository.getAllUserData();

    // Step 3: Construct the specialized prompt for commitment extraction
    final extractionPrompt = _buildCommitmentExtractionPrompt();

    // Step 4: Combine the prompt with user data
    final fullPrompt = _combinePromptWithUserData(extractionPrompt, userData);

    // Step 5: Format the request body for Gemini API
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
    final httpResponse = await _aiReportService.generateReport(requestBody);

    // Extract the response data
    final response = httpResponse.data as Map<String, dynamic>;

    // Step 7: Extract the generated text from the response
    final generatedText = _parseGeneratedText(response);

    // Step 8: Parse the JSON response into Commitment objects
    final commitments = _parseCommitmentsFromJson(generatedText);

    // Step 9: Cache the commitments in the User model
    await _cacheCommitments(commitments);

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
  /// [commitments] The list of commitments to cache
  Future<void> _cacheCommitments(List<Commitment> commitments) async {
    final user = await _isar.users.where().findFirst();
    if (user == null) {
      throw StateError('No user found in database');
    }

    final commitmentModels =
        commitments.map((c) => CommitmentModel.fromEntity(c)).toList();

    await _isar.writeTxn(() async {
      user.commitments = commitmentModels;
      await _isar.users.put(user);
    });
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
2. Avoid vague or general statements (e.g., "I will be better" is NOT a commitment)
3. Look for commitments related to:
   - Daily practices or habits
   - Behavioral changes
   - Lifestyle modifications
   - Relationship boundaries
   - Personal growth actions
4. Each commitment should be clearly stated in the user's voice or closely derived from their words
5. Note which day (1, 2, or 3) each commitment came from

OUTPUT FORMAT:
You MUST return ONLY a valid JSON array with this exact structure:
[
  {
    "id": "commitment_1",
    "commitmentText": "The specific commitment in the user's voice",
    "sourceDay": 1
  },
  {
    "id": "commitment_2",
    "commitmentText": "Another specific commitment",
    "sourceDay": 2
  }
]

CRITICAL:
- Return ONLY the JSON array, no additional text, no markdown code blocks, no explanations
- Ensure the JSON is valid and properly formatted
- Extract between 3 and 5 commitments maximum
- Use sequential IDs: commitment_1, commitment_2, etc.

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

      // Parse the JSON
      final decoded = json.decode(cleanedText);

      if (decoded is! List) {
        throw StateError('Expected JSON array, got ${decoded.runtimeType}');
      }

      final commitments = <Commitment>[];
      for (final item in decoded) {
        if (item is! Map<String, dynamic>) {
          throw StateError('Expected JSON object in array');
        }

        final id = item['id'] as String?;
        final commitmentText = item['commitmentText'] as String?;
        final sourceDay = item['sourceDay'] as int?;

        if (id == null || commitmentText == null || sourceDay == null) {
          throw StateError('Missing required fields in commitment JSON');
        }

        commitments.add(Commitment(
          id: id,
          commitmentText: commitmentText,
          sourceDay: sourceDay,
        ));
      }

      if (commitments.isEmpty) {
        throw StateError('No commitments found in JSON response');
      }

      return commitments;
    } catch (e) {
      throw FormatException('Failed to parse commitments from JSON: $e');
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
    AftercareRepositoryRef ref) async {
  final aiReportService = ref.watch(aiReportServiceProvider);
  final journalRepository = await ref.watch(journalRepositoryProvider.future);
  final isar = await ref.watch(isarProvider.future);

  return AftercareRepositoryImpl(
    aiReportService: aiReportService,
    journalRepository: journalRepository,
    isar: isar,
  );
}
