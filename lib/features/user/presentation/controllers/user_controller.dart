import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../../user/data/models/user_model.dart';

part 'user_controller.g.dart';

/// Controller for managing user state.
///
/// This controller provides cached access to the current user's data,
/// ensuring that the user information is loaded once and available
/// throughout the app lifecycle.
@riverpod
class UserController extends _$UserController {
  /// Builds the initial state by fetching the current user.
  ///
  /// This method loads the user from the repository and caches it.
  /// The user data will be automatically refetched when the provider
  /// is invalidated or when the app restarts.
  ///
  /// Returns null if no user is found or if the user is not authenticated.
  @override
  Future<User?> build() async {
    final userRepository = await ref.watch(userRepositoryProvider.future);
    return await userRepository.getUser();
  }

  /// Manually refreshes the user data.
  ///
  /// This method can be called to reload user data from the repository,
  /// useful after updating user information or when data might have changed.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  /// Saves user information and updates the cached state.
  ///
  /// This method saves the user data to the repository and then
  /// refreshes the controller state to reflect the changes.
  Future<void> saveUser({
    required String name,
    required String integrationStatement,
  }) async {
    final userRepository = await ref.read(userRepositoryProvider.future);
    await userRepository.saveUser(
      name: name,
      integrationStatement: integrationStatement,
    );

    // Refresh the state after saving
    await refresh();
  }
}
