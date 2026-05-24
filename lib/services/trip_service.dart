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

  /// Lấy tất cả chuyến đi có status = 'open' từ Supabase
  Future<List<TripModel>> fetchOpenTrips() async {
    final response = await _client
        .from('trips')
        .select()
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
      // Tạo một client tạm thời có header xác thực từ Firebase để vượt qua RLS
      final authenticatedClient = SupabaseClient(
        dotenv.env['SUPABASE_URL']!,
        dotenv.env['SUPABASE_ANON_KEY']!,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      await authenticatedClient.from('trips').insert(trip.toMap());
    } catch (e) {
      debugPrint('Failed to create trip: $e');
      rethrow;
    }
  }
}
