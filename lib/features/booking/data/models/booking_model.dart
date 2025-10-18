import 'package:isar/isar.dart';
import '../../domain/entities/booking.dart';

part 'booking_model.g.dart';

/// Data model for [Booking] entity with Isar persistence.
@collection
class BookingModel {
  /// Isar auto-increment ID.
  Id isarId = Isar.autoIncrement;

  /// Unique identifier for the booking.
  @Index(unique: true)
  late String id;

  /// User ID associated with this booking.
  @Index()
  late String userId;

  /// Start date of the booking (stored as milliseconds since epoch).
  late int startDateMillis;

  /// End date of the booking (stored as milliseconds since epoch).
  late int endDateMillis;

  /// Whether the user has checked in for this booking.
  late bool isCheckedIn;

  /// Converts this model to a domain entity.
  Booking toEntity() {
    return Booking(
      id: id,
      userId: userId,
      startDate: DateTime.fromMillisecondsSinceEpoch(startDateMillis),
      endDate: DateTime.fromMillisecondsSinceEpoch(endDateMillis),
      isCheckedIn: isCheckedIn,
    );
  }

  /// Creates a model from a domain entity.
  static BookingModel fromEntity(Booking booking) {
    return BookingModel()
      ..id = booking.id
      ..userId = booking.userId
      ..startDateMillis = booking.startDate.millisecondsSinceEpoch
      ..endDateMillis = booking.endDate.millisecondsSinceEpoch
      ..isCheckedIn = booking.isCheckedIn;
  }
}
