import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/services/trip_service.dart';

import '../utils/route_matcher.dart';

class TripProvider extends ChangeNotifier {
  bool _isNow = false;
  bool _isTimeSelected = false;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _note = "";
  int _passengerCount = 1;
  String _paymentMethod = "Tiền mặt";
  List<TripModel> _trips = [];
  bool _isLoading = false;
  bool _showBookingBottomSheet = true;
  String? _errorMessage;

  final _tripService = TripService();

  final SearchController searchController = SearchController();

  SearchController get searchCtrl => searchController;

  TripProvider() {
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    notifyListeners();
  }

  bool get isNow => _isNow;
  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;
  bool get isTimeSelected => _isTimeSelected;
  int get passengerCount => _passengerCount;
  String get paymentMethod => _paymentMethod;
  String get note => _note;
  List<TripModel> get trips => _trips;
  bool get isLoading => _isLoading;
  bool get showBookingBottomSheet => _showBookingBottomSheet;

  String? get errorMessage => _errorMessage;

  void setShowBookingBottomSheet(bool value) {
    _showBookingBottomSheet = value;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setTime(TimeOfDay time) {
    _selectedTime = time;
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

  Future<void> findTrips({
    required LatLng origin,
    required LatLng destination,
  }) async {
    _isLoading = true;
    _trips = [];
    _errorMessage = null;
    notifyListeners();

    try {
      final List<TripModel> allTrips = await _tripService.fetchOpenTrips();
      List<TripModel> recommendedTrips = [];

      for (var trip in allTrips) {
        if (trip.availableSeats < _passengerCount) {
          continue;
        }

        if (!_isNow) {
          DateTime tripDateTime = trip.departureTime;
          bool isSameDay =
              tripDateTime.year == _selectedDate.year &&
              tripDateTime.month == _selectedDate.month &&
              tripDateTime.day == _selectedDate.day;
          if (!isSameDay) {
            continue;
          }
        }

        if (trip.routePolyline.isNotEmpty) {
          List<LatLng> driverRoute = RouteMatcher.decodePolyline(
            trip.routePolyline,
          );
          double score = RouteMatcher.calculateDistance(
            userOrigin: origin,
            userDestination: destination,
            driverRoute: driverRoute,
          );

          if (score >= 50.0) {
            recommendedTrips.add(trip);
          }
        }
      }

      _trips = recommendedTrips;
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách chuyến đi: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<String?> fetchRoutePolyline(LatLng origin, LatLng destination) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try{
      final routePolyline = await _tripService.getRoutePolyline(origin, destination);
      if (routePolyline == null) {
        _errorMessage = "Không thể lấy thông tin đường đi từ bản đồ.";
      }
      return routePolyline;
    }catch(e){
      _errorMessage = e.toString();
      return null;
    }finally{
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<bool> createTrip(TripModel trip) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Lấy token hiện tại của người dùng Firebase để xác thực với Supabase vượt qua RLS
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (idToken == null) throw Exception("User not authenticated");

      await _tripService.createTrip(trip, idToken);
      return true;
    } catch (e) {
      _errorMessage = 'Lỗi tạo chuyến đi: $e';
      debugPrint('Error creating trip: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
