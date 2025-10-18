/// Contains concierge information for a user's wellness journey.
///
/// This includes details about the assigned driver, villa accommodation,
/// and check-in instructions to ensure a smooth arrival experience.
class ConciergeInfo {
  /// Name of the assigned driver
  final String driverName;

  /// Phone number of the assigned driver
  final String driverPhone;

  /// Physical address of the assigned villa
  final String villaAddress;

  /// URL to an image of the villa
  final String villaImageUrl;

  /// Instructions for checking into the villa
  final String checkInInstructions;

  /// Creates a new [ConciergeInfo] instance.
  const ConciergeInfo({
    required this.driverName,
    required this.driverPhone,
    required this.villaAddress,
    required this.villaImageUrl,
    required this.checkInInstructions,
  });

  /// Creates a copy of this concierge info with the given fields replaced with new values.
  ConciergeInfo copyWith({
    String? driverName,
    String? driverPhone,
    String? villaAddress,
    String? villaImageUrl,
    String? checkInInstructions,
  }) {
    return ConciergeInfo(
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
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
        other.villaAddress == villaAddress &&
        other.villaImageUrl == villaImageUrl &&
        other.checkInInstructions == checkInInstructions;
  }

  @override
  int get hashCode {
    return driverName.hashCode ^
        driverPhone.hashCode ^
        villaAddress.hashCode ^
        villaImageUrl.hashCode ^
        checkInInstructions.hashCode;
  }

  @override
  String toString() {
    return 'ConciergeInfo(driverName: $driverName, driverPhone: $driverPhone, villaAddress: $villaAddress, villaImageUrl: $villaImageUrl, checkInInstructions: $checkInInstructions)';
  }
}
