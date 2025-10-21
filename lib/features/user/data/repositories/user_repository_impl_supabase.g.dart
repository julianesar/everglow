// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repository_impl_supabase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userRemoteDatasourceHash() =>
    r'8e3055cc19091404e38d0909532d4a0363e71de5';

/// Provides the user remote datasource.
///
/// Copied from [userRemoteDatasource].
@ProviderFor(userRemoteDatasource)
final userRemoteDatasourceProvider =
    AutoDisposeProvider<UserRemoteDatasource>.internal(
  userRemoteDatasource,
  name: r'userRemoteDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userRemoteDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserRemoteDatasourceRef = AutoDisposeProviderRef<UserRemoteDatasource>;
String _$userRepositoryHash() => r'fc13cb7386ac98eb71a09dff849b75eb2b4c4c5c';

/// Provides an instance of [UserRepository].
///
/// This provider creates and manages the [SupabaseUserRepository] instance,
/// which uses Supabase for persistent storage.
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
