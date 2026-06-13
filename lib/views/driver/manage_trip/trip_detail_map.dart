import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:optigo/models/booking_model.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:optigo/views/driver/manage_trip/widget/passenger_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'edit_trip.dart';

class TripDetailMap extends StatefulWidget {
  final TripModel trip;

  const TripDetailMap({super.key, required this.trip});

  @override
  State<TripDetailMap> createState() => _TripDetailMapState();
}

class _TripDetailMapState extends State<TripDetailMap> {
  List<BookingModel> _tripBookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final bookingProvider = context.read<BookingProvider>();
    final allBookings = await bookingProvider.loadBookingsForDriver(
      widget.trip.driverId,
    );
    if (mounted) {
      setState(() {
        _tripBookings = bookingProvider.filterConfirmedBookingsForTrip(
          allBookings,
          widget.trip.id!,
        );
        _isLoading = false;
      });
      _setupMapLayer();
    }
  }

  Future<void> _setupMapLayer() async {
    final mapProvider = context.read<MapProvider>();
    if (mapProvider.controller == null || !mapProvider.styleLoaded) return;

    await mapProvider.clearTripMarkers();

    final pickupPoints = _tripBookings
        .where((b) => b.pickupLat != null && b.pickupLng != null)
        .map((b) => LatLng(b.pickupLat!, b.pickupLng!))
        .toList();

    // 1. Vẽ polyline TRƯỚC (layer dưới cùng)
    await mapProvider.showTripRoute(
      origin: LatLng(widget.trip.originLat, widget.trip.originLng),
      destination: LatLng(
        widget.trip.destinationLat,
        widget.trip.destinationLng,
      ),
      waypoints: pickupPoints,
    );

    // 2. Thêm markers SAU (hiển thị trên polyline)
    // Điểm đi
    await mapProvider.addTripMarker(
      LatLng(widget.trip.originLat, widget.trip.originLng),
      icon: 'location-start-icon',
      iconSize: 0.3,
    );

    // Điểm đến
    await mapProvider.addTripMarker(
      LatLng(widget.trip.destinationLat, widget.trip.destinationLng),
      icon: 'location-end-icon',
      iconSize: 0.5,
    );

    // Các điểm đón hành khách
    await mapProvider.addTripMarkers(pickupPoints, icon: 'pin-icon');
  }

  @override
  Widget build(BuildContext context) {
    final mapProvider = context.watch<MapProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết lộ trình'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          MapLibreMap(
            styleString: MapProvider.goongStyleUrl,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.trip.originLat, widget.trip.originLng),
              zoom: 12,
            ),
            onMapCreated: (controller) {
              mapProvider.onMapCreated(controller);
            },
            onStyleLoadedCallback: () async {
              await mapProvider.onStyleLoaded();
              _setupMapLayer();
            },
            myLocationEnabled: false,
          ),
          if (_isLoading || !mapProvider.styleLoaded)
            const Center(child: CircularProgressIndicator()),
          Align(
            alignment: Alignment.bottomCenter,
            child: PassengerBottomSheet(bookings: _tripBookings),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.sp),
        color: Colors.white,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditTrip(trip: widget.trip),
                    ),
                  );
                },
                label: Text(
                  'Sửa chuyến đi',
                  style: GoogleFonts.lexend(fontSize: 16.sp),
                ),
                icon: const Icon(Icons.edit_outlined),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfffedd59),
                  foregroundColor: const Color(0xff176bac),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditTrip(trip: widget.trip),
                    ),
                  );
                },
                label: Text(
                  'Bắt đầu',
                  style: GoogleFonts.lexend(fontSize: 16.sp),
                ),
                icon: const Icon(Icons.navigation),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfffedd59),
                  foregroundColor: const Color(0xff176bac),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
