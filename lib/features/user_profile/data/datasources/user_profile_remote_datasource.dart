import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for user profiles using Supabase.
///
/// Handles all network requests for medical profiles and concierge preferences.
class UserProfileRemoteDatasource {
  final SupabaseClient _supabase;

  UserProfileRemoteDatasource(this._supabase);

  /// Fetches the user profile for the given user ID.
  ///
  /// Returns null if no profile exists.
  Future<UserProfileData?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserProfileData.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  /// Creates a new user profile.
  ///
  /// Throws an exception if a profile already exists for this user.
  Future<UserProfileData> createUserProfile(UserProfileData profile) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .insert(profile.toJson())
          .select()
          .single();

      return UserProfileData.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  /// Updates an existing user profile.
  Future<UserProfileData> updateUserProfile(UserProfileData profile) async {
    try {
      final response = await _supabase
          .from('user_profiles')
          .update(profile.toJson())
          .eq('user_id', profile.userId)
          .select()
          .single();

      return UserProfileData.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  /// Deletes the user profile for the given user ID.
  ///
  /// Used for GDPR compliance (right to erasure).
  Future<void> deleteUserProfile(String userId) async {
    try {
      await _supabase.from('user_profiles').delete().eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }

  /// Updates only the medical profile fields.
  Future<void> updateMedicalProfile({
    required String userId,
    required List<String> allergies,
    required List<String> medicalConditions,
    required List<String> medications,
    required bool hasSignedConsent,
  }) async {
    try {
      await _supabase.from('user_profiles').update({
        'allergies': allergies,
        'medical_conditions': medicalConditions,
        'medications': medications,
        'has_signed_medical_consent': hasSignedConsent,
      }).eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to update medical profile: $e');
    }
  }

  /// Updates only the concierge preferences fields.
  Future<void> updateConciergePreferences({
    required String userId,
    required List<String> dietaryRestrictions,
    String? coffeeOrTea,
    String? roomTemperature,
  }) async {
    try {
      await _supabase.from('user_profiles').update({
        'dietary_restrictions': dietaryRestrictions,
        'coffee_or_tea': coffeeOrTea,
        'room_temperature': roomTemperature,
      }).eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to update concierge preferences: $e');
    }
  }
}

/// Combined data model for user profile (medical + concierge).
///
/// This matches the Supabase user_profiles table schema.
class UserProfileData {
  final String id;
  final String userId;
  final List<String> allergies;
  final List<String> medicalConditions;
  final List<String> medications;
  final bool hasSignedMedicalConsent;
  final List<String> dietaryRestrictions;
  final String? coffeeOrTea;
  final String? roomTemperature;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfileData({
    required this.id,
    required this.userId,
    required this.allergies,
    required this.medicalConditions,
    required this.medications,
    required this.hasSignedMedicalConsent,
    required this.dietaryRestrictions,
    this.coffeeOrTea,
    this.roomTemperature,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      allergies: (json['allergies'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      medicalConditions: (json['medical_conditions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      medications: (json['medications'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      hasSignedMedicalConsent:
          json['has_signed_medical_consent'] as bool? ?? false,
      dietaryRestrictions: (json['dietary_restrictions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      coffeeOrTea: json['coffee_or_tea'] as String?,
      roomTemperature: json['room_temperature'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'allergies': allergies,
      'medical_conditions': medicalConditions,
      'medications': medications,
      'has_signed_medical_consent': hasSignedMedicalConsent,
      'dietary_restrictions': dietaryRestrictions,
      'coffee_or_tea': coffeeOrTea,
      'room_temperature': roomTemperature,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
