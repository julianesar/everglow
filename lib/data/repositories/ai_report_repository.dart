import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../remote/ai_report_service.dart';
import '../remote/ai_report_service_provider.dart';
import 'journal_repository.dart';

part 'ai_report_repository.g.dart';

/// Master prompt template for AI report generation.
///
/// This prompt is sent to the AI along with the user's journal data
/// to generate a comprehensive personal growth report.
const String masterPrompt = '''
You are a compassionate and insightful personal growth coach. Your task is to analyze the user's 21-day journey data and create a comprehensive, personalized report.

The user has completed a 21-day self-discovery and personal growth journey. They have:
- Set a single priority for each day
- Answered reflective journal prompts throughout their journey

Please analyze their responses and create a report that includes:

1. **Journey Overview**: Summarize the key themes and patterns you observe across their 21 days.

2. **Priority Analysis**:
   - Identify recurring priorities and focus areas
   - Note how their priorities evolved over time
   - Highlight any shifts in mindset or focus

3. **Growth Insights**:
   - Key realizations and breakthroughs
   - Emotional patterns and progress
   - Areas of significant growth
   - Challenges they faced and how they navigated them

4. **Strengths Identified**:
   - Personal strengths demonstrated through their responses
   - Positive coping mechanisms and strategies they used
   - Moments of resilience and self-awareness

5. **Recommendations for Continued Growth**:
   - Specific, actionable suggestions based on their journey
   - Areas that might benefit from further exploration
   - Practices or habits to maintain or develop
   - Resources or approaches that align with their growth trajectory

6. **Closing Message**:
   - An encouraging, personalized message acknowledging their commitment
   - Affirmation of their progress and potential

Guidelines:
- Be warm, encouraging, and non-judgmental
- Use specific examples from their journal entries
- Avoid generic advice; make everything personalized to their specific journey
- Keep the tone professional yet compassionate
- Structure the report with clear sections and headings
- Aim for approximately 2-3 pages of content

Below is the user's 21-day journey data:

''';

/// Repository for AI report generation operations.
///
/// This repository coordinates between the [JournalRepository] and [AiReportService]
/// to generate comprehensive AI-powered reports about the user's journey.
///
/// The repository:
/// 1. Fetches all user journal data from the local database
/// 2. Combines it with a master prompt template
/// 3. Sends the request to the AI API
/// 4. Returns the generated report text
abstract class AiReportRepository {
  /// Generates a comprehensive AI report based on the user's complete journey data.
  ///
  /// This method:
  /// 1. Retrieves all user data (priorities and journal entries) from [JournalRepository]
  /// 2. Combines the data with the master prompt
  /// 3. Sends the request to the AI API via [AiReportService]
  /// 4. Returns the generated report text
  ///
  /// Returns a [Future<String>] containing the AI-generated report.
  ///
  /// Throws an exception if:
  /// - The journal repository fails to fetch data
  /// - The API request fails
  /// - The response format is invalid
  Future<String> generateFinalReport();
}

/// Implementation of [AiReportRepository] using Isar and Retrofit.
///
/// This class provides the business logic for generating AI reports
/// by coordinating between local data storage and remote API calls.
class AiReportRepositoryImpl implements AiReportRepository {
  /// The journal repository for accessing local user data.
  final JournalRepository _journalRepository;

  /// The AI report service for making API calls.
  final AiReportService _aiReportService;

  /// Creates an instance of [AiReportRepositoryImpl].
  ///
  /// [journalRepository] Repository for accessing local journal data
  /// [aiReportService] Service for making API calls to generate reports
  const AiReportRepositoryImpl({
    required JournalRepository journalRepository,
    required AiReportService aiReportService,
  }) : _journalRepository = journalRepository,
       _aiReportService = aiReportService;

  @override
  Future<String> generateFinalReport() async {
    try {
      // Step 1: Fetch all user data from the local database
      final userData = await _journalRepository.getAllUserData();

      // Step 2: Prepare the request payload
      // Combine the master prompt with the user data
      final requestPayload = {
        'prompt': masterPrompt,
        'userData': userData,
        'format': 'markdown', // Request markdown format for better structure
        'maxLength': 3000, // Approximate word count for 2-3 pages
      };

      // Step 3: Send the request to the AI API
      final response = await _aiReportService.generateReport(requestPayload);

      // Step 4: Return the generated report
      return response.report;
    } catch (e) {
      // Re-throw with more context for debugging
      throw Exception('Failed to generate AI report: $e');
    }
  }
}

/// Provides an instance of [AiReportRepository].
///
/// This provider creates and manages the [AiReportRepositoryImpl] instance,
/// which coordinates between the journal repository and AI service.
///
/// The provider watches both [journalRepositoryProvider] and [aiReportServiceProvider]
/// to ensure all dependencies are available.
///
/// Usage example:
/// ```dart
/// final repo = await ref.read(aiReportRepositoryProvider.future);
/// final report = await repo.generateFinalReport();
/// print(report);
/// ```
@riverpod
Future<AiReportRepository> aiReportRepository(AiReportRepositoryRef ref) async {
  final journalRepository = await ref.watch(journalRepositoryProvider.future);
  final aiReportService = ref.watch(aiReportServiceProvider);

  return AiReportRepositoryImpl(
    journalRepository: journalRepository,
    aiReportService: aiReportService,
  );
}
