import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/booking_model.dart';

class BookingService {
  final _client = Supabase.instance.client;

  static SupabaseClient authClient(String token) => SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_ANON_KEY']!,
    headers: {'Authorization': 'Bearer $token'},
  );
  Future<List<BookingModel>> fetchBookings(String passengerId, {SupabaseClient? client}) async {
    try{
      final supabaseClient = client ?? _client;
      final response = await supabaseClient.from('bookings').select().eq('passenger_id', passengerId);
      return (response as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();
    }catch(e){
      debugPrint('fetchBookings error: $e');
      rethrow;
    }
  }
  Future<void> deleteBooking({required String tripId, required int bookingId, required int seatsReturn, required String idToken}) async {
     try{
       await authClient(idToken).rpc('cancel_booking', params: {'p_trip_id': tripId, 'p_booking_id': bookingId, 'p_seats_to_return': seatsReturn});
     }catch(e){
       debugPrint('Failed to delete booking: $e');
       rethrow;
     }
  }
  Future<List<BookingModel>> fetchBookingsForDriver(String driverId, String idToken) async {
    try {
      final response = await authClient(idToken)
          .rpc('get_bookings_for_driver', params: {'p_driver_id': driverId});
      return (response as List)
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('fetchBookingsForDriver error: $e');
      rethrow;
    }
  }
  Future<void> confirmBooking(String driverId, String bookingId, String idToken) async {
    try{
      await authClient(idToken).rpc('confirm_booking', params: {'p_driver_id': driverId, 'p_booking_id': bookingId});
    }
    catch(e){
      debugPrint('Failed to confirm booking: $e');
      rethrow;
    }
  }
}