import 'package:isar/isar.dart';

import '../../domain/models/journal_models.dart';
import '../../domain/models/onboarding_question.dart';
import '../../domain/repositories/onboarding_repository.dart';

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
  Future<List<OnboardingQuestion>> getOnboardingQuestions() async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: simulatedDelay));

    return _dummyQuestions;
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

  /// Dummy onboarding questions mixing medical and concierge types
  static final List<OnboardingQuestion> _dummyQuestions = [
    // Medical Questions
    const OnboardingQuestion(
      id: 'med_001',
      questionText: 'Do you have any known allergies?',
      questionType: QuestionType.text,
      placeholder: 'e.g., Peanuts, Shellfish, Penicillin...',
      isRequired: true,
      category: 'medical',
    ),
    const OnboardingQuestion(
      id: 'med_002',
      questionText: 'Please list any current medications you are taking',
      questionType: QuestionType.text,
      placeholder: 'e.g., Aspirin 81mg daily, Lisinopril 10mg...',
      isRequired: false,
      category: 'medical',
    ),
    const OnboardingQuestion(
      id: 'med_003',
      questionText: 'Do you have any chronic health conditions?',
      questionType: QuestionType.yesNo,
      isRequired: true,
      category: 'medical',
    ),
    const OnboardingQuestion(
      id: 'med_004',
      questionText: 'How would you rate your overall health?',
      questionType: QuestionType.multipleChoice,
      options: ['Excellent', 'Very Good', 'Good', 'Fair', 'Poor'],
      isRequired: true,
      category: 'medical',
    ),

    // Lifestyle/Concierge Questions
    const OnboardingQuestion(
      id: 'life_001',
      questionText: 'Coffee or Tea in the morning?',
      questionType: QuestionType.multipleChoice,
      options: ['Coffee', 'Tea', 'Both', 'Neither', 'Other'],
      isRequired: false,
      category: 'concierge',
    ),
    const OnboardingQuestion(
      id: 'life_002',
      questionText: 'What are your preferred meal times?',
      questionType: QuestionType.multipleSelection,
      options: [
        'Early Morning (5-7 AM)',
        'Morning (7-9 AM)',
        'Midday (12-2 PM)',
        'Afternoon (2-4 PM)',
        'Evening (6-8 PM)',
        'Night (8-10 PM)',
      ],
      isRequired: false,
      category: 'concierge',
    ),
    const OnboardingQuestion(
      id: 'life_003',
      questionText: 'Do you have any dietary preferences or restrictions?',
      questionType: QuestionType.multipleSelection,
      options: [
        'Vegetarian',
        'Vegan',
        'Gluten-Free',
        'Dairy-Free',
        'Kosher',
        'Halal',
        'Keto',
        'Paleo',
        'None',
      ],
      isRequired: true,
      category: 'concierge',
    ),
    const OnboardingQuestion(
      id: 'life_004',
      questionText: 'How often do you exercise?',
      questionType: QuestionType.multipleChoice,
      options: [
        'Daily',
        '4-6 times per week',
        '2-3 times per week',
        'Once a week',
        'Rarely',
        'Never',
      ],
      isRequired: true,
      category: 'lifestyle',
    ),
    const OnboardingQuestion(
      id: 'life_005',
      questionText: 'What is your typical bedtime?',
      questionType: QuestionType.multipleChoice,
      options: [
        'Before 9 PM',
        '9-10 PM',
        '10-11 PM',
        '11 PM-12 AM',
        'After midnight',
      ],
      isRequired: false,
      category: 'lifestyle',
    ),
    const OnboardingQuestion(
      id: 'pref_001',
      questionText: 'Would you like to receive daily wellness reminders?',
      questionType: QuestionType.yesNo,
      isRequired: true,
      category: 'preferences',
    ),
  ];
}
