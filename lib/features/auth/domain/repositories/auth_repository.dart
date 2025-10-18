import '../entities/app_user.dart';

/// Contract for authentication operations.
///
/// This is a pure domain interface that defines the authentication
/// capabilities without any implementation details. The data layer
/// will provide the concrete implementation.
///
/// Following the Dependency Inversion Principle, the domain layer
/// defines what it needs, and outer layers provide the implementation.
abstract class AuthRepository {
  /// Signs in a user with email and password.
  ///
  /// Throws an exception if authentication fails.
  ///
  /// - [email]: The user's email address.
  /// - [password]: The user's password.
  Future<void> signInWithEmail({
    required String email,
    required String password,
  });

  /// Creates a new user account with email and password.
  ///
  /// Throws an exception if registration fails.
  ///
  /// - [email]: The user's email address.
  /// - [password]: The user's password.
  /// - [name]: Optional display name for the user.
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  });

  /// Signs in as a guest user (temporary, no account required).
  ///
  /// Throws an exception if guest sign in fails.
  Future<void> signInAsGuest();

  /// Signs in a user with Google authentication.
  ///
  /// Throws an exception if Google sign in fails or is cancelled by the user.
  Future<void> signInWithGoogle();

  /// Signs in a user with Apple authentication.
  ///
  /// Throws an exception if Apple sign in fails or is cancelled by the user.
  Future<void> signInWithApple();

  /// Signs out the current user.
  ///
  /// Throws an exception if sign out fails.
  Future<void> signOut();

  /// Stream that emits authentication state changes.
  ///
  /// Emits [AppUser] when a user is signed in, or null when signed out.
  /// This allows reactive listening to authentication state throughout the app.
  Stream<AppUser?> get authStateChanges;

  /// Synchronously retrieves the current authenticated user.
  ///
  /// Returns [AppUser] if a user is currently signed in, null otherwise.
  /// Use this for one-time checks; prefer [authStateChanges] for reactive updates.
  AppUser? get currentUser;
}
