import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../../../../core/network/supabase_provider.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

part 'user_repository_impl_supabase.g.dart';

/// Supabase implementation of [UserRepository].
///
/// This class provides persistent storage using Supabase backend.
/// User data is stored remotely and synced across devices.
class SupabaseUserRepository implements UserRepository {
  final UserRemoteDatasource _remoteDatasource;
  final SupabaseClient _supabase;

  /// Creates an instance of [SupabaseUserRepository].
  ///
  /// [remoteDatasource] The remote datasource for user operations.
  /// [supabase] The Supabase client for auth operations.
  const SupabaseUserRepository(this._remoteDatasource, this._supabase);

  @override
  Future<void> saveUser({
    required String name,
    required String integrationStatement,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _remoteDatasource.saveUserBasicInfo(
      userId: userId,
      name: name,
      integrationStatement: integrationStatement,
    );
  }

  @override
  Future<User?> getUser() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return null;
    }

    final userData = await _remoteDatasource.getUserBasicInfo(userId);
    if (userData == null) {
      return null;
    }

    return User.create(
      name: userData.name,
      integrationStatement: userData.integrationStatement,
    );
  }

  @override
  Future<void> saveGeneratedReport(String reportText) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    await _remoteDatasource.saveGeneratedReport(
      userId: userId,
      reportText: reportText,
    );
  }

  @override
  Future<String?> getGeneratedReport() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      return null;
    }

    return await _remoteDatasource.getGeneratedReport(userId);
  }
}

/// Provides the user remote datasource.
@riverpod
UserRemoteDatasource userRemoteDatasource(UserRemoteDatasourceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return UserRemoteDatasource(supabase);
}

/// Provides an instance of [UserRepository].
///
/// This provider creates and manages the [SupabaseUserRepository] instance,
/// which uses Supabase for persistent storage.
@riverpod
Future<UserRepository> userRepository(UserRepositoryRef ref) async {
  final datasource = ref.watch(userRemoteDatasourceProvider);
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseUserRepository(datasource, supabase);
}
