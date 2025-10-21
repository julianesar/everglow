import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for journal responses and task completions using Supabase.
class JournalRemoteDatasource {
  final SupabaseClient _supabase;

  JournalRemoteDatasource(this._supabase);

  /// Fetches all journal responses for a user.
  Future<List<JournalResponseData>> getUserJournalResponses(
      String userId) async {
    try {
      final response = await _supabase
          .from('user_journal_responses')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => JournalResponseData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch journal responses: $e');
    }
  }

  /// Fetches journal responses for a specific day.
  Future<List<JournalResponseData>> getJournalResponsesByDay(
      String userId, int dayNumber) async {
    try {
      final response = await _supabase
          .from('user_journal_responses')
          .select()
          .eq('user_id', userId)
          .eq('day_number', dayNumber)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => JournalResponseData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch journal responses for day: $e');
    }
  }

  /// Saves or updates a journal response.
  Future<JournalResponseData> saveJournalResponse(
      JournalResponseData response) async {
    try {
      final result = await _supabase
          .from('user_journal_responses')
          .upsert(response.toJson())
          .select()
          .single();

      return JournalResponseData.fromJson(result);
    } catch (e) {
      throw Exception('Failed to save journal response: $e');
    }
  }

  /// Fetches all task completions for a user.
  Future<List<TaskCompletionData>> getUserTaskCompletions(
      String userId) async {
    try {
      final response = await _supabase
          .from('user_task_completions')
          .select()
          .eq('user_id', userId)
          .order('completed_at', ascending: true);

      return (response as List)
          .map((json) => TaskCompletionData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch task completions: $e');
    }
  }

  /// Fetches task completions for a specific day.
  Future<List<TaskCompletionData>> getTaskCompletionsByDay(
      String userId, int dayNumber) async {
    try {
      final response = await _supabase
          .from('user_task_completions')
          .select()
          .eq('user_id', userId)
          .eq('day_number', dayNumber)
          .order('completed_at', ascending: true);

      return (response as List)
          .map((json) => TaskCompletionData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch task completions for day: $e');
    }
  }

  /// Marks a task as completed.
  Future<TaskCompletionData> completeTask({
    required String userId,
    required String itineraryItemId,
    required int dayNumber,
  }) async {
    try {
      final result = await _supabase
          .from('user_task_completions')
          .insert({
            'user_id': userId,
            'itinerary_item_id': itineraryItemId,
            'day_number': dayNumber,
          })
          .select()
          .single();

      return TaskCompletionData.fromJson(result);
    } catch (e) {
      throw Exception('Failed to complete task: $e');
    }
  }

  /// Uncompletes a task (removes the completion record).
  Future<void> uncompleteTask({
    required String userId,
    required String itineraryItemId,
  }) async {
    try {
      await _supabase
          .from('user_task_completions')
          .delete()
          .eq('user_id', userId)
          .eq('itinerary_item_id', itineraryItemId);
    } catch (e) {
      throw Exception('Failed to uncomplete task: $e');
    }
  }

  /// Deletes all journal responses for a user (GDPR compliance).
  Future<void> deleteUserJournalResponses(String userId) async {
    try {
      await _supabase
          .from('user_journal_responses')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete journal responses: $e');
    }
  }

  /// Deletes all task completions for a user.
  Future<void> deleteUserTaskCompletions(String userId) async {
    try {
      await _supabase
          .from('user_task_completions')
          .delete()
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete task completions: $e');
    }
  }
}

/// Data model for journal responses.
class JournalResponseData {
  final String id;
  final String userId;
  final String promptId;
  final int dayNumber;
  final String responseText;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalResponseData({
    required this.id,
    required this.userId,
    required this.promptId,
    required this.dayNumber,
    required this.responseText,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalResponseData.fromJson(Map<String, dynamic> json) {
    return JournalResponseData(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      promptId: json['prompt_id'] as String,
      dayNumber: json['day_number'] as int,
      responseText: json['response_text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'prompt_id': promptId,
      'day_number': dayNumber,
      'response_text': responseText,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

/// Data model for task completions.
class TaskCompletionData {
  final String id;
  final String userId;
  final String itineraryItemId;
  final int dayNumber;
  final DateTime completedAt;

  TaskCompletionData({
    required this.id,
    required this.userId,
    required this.itineraryItemId,
    required this.dayNumber,
    required this.completedAt,
  });

  factory TaskCompletionData.fromJson(Map<String, dynamic> json) {
    return TaskCompletionData(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      itineraryItemId: json['itinerary_item_id'] as String,
      dayNumber: json['day_number'] as int,
      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'itinerary_item_id': itineraryItemId,
      'day_number': dayNumber,
      'completed_at': completedAt.toIso8601String(),
    };
  }
}
