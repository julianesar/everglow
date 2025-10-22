// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_repository_impl.dart';

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
String _$progressRepositoryHash() =>
    r'8825287715b9dab88c0bb3d9909d27accc40fd7f';

/// Provides an instance of [ProgressRepository].
///
/// This provider creates and manages the [SupabaseProgressRepository] instance,
/// which uses Supabase for authentication and onboarding status,
/// and Isar for querying daily log data.
///
/// The provider watches [isarProvider] to get the database instance,
/// [userRepositoryProvider] to get the user repository instance,
/// [bookingRepositoryProvider] to get the booking repository instance,
/// [supabaseClientProvider] to get the Supabase client,
/// and [userRemoteDatasourceProvider] to get the user remote datasource,
/// then passes all to the repository constructor.
///
/// Usage example:
/// ```dart
/// final progressRepo = await ref.read(progressRepositoryProvider.future);
/// final status = await progressRepo.getJourneyStatus();
/// final currentDay = await progressRepo.getCurrentDay();
/// ```
///
/// Copied from [progressRepository].
@ProviderFor(progressRepository)
final progressRepositoryProvider =
    AutoDisposeFutureProvider<ProgressRepository>.internal(
  progressRepository,
  name: r'progressRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$progressRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProgressRepositoryRef
    = AutoDisposeFutureProviderRef<ProgressRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
