import 'package:isar/isar.dart';
import '../../domain/entities/concierge_info.dart';

part 'concierge_info_model.g.dart';

/// Data model for [ConciergeInfo] entity with Isar persistence.
@collection
class ConciergeInfoModel {
  /// Isar auto-increment ID.
  Id isarId = Isar.autoIncrement;

  /// The booking ID this concierge info is associated with.
  @Index(unique: true)
  late String bookingId;

  /// Name of the assigned driver.
  late String driverName;

  /// Phone number of the assigned driver.
  late String driverPhone;

  /// Name of the assigned concierge.
  late String conciergeName;

  /// Phone number of the assigned concierge.
  late String conciergePhone;

  /// URL to the concierge's photo.
  late String conciergePhotoUrl;

  /// Physical address of the assigned villa.
  late String villaAddress;

  /// URL to an image of the villa.
  late String villaImageUrl;

  /// Instructions for checking into the villa.
  late String checkInInstructions;

  /// Converts this model to a domain entity.
  ConciergeInfo toEntity() {
    return ConciergeInfo(
      driverName: driverName,
      driverPhone: driverPhone,
      conciergeName: conciergeName,
      conciergePhone: conciergePhone,
      conciergePhotoUrl: conciergePhotoUrl,
      villaAddress: villaAddress,
      villaImageUrl: villaImageUrl,
      checkInInstructions: checkInInstructions,
    );
  }

  /// Creates a model from a domain entity.
  static ConciergeInfoModel fromEntity(ConciergeInfo info, String bookingId) {
    return ConciergeInfoModel()
      ..bookingId = bookingId
      ..driverName = info.driverName
      ..driverPhone = info.driverPhone
      ..conciergeName = info.conciergeName
      ..conciergePhone = info.conciergePhone
      ..conciergePhotoUrl = info.conciergePhotoUrl
      ..villaAddress = info.villaAddress
      ..villaImageUrl = info.villaImageUrl
      ..checkInInstructions = info.checkInInstructions;
  }
}
