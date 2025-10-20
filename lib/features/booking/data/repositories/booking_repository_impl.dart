import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/isar_provider.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
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

/// Implementation of [BookingRepository] with Isar database persistence.
///
/// This repository uses Isar to store booking data persistently,
/// ensuring bookings survive app restarts.
class BookingRepositoryImpl implements BookingRepository {
  /// The Isar database instance.
  final Isar _isar;

  /// Creates an instance of [BookingRepositoryImpl].
  ///
  /// [isar] The Isar database instance to use for storage.
  const BookingRepositoryImpl(this._isar);

  @override
  Future<Booking?> getActiveBookingForUser(String userId) async {
    // Query for a booking with the given userId
    final bookingModel = await _isar.bookingModels
        .filter()
        .userIdEqualTo(userId)
        .findFirst();

    // Convert to domain entity if found
    return bookingModel?.toEntity();
  }

  @override
  Future<void> updateBooking(Booking booking) async {
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

  @override
  Future<Booking> createBooking({
    required DateTime startDate,
    required String userId,
  }) async {
    // Print the selected date and userId for debugging
    print('Creating booking with start date: $startDate for user: $userId');

    // Create a booking with 7-day duration
    final endDate = startDate.add(const Duration(days: 7));
    final newBooking = Booking(
      id: 'booking-${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      isCheckedIn: false,
    );

    // Persist the new booking in the database
    await _isar.writeTxn(() async {
      final model = BookingModel.fromEntity(newBooking);
      await _isar.bookingModels.put(model);
    });

    print('Created booking: ${newBooking.id} for user ${newBooking.userId} (${newBooking.startDate} - ${newBooking.endDate})');

    return newBooking;
  }
}

/// Provider for [BookingRepository].
///
/// This provider creates and provides the Isar-based booking repository.
/// It automatically injects the Isar database dependency.
@Riverpod(keepAlive: true)
Future<BookingRepository> bookingRepository(BookingRepositoryRef ref) async {
  final isar = await ref.watch(isarProvider.future);
  return BookingRepositoryImpl(isar);
}
