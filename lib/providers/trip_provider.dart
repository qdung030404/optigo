import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/services/trip_service.dart';

import '../utils/route_matcher.dart';

class TripProvider extends ChangeNotifier {
  List<TripModel> _trips = [];
  bool _isLoading = false;
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

  List<TripModel> get trips => _trips;
  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> findTrips({
    required LatLng origin,
    required LatLng destination,
    required int passengerCount,
    required bool isNow,
    required DateTime selectedDate,
  }) async {
    _isLoading = true;
    _trips = [];
    _errorMessage = null;
    notifyListeners();

    try {
      final List<TripModel> allTrips = await _tripService.fetchOpenTrips();
      List<TripModel> recommendedTrips = [];

      for (var trip in allTrips) {
        if (trip.availableSeats < passengerCount) {
          continue;
        }

        if (!isNow) {
          DateTime tripDateTime = trip.departureTime;
          bool isSameDay =
              tripDateTime.year == selectedDate.year &&
              tripDateTime.month == selectedDate.month &&
              tripDateTime.day == selectedDate.day;
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

  Future<void> loadAllTrips() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final List<TripModel> allTrips = await _tripService.fetchOpenTrips();
      _trips = allTrips;
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
  Future<TripModel?> getTripById(String id) async {
    try {
      return await _tripService.fetchTripById(id);
    } catch (e) {
      debugPrint('Error fetching trip by ID: $e');
      return null;
    }
  }
  Future<List<TripModel>> loadTripsByDriverId(String driverId) async {
    _isLoading = true;
    _errorMessage = null;
    Future.microtask(() => notifyListeners());
    try{
      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();
      if (idToken == null) throw Exception("User not authenticated");
      final trips = await _tripService.fetchTripsByDriverId(driverId, idToken);
      return trips;
    }catch(e){
      _errorMessage = e.toString();
      return [];
    }finally{
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
