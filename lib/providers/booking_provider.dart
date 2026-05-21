import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:optigo/services/trip_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;
  final _tripService = TripService();
  List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;


  bool _isLoadingBookings = false;
  bool get isLoadingBookings => _isLoadingBookings;
  String? _bookingErrorMessage;
  String? get bookingErrorMessage => _bookingErrorMessage;

  void setSuccess(bool value) {
    _isSuccess = value;
    notifyListeners();
  }

  Future<void> createBooking(BookingModel booking) async {
    final currentUser = FirebaseAuth.instance.currentUser!;
    final idToken = await currentUser.getIdToken();

    final supabase = SupabaseClient(
      dotenv.env['SUPABASE_URL']!,
      dotenv.env['SUPABASE_ANON_KEY']!,
      headers: {'Authorization': 'Bearer $idToken'},
    );

    // Bước 1: Đảm bảo profile tồn tại
    try {
      await supabase.from('profiles').upsert(
        {
          'id': currentUser.uid,
          'phone': currentUser.phoneNumber ?? '',
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'id',
      );
    } catch (e) {
      debugPrint('[Booking] Profile upsert THẤT BẠI: $e');
      rethrow;
    }

    // Bước 2: Tạo booking
    try {
      await supabase.from('bookings').insert(booking.toMap());
    } catch (e) {
      debugPrint('[Booking] Booking insert THẤT BẠI: $e');
      rethrow;
    }
  }

  Future<void> loadBookings() async {
    _isLoadingBookings = true;
    _bookingErrorMessage = null;
    _bookings = [];
    notifyListeners();

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _bookingErrorMessage = "Người dùng chưa đăng nhập";
        _isLoadingBookings = false;
        notifyListeners();
        return;
      }

      final idToken = await currentUser.getIdToken();
      final supabase = SupabaseClient(
        dotenv.env['SUPABASE_URL']!,
        dotenv.env['SUPABASE_ANON_KEY']!,
        headers: {'Authorization': 'Bearer $idToken'},
      );

      final List<BookingModel> allBookings = await _tripService.fetchBookings(
        currentUser.uid,
        client: supabase,
      );
      _bookings = allBookings;
      print( currentUser.uid);
    } catch (e) {
      debugPrint('[Booking] Load bookings THẤT BẠI: $e');
      _bookingErrorMessage = "Không thể tải danh sách chuyến đi";
    } finally {
      _isLoadingBookings = false;
      notifyListeners();
    }
  }
}
