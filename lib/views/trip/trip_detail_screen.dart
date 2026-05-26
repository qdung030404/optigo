import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/models/booking_model.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/utils/route_matcher.dart';
import 'package:optigo/views/trip/widget/departure_time_card.dart';
import 'package:optigo/views/trip/widget/driver_infomation_card.dart';
import 'package:optigo/views/trip/widget/pickup_points_bottom_sheet.dart';
import 'package:optigo/views/trip/widget/route_details_card.dart';
import 'package:provider/provider.dart';

import '../../providers/booking_provider.dart';

class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({super.key});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  String? selectedName;
  LatLng? _selectedPickupPoint;

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: const Color(0xff176bac),
                size: 80.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                'đặt chuyến thành công',
                style: GoogleFonts.lexend(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfffedd59),
                    foregroundColor: Color(0xff176bac),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName(Routes.home));
                  },
                  child: Text(
                      'Quay về trang chủ'
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.read<BookingProvider>();
    final tripProvider = context.read<TripProvider>();
    final trip = ModalRoute.of(context)!.settings.arguments as TripModel;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chi tiết chuyến đi',
          style: GoogleFonts.lexend(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Route Details Card
            RouteDetailsCard(
              trip: trip,
              selectedPickupPoint: selectedName,
              onPickupTap: () async {
                final mapProvider = context.read<MapProvider>();
                if (mapProvider.currentLatLng != null &&
                    trip.routePolyline.isNotEmpty) {
                  final driverRoute = RouteMatcher.decodePolyline(
                    trip.routePolyline,
                  );
                  final candidates = RouteMatcher.getPickUpPoint(
                    userOrigin: mapProvider.currentLatLng!,
                    driverRoute: driverRoute,
                  );
                  final result =
                      await showModalBottomSheet<Map<String, dynamic>>(
                        context: context,
                        builder: (context) => PickupPointsBottomSheet(
                          points: candidates,
                          initialSelectedAddress: selectedName,
                        ),
                      );

                  if (result != null) {
                    setState(() {
                      selectedName = result['name'];
                      _selectedPickupPoint = result['point'];
                    });
                  }
                }
              },
            ),
            SizedBox(height: 16.h),
            // Departure Time Card
            DepartureTimeCard(trip: trip),
            SizedBox(height: 16.h),
             DriverInfomationCard(
              driverName: trip.driverName ?? '',
              driverLicensePlate: trip.driverLicensePlate ?? '',
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(padding: EdgeInsets.all(16.sp),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: bookingProvider.isLoading ? null : () async {
              final bookingData = BookingModel(
                passengerId: FirebaseAuth.instance.currentUser?.uid ?? '',
                tripId: trip.id!,
                pickupLocation: selectedName,
                pickupLat: _selectedPickupPoint?.latitude,
                pickupLng: _selectedPickupPoint?.longitude,
                dropOffLocation: tripProvider.searchCtrl.text,
                numberOfPassengers: bookingProvider.passengerCount,
                totalFare: trip.price * bookingProvider.passengerCount,
                paymentMethod: bookingProvider.paymentMethod,
                note: bookingProvider.note,
                status: 'confirmed',
                createdAt: DateTime.now(),
              );
              try {
                await bookingProvider.createBooking(bookingData);
                _showSuccessDialog(); // chỉ mở khi thành công
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đặt chuyến thất bại: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfffedd59),
              foregroundColor: const Color(0xff176bac),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Đặt chuyến',
              style: GoogleFonts.lexend(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
