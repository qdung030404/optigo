import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


import '../models/booking_model.dart';

class TripService {
  final _client = Supabase.instance.client;

  static SupabaseClient authClient(String token) => SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_ANON_KEY']!,
    headers: {'Authorization': 'Bearer $token'},
  );


  /// Lấy tất cả chuyến đi có status = 'open' từ Supabase
  Future<List<TripModel>> fetchOpenTrips() async {
    final response = await _client
        .from('trips')
        .select('*, profiles(user_name, license_plate, phone)')
        .eq('status', 'open')
        .order('departure_time', ascending: true);

    return (response as List)
        .map((json) => TripModel.fromJson(json))
        .toList();
  }
  Future<List<BookingModel>> fetchBookings(String passengerId, {SupabaseClient? client}) async {
    final supabaseClient = client ?? _client;
    final response = await supabaseClient.from('bookings').select().eq('passenger_id', passengerId);
    return (response as List)
        .map((json) => BookingModel.fromJson(json))
        .toList();
  }
  Future<String?> getRoutePolyline(LatLng origin, LatLng destination) async {
    try{
      final apiKey = dotenv.env['GOONG_API_KEY'];
      if (apiKey == null) throw Exception('Goong API Key not found');
      final url = 'https://rsapi.goong.io/Direction?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&vehicle=car&api_key=$apiKey';
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        if(data['routes'] != null && (data['routes'] as List).isNotEmpty){
          var route = data['routes'][0]['overview_polyline']['points'];
          return route;
        }else{
          debugPrint('Goong API Error: ${response.statusCode} - ${response.body}');
        }
      }
    }catch(e){
      debugPrint('Failed to fetch route polyline: $e');
      return null;
    }
    return null;

  }
  Future<void> createTrip(TripModel trip, String idToken) async {
    try {
      await authClient(idToken).from('trips').insert(trip.toMap());
    } catch (e) {
      debugPrint('Failed to create trip: $e');
      rethrow;
    }
  }
  Future<void> updateTrip({required String tripId, required int seatsReduce, required String idToken}) async {
    try{
      await authClient(idToken).rpc('book_trip_and_update_seats', params: {'p_trip_id': tripId, 'p_seats_to_reduce': seatsReduce});
    }catch(e){
      debugPrint('Failed to update trip: $e');
      rethrow;
    }
  }
  Future<void> deleteBooking({required String tripId, required int bookingId, required int seatsReturn, required String idToken}) async {
    try {
      await authClient(idToken).rpc('cancel_booking_and_return_seats',
          params: {'p_trip_id': tripId, 'p_booking_id': bookingId, 'p_seats_to_return': seatsReturn});
    }catch (e) {
      debugPrint('Failed to delete booking: $e');
      rethrow;
    }
  }
  /// Lấy thông tin chi tiết của một chuyến đi theo ID
  Future<TripModel> fetchTripById(String tripId) async {
    final response = await _client
        .from('trips')
        .select('*, profiles(user_name, license_plate, phone)')
        .eq('id', tripId)
        .single();

    return TripModel.fromJson(response);
  }
}
