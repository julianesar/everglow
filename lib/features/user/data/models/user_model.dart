import 'package:isar/isar.dart';

part 'user_model.g.dart';

/// User model representing the app user with their integration statement
///
/// This model stores user information including their personal integration
/// statement for the EverGlow journaling process.
@collection
class User {
  /// Auto-incremental unique identifier
  Id id = Isar.autoIncrement;

  /// User's name
  String name = '';

  /// User's integration statement for personal growth
  String integrationStatement = '';

  /// Cached AI-generated report for the user
  String? generatedReport;

  /// Flag indicating whether the user has completed the onboarding process
  bool hasCompletedOnboarding = false;

  /// Default constructor
  User();

  /// Named constructor with parameters
  User.create({required this.name, required this.integrationStatement});
}
