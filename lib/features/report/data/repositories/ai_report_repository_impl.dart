import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/isar_provider.dart';
import '../../../../core/network/ai_report_service.dart';
import '../../../../core/network/ai_report_service_provider.dart';
import '../../../journal/domain/repositories/journal_repository.dart';
import '../../../journal/data/repositories/journal_repository_impl.dart';
import '../../../user/data/models/user_model.dart';

part 'ai_report_repository_impl.g.dart';

/// Repository responsible for generating comprehensive AI-powered transformation reports.
///
/// This repository orchestrates the report generation process by:
/// 1. Checking if a report is already cached in the User model
/// 2. If not cached, fetching all user journal data from [JournalRepository]
/// 3. Constructing a detailed prompt for the AI
/// 4. Sending the request to Google's Gemini API via [AiReportService]
/// 5. Caching the result in the User model
/// 6. Parsing and returning the generated report text
///
/// The repository acts as the single source of truth for AI report generation,
/// encapsulating the business logic of prompt construction and response handling.
class AIReportRepository {
  /// The service for communicating with the Gemini API.
  final AiReportService _aiReportService;

  /// The repository for accessing user journal data.
  final JournalRepository _journalRepository;

  /// The Isar database instance for caching reports.
  final Isar _isar;

  /// Creates an instance of [AIReportRepository].
  ///
  /// [aiReportService] Service for making API calls to Gemini
  /// [journalRepository] Repository for fetching user journal data
  /// [isar] Database instance for caching reports
  const AIReportRepository({
    required AiReportService aiReportService,
    required JournalRepository journalRepository,
    required Isar isar,
  }) : _aiReportService = aiReportService,
       _journalRepository = journalRepository,
       _isar = isar;

  /// Generates a comprehensive transformation report based on all user data.
  ///
  /// This method orchestrates the entire report generation workflow:
  /// 1. Checks if a report is already cached (unless forceRefresh is true)
  /// 2. Retrieves all user journal entries and priorities from the database
  /// 3. Constructs a master prompt instructing the AI to act as a compassionate coach
  /// 4. Combines the prompt with user data into a comprehensive context
  /// 5. Formats the request according to Gemini API specifications
  /// 6. Sends the request and parses the response
  /// 7. Caches the report in the User model
  ///
  /// [forceRefresh] If true, bypasses the cache and regenerates the report
  ///
  /// Returns the generated report text as a String.
  ///
  /// Throws:
  /// - [Exception] if the API call fails
  /// - [FormatException] if the response cannot be parsed
  /// - [StateError] if the response structure is unexpected
  ///
  /// Example usage:
  /// ```dart
  /// final repository = await ref.read(aiReportRepositoryProvider.future);
  /// try {
  ///   final report = await repository.generateFinalReport();
  ///   print(report);
  /// } catch (e) {
  ///   print('Failed to generate report: $e');
  /// }
  /// ```
  Future<String> generateFinalReport({bool forceRefresh = false}) async {
    debugPrint('[AIReportRepository] === STARTING REPORT GENERATION ===');
    debugPrint('[AIReportRepository] Force refresh: $forceRefresh');

    // Step 1: Check if report is already cached (unless force refresh)
    if (!forceRefresh) {
      debugPrint('[AIReportRepository] Checking cache...');
      final cachedReport = await _getCachedReport();
      if (cachedReport != null && cachedReport.isNotEmpty) {
        debugPrint('[AIReportRepository] Found cached report. Returning cache.');
        return cachedReport;
      }
      debugPrint('[AIReportRepository] No cached report found.');
    } else {
      debugPrint('[AIReportRepository] Skipping cache check (force refresh enabled).');
    }

    // Step 2: Retrieve all user data from the journal repository
    debugPrint('[AIReportRepository] Fetching user journal data...');
    final userData = await _journalRepository.getAllUserData();

    // Step 3: Construct the master prompt
    debugPrint('[AIReportRepository] Building master prompt...');
    final masterPrompt = _buildMasterPrompt();

    // Step 4: Combine the master prompt with user data
    debugPrint('[AIReportRepository] Combining prompt with user data...');
    final fullPrompt = _combinePromptWithUserData(masterPrompt, userData);

    // Step 5: Format the request body for Gemini API
    debugPrint('[AIReportRepository] Formatting API request...');
    // The Gemini API expects this exact structure:
    // {"contents": [{"parts": [{"text": "YOUR_FULL_PROMPT_STRING"}]}]}
    final requestBody = {
      'contents': [
        {
          'parts': [
            {'text': fullPrompt},
          ],
        },
      ],
    };

    // Step 6: Call the AI service and parse the response
    debugPrint('[AIReportRepository] Calling Gemini API...');
    final httpResponse = await _aiReportService.generateReport(requestBody);
    debugPrint('[AIReportRepository] API call successful.');

    // Extract the response data
    final response = httpResponse.data as Map<String, dynamic>;

    // Step 7: Extract the generated text from the response
    debugPrint('[AIReportRepository] Parsing API response...');
    final generatedText = _parseGeneratedText(response);
    debugPrint('[AIReportRepository] Generated text length: ${generatedText.length} characters');

    // Step 8: Cache the report in the User model
    debugPrint('[AIReportRepository] Caching report...');
    await _cacheReport(generatedText);
    debugPrint('[AIReportRepository] Report cached successfully.');

    debugPrint('[AIReportRepository] === REPORT GENERATION COMPLETED ===');
    return generatedText;
  }

