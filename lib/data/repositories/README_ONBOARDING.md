# Onboarding Repository

## Overview

The onboarding repository follows Clean Architecture principles and is designed to be easily switchable between different data sources (static data, Supabase, REST API, etc.).

## Architecture

```
lib/
├── domain/
│   ├── models/
│   │   └── onboarding_question.dart    # Entity (domain model)
│   └── repositories/
│       └── onboarding_repository.dart  # Repository interface (contract)
└── data/
    └── repositories/
        └── static_onboarding_repository.dart  # Implementation with dummy data
```

## Usage Example

### 1. Basic Usage (without dependency injection)

```dart
import 'package:everglow_app/domain/repositories/onboarding_repository.dart';
import 'package:everglow_app/data/repositories/static_onboarding_repository.dart';

void main() async {
  // Create repository instance
  final OnboardingRepository repository = StaticOnboardingRepository();

  // Fetch questions
  final questions = await repository.getOnboardingQuestions();

  print('Total questions: ${questions.length}');

  // Submit answers
  final answers = {
    'med_001': 'Peanuts, Shellfish',
    'med_002': 'Aspirin 81mg daily',
    'med_003': false,
    'med_004': 'Excellent',
    'life_001': 'Coffee',
    'life_002': ['Morning (7-9 AM)', 'Evening (6-8 PM)'],
    'life_003': ['Vegetarian', 'Gluten-Free'],
    'life_004': '4-6 times per week',
    'life_005': '10-11 PM',
    'pref_001': true,
  };

  await repository.submitOnboardingAnswers(answers);
}
```

### 2. With Riverpod (Recommended)

First, create a provider:

```dart
// lib/data/repositories/onboarding_repository_provider.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/onboarding_repository.dart';
import 'static_onboarding_repository.dart';

part 'onboarding_repository_provider.g.dart';

@riverpod
OnboardingRepository onboardingRepository(OnboardingRepositoryRef ref) {
  // Return static implementation for now
  return StaticOnboardingRepository();

  // When switching to Supabase, just change this line:
  // return SupabaseOnboardingRepository(
  //   supabaseClient: ref.watch(supabaseClientProvider),
  // );
}
```

Then use it in your widgets:

```dart
class OnboardingScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(onboardingRepositoryProvider);

    return FutureBuilder(
      future: repository.getOnboardingQuestions(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final questions = snapshot.data!;
          // Build your UI with questions
        }
        // Handle loading and error states
      },
    );
  }
}
```

### 3. In a Controller/Notifier

```dart
@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<List<OnboardingQuestion>> build() async {
    final repository = ref.watch(onboardingRepositoryProvider);
    return repository.getOnboardingQuestions();
  }

  Future<void> submitAnswers(Map<String, dynamic> answers) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(onboardingRepositoryProvider);
      await repository.submitOnboardingAnswers(answers);
      state = AsyncValue.data(await repository.getOnboardingQuestions());
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
```

## Question Types

The repository supports multiple question types:

1. **text** - Free text input
2. **multipleChoice** - Single selection from options
3. **yesNo** - Boolean yes/no question
4. **multipleSelection** - Multiple selections from options

## Current Questions

The static implementation includes 10 questions across 4 categories:

- **Medical** (4 questions): Allergies, medications, chronic conditions, health rating
- **Concierge** (3 questions): Coffee/tea preference, meal times, dietary restrictions
- **Lifestyle** (2 questions): Exercise frequency, bedtime
- **Preferences** (1 question): Wellness reminders

## Switching to Supabase

When ready to implement Supabase backend:

### 1. Create Supabase tables

```sql
-- Onboarding questions table
CREATE TABLE onboarding_questions (
  id TEXT PRIMARY KEY,
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL,
  options JSONB,
  placeholder TEXT,
  is_required BOOLEAN DEFAULT true,
  category TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- User answers table
CREATE TABLE user_onboarding_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  question_id TEXT REFERENCES onboarding_questions(id),
  answer JSONB NOT NULL,
  answered_at TIMESTAMP DEFAULT NOW()
);
```

### 2. Create SupabaseOnboardingRepository

```dart
class SupabaseOnboardingRepository implements OnboardingRepository {
  final SupabaseClient _client;

  SupabaseOnboardingRepository(this._client);

  @override
  Future<List<OnboardingQuestion>> getOnboardingQuestions() async {
    final response = await _client
        .from('onboarding_questions')
        .select()
        .order('id');

    return response
        .map((json) => OnboardingQuestionModel.fromJson(json).toEntity())
        .toList();
  }

  @override
  Future<void> submitOnboardingAnswers(Map<String, dynamic> answers) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    final rows = answers.entries.map((entry) => {
      'user_id': userId,
      'question_id': entry.key,
      'answer': entry.value,
    }).toList();

    await _client.from('user_onboarding_answers').insert(rows);
  }
}
```

### 3. Update provider

```dart
@riverpod
OnboardingRepository onboardingRepository(OnboardingRepositoryRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseOnboardingRepository(supabase);
}
```

**That's it!** No changes needed in:
- Domain layer (entities, repository interface)
- Presentation layer (controllers, widgets)
- Business logic

This is the power of Clean Architecture! 🎉
