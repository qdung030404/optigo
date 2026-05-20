import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:optigo/models/trip_model.dart';

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
}
