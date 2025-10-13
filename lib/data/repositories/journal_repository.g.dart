// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$journalRepositoryHash() => r'04372db17b98dec8f02293becbfcbdcfe8b13d0d';

/// Provides an instance of [JournalRepository].
///
/// This provider creates and manages the [IsarJournalRepository] instance,
/// which uses Isar for persistent storage.
///
/// The provider watches [isarProvider] to get the database instance
/// and passes it to the repository constructor.
///
/// Usage example:
/// ```dart
/// final journalRepo = await ref.read(journalRepositoryProvider.future);
/// await journalRepo.saveSinglePriority(dayNumber: 1, priorityText: 'Focus on healing');
/// ```
///
/// Copied from [journalRepository].
@ProviderFor(journalRepository)
final journalRepositoryProvider =
    AutoDisposeFutureProvider<JournalRepository>.internal(
  journalRepository,
  name: r'journalRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef JournalRepositoryRef = AutoDisposeFutureProviderRef<JournalRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
