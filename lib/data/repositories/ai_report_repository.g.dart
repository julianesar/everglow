// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_report_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$aiReportRepositoryHash() =>
    r'5456f63e0ded44ea59d0bd5bc3f815378dd3c2d3';

/// Provides an instance of [AIReportRepository].
///
/// This provider creates and manages the [AIReportRepository] instance,
/// injecting the required dependencies ([AiReportService] and [JournalRepository]).
///
/// The provider watches [aiReportServiceProvider] and [journalRepositoryProvider]
/// to get the necessary dependencies.
///
/// Usage example:
/// ```dart
/// final aiReportRepo = await ref.read(aiReportRepositoryProvider.future);
/// final report = await aiReportRepo.generateFinalReport();
/// ```
///
/// Copied from [aiReportRepository].
@ProviderFor(aiReportRepository)
final aiReportRepositoryProvider =
    AutoDisposeFutureProvider<AIReportRepository>.internal(
      aiReportRepository,
      name: r'aiReportRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$aiReportRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef AiReportRepositoryRef =
    AutoDisposeFutureProviderRef<AIReportRepository>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
