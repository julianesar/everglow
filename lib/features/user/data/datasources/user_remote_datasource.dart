import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for basic user data using Supabase.
///
/// Handles user name, integration statement, and generated reports.
/// Uses a custom table or extends user_profiles table.
class UserRemoteDatasource {
  final SupabaseClient _supabase;

  UserRemoteDatasource(this._supabase);

  /// Fetches the current authenticated user's ID.
  String? get currentUserId => _supabase.auth.currentUser?.id;

  /// Saves user basic information (name and integration statement).
  ///
  /// This updates the user_profiles table with name-related fields.
  Future<void> saveUserBasicInfo({
    required String userId,
    required String name,
    required String integrationStatement,
  }) async {
    try {
      // Upsert user profile with basic info
      await _supabase.from('user_profiles').upsert({
        'user_id': userId,
        'name': name,
        'integration_statement': integrationStatement,
      });
    } catch (e) {
      throw Exception('Failed to save user basic info: $e');
    }
  }

  /// Retrieves user basic information.
  Future<UserBasicData?> getUserBasicInfo(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select('name, integration_statement')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      final name = response['name'] as String?;
      final integrationStatement = response['integration_statement'] as String?;

      if (name != null && integrationStatement != null) {
        return UserBasicData(
          userId: userId,
          name: name,
          integrationStatement: integrationStatement,
        );
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get user basic info: $e');
    }
  }

  /// Checks if the user has completed onboarding.
  Future<bool> hasCompletedOnboarding(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select('has_completed_onboarding')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return false;

      return response['has_completed_onboarding'] as bool? ?? false;
    } catch (e) {
      throw Exception('Failed to check onboarding status: $e');
    }
  }

  /// Saves the AI-generated report.
  Future<void> saveGeneratedReport({
    required String userId,
    required String reportText,
  }) async {
    try {
      await _supabase.from('user_profiles').upsert({
        'user_id': userId,
        'generated_report': reportText,
      });
    } catch (e) {
      throw Exception('Failed to save generated report: $e');
    }
  }

  /// Retrieves the AI-generated report.
  Future<String?> getGeneratedReport(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select('generated_report')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;

      return response['generated_report'] as String?;
    } catch (e) {
      throw Exception('Failed to get generated report: $e');
    }
  }
}

/// Data model for basic user information.
class UserBasicData {
  final String userId;
  final String name;
  final String integrationStatement;

  UserBasicData({
    required this.userId,
    required this.name,
    required this.integrationStatement,
  });
}
