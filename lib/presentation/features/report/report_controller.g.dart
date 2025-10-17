// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reportControllerHash() => r'ea26d476c2fd7ac666eff4b2ac2e8a4628a44e55';

/// Controller for managing the final AI report generation.
///
/// This controller handles the async state of report generation by calling
/// the AIReportRepository. It uses Riverpod's AsyncNotifier to manage
/// loading, error, and data states automatically.
///
/// Copied from [ReportController].
@ProviderFor(ReportController)
final reportControllerProvider =
    AutoDisposeAsyncNotifierProvider<ReportController, String>.internal(
      ReportController.new,
      name: r'reportControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reportControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReportController = AutoDisposeAsyncNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
