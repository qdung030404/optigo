import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/providers/map_provider.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/views/home/widget/booking_bottomsheet/trip_time.dart';
import 'package:provider/provider.dart';

import 'number_of_passenger.dart';
import 'payment_method.dart';

class BookingBottomsheet extends StatefulWidget {
  const BookingBottomsheet({super.key});

  @override
  State<BookingBottomsheet> createState() => _BookingBottomsheetState();
}

class _BookingBottomsheetState extends State<BookingBottomsheet> {

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: const Color(0xff176bac)),
              SizedBox(height: 16.h),
              Text(
                'Đang tìm chuyến đi...',
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
                    context.read<BookingProvider>().setShowBookingBottomSheet(true);
                    Navigator.pop(context);
                  },
                  child: Text('Hủy tìm kiếm'),
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
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Container(
              width: 80,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TripTime(),
          const SizedBox(height: 16),
          NumberOfPassenger(),
          const SizedBox(height: 16),
          const PaymentMethod(),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final mapProvider = context.read<MapProvider>();
              final tripProvider = context.read<TripProvider>();
              final bookingProvider = context.read<BookingProvider>();
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              // Guard: kiểm tra toạ độ trước khi tìm chuyến
              if (mapProvider.currentLatLng == null || mapProvider.destinationLatLng == null) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng chọn điểm đi và điểm đến trước khi tìm chuyến.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }

              bookingProvider.setShowBookingBottomSheet(false);
              _showLoadingDialog();

              try {
                await tripProvider.findTrips(
                  origin: mapProvider.currentLatLng!,
                  destination: mapProvider.destinationLatLng!,
                  passengerCount: bookingProvider.passengerCount,
                  isNow: bookingProvider.isNow,
                  selectedDate: bookingProvider.selectedDate,
                );

                if (!bookingProvider.showBookingBottomSheet) {
                  navigator.pop(); // Close loading dialog
                  navigator.pushNamed(Routes.tripList);
                  bookingProvider.setShowBookingBottomSheet(true);
                }
              } catch (e) {
                if (!bookingProvider.showBookingBottomSheet) {
                  navigator.pop();
                  bookingProvider.setShowBookingBottomSheet(true);
                }
                debugPrint("Lỗi tìm chuyến: $e");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfffedd59),
              minimumSize: Size(double.infinity, 60.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'Tìm chuyến',
              style: TextStyle(
                color: const Color(0xff176bac),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
