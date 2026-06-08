import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:optigo/services/trip_service.dart';
import 'package:optigo/utils/currency_formatter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/booking_model.dart';
import '../services/booking_service.dart';
import '../services/realtime_notification_service.dart';

class BookingProvider extends ChangeNotifier {
  final _realtimeService = RealtimeNotificationService();
  bool _isSuccess = false;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  
  // Callback để thông báo cho UI (như HomeScreen) khi có thay đổi trạng thái
  void Function(BookingModel)? onBookingStatusChanged;

  final _tripService = TripService();
  final _bookingService = BookingService();
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

  final currentUser = FirebaseAuth.instance.currentUser;
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
    _isSuccess = false;
    _bookingErrorMessage = null;
    notifyListeners();

    try {
      final idToken = await currentUser?.getIdToken();
      if (idToken == null) throw Exception("Người dùng chưa đăng nhập");
      await TripService.authClient(idToken).from('profiles').upsert({
        'id': currentUser?.uid,
        'phone': currentUser?.phoneNumber ?? '',
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'id');

      // Gọi RPC kiểm tra & cập nhật seats
      await _tripService.updateTrip(
        tripId: booking.tripId,
        seatsReduce: passengerCount,
        idToken: idToken,
      );

      // Insert booking
      await TripService.authClient(
        idToken,
      ).from('bookings').insert(booking.toMap());
      _isSuccess = true;
    } on PostgrestException catch (e) {
      if (e.message.contains('seat_full')) {
        _bookingErrorMessage = 'seat_full';
      } else if (e.message.contains('not_enough_seats')) {
        _bookingErrorMessage = 'not_enough_seats';
      } else {
        _bookingErrorMessage = 'Đặt chuyến thất bại';
      }
    } catch (e) {
      _bookingErrorMessage = 'Đã có lỗi xảy ra, vui lòng thử lại';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadBookings() async {
    _isLoading = true;
    _bookingErrorMessage = null;
    _bookings = [];
    notifyListeners();

    try {
      if (currentUser == null) {
        _bookingErrorMessage = "Người dùng chưa đăng nhập";
        _isLoading = false;
        notifyListeners();
        return;
      }

      final idToken = await currentUser?.getIdToken();
      if (idToken == null) throw Exception("Người dùng chưa đăng nhập");
      final List<BookingModel> allBookings = await _bookingService.fetchBookings(
        currentUser!.uid,
        client: TripService.authClient(idToken),
      );
      _bookings = allBookings;
      
      // Khởi động real-time sau khi tải dữ liệu xong
      _realtimeService.subscribeToBookingsForPassenger(
        currentUser!.uid,
        (data) => _handleBookingUpdate(data),
      );
    } catch (e) {
      _isLoading = false;
      _bookingErrorMessage = "Không thể tải danh sách chuyến đi";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _handleBookingUpdate(Map<String, dynamic> data) {
    final updatedBooking = BookingModel.fromJson(data);
    final index = _bookings.indexWhere((b) => b.id == updatedBooking.id);
    
    if (index != -1) {
      // Cập nhật đơn hàng cũ bằng đơn hàng mới
      _bookings[index] = updatedBooking;
      notifyListeners(); // Cập nhật UI (như BookingManager) ngay lập tức!
      
      // Kích hoạt callback nếu có (như hiện SnackBar ở HomeScreen)
      onBookingStatusChanged?.call(updatedBooking);
    }
  }

  @override
  void dispose() {
    _realtimeService.unsubscribe();
    super.dispose();
  }
  Future<List<BookingModel>> loadBookingsForDriver(String driverId) async {
    _isLoading = true;
    _bookingErrorMessage = null;
    _bookings = [];
    Future.microtask(() => notifyListeners());
    try{
      final idToken = await currentUser?.getIdToken();
      if (idToken == null) throw Exception("Người dùng chưa đăng nhập");
      final List<BookingModel> allBookings = await _bookingService.fetchBookingsForDriver(
        driverId,
        idToken,
      );
      return allBookings;
    }catch(e){
      _isLoading = false;
      _bookingErrorMessage = "Không thể tải danh sách yêu cầu ghép chuyến";
      return [];
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> contactDriver(String phoneNumber) async {
    String cleanNumber = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    String formattedNumber = Formatter.phoneFormatter(cleanNumber);
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: formattedNumber,
    );

    //Kiểm tra xem thiết bị có thể mở ứng dụng gọi điện không
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      //Xử lý lỗi nếu thiết bị không hỗ trợ (ví dụ: máy tính bảng không có SIM)
      debugPrint('Không thể mở ứng dụng gọi điện với số: $cleanNumber');
    }
  }
  Future<void> cancelBooking(BookingModel booking) async {
    if (booking.id == null) return;

    _isLoading = true;
    notifyListeners();
    try {
      final idToken = await currentUser?.getIdToken();
      if (idToken == null) throw Exception("Người dùng chưa đăng nhập");
      await _bookingService.deleteBooking(
        tripId: booking.tripId,
        bookingId: booking.id!,
        seatsReturn: booking.numberOfPassengers,
        idToken: idToken,

      );
      _bookings.removeWhere((b) => b.id == booking.id);
    } catch (e) {
      debugPrint('Error canceling booking: $e');
      _bookingErrorMessage = "Không thể hủy chuyến đi. Vui lòng thử lại.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> confirmBooking(String driverId, int bookingId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final idToken = await currentUser?.getIdToken();
      if (idToken == null) throw Exception("Người dùng chưa đăng nhập");
      await _bookingService.confirmBooking(driverId, bookingId, idToken);
      _isSuccess = true;
      debugPrint('Booking confirmed successfully');
    } catch (e) {
      _isSuccess = false;
      debugPrint('Error confirming booking: $e');
      _bookingErrorMessage = e is PostgrestException
          ? e.message
          : "Không thể xác nhận chuyến đi. Vui lòng thử lại.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
