import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for user commitments using Supabase.
class CommitmentsRemoteDatasource {
  final SupabaseClient _supabase;

  CommitmentsRemoteDatasource(this._supabase);

  /// Fetches all commitments for a user.
  Future<List<CommitmentData>> getUserCommitments(String userId) async {
    try {
      final response = await _supabase
          .from('user_commitments')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => CommitmentData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user commitments: $e');
    }
  }

  /// Fetches commitments for a specific day.
  Future<List<CommitmentData>> getCommitmentsByDay(
    String userId,
    int dayNumber,
  ) async {
    try {
      final response = await _supabase
          .from('user_commitments')
          .select()
          .eq('user_id', userId)
          .eq('source_day', dayNumber)
          .order('created_at', ascending: true);

      return (response as List)
          .map((json) => CommitmentData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch commitments for day: $e');
    }
  }

  /// Saves a new commitment.
  Future<CommitmentData> saveCommitment(CommitmentData commitment) async {
    try {
      final result = await _supabase
          .from('user_commitments')
          .insert(commitment.toJson())
          .select()
          .single();

      return CommitmentData.fromJson(result);
    } catch (e) {
      throw Exception('Failed to save commitment: $e');
    }
  }

  /// Saves multiple commitments at once.
  Future<List<CommitmentData>> saveCommitments(
    List<CommitmentData> commitments,
  ) async {
    try {
      final result = await _supabase
          .from('user_commitments')
          .insert(commitments.map((c) => c.toJson()).toList())
          .select();

      return (result as List)
          .map((json) => CommitmentData.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to save commitments: $e');
    }
  }

  /// Deletes a commitment by ID.
  Future<void> deleteCommitment(String commitmentId) async {
    try {
      await _supabase.from('user_commitments').delete().eq('id', commitmentId);
    } catch (e) {
      throw Exception('Failed to delete commitment: $e');
    }
  }

  /// Deletes all commitments for a user.
  Future<void> deleteUserCommitments(String userId) async {
    try {
      await _supabase.from('user_commitments').delete().eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete user commitments: $e');
    }
  }

  /// Deletes commitments for a specific day.
  Future<void> deleteCommitmentsByDay(String userId, int dayNumber) async {
    try {
      await _supabase
          .from('user_commitments')
          .delete()
          .eq('user_id', userId)
          .eq('source_day', dayNumber);
    } catch (e) {
      throw Exception('Failed to delete commitments for day: $e');
    }
  }
}

/// Data model for user commitments.
class CommitmentData {
  final String id;
  final String userId;
  final String commitmentText;
  final int sourceDay;
  final DateTime createdAt;

  CommitmentData({
    required this.id,
    required this.userId,
    required this.commitmentText,
    required this.sourceDay,
    required this.createdAt,
  });

  factory CommitmentData.fromJson(Map<String, dynamic> json) {
    return CommitmentData(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      commitmentText: json['commitment_text'] as String,
      sourceDay: json['source_day'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'commitment_text': commitmentText,
      'source_day': sourceDay,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
