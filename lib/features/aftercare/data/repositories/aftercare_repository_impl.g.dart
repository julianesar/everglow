// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aftercare_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aftercareRepositoryHash() =>
    r'c2f80801ea333e3a93ff0f9e9bb73530159a85c6';

/// Provides an instance of [AftercareRepository].
///
/// This provider creates and manages the [AftercareRepositoryImpl] instance,
/// injecting the required dependencies ([AiReportService], [JournalRepository], and [Isar]).
///
/// Usage example:
/// ```dart
/// final aftercareRepo = await ref.read(aftercareRepositoryProvider.future);
/// final commitments = await aftercareRepo.extractCommitmentsFromJournal();
/// ```
///
/// Copied from [aftercareRepository].
@ProviderFor(aftercareRepository)
final aftercareRepositoryProvider =
    AutoDisposeFutureProvider<AftercareRepository>.internal(
  aftercareRepository,
  name: r'aftercareRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aftercareRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AftercareRepositoryRef
    = AutoDisposeFutureProviderRef<AftercareRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
