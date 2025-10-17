import '../models/onboarding_question.dart';
import '../models/onboarding_section.dart';

/// Abstract repository contract for managing onboarding data
///
/// This interface defines the contract for fetching onboarding questions
/// and submitting user answers. Implementations can use different data sources
/// (static data, Supabase, REST API, etc.) without affecting the domain layer.
abstract class OnboardingRepository {
  /// Retrieves the list of onboarding sections with their questions
  ///
  /// Returns a list of [OnboardingSection] that group related questions
  /// to be presented to the user during the onboarding flow.
  ///
  /// Throws an exception if the sections cannot be retrieved.
  Future<List<OnboardingSection>> getOnboardingQuestions();

  /// Submits the user's answers to the onboarding questions
  ///
  /// The [answers] map should contain question IDs as keys and
  /// the user's responses as values. The response format depends
  /// on the question type:
  /// - For text questions: String value
  /// - For multiple choice: String value (selected option)
  /// - For yes/no: bool value
  /// - For multiple selection: List\<String\> value
  ///
  /// Example:
  /// ```dart
  /// {
  ///   'q1': 'Peanuts, Shellfish',
  ///   'q2': 'Coffee',
  ///   'q3': true,
  ///   'q4': ['Morning', 'Evening']
  /// }
  /// ```
  ///
  /// Throws an exception if the submission fails.
  Future<void> submitOnboardingAnswers(Map<String, dynamic> answers);
}
