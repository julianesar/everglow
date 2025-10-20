// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$bookingRepositoryHash() => r'7aadf5d62b079cd6a048e279cff5911b97c017ff';

/// Provider for [BookingRepository].
///
/// This provider creates and provides the Isar-based booking repository.
/// It automatically injects the Isar database dependency.
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
