import 'package:isar/isar.dart';
import '../../domain/entities/concierge_info.dart';

part 'concierge_info_model.g.dart';

/// Data model for [ConciergeInfo] entity with Isar persistence and Supabase serialization.
@collection
class ConciergeInfoModel {
  /// Isar auto-increment ID.
  Id isarId = Isar.autoIncrement;

  /// The booking ID this concierge info is associated with.
  @Index(unique: true)
  late String bookingId;

  /// Name of the assigned driver (nullable).
  String? driverName;

  /// Phone number of the assigned driver (nullable).
  String? driverPhone;

  /// Name of the assigned concierge (nullable).
  String? conciergeName;

  /// Phone number of the assigned concierge (nullable).
  String? conciergePhone;

  /// URL to the concierge's photo (nullable).
  String? conciergePhotoUrl;

  /// Physical address of the assigned villa (nullable).
  String? villaAddress;

  /// URL to an image of the villa (nullable).
  String? villaImageUrl;

  /// Instructions for checking into the villa (nullable).
  String? checkInInstructions;

  /// Creates a new [ConciergeInfoModel] instance.
  ConciergeInfoModel();

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

  /// Creates a model from Supabase JSON data.
  factory ConciergeInfoModel.fromSupabaseJson(Map<String, dynamic> json) {
    return ConciergeInfoModel()
      ..bookingId = json['booking_id'] as String
      ..driverName = json['driver_name'] as String?
      ..driverPhone = json['driver_phone'] as String?
      ..conciergeName = json['concierge_name'] as String?
      ..conciergePhone = json['concierge_phone'] as String?
      ..conciergePhotoUrl = json['concierge_photo_url'] as String?
      ..villaAddress = json['villa_address'] as String?
      ..villaImageUrl = json['villa_image_url'] as String?
      ..checkInInstructions = json['check_in_instructions'] as String?;
  }

  /// Converts this model to Supabase JSON format.
  Map<String, dynamic> toSupabaseJson() {
    return {
      'booking_id': bookingId,
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'concierge_name': conciergeName,
      'concierge_phone': conciergePhone,
      'concierge_photo_url': conciergePhotoUrl,
      'villa_address': villaAddress,
      'villa_image_url': villaImageUrl,
      'check_in_instructions': checkInInstructions,
    };
  }
}
