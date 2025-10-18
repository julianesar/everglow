import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:everglow_app/features/auth/data/repositories/auth_repository_impl.dart';

/// A [ChangeNotifier] that listens to authentication state changes
/// and notifies GoRouter to refresh routes when the auth state changes.
///
/// This class acts as a bridge between Riverpod's stream-based
/// authentication state and GoRouter's [ChangeNotifier]-based refresh system.
class AuthNotifier extends ChangeNotifier {
  /// The Riverpod ref to access providers.
  final Ref _ref;

  /// Creates an [AuthNotifier].
  AuthNotifier(this._ref) {
    // Listen to auth state changes and notify listeners
    _ref.listen(
      authStateProvider,
      (previous, next) {
        // Notify GoRouter to refresh whenever auth state changes
        notifyListeners();
      },
    );
  }
}

/// Provider for the [AuthNotifier].
///
/// This notifier will be used by GoRouter's `refreshListenable` parameter
/// to automatically refresh routes when authentication state changes.
final authNotifierProvider = Provider<AuthNotifier>((ref) {
  return AuthNotifier(ref);
});
