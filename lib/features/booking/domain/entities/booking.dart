/// Represents a user's booking for a wellness journey.
///
/// A booking defines the period during which a user has reserved
/// their wellness experience, including check-in status.
class Booking {
  /// Unique identifier for the booking
  final String id;

  /// ID of the user who made this booking
  final String userId;

  /// Start date of the booking period
  final DateTime startDate;

  /// End date of the booking period
  final DateTime endDate;

  /// Whether the user has checked in for this booking
  final bool isCheckedIn;

  /// Creates a new [Booking] instance.
  const Booking({
    required this.id,
    required this.userId,
    required this.startDate,
    required this.endDate,
    this.isCheckedIn = false,
  });

  /// Creates a copy of this booking with the given fields replaced with new values.
  Booking copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCheckedIn,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }

  /// Returns the duration of this booking in days.
  int get durationInDays {
    return endDate.difference(startDate).inDays;
  }

  /// Returns whether this booking is currently active (today is between start and end dates).
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  /// Returns whether this booking has started.
  bool get hasStarted {
    return DateTime.now().isAfter(startDate);
  }

  /// Returns whether this booking has ended.
  bool get hasEnded {
    return DateTime.now().isAfter(endDate);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Booking &&
        other.id == id &&
        other.userId == userId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.isCheckedIn == isCheckedIn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        isCheckedIn.hashCode;
  }

  @override
  String toString() {
    return 'Booking(id: $id, userId: $userId, startDate: $startDate, endDate: $endDate, isCheckedIn: $isCheckedIn)';
  }
}
