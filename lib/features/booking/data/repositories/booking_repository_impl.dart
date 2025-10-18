import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/config/dev_config.dart';
import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';

part 'booking_repository_impl.g.dart';

/// Implementation of [BookingRepository] with hardcoded data.
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

    // Return hardcoded booking using simulated start date for testing
    final startDate = kSimulatedBookingStartDate;
    final endDate = startDate.add(const Duration(days: 7)); // 7-day booking

    _cachedBooking = Booking(
      id: 'booking-001',
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      isCheckedIn: false,
    );

    return _cachedBooking;
  }

  @override
  Future<void> updateBooking(Booking booking) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Update the cached booking
    _cachedBooking = booking;
  }
}

/// Provider for [BookingRepository].
@riverpod
BookingRepository bookingRepository(BookingRepositoryRef ref) {
  return BookingRepositoryImpl();
}
