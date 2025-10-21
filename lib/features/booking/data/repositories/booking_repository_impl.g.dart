// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingRemoteDatasourceHash() =>
    r'ad5c15f45856334f7f8463ffac5b17c5a77f2cad';

/// Provider for [BookingRemoteDatasource].
///
/// This provider creates and provides the Supabase-based remote datasource.
///
/// Copied from [bookingRemoteDatasource].
@ProviderFor(bookingRemoteDatasource)
final bookingRemoteDatasourceProvider =
    Provider<BookingRemoteDatasource>.internal(
  bookingRemoteDatasource,
  name: r'bookingRemoteDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingRemoteDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookingRemoteDatasourceRef = ProviderRef<BookingRemoteDatasource>;
String _$bookingRepositoryHash() => r'7bcdcf116f887f06e956c90e7c47eb748c35e8d9';

/// Provider for [BookingRepository].
///
/// This provider creates and provides the booking repository with
/// both Isar (local) and Supabase (remote) persistence.
///
/// Copied from [bookingRepository].
@ProviderFor(bookingRepository)
final bookingRepositoryProvider = FutureProvider<BookingRepository>.internal(
  bookingRepository,
  name: r'bookingRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$bookingRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef BookingRepositoryRef = FutureProviderRef<BookingRepository>;
String _$selectedBookingDateHash() =>
    r'1eaf8afaf26e09dcd71eaa60c9dc8ae9b6d51b24';

/// State notifier to store the current booking date selected by the user.
///
/// This provider maintains the real booking date that the user selected
/// during the booking flow, making it accessible across the application.
/// Uses keepAlive to preserve the date across the authentication flow.
///
/// Copied from [SelectedBookingDate].
@ProviderFor(SelectedBookingDate)
final selectedBookingDateProvider =
    NotifierProvider<SelectedBookingDate, DateTime?>.internal(
  SelectedBookingDate.new,
  name: r'selectedBookingDateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedBookingDateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedBookingDate = Notifier<DateTime?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
