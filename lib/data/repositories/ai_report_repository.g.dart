// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiReportRepositoryHash() =>
    r'17c43f4c9fcad1d85e9d2c95dc2893e214cd0e42';

/// Provides an instance of [AiReportRepository].
///
/// This provider creates and manages the [AiReportRepositoryImpl] instance,
/// which coordinates between the journal repository and AI service.
///
/// The provider watches both [journalRepositoryProvider] and [aiReportServiceProvider]
/// to ensure all dependencies are available.
///
/// Usage example:
/// ```dart
/// final repo = await ref.read(aiReportRepositoryProvider.future);
/// final report = await repo.generateFinalReport();
/// print(report);
/// ```
///
/// Copied from [aiReportRepository].
@ProviderFor(aiReportRepository)
final aiReportRepositoryProvider =
    AutoDisposeFutureProvider<AiReportRepository>.internal(
  aiReportRepository,
  name: r'aiReportRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$aiReportRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AiReportRepositoryRef
    = AutoDisposeFutureProviderRef<AiReportRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
