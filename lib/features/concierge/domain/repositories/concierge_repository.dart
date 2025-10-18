import '../entities/concierge_info.dart';

/// Repository contract for concierge-related operations.
abstract class ConciergeRepository {
  /// Retrieves concierge information for the given booking.
  ///
  /// Returns personalized concierge details including assigned staff,
  /// special services, and booking-specific information.
  Future<ConciergeInfo> getConciergeInfo(String bookingId);
}
