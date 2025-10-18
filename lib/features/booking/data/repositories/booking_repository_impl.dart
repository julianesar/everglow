import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';

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

/// Implementation of [BookingRepository] with in-memory storage.
///
/// This repository uses a simple in-memory cache to store booking data.
/// In a production application, this would be replaced with actual
/// API calls and database persistence.
class BookingRepositoryImpl implements BookingRepository {
  // In-memory storage for the booking (simulates database)
  Booking? _cachedBooking;

  @override
  Future<Booking?> getActiveBookingForUser(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Return cached booking if it exists and belongs to the user
    if (_cachedBooking != null && _cachedBooking!.userId == userId) {
      return _cachedBooking;
    }

    // If no cached booking exists, return null
    // The booking should be created explicitly via createBooking
    return null;
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Update the cached booking
    _cachedBooking = booking;
  }

  @override
  Future<Booking> createBooking({
    required DateTime startDate,
    required String userId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

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

    // Cache the new booking
    _cachedBooking = newBooking;

    print('Created booking: ${newBooking.id} for user ${newBooking.userId} (${newBooking.startDate} - ${newBooking.endDate})');

    return newBooking;
  }
}

/// Provider for [BookingRepository].
///
/// This provider maintains a singleton instance to preserve the in-memory
/// cached booking across the application lifecycle.
@Riverpod(keepAlive: true)
BookingRepository bookingRepository(BookingRepositoryRef ref) {
  return BookingRepositoryImpl();
}
