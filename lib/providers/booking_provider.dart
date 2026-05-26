import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:optigo/services/trip_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  bool _isSuccess = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  final _tripService = TripService();
  bool _isNow = false;
  bool _isTimeSelected = false;
  DateTime _selectedDate = DateTime.now();
  String _note = "";
  int _passengerCount = 1;
  String _paymentMethod = "Tiền mặt";
  bool _showBookingBottomSheet = true;

  bool get isNow => _isNow;
  DateTime get selectedDate => _selectedDate;
  bool get isTimeSelected => _isTimeSelected;
  int get passengerCount => _passengerCount;
  String get paymentMethod => _paymentMethod;
  String get note => _note;
  bool get showBookingBottomSheet => _showBookingBottomSheet;

  void setShowBookingBottomSheet(bool value) {
    _showBookingBottomSheet = value;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setNote(String note) {
    _note = note;
    notifyListeners();
  }

  void setIsNow(bool isNow) {
    _isNow = isNow;
    notifyListeners();
  }

  void confirmTime() {
    _isTimeSelected = true;
    notifyListeners();
  }

  void incrementPassenger() {
    _updatePassengerCount(_passengerCount + 1);
  }

  void decrementPassenger() {
    _updatePassengerCount(_passengerCount - 1);
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void _updatePassengerCount(int newCount) {
    if (newCount >= 1) {
      _passengerCount = newCount;
      notifyListeners();
    }
  }

  List<BookingModel> _bookings = [];
  List<BookingModel> get bookings => _bookings;

  String? _bookingErrorMessage;
  String? get bookingErrorMessage => _bookingErrorMessage;

  void setSuccess(bool value) {
    _isSuccess = value;
    notifyListeners();
  }

  Future<void> createBooking(BookingModel booking) async {
    _isLoading = true;
    notifyListeners();
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
      _isLoading = false;
    }finally{
      _isLoading = false;
      notifyListeners();
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
    _isLoading = true;
    _bookingErrorMessage = null;
    _bookings = [];
    notifyListeners();

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        _bookingErrorMessage = "Người dùng chưa đăng nhập";
        _isLoading = false;
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
      _isLoading = false;
      debugPrint('[Booking] Load bookings THẤT BẠI: $e');
      _bookingErrorMessage = "Không thể tải danh sách chuyến đi";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
