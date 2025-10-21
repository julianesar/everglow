import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:uuid/uuid.dart';

import '../../../../core/network/supabase_provider.dart';
import '../../domain/entities/onboarding_question.dart';
import '../../domain/entities/onboarding_section.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_remote_datasource.dart';

part 'onboarding_repository_impl_supabase.g.dart';

/// Supabase implementation of [OnboardingRepository].
///
/// This class fetches onboarding questions from Supabase and saves user responses.
class SupabaseOnboardingRepository implements OnboardingRepository {
  final OnboardingRemoteDatasource _remoteDatasource;
  final SupabaseClient _supabase;
  final Uuid _uuid;

  const SupabaseOnboardingRepository(
    this._remoteDatasource,
    this._supabase,
    this._uuid,
  );

  String? get _userId => _supabase.auth.currentUser?.id;

  @override
  Future<List<OnboardingSection>> getOnboardingQuestions() async {
    final questionsData = await _remoteDatasource.getOnboardingQuestions();

    // Group questions by category (medical and concierge)
    final medicalQuestions = <OnboardingQuestion>[];
    final conciergeQuestions = <OnboardingQuestion>[];

    for (final questionData in questionsData) {
      final question = OnboardingQuestion(
        id: questionData.id,
        questionText: questionData.questionText,
        questionType: _mapQuestionType(questionData.questionType),
        options: questionData.options.isNotEmpty ? questionData.options : null,
        placeholder: questionData.placeholder,
        isRequired: questionData.isRequired,
        category: questionData.category,
      );

      if (questionData.category == 'medical') {
        medicalQuestions.add(question);
      } else {
        conciergeQuestions.add(question);
      }
    }

    // Create sections
    return [
      OnboardingSection(
        title: 'Medical Information',
        questions: medicalQuestions,
      ),
      OnboardingSection(
        title: 'Concierge Preferences',
        questions: conciergeQuestions,
      ),
    ];
  }

  @override
  Future<void> submitOnboardingAnswers(Map<String, dynamic> answers) async {
    final userId = _userId;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Convert answers to OnboardingResponseData objects
    final responses = <OnboardingResponseData>[];

    for (final entry in answers.entries) {
      final questionId = entry.key;
      final answer = entry.value;

      String? responseText;
      List<String> responseOptions = [];

      if (answer is String) {
        responseText = answer;
      } else if (answer is bool) {
        responseText = answer.toString();
      } else if (answer is List) {
        responseOptions = answer.map((e) => e.toString()).toList();
      }

      responses.add(
        OnboardingResponseData(
          id: _uuid.v4(),
          userId: userId,
          questionId: questionId,
          responseText: responseText,
          responseOptions: responseOptions,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }

    // Save all responses at once
    await _remoteDatasource.saveUserResponses(responses);

    // Also update user_profiles table with has_completed_onboarding flag
    await _supabase.from('user_profiles').upsert({
      'user_id': userId,
      'has_completed_onboarding': true,
    });
  }

  /// Maps Supabase question type string to QuestionType enum.
  QuestionType _mapQuestionType(String type) {
    switch (type) {
      case 'text':
        return QuestionType.text;
      case 'multipleChoice':
        return QuestionType.multipleChoice;
      case 'yesNo':
        return QuestionType.yesNo;
      case 'multipleSelection':
        return QuestionType.multipleSelection;
      default:
        return QuestionType.text;
    }
  }
}

/// Provides the onboarding remote datasource.
@riverpod
OnboardingRemoteDatasource onboardingRemoteDatasource(
    OnboardingRemoteDatasourceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return OnboardingRemoteDatasource(supabase);
}

/// Provides an instance of [OnboardingRepository].
@riverpod
Future<OnboardingRepository> onboardingRepository(
    OnboardingRepositoryRef ref) async {
  final datasource = ref.watch(onboardingRemoteDatasourceProvider);
  final supabase = ref.watch(supabaseClientProvider);
  final uuid = const Uuid();
  return SupabaseOnboardingRepository(datasource, supabase, uuid);
}
