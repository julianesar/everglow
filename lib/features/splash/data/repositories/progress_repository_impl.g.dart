// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$progressRepositoryHash() =>
    r'138649322db4d55d6587e150a91fd2bf48d840d5';

/// Provides an instance of [ProgressRepository].
///
/// This provider creates and manages the [IsarProgressRepository] instance,
/// which uses Isar for querying progress data.
///
/// The provider watches [isarProvider] to get the database instance,
/// [userRepositoryProvider] to get the user repository instance,
/// and [bookingRepositoryProvider] to get the booking repository instance,
/// then passes all three to the repository constructor.
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
