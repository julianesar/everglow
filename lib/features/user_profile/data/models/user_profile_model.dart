import 'package:isar/isar.dart';

part 'user_profile_model.g.dart';

/// Medical profile entity for storing user's health information
///
/// This model stores medical information including allergies, medical conditions,
/// medications, and consent status for the EverGlow onboarding process.
@collection
class MedicalProfile {
  /// Auto-incremental unique identifier
  Id id = Isar.autoIncrement;

  /// List of user's allergies
  List<String> allergies = [];

  /// List of user's medical conditions
  List<String> medicalConditions = [];

  /// List of user's current medications
  List<String> medications = [];

  /// Indicates whether user has signed the medical consent
  bool hasSignedConsent = false;

  /// Timestamp when the profile was created
  @Index()
  DateTime createdAt = DateTime.now();

  /// Timestamp when the profile was last updated
  DateTime updatedAt = DateTime.now();

  /// Default constructor
  MedicalProfile();

  /// Named constructor with parameters
  MedicalProfile.create({
    required this.allergies,
    required this.medicalConditions,
    required this.medications,
    required this.hasSignedConsent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }
}

/// Concierge preferences entity for storing user's lifestyle preferences
///
/// This model stores user preferences for personalized recommendations
/// including dietary restrictions, beverage preferences, and room temperature.
@collection
class ConciergePreferences {
  /// Auto-incremental unique identifier
  Id id = Isar.autoIncrement;

  /// List of user's dietary restrictions (e.g., "vegetarian", "gluten-free")
  List<String> dietaryRestrictions = [];

  /// User's beverage preference (e.g., "Coffee", "Tea", "Both", "Neither")
  String coffeeOrTea = '';

  /// User's preferred room temperature (e.g., "Cool", "Moderate", "Warm")
  String roomTemperature = '';

  /// Timestamp when the preferences were created
  @Index()
  DateTime createdAt = DateTime.now();

  /// Timestamp when the preferences were last updated
  DateTime updatedAt = DateTime.now();

  /// Default constructor
  ConciergePreferences();

  /// Named constructor with parameters
  ConciergePreferences.create({
    required this.dietaryRestrictions,
    required this.coffeeOrTea,
    required this.roomTemperature,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }
}
