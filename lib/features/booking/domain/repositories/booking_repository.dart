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

  /// Creates a new booking with the specified start date and user ID.
  ///
  /// The booking duration is determined by the business logic.
  /// Returns the newly created [Booking].
  Future<Booking> createBooking({
    required DateTime startDate,
    required String userId,
  });

  /// Streams the active booking for the given user in real-time.
  ///
  /// This stream will emit updates whenever the booking data changes
  /// in the database, allowing the UI to react to changes immediately.
  ///
  /// The stream will emit the initial value immediately, then emit new values
  /// whenever the data changes on the server.
  ///
  /// Returns `null` if no active booking exists.
  Stream<Booking?> watchActiveBookingForUser(String userId);
}
