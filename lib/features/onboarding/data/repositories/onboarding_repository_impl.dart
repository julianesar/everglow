import 'package:isar/isar.dart';

import '../../../user/data/models/user_model.dart';
import '../../domain/entities/onboarding_question.dart';
import '../../domain/entities/onboarding_section.dart';
import '../../domain/repositories/onboarding_repository.dart';

// MIGRATION TO SUPABASE: Export the new Supabase implementation
export 'onboarding_repository_impl_supabase.dart';

/// Static implementation of [OnboardingRepository]
///
/// This implementation uses hardcoded dummy data for onboarding questions
/// and simulates API calls with delays. It's designed to be easily replaced
/// with a real implementation (e.g., Supabase) without changing the domain layer.
///
/// To switch to a real backend:
/// 1. Create a new implementation (e.g., SupabaseOnboardingRepository)
/// 2. Update the dependency injection configuration
/// 3. No changes needed in the domain or presentation layers
class StaticOnboardingRepository implements OnboardingRepository {
  /// The Isar database instance
  final Isar _isar;

  /// Simulated network delay in milliseconds
  final int simulatedDelay;

  StaticOnboardingRepository(this._isar, {this.simulatedDelay = 500});

  @override
  Future<List<OnboardingSection>> getOnboardingQuestions() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: simulatedDelay));

    return _dummySections;
  }

  @override
  Future<void> submitOnboardingAnswers(Map<String, dynamic> answers) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: simulatedDelay));

    // Mark onboarding as completed in the User model
    await _isar.writeTxn(() async {
      // Get the first user (there should only be one)
      final user = await _isar.users.where().findFirst();

      if (user != null) {
        // Update the existing user
        user.hasCompletedOnboarding = true;
        await _isar.users.put(user);
      } else {
        // Create a new user with onboarding completed
        final newUser = User()..hasCompletedOnboarding = true;
        await _isar.users.put(newUser);
      }
    });

    // In a real implementation, this would send data to Supabase
    // When implementing Supabase:
    // - Store answers in a user_onboarding_answers table
    // - Link to user profile via user_id
    // - Handle network errors and validation
  }

  /// Dummy onboarding sections grouping related questions
  static final List<OnboardingSection> _dummySections = [
    // SECTION 1: MEDICAL INTAKE
    const OnboardingSection(
      title: 'Medical Intake',
      questions: [
        OnboardingQuestion(
          id: 'med_01',
          questionText:
              'Do you have any known allergies to medications, food, or the environment?',
          questionType: QuestionType.text,
          isRequired: true,
          category: 'medical',
        ),
        OnboardingQuestion(
          id: 'med_02',
          questionText:
              'Please list any pre-existing medical conditions we should be aware of.',
          questionType: QuestionType.text,
          isRequired: true,
          category: 'medical',
        ),
        OnboardingQuestion(
          id: 'med_03',
          questionText:
              'Please list any medications or supplements you are currently taking.',
          questionType: QuestionType.text,
          isRequired: true,
          category: 'medical',
        ),
        OnboardingQuestion(
          id: 'med_04',
          questionText:
              'Have you had any major surgeries or medical procedures in the past 5 years?',
          questionType: QuestionType.yesNo,
          isRequired: true,
          category: 'medical',
        ),
        OnboardingQuestion(
          id: 'med_05',
          questionText:
              'Are you currently under a doctor\'s care for a specific health issue?',
          questionType: QuestionType.yesNo,
          isRequired: true,
          category: 'medical',
        ),
      ],
    ),

    // SECTION 2: CONCIERGE & PERSONAL PREFERENCES
    const OnboardingSection(
      title: 'Concierge & Personal Preferences',
      questions: [
        OnboardingQuestion(
          id: 'con_01',
          questionText:
              'To ensure your mornings are perfect, do you prefer: Coffee or a selection of Herbal Teas?',
          questionType: QuestionType.multipleChoice,
          options: ['Coffee', 'Herbal Teas', 'Both'],
          isRequired: true,
          category: 'concierge',
        ),
        OnboardingQuestion(
          id: 'con_02',
          questionText:
              'Do you have any strict dietary restrictions or preferences? (e.g., vegan, gluten-free, keto)',
          questionType: QuestionType.text,
          isRequired: true,
          category: 'concierge',
        ),
        OnboardingQuestion(
          id: 'con_03',
          questionText:
              'For your comfort, how do you prefer your suite\'s temperature?',
          questionType: QuestionType.multipleChoice,
          options: ['Cool', 'Mild', 'Warm'],
          isRequired: true,
          category: 'concierge',
        ),
        OnboardingQuestion(
          id: 'con_04',
          questionText:
              'During your relaxation time, what type of music or sound do you prefer?',
          questionType: QuestionType.multipleChoice,
          options: [
            'Nature Sounds',
            'Classical',
            'Ambient Electronic',
            'Silence',
          ],
          isRequired: true,
          category: 'concierge',
        ),
        OnboardingQuestion(
          id: 'con_05',
          questionText:
              'Is there anything, no matter how small, we can prepare to make your arrival and stay exceptional?',
          questionType: QuestionType.text,
          isRequired: true,
          category: 'concierge',
        ),
      ],
    ),
  ];
}
