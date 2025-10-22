// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'concierge_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$conciergeRemoteDatasourceHash() =>
    r'45aa9e80dbaa8e55024d1d2c907ad1eae0138585';

/// Provider for [ConciergeRemoteDatasource].
///
/// This provider creates and provides the Supabase-based remote datasource.
///
/// Copied from [conciergeRemoteDatasource].
@ProviderFor(conciergeRemoteDatasource)
final conciergeRemoteDatasourceProvider =
    Provider<ConciergeRemoteDatasource>.internal(
  conciergeRemoteDatasource,
  name: r'conciergeRemoteDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$conciergeRemoteDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConciergeRemoteDatasourceRef = ProviderRef<ConciergeRemoteDatasource>;
String _$conciergeRepositoryHash() =>
    r'7831dab17f53a6e98216f1b31bb9ce72cbb939f3';

/// Provider for [ConciergeRepository].
///
/// This provider creates and provides the concierge repository with
/// both Isar (local) and Supabase (remote) persistence.
///
/// Copied from [conciergeRepository].
@ProviderFor(conciergeRepository)
final conciergeRepositoryProvider =
    FutureProvider<ConciergeRepository>.internal(
  conciergeRepository,
  name: r'conciergeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$conciergeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ConciergeRepositoryRef = FutureProviderRef<ConciergeRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
