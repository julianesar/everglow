// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_journey_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dailyJourneyControllerHash() =>
    r'86d8700dc742f4452b1b6fa9ecad214bb8499d58';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$DailyJourneyController
    extends BuildlessAutoDisposeAsyncNotifier<DailyJourney> {
  late final int dayNumber;

  FutureOr<DailyJourney> build(
    int dayNumber,
  );
}

/// Controller for managing daily journey state and operations.
///
/// This controller fetches and manages the daily journey data for a specific day.
/// It uses Riverpod's AsyncNotifier to handle async state management.
///
/// Copied from [DailyJourneyController].
@ProviderFor(DailyJourneyController)
const dailyJourneyControllerProvider = DailyJourneyControllerFamily();

/// Controller for managing daily journey state and operations.
///
/// This controller fetches and manages the daily journey data for a specific day.
/// It uses Riverpod's AsyncNotifier to handle async state management.
///
/// Copied from [DailyJourneyController].
class DailyJourneyControllerFamily extends Family<AsyncValue<DailyJourney>> {
  /// Controller for managing daily journey state and operations.
  ///
  /// This controller fetches and manages the daily journey data for a specific day.
  /// It uses Riverpod's AsyncNotifier to handle async state management.
  ///
  /// Copied from [DailyJourneyController].
  const DailyJourneyControllerFamily();

  /// Controller for managing daily journey state and operations.
  ///
  /// This controller fetches and manages the daily journey data for a specific day.
  /// It uses Riverpod's AsyncNotifier to handle async state management.
  ///
  /// Copied from [DailyJourneyController].
  DailyJourneyControllerProvider call(
    int dayNumber,
  ) {
    return DailyJourneyControllerProvider(
      dayNumber,
    );
  }

  @override
  DailyJourneyControllerProvider getProviderOverride(
    covariant DailyJourneyControllerProvider provider,
  ) {
    return call(
      provider.dayNumber,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dailyJourneyControllerProvider';
}

/// Controller for managing daily journey state and operations.
///
/// This controller fetches and manages the daily journey data for a specific day.
/// It uses Riverpod's AsyncNotifier to handle async state management.
///
/// Copied from [DailyJourneyController].
class DailyJourneyControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DailyJourneyController,
        DailyJourney> {
  /// Controller for managing daily journey state and operations.
  ///
  /// This controller fetches and manages the daily journey data for a specific day.
  /// It uses Riverpod's AsyncNotifier to handle async state management.
  ///
  /// Copied from [DailyJourneyController].
  DailyJourneyControllerProvider(
    int dayNumber,
  ) : this._internal(
          () => DailyJourneyController()..dayNumber = dayNumber,
          from: dailyJourneyControllerProvider,
          name: r'dailyJourneyControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dailyJourneyControllerHash,
          dependencies: DailyJourneyControllerFamily._dependencies,
          allTransitiveDependencies:
              DailyJourneyControllerFamily._allTransitiveDependencies,
          dayNumber: dayNumber,
        );

  DailyJourneyControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dayNumber,
  }) : super.internal();

  final int dayNumber;

  @override
  FutureOr<DailyJourney> runNotifierBuild(
    covariant DailyJourneyController notifier,
  ) {
    return notifier.build(
      dayNumber,
    );
  }

  @override
  Override overrideWith(DailyJourneyController Function() create) {
    return ProviderOverride(
      origin: this,
      override: DailyJourneyControllerProvider._internal(
        () => create()..dayNumber = dayNumber,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dayNumber: dayNumber,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DailyJourneyController, DailyJourney>
      createElement() {
    return _DailyJourneyControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyJourneyControllerProvider &&
        other.dayNumber == dayNumber;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dayNumber.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DailyJourneyControllerRef
    on AutoDisposeAsyncNotifierProviderRef<DailyJourney> {
  /// The parameter `dayNumber` of this provider.
  int get dayNumber;
}

class _DailyJourneyControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DailyJourneyController,
        DailyJourney> with DailyJourneyControllerRef {
  _DailyJourneyControllerProviderElement(super.provider);

  @override
  int get dayNumber => (origin as DailyJourneyControllerProvider).dayNumber;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
