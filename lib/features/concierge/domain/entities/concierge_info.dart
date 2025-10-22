/// Contains concierge information for a user's wellness journey.
///
/// This includes details about the assigned driver, concierge team member,
/// villa accommodation, and check-in instructions to ensure a smooth arrival experience.
/// All fields are nullable as assignments may not be finalized yet.
class ConciergeInfo {
  /// Name of the assigned driver (null if not assigned yet)
  final String? driverName;

  /// Phone number of the assigned driver (null if not assigned yet)
  final String? driverPhone;

  /// Name of the assigned concierge (null if not assigned yet)
  final String? conciergeName;

  /// Phone number of the assigned concierge (null if not assigned yet)
  final String? conciergePhone;

  /// URL to the concierge's photo (null if not assigned yet)
  final String? conciergePhotoUrl;

  /// Physical address of the assigned villa (null if not assigned yet)
  final String? villaAddress;

  /// URL to an image of the villa (null if not assigned yet)
  final String? villaImageUrl;

  /// Instructions for checking into the villa (null if not assigned yet)
  final String? checkInInstructions;

  /// Creates a new [ConciergeInfo] instance.
  const ConciergeInfo({
    this.driverName,
    this.driverPhone,
    this.conciergeName,
    this.conciergePhone,
    this.conciergePhotoUrl,
    this.villaAddress,
    this.villaImageUrl,
    this.checkInInstructions,
  });

  /// Creates a copy of this concierge info with the given fields replaced with new values.
  ConciergeInfo copyWith({
    String? driverName,
    String? driverPhone,
    String? conciergeName,
    String? conciergePhone,
    String? conciergePhotoUrl,
    String? villaAddress,
    String? villaImageUrl,
    String? checkInInstructions,
  }) {
    return ConciergeInfo(
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      conciergeName: conciergeName ?? this.conciergeName,
      conciergePhone: conciergePhone ?? this.conciergePhone,
      conciergePhotoUrl: conciergePhotoUrl ?? this.conciergePhotoUrl,
      villaAddress: villaAddress ?? this.villaAddress,
      villaImageUrl: villaImageUrl ?? this.villaImageUrl,
      checkInInstructions: checkInInstructions ?? this.checkInInstructions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ConciergeInfo &&
        other.driverName == driverName &&
        other.driverPhone == driverPhone &&
        other.conciergeName == conciergeName &&
        other.conciergePhone == conciergePhone &&
        other.conciergePhotoUrl == conciergePhotoUrl &&
        other.villaAddress == villaAddress &&
        other.villaImageUrl == villaImageUrl &&
        other.checkInInstructions == checkInInstructions;
  }

  @override
  int get hashCode {
    return driverName.hashCode ^
        driverPhone.hashCode ^
        conciergeName.hashCode ^
        conciergePhone.hashCode ^
        conciergePhotoUrl.hashCode ^
        villaAddress.hashCode ^
        villaImageUrl.hashCode ^
        checkInInstructions.hashCode;
  }

  @override
  String toString() {
    return 'ConciergeInfo(driverName: $driverName, driverPhone: $driverPhone, conciergeName: $conciergeName, conciergePhone: $conciergePhone, conciergePhotoUrl: $conciergePhotoUrl, villaAddress: $villaAddress, villaImageUrl: $villaImageUrl, checkInInstructions: $checkInInstructions)';
  }
}
