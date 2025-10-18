import '../entities/booking.dart';

/// Repository contract for booking-related operations.
abstract class BookingRepository {
  /// Retrieves the active booking for the given user.
  ///
  /// Returns `null` if no active booking exists.
  Future<Booking?> getActiveBookingForUser(String userId);

  /// Updates an existing booking.
  ///
  /// This method persists the updated booking data.
  Future<void> updateBooking(Booking booking);
}
