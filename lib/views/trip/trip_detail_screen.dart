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
import 'package:optigo/views/trip/widget/trip_detail_widget/departure_time_card.dart';
import 'package:optigo/views/trip/widget/trip_detail_widget/driver_infomation_card.dart';
import 'package:optigo/views/trip/widget/trip_detail_widget/notify_dialog.dart';
import 'package:optigo/views/trip/widget/trip_detail_widget/pickup_points_bottom_sheet.dart';
import 'package:optigo/views/trip/widget/trip_detail_widget/route_details_card.dart';
import 'package:provider/provider.dart';

import '../../providers/booking_provider.dart';

class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({super.key});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  TripModel? _liveTrip;
  String? selectedName;
  LatLng? _selectedPickupPoint;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_liveTrip == null) {
      _liveTrip = ModalRoute.of(context)!.settings.arguments as TripModel;
      _refreshData();
    }
  }

  Future<void> _refreshData() async {
    final updated = await context.read<TripProvider>().getTripById(
      _liveTrip!.id!,
    );
    if (updated != null && mounted) {
      setState(() {
        _liveTrip = updated;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: NotifyDialog(
          icon: Icons.check_circle,
          title: 'đặt chuyến thành công',
          textButton: 'Quản lý chuyến đi',
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName(Routes.home)),
        ),
      ),
    );
  }

  void _showBookingErrorDialog({
    required String errorTitle,
    required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: NotifyDialog(
          icon: Icons.error_rounded,
          title: errorTitle,
          textButton: 'Quay lại',
          onPressed: onPressed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final tripProvider = context.read<TripProvider>();
    final mapProvider = context.read<MapProvider>();
    final trip = _liveTrip!;
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
              destinationPoint: tripProvider.searchCtrl.text,
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
              availableSeat: trip.availableSeats.toString(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.sp),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: bookingProvider.isLoading
                ? null
                : () async {
                    final bookingData = BookingModel(
                      passengerId: FirebaseAuth.instance.currentUser?.uid ?? '',
                      tripId: trip.id!,
                      pickupLocation: selectedName,
                      pickupLat: _selectedPickupPoint?.latitude,
                      pickupLng: _selectedPickupPoint?.longitude,
                      dropOffLocation: tripProvider.searchCtrl.text,
                      dropOffLat: mapProvider.destinationLatLng?.latitude,
                      dropOffLng: mapProvider.destinationLatLng?.longitude,
                      numberOfPassengers: bookingProvider.passengerCount,
                      distance: mapProvider.routeDistanceKm,
                      duration: mapProvider.routeDurationText,
                      totalFare: trip.price * bookingProvider.passengerCount,
                      paymentMethod: bookingProvider.paymentMethod,
                      note: bookingProvider.note,
                      status: 'pending',
                      createdAt: DateTime.now(),
                    );
                    try {
                      await bookingProvider.createBooking(bookingData);
                      if (!mounted) return;
                      if (selectedName == null) {
                        _showBookingErrorDialog(
                          errorTitle: 'Vui lòng chọn điểm đón',
                          onPressed: () => Navigator.pop(context),
                        );
                        return;
                      }
                      if (bookingProvider.bookingErrorMessage == 'seat_full') {
                        _showBookingErrorDialog(
                          errorTitle:
                              'Rất tiếc! Chuyến này vừa hết chỗ trống.\n'
                              'Vui lòng tìm chuyến khác.',
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            context.read<TripProvider>().loadAllTrips();
                          },
                        );
                      } else if (bookingProvider.bookingErrorMessage ==
                          'not_enough_seats') {
                        final updatedTrip = await tripProvider.getTripById(
                          trip.id!,
                        );
                        if (!mounted) return;
                        _showBookingErrorDialog(
                          errorTitle:
                              'Rất tiếc! Chuyến này hiện chỉ còn ${updatedTrip?.availableSeats ?? trip.availableSeats} chỗ trống.\n'
                              'Vui lòng điều chỉnh lại số lượng hành khách.',
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            context.read<TripProvider>().loadAllTrips();
                          },
                        );
                      } else if (bookingProvider.isSuccess) {
                        _showSuccessDialog();
                      }
                      // chỉ mở khi thành công
                    } catch (e) {
                      print(e);
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
            child: bookingProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xff176bac),
                    ),
                  )
                : Text(
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