  /// Retrieves cached report from the User model if it exists.
  ///
  /// Returns the cached report string if it exists, or null if not.
  Future<String?> _getCachedReport() async {
    final user = await _isar.users.where().findFirst();
    return user?.generatedReport;
  }

  /// Caches the generated report in the User model.
  ///
  /// [report] The report text to cache
  Future<void> _cacheReport(String report) async {
    final user = await _isar.users.where().findFirst();
    if (user == null) {
      throw StateError('No user found in database');
    }

    await _isar.writeTxn(() async {
      user.generatedReport = report;
      await _isar.users.put(user);
    });
  }

  /// Builds the master prompt that instructs the AI on how to generate the report.
  ///
  /// The prompt instructs the AI to:
  /// - Act as 'EverGlow AI Guide', an insightful and compassionate transformation coach
  /// - Synthesize the user's 3-day 'EverGlow Rebirth Protocol' journey
  /// - Create a cohesive, empowering, and deeply personal final report
  /// - Structure the report with specific sections for each day
  /// - Weave the user's own words into the narrative
  /// - Connect released patterns with new identity anchoring
  String _buildMasterPrompt() {
    return '''
You are an insightful and compassionate transformation coach. Your name is 'EverGlow AI Guide'.
Your task is to synthesize a user's personal reflections from their 3-day 'EverGlow Rebirth Protocol' into a cohesive, empowering, and deeply personal final report. The report must be a celebration of their journey, not just a summary of their answers.
GUIDELINES:
Title: The report must begin with the title: # Your Rebirth Protocol.
Structure: Structure the report with a powerful introduction, followed by three distinct sections titled ## Day 1: The Great Release, ## Day 2: The Courage to Rise, and ## Day 3: Anchoring the Rebirth. Conclude with a short, forward-looking summary called ## Your New Standard.
Tone: The tone must be inspiring, personal, and insightful. Weave the user's own words and phrases (provided below) into the narrative to make it feel deeply resonant. Connect the dots between what they released, how they chose to rise, and the new identity they are anchoring.
Action: Do NOT simply list the user's answers. Interpret and connect them into a flowing narrative. For example, if they released a 'fear of failure' and their new identity is a 'bold creator', connect those two points directly.
Source of Truth: Use ONLY the user data provided below. Do not add generic advice or information not derived from their inputs.
--- USER DATA ---
{user_data_json_string}
--- END OF USER DATA ---
Begin the report now.
''';
  }

  /// Combines the master prompt with user data into a single prompt string.
  ///
  /// This method serializes the [userData] map into a clean JSON string and injects
  /// it into the {user_data_json_string} placeholder within the [masterPrompt].
  ///
  /// [masterPrompt] The instruction prompt for the AI containing the placeholder
  /// [userData] The structured user data from the journal repository
  ///
  /// Returns the complete formatted prompt with user data injected.
  String _combinePromptWithUserData(
    String masterPrompt,
    Map<String, dynamic> userData,
  ) {
    // Import dart:convert is needed at the top of the file for json encoding
    // Convert user data map to a clean JSON string
    final userDataJsonString = _formatUserDataAsJson(userData);

    // Inject the JSON string into the placeholder in the master prompt
    return masterPrompt.replaceAll(
      '{user_data_json_string}',
      userDataJsonString,
    );
  }

  /// Serializes user data into a clean JSON string for the AI prompt.
  ///
  /// Converts the structured map into a JSON string representation that the AI
  /// can parse and understand. The JSON format ensures data integrity and makes
  /// it easier for the AI to extract structured information.
  ///
  /// [userData] The structured user data from the journal repository
  ///
  /// Returns a JSON string representation of the user's journey data.
  String _formatUserDataAsJson(Map<String, dynamic> userData) {
    // Use JsonEncoder with indentation for better readability
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(userData);
  }

  /// Parses the generated text from the Gemini API response.
  ///
  /// The expected response structure is:
  /// ```json
  /// {
  ///   "candidates": [
  ///     {
  ///       "content": {
  ///         "parts": [
  ///           {"text": "The generated report text..."}
  ///         ]
  ///       }
  ///     }
  ///   ]
  /// }
  /// ```
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
}

/// Provides an instance of [AIReportRepository].
///
/// This provider creates and manages the [AIReportRepository] instance,
/// injecting the required dependencies ([AiReportService], [JournalRepository], and [Isar]).
///
/// The provider watches [aiReportServiceProvider], [journalRepositoryProvider],
/// and [isarProvider] to get the necessary dependencies.
///
/// Usage example:
/// ```dart
/// final aiReportRepo = await ref.read(aiReportRepositoryProvider.future);
/// final report = await aiReportRepo.generateFinalReport();
/// ```
@riverpod
Future<AIReportRepository> aiReportRepository(AiReportRepositoryRef ref) async {
  final aiReportService = ref.watch(aiReportServiceProvider);
  final journalRepository = await ref.watch(journalRepositoryProvider.future);
  final isar = await ref.watch(isarProvider.future);

  return AIReportRepository(
    aiReportService: aiReportService,
    journalRepository: journalRepository,
    isar: isar,
  );
}
