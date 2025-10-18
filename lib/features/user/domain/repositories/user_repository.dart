import '../../data/models/user_model.dart';

/// Abstract repository contract for user data management.
///
/// This interface defines the contract for user data operations,
/// following the Repository pattern from Clean Architecture.
abstract class UserRepository {
  /// Saves a user with the provided information.
  ///
  /// [name] The user's name
  /// [integrationStatement] The user's integration statement
  ///
  /// Throws an exception if the save operation fails.
  Future<void> saveUser({
    required String name,
    required String integrationStatement,
  });

  /// Retrieves the current user's data.
  ///
  /// Returns the user object, or null if no user has been saved.
  Future<User?> getUser();

  /// Saves the AI-generated report text for the current user.
  ///
  /// [reportText] The generated report text to cache
  ///
  /// Throws an exception if the save operation fails.
  Future<void> saveGeneratedReport(String reportText);

  /// Retrieves the cached AI-generated report for the current user.
  ///
  /// Returns the cached report text, or null if no report has been generated.
  Future<String?> getGeneratedReport();
}
