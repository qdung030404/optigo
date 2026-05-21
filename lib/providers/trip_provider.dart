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

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
