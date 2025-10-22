import '../entities/concierge_info.dart';

/// Repository contract for concierge-related operations.
abstract class ConciergeRepository {
  /// Retrieves concierge information for the given booking.
  ///
  /// Returns personalized concierge details including assigned staff,
  /// special services, and booking-specific information.
  Future<ConciergeInfo> getConciergeInfo(String bookingId);

  /// Streams concierge information for the given booking in real-time.
  ///
  /// This stream will emit updates whenever the concierge information
  /// changes in the database, allowing the UI to react to changes immediately.
  ///
  /// The stream will emit the initial value immediately, then emit new values
  /// whenever the data changes on the server.
  Stream<ConciergeInfo> watchConciergeInfo(String bookingId);
}
