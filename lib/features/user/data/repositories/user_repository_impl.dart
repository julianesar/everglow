import 'package:isar/isar.dart';

import '../../../../core/database/isar_provider.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

// MIGRATION TO SUPABASE: Export the new Supabase implementation
export 'user_repository_impl_supabase.dart';

/// In-memory implementation of [UserRepository].
///
/// This class provides a simple in-memory implementation for development.
/// TODO: Replace with Isar implementation for production use.
class InMemoryUserRepository implements UserRepository {
  /// Creates an instance of [InMemoryUserRepository].
  const InMemoryUserRepository();

  // In-memory storage
  static String? _userName;
  static String? _userStatement;
  static String? _generatedReport;

  @override
  Future<void> saveUser({
    required String name,
    required String integrationStatement,
  }) async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));

    _userName = name;
    _userStatement = integrationStatement;

    // Print for debugging
    // ignore: avoid_print
    print('User saved: $name - $integrationStatement');
  }

  @override
  Future<User?> getUser() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));

    if (_userName != null && _userStatement != null) {
      return User.create(
        name: _userName!,
        integrationStatement: _userStatement!,
      );
    }

    return null;
  }

  @override
  Future<void> saveGeneratedReport(String reportText) async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));

    _generatedReport = reportText;

    // Print for debugging
    // ignore: avoid_print
    print('Generated report saved: ${reportText.substring(0, 50)}...');
  }

  @override
  Future<String?> getGeneratedReport() async {
    // Simulate async operation
    await Future.delayed(const Duration(milliseconds: 100));

    return _generatedReport;
  }
}

/// Isar database implementation of [UserRepository].
///
/// This class provides persistent storage using Isar database.
/// User data is stored locally and survives app restarts.
class IsarUserRepository implements UserRepository {
  /// The Isar database instance.
  final Isar _isar;

  /// Creates an instance of [IsarUserRepository].
  ///
  /// [isar] The Isar database instance to use for storage.
  const IsarUserRepository(this._isar);

  @override
  Future<void> saveUser({
    required String name,
    required String integrationStatement,
  }) async {
    // Create or update user in database
    await _isar.writeTxn(() async {
      // Get existing user or create new one
      final existingUser = await _isar.users.where().findFirst();

      final user = existingUser ?? User()
        ..name = name
        ..integrationStatement = integrationStatement;

      // Update existing user
      if (existingUser != null) {
        user.name = name;
        user.integrationStatement = integrationStatement;
      }

      // Save to database
      await _isar.users.put(user);
    });
  }

  @override
  Future<User?> getUser() async {
    // Query and return the first user from the database
    return await _isar.users.where().findFirst();
  }

  @override
  Future<void> saveGeneratedReport(String reportText) async {
    await _isar.writeTxn(() async {
      // Find the current user
      final user = await _isar.users.where().findFirst();

      if (user != null) {
        // Update the generatedReport field
        user.generatedReport = reportText;

        // Save the updated user to database
        await _isar.users.put(user);
      }
    });
  }

  @override
  Future<String?> getGeneratedReport() async {
    // Find the current user
    final user = await _isar.users.where().findFirst();

    // Return the generatedReport field
    return user?.generatedReport;
  }
}

// MIGRATION TO SUPABASE: Provider now comes from user_repository_impl_supabase.dart
// The old Isar implementation above is kept for reference but not used.
