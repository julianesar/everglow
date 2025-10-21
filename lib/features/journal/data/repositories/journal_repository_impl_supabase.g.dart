// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_repository_impl_supabase.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$uuidHash() => r'93ceb3977b7374fc0dfde75246f4746b64edb0e3';

/// Provides the UUID generator.
///
/// Copied from [uuid].
@ProviderFor(uuid)
final uuidProvider = AutoDisposeProvider<Uuid>.internal(
  uuid,
  name: r'uuidProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$uuidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UuidRef = AutoDisposeProviderRef<Uuid>;
String _$journalRemoteDatasourceHash() =>
    r'2ac6b7a930a9b52fd66a78662e57a6f4a1a49622';

/// Provides the journal remote datasource.
///
/// Copied from [journalRemoteDatasource].
@ProviderFor(journalRemoteDatasource)
final journalRemoteDatasourceProvider =
    AutoDisposeProvider<JournalRemoteDatasource>.internal(
  journalRemoteDatasource,
  name: r'journalRemoteDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$journalRemoteDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef JournalRemoteDatasourceRef
    = AutoDisposeProviderRef<JournalRemoteDatasource>;
String _$journalRepositoryHash() => r'192c4c481da609ba66fb233574f754f04bc792f2';

/// Provides an instance of [JournalRepository].
///
/// This provider creates and manages the [SupabaseJournalRepository] instance,
/// which uses Supabase for persistent storage.
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
