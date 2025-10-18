// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logistics_hub_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$logisticsHubControllerHash() =>
    r'cf662de6f7b54570b36e4518c1601a961ff032cc';

/// Controller for managing the Logistics Hub screen state.
///
/// This controller orchestrates the loading of booking and concierge data,
/// determining whether to show arrival-day or pre-arrival information based
/// on the booking dates.
///
/// The controller follows these steps:
/// 1. Retrieves the current authenticated user ID
/// 2. Fetches the user's active booking
/// 3. Determines if today is the arrival day by comparing dates
/// 4. Conditionally fetches concierge information (only on arrival day)
/// 5. Returns a complete [LogisticsHubState] with all necessary data
///
/// Copied from [LogisticsHubController].
@ProviderFor(LogisticsHubController)
final logisticsHubControllerProvider = AutoDisposeAsyncNotifierProvider<
    LogisticsHubController, LogisticsHubState>.internal(
  LogisticsHubController.new,
  name: r'logisticsHubControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$logisticsHubControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LogisticsHubController = AutoDisposeAsyncNotifier<LogisticsHubState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
