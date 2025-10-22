import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote datasource for fetching concierge assignment data from Supabase.
///
/// This datasource handles all communication with the Supabase
/// `concierge_assignments` table, providing methods to fetch concierge,
/// driver, and villa information for a specific booking.
class ConciergeRemoteDatasource {
  /// The Supabase client used for database operations.
  final SupabaseClient _supabaseClient;

  /// Creates an instance of [ConciergeRemoteDatasource].
  ///
  /// [supabaseClient] The Supabase client to use for database operations.
  const ConciergeRemoteDatasource({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  /// Fetches concierge assignment information for a specific booking.
  ///
  /// Returns a Map containing the concierge assignment data from Supabase,
  /// or null if no assignment exists for the given booking ID.
  ///
  /// [bookingId] The ID of the booking to fetch concierge info for.
  ///
  /// Throws an exception if the database query fails.
  Future<Map<String, dynamic>?> getConciergeInfo(String bookingId) async {
    try {
      final response = await _supabaseClient
          .from('concierge_assignments')
          .select()
          .eq('booking_id', bookingId)
          .maybeSingle();

      return response;
    } catch (e) {
      throw Exception('Failed to fetch concierge info from Supabase: $e');
    }
  }

  /// Streams concierge assignment information for a specific booking in real-time.
  ///
  /// Returns a Stream that emits updates whenever the concierge assignment
  /// data changes in the database.
  ///
  /// [bookingId] The ID of the booking to watch for concierge info changes.
  ///
  /// The stream will emit:
  /// - Initial data immediately when subscribed
  /// - New data whenever the row is updated
  /// - New data when a row is inserted for this booking
  Stream<Map<String, dynamic>?> watchConciergeInfo(String bookingId) {
    print('📡 [ConciergeDataSource] Setting up real-time stream for booking: $bookingId');

    return _supabaseClient
        .from('concierge_assignments')
        .stream(primaryKey: ['id'])
        .eq('booking_id', bookingId)
        .map((data) {
          print('📨 [ConciergeDataSource] Stream event received - Records: ${data.length}');
          if (data.isNotEmpty) {
            print('   Data: ${data.first}');
          }
          return data.isEmpty ? null : data.first;
        });
  }

  /// Creates or updates a concierge assignment for a booking.
  ///
  /// [bookingId] The ID of the booking.
  /// [driverName] The name of the assigned driver (optional).
  /// [driverPhone] The phone number of the assigned driver (optional).
  /// [conciergeName] The name of the assigned concierge (optional).
  /// [conciergePhone] The phone number of the assigned concierge (optional).
  /// [conciergePhotoUrl] The URL to the concierge's photo (optional).
  /// [villaAddress] The address of the assigned villa (optional).
  /// [villaImageUrl] The URL to an image of the villa (optional).
  /// [checkInInstructions] Instructions for checking in (optional).
  ///
  /// Throws an exception if the database operation fails.
  Future<void> upsertConciergeInfo({
    required String bookingId,
    String? driverName,
    String? driverPhone,
    String? conciergeName,
    String? conciergePhone,
    String? conciergePhotoUrl,
    String? villaAddress,
    String? villaImageUrl,
    String? checkInInstructions,
  }) async {
    try {
      await _supabaseClient.from('concierge_assignments').upsert({
        'booking_id': bookingId,
        'driver_name': driverName,
        'driver_phone': driverPhone,
        'concierge_name': conciergeName,
        'concierge_phone': conciergePhone,
        'concierge_photo_url': conciergePhotoUrl,
        'villa_address': villaAddress,
        'villa_image_url': villaImageUrl,
        'check_in_instructions': checkInInstructions,
      });
    } catch (e) {
      throw Exception('Failed to upsert concierge info in Supabase: $e');
    }
  }
}
