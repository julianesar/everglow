import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/isar_provider.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_datasource.dart';
import '../models/booking_model.dart';

part 'booking_repository_impl.g.dart';

/// State notifier to store the current booking date selected by the user.
///
/// This provider maintains the real booking date that the user selected
/// during the booking flow, making it accessible across the application.
/// Uses keepAlive to preserve the date across the authentication flow.
@Riverpod(keepAlive: true)
class SelectedBookingDate extends _$SelectedBookingDate {
  @override
  DateTime? build() => null;

  /// Updates the selected booking date.
  void setDate(DateTime date) {
    state = date;
  }

  /// Clears the selected booking date.
  void clear() {
    state = null;
  }
}

/// Implementation of [BookingRepository] with Isar and Supabase persistence.
///
/// This repository uses a dual-persistence strategy:
/// - Isar for local caching and offline access
/// - Supabase for remote synchronization and backup
class BookingRepositoryImpl implements BookingRepository {
  /// The Isar database instance for local storage.
  final Isar _isar;

  /// The remote datasource for Supabase operations.
  final BookingRemoteDatasource _remoteDatasource;

  /// Creates an instance of [BookingRepositoryImpl].
  ///
  /// [isar] The Isar database instance to use for local storage.
  /// [remoteDatasource] The remote datasource for Supabase operations.
  const BookingRepositoryImpl(this._isar, this._remoteDatasource);

  @override
  Future<Booking?> getActiveBookingForUser(String userId) async {
    try {
      // Try to fetch from Supabase first
      final remoteData = await _remoteDatasource.getActiveBookingForUser(userId);

      if (remoteData != null) {
        // Convert remote data to entity
        final booking = _bookingFromMap(remoteData);

        // Update local cache
        await _updateLocalBooking(booking);

        return booking;
      }
    } catch (e) {
      // If remote fetch fails, continue to local fallback
      print('Failed to fetch booking from Supabase: $e');
    }

    // Fallback to local database
    final bookingModel = await _isar.bookingModels
        .filter()
        .userIdEqualTo(userId)
        .findFirst();

    // Convert to domain entity if found
    return bookingModel?.toEntity();
  }

  @override
  Stream<Booking?> watchActiveBookingForUser(String userId) {
    return _remoteDatasource.watchActiveBookingForUser(userId).asyncMap((remoteData) async {
      if (remoteData != null) {
        // Convert remote data to entity
        final booking = _bookingFromMap(remoteData);

        // Update local cache in the background
        _updateLocalBooking(booking);

        return booking;
      }

      // If no remote data, try to get from local cache
      final bookingModel = await _isar.bookingModels
          .filter()
          .userIdEqualTo(userId)
          .findFirst();

      // Convert to domain entity if found
      return bookingModel?.toEntity();
    });
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    // Update in Supabase first
    try {
      await _remoteDatasource.updateBooking(
        id: booking.id,
        userId: booking.userId,
        startDate: booking.startDate,
        endDate: booking.endDate,
        isCheckedIn: booking.isCheckedIn,
      );
    } catch (e) {
      print('Failed to update booking in Supabase: $e');
      // Continue to update locally even if remote fails
    }

    // Update in local database
    await _updateLocalBooking(booking);
  }

  @override
  Future<Booking> createBooking({
    required DateTime startDate,
    required String userId,
  }) async {
    // Normalize start date to midnight to avoid time-related calculation issues
    final normalizedStartDate = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );

    // Print the selected date and userId for debugging
    print('Creating booking with start date: $normalizedStartDate for user: $userId');

    // Create a booking with 3-day duration (days 1, 2, and 3)
    // End date is 2 days after start date (inclusive of both start and end dates)
    final endDate = normalizedStartDate.add(const Duration(days: 2));
    final bookingId = 'booking-${DateTime.now().millisecondsSinceEpoch}';

    final newBooking = Booking(
      id: bookingId,
      userId: userId,
      startDate: normalizedStartDate,
      endDate: endDate,
      isCheckedIn: false,
    );

    // Create in Supabase first (this is the source of truth)
    try {
      await _remoteDatasource.createBooking(
        id: bookingId,
        userId: userId,
        startDate: normalizedStartDate,
        endDate: endDate,
        isCheckedIn: false,
      );

      print('Successfully created booking in Supabase: $bookingId');
    } catch (e) {
      print('Failed to create booking in Supabase: $e');
      // Rethrow the error so the UI can handle it
      rethrow;
    }

    // Persist in local database for offline access
    await _updateLocalBooking(newBooking);

    print('Created booking: ${newBooking.id} for user ${newBooking.userId} (${newBooking.startDate} - ${newBooking.endDate})');

    return newBooking;
  }

  /// Updates or inserts a booking in the local Isar database.
  Future<void> _updateLocalBooking(Booking booking) async {
    await _isar.writeTxn(() async {
      // Find existing booking model by ID
      final existingModel = await _isar.bookingModels
          .filter()
          .idEqualTo(booking.id)
          .findFirst();

      if (existingModel != null) {
        // Update the existing model with new values
        existingModel
          ..userId = booking.userId
          ..startDateMillis = booking.startDate.millisecondsSinceEpoch
          ..endDateMillis = booking.endDate.millisecondsSinceEpoch
          ..isCheckedIn = booking.isCheckedIn;

        // Save the updated model
        await _isar.bookingModels.put(existingModel);
      } else {
        // If not found, create a new one
        final model = BookingModel.fromEntity(booking);
        await _isar.bookingModels.put(model);
      }
    });
  }

  /// Converts a Map from Supabase to a [Booking] entity.
  Booking _bookingFromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      startDate: DateTime.parse(map['start_date'] as String),
      endDate: DateTime.parse(map['end_date'] as String),
      isCheckedIn: map['is_checked_in'] as bool,
    );
  }
}

/// Provider for [BookingRemoteDatasource].
///
/// This provider creates and provides the Supabase-based remote datasource.
@Riverpod(keepAlive: true)
BookingRemoteDatasource bookingRemoteDatasource(
    BookingRemoteDatasourceRef ref) {
  return BookingRemoteDatasource(
    supabaseClient: Supabase.instance.client,
  );
}

/// Provider for [BookingRepository].
///
/// This provider creates and provides the booking repository with
/// both Isar (local) and Supabase (remote) persistence.
@Riverpod(keepAlive: true)
Future<BookingRepository> bookingRepository(BookingRepositoryRef ref) async {
  final isar = await ref.watch(isarProvider.future);
  final remoteDatasource = ref.watch(bookingRemoteDatasourceProvider);
  return BookingRepositoryImpl(isar, remoteDatasource);
}
