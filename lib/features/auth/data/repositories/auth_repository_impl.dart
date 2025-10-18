import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

/// Implementation of [AuthRepository] using Supabase authentication.
///
/// This class provides concrete implementations of authentication operations
/// by delegating to the Supabase Auth SDK.
class AuthRepositoryImpl implements AuthRepository {
  /// The Supabase client instance.
  final SupabaseClient _supabaseClient;

  /// Creates an instance of [AuthRepositoryImpl].
  ///
  /// - [supabaseClient]: The Supabase client to use for authentication operations.
  AuthRepositoryImpl({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  @override
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      throw Exception('Sign in failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  @override
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: name != null ? {'name': name} : null,
      );
    } on AuthException catch (e) {
      throw Exception('Sign up failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  @override
  Future<void> signInAsGuest() async {
    try {
      // Sign in anonymously using Supabase anonymous auth
      await _supabaseClient.auth.signInAnonymously();
    } on AuthException catch (e) {
      throw Exception('Guest sign in failed: ${e.message}');
    } catch (e) {
      throw Exception('Guest sign in failed: $e');
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await _supabaseClient.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.everglow://login-callback/',
      );
    } on AuthException catch (e) {
      throw Exception('Google sign in failed: ${e.message}');
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }

  @override
  Future<void> signInWithApple() async {
    try {
      await _supabaseClient.auth.signInWithOAuth(
        OAuthProvider.apple,
        redirectTo: 'io.supabase.everglow://login-callback/',
      );
    } on AuthException catch (e) {
      throw Exception('Apple sign in failed: ${e.message}');
    } catch (e) {
      throw Exception('Apple sign in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      throw Exception('Sign out failed: ${e.message}');
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  @override
  AppUser? get currentUser {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) return null;

    return _mapSupabaseUserToAppUser(user);
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;

      return _mapSupabaseUserToAppUser(user);
    });
  }

  /// Maps a Supabase [User] to our domain [AppUser] entity.
  AppUser _mapSupabaseUserToAppUser(User user) {
    // Check if user is anonymous (guest)
    final isGuest = user.isAnonymous;

    return AppUser(
      id: user.id,
      email: user.email ?? 'guest@everglow.app',
      name: user.userMetadata?['name'] as String? ?? (isGuest ? 'Guest' : null),
      isGuest: isGuest,
    );
  }
}

/// Provider for the [AuthRepository] implementation.
///
/// This provider creates and provides the Supabase-based authentication repository.
/// It automatically injects the Supabase client dependency.
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    supabaseClient: Supabase.instance.client,
  );
}

/// Provider for the current authentication state.
///
/// This provider exposes a stream of [AppUser] that emits whenever
/// the authentication state changes. It enables reactive navigation
/// and UI updates based on authentication status.
///
/// Returns:
/// - [AppUser] when a user is authenticated
/// - null when no user is authenticated
@riverpod
Stream<AppUser?> authState(AuthStateRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
}
