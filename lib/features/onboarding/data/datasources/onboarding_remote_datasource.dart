import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for onboarding questions and responses using Supabase.
class OnboardingRemoteDatasource {
  final SupabaseClient _supabase;

  OnboardingRemoteDatasource(this._supabase);

  /// Fetches all onboarding questions ordered by display_order.
  Future<List<OnboardingQuestionData>> getOnboardingQuestions() async {
    try {
      final response = await _supabase
          .from('onboarding_questions')
          .select()
          .order('display_order', ascending: true);

      return (response as List)
          .map((json) => OnboardingQuestionData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch onboarding questions: $e');
    }
  }

  /// Fetches onboarding questions by category (medical or concierge).
  Future<List<OnboardingQuestionData>> getQuestionsByCategory(
      String category) async {
    try {
      final response = await _supabase
          .from('onboarding_questions')
          .select()
          .eq('category', category)
          .order('display_order', ascending: true);

      return (response as List)
          .map((json) => OnboardingQuestionData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch onboarding questions: $e');
    }
  }

  /// Fetches user responses to onboarding questions.
  Future<List<OnboardingResponseData>> getUserResponses(
      String userId) async {
    try {
      final response = await _supabase
          .from('user_onboarding_responses')
          .select()
          .eq('user_id', userId);

      return (response as List)
          .map((json) => OnboardingResponseData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user responses: $e');
    }
  }

  /// Saves or updates a user response to an onboarding question.
  Future<OnboardingResponseData> saveUserResponse(
      OnboardingResponseData response) async {
    try {
      final result = await _supabase
          .from('user_onboarding_responses')
          .upsert(response.toJson())
          .select()
          .single();

      return OnboardingResponseData.fromJson(result);
    } catch (e) {
      throw Exception('Failed to save user response: $e');
    }
  }

  /// Saves multiple user responses at once.
  Future<void> saveUserResponses(
      List<OnboardingResponseData> responses) async {
    try {
      await _supabase
          .from('user_onboarding_responses')
          .upsert(responses.map((r) => r.toJson()).toList());
    } catch (e) {
      throw Exception('Failed to save user responses: $e');
    }
  }

  /// Deletes all user responses (for GDPR compliance).
  Future<void> deleteUserResponses(String userId) async {
    try {
      await _supabase
          .from('user_onboarding_responses')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete user responses: $e');
    }
  }
}

/// Data model for onboarding questions.
class OnboardingQuestionData {
  final String id;
  final String questionText;
  final String questionType;
  final String category;
  final List<String> options;
  final String? placeholder;
  final bool isRequired;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  OnboardingQuestionData({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.category,
    required this.options,
    this.placeholder,
    required this.isRequired,
    required this.displayOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OnboardingQuestionData.fromJson(Map<String, dynamic> json) {
    return OnboardingQuestionData(
      id: json['id'] as String,
      questionText: json['question_text'] as String,
      questionType: json['question_type'] as String,
      category: json['category'] as String,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      placeholder: json['placeholder'] as String?,
      isRequired: json['is_required'] as bool? ?? true,
      displayOrder: json['display_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'question_type': questionType,
      'category': category,
      'options': options,
      'placeholder': placeholder,
      'is_required': isRequired,
      'display_order': displayOrder,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Data model for user onboarding responses.
class OnboardingResponseData {
  final String id;
  final String userId;
  final String questionId;
  final String? responseText;
  final List<String> responseOptions;
  final DateTime createdAt;
  final DateTime updatedAt;

  OnboardingResponseData({
    required this.id,
    required this.userId,
    required this.questionId,
    this.responseText,
    required this.responseOptions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OnboardingResponseData.fromJson(Map<String, dynamic> json) {
    return OnboardingResponseData(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      questionId: json['question_id'] as String,
      responseText: json['response_text'] as String?,
      responseOptions: (json['response_options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'question_id': questionId,
      'response_text': responseText,
      'response_options': responseOptions,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
