// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isarHash() => r'adc1ffea245f3339c497e07fb35a4d2e152ae9c7';

/// Provides the Isar database instance to the application.
///
/// This provider initializes the Isar database and makes it available
/// throughout the app via Riverpod's dependency injection.
///
/// Usage example:
/// ```dart
/// final isar = await ref.read(isarProvider.future);
/// ```
///
/// The database instance is cached and shared across the entire app.
///
/// Copied from [isar].
@ProviderFor(isar)
final isarProvider = FutureProvider<Isar>.internal(
  isar,
  name: r'isarProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsarRef = FutureProviderRef<Isar>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
