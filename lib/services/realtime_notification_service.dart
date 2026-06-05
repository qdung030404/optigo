import 'package:optigo/models/booking_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RealtimeNotificationService {
  RealtimeChannel? _channel;

  // SỬ DỤNG CLIENT MẶC ĐỊNH (ANON) ĐỂ TRÁNH LỖI JWT
  final _supabase = Supabase.instance.client;

  Future<void> subscribeToBookings(
    String currentDriverId,
    Function(Map<String, dynamic>) onNewBooking,
  ) async {
    _channel = _supabase
        .channel('public:bookings')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'bookings',
          callback: (payload) async {
            final newBooking = payload.newRecord;
            final tripId = newBooking['trip_id'];

            try {
              final tripData = await _supabase
                  .from('trips')
                  .select('driver_id')
                  .eq('id', tripId)
                  .single();

              if (tripData['driver_id'] == currentDriverId) {
                onNewBooking(newBooking);
              }
            } catch (e) {
              print('[Realtime] Lỗi xử lý callback: $e');
            }
          },
        )
        .subscribe((status, [error]) {
          print('[Realtime] Trạng thái Channel: $status');
          if (error != null) print('[Realtime] Lỗi Channel: $error');
        });
  }

  Future<void> subscribeToBookingsForPassenger(
    String currentPassengerId,
    Function(Map<String, dynamic>) onUpdateStatus,
  ) async {
    _channel = _supabase
        .channel('public:bookings')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'bookings',
          callback: (payload) async {
            final record = payload.newRecord;

            if (record['passenger_id'] == currentPassengerId) {
              final status = BookingStatus.fromString(
                record['status'] ?? 'pending',
              );
              print(
                '[Realtime-Passenger] Cập nhật trạng thái: ${status.label}',
              );
              onUpdateStatus(record);
            }
          },
        )
        .subscribe((status, [error]) {
          print('[Realtime] Trạng thái Channel: $status');
          if (error != null) print('[Realtime] Lỗi Channel: $error');
        });
  }

  void unsubscribe() {
    _channel?.unsubscribe();
  }
}
