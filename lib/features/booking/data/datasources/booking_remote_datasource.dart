import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote data source for booking operations using Supabase.
///
/// This class handles all remote operations related to bookings,
/// including creating, retrieving, and updating booking records in Supabase.
class BookingRemoteDatasource {
  /// The Supabase client instance.
  final SupabaseClient _supabaseClient;

  /// Table name for bookings in Supabase.
  static const String _bookingsTable = 'bookings';

  /// Creates an instance of [BookingRemoteDatasource].
  ///
  /// [supabaseClient]: The Supabase client to use for remote operations.
  BookingRemoteDatasource({required SupabaseClient supabaseClient})
      : _supabaseClient = supabaseClient;

  /// Creates a new booking in Supabase.
  ///
  /// Returns the created booking data as a Map.
  /// Throws an exception if the operation fails.
  Future<Map<String, dynamic>> createBooking({
    required String id,
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required bool isCheckedIn,
  }) async {
    try {
      final data = {
        'id': id,
        'user_id': userId,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'is_checked_in': isCheckedIn,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabaseClient
          .from(_bookingsTable)
          .insert(data)
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to create booking in Supabase: ${e.message}');
    } catch (e) {
      throw Exception('Failed to create booking in Supabase: $e');
    }
  }

  /// Retrieves the active booking for a given user.
  ///
  /// Returns the booking data as a Map, or null if no active booking exists.
  /// Throws an exception if the operation fails.
  Future<Map<String, dynamic>?> getActiveBookingForUser(String userId) async {
    try {
      final response = await _supabaseClient
          .from(_bookingsTable)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      return response;
    } on PostgrestException catch (e) {
      throw Exception(
          'Failed to retrieve booking from Supabase: ${e.message}');
    } catch (e) {
      throw Exception('Failed to retrieve booking from Supabase: $e');
    }
  }

  /// Updates an existing booking in Supabase.
  ///
  /// Returns the updated booking data as a Map.
  /// Throws an exception if the operation fails.
  Future<Map<String, dynamic>> updateBooking({
    required String id,
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required bool isCheckedIn,
  }) async {
    try {
      final data = {
        'user_id': userId,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'is_checked_in': isCheckedIn,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _supabaseClient
          .from(_bookingsTable)
          .update(data)
          .eq('id', id)
          .select()
          .single();

      return response;
    } on PostgrestException catch (e) {
      throw Exception('Failed to update booking in Supabase: ${e.message}');
    } catch (e) {
      throw Exception('Failed to update booking in Supabase: $e');
    }
  }

  /// Deletes a booking from Supabase.
  ///
  /// Throws an exception if the operation fails.
  Future<void> deleteBooking(String id) async {
    try {
      await _supabaseClient.from(_bookingsTable).delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Failed to delete booking from Supabase: ${e.message}');
    } catch (e) {
      throw Exception('Failed to delete booking from Supabase: $e');
    }
  }
}
