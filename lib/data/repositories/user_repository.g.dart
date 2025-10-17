// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRepositoryHash() => r'96cd71fedf6492069367d43721de6af82649fa19';

/// Provides an instance of [UserRepository].
///
/// This provider creates and manages the [IsarUserRepository] instance,
/// which uses Isar for persistent storage.
///
/// The provider watches [isarProvider] to get the database instance
/// and passes it to the repository constructor.
///
/// Copied from [userRepository].
@ProviderFor(userRepository)
final userRepositoryProvider =
    AutoDisposeFutureProvider<UserRepository>.internal(
      userRepository,
      name: r'userRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef UserRepositoryRef = AutoDisposeFutureProviderRef<UserRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
