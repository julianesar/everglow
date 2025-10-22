// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logistics_hub_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$logisticsHubControllerHash() =>
    r'03176e657e5e92c51e4b209af5d3694d70a0ffa4';

/// Controller for managing the Logistics Hub screen state.
///
/// This controller orchestrates the loading of booking and concierge data,
/// determining whether to show arrival-day or pre-arrival information based
/// on the booking dates.
///
/// The controller now uses real-time streams to listen for changes in:
/// 1. Booking data (check-in status, dates, etc.)
/// 2. Concierge information (driver, villa, contact details)
///
/// The UI will automatically update when any of this data changes in Supabase.
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
