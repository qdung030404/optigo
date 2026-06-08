
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/utils/address_utils.dart';
import 'package:optigo/views/booking/widget/card_body.dart';
import 'package:optigo/views/booking/widget/card_footer.dart';
import 'package:optigo/views/booking/widget/card_header.dart';
import 'package:optigo/views/booking/widget/driver_infomation.dart';
import 'package:optigo/models/booking_model.dart';
import 'package:provider/provider.dart';

import '../../config/routes.dart';

class BookingManager extends StatefulWidget {
  const BookingManager({super.key});

  @override
  State<BookingManager> createState() => _BookingManagerState();
}

class _BookingManagerState extends State<BookingManager> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingProvider>().loadBookings();
    });
  }

  String getInitials(String text) {
    if (text.isEmpty) return "";
    List<String> words = text.split(' ');
    String initials = "";
    for (var word in words) {
      if (word.isNotEmpty) {
        if (word.contains('.')) {
          initials += word;
        } else {
          initials += word[0].toUpperCase();
        }
      }
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final bookings = bookingProvider.bookings;
    final tripProvider = context.watch<TripProvider>();
    final trips = tripProvider.trips;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () =>
              Navigator.popUntil(context, ModalRoute.withName(Routes.home)),
        ),
        title: Text(
          'Quản lý chuyến đi của bạn',
          style: GoogleFonts.lexend(
            color: Colors.black,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: bookingProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemCount: bookings.length,
              itemBuilder: (BuildContext context, int index) {
                final booking = bookings[index];
                final trip = trips.firstWhere(
                  (t) => t.id == booking.tripId,
                  orElse: () => TripModel(
                    driverId: '',
                    originName: 'Đang tải...',
                    destinationName: 'Đang tải...',
                    originLat: 0,
                    originLng: 0,
                    destinationLat: 0,
                    destinationLng: 0,
                    routePolyline: '',
                    price: 0,
                    availableSeats: 0,
                    departureTime: DateTime.now(),
                    status: '',
                    totalSeats: 0,
                  ),
                );
                return _buildTripCard(
                  from: trip.originName,
                  to: trip.destinationName,
                  code: booking.id.toString(),
                  pickup: booking.pickupLocation ?? 'Chưa xác định',
                  date: DateFormat('dd/MM/yyyy').format(trip.departureTime),
                  time: DateFormat('HH:mm').format(trip.departureTime),
                  status: booking.status,
                  driverName: trip.driverName?.toString() ?? '',
                  driverLicensePlate: trip.driverLicensePlate?.toString() ?? '',
                  onTap: () =>  Navigator.pushNamed(
                    context,
                    Routes.bookingDetail,
                    arguments: {
                      'booking': booking,
                      'trip': trip,
                    },
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 80.sp,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16.h),
          Text(
            'Bạn không có lịch cho chuyến đi nào',
            style: GoogleFonts.lexend(fontSize: 16.sp, color: Colors.grey[600]),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
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
              child: Text('Đặt chuyến ngay'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard({
    required String from,
    required String to,
    required String code,
    required String date,
    required String time,
    required String pickup,
    required BookingStatus status,
    required String driverName,
    required String driverLicensePlate,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Phần Header: Mã đặt vé và Trạng thái
            CardHeader(code: code, status: status, isReadOnly: true,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Divider(height: 1, color: Colors.grey[100]),
            ),

            CardBody(from: AddressUtils.getLast(from), to: AddressUtils.getLast(to), pickup: pickup,),
            DriverInfomation(driverName: driverName, driverLicensePlate: driverLicensePlate, isReadOnly: true,),
            // Phần Footer: Thông tin thời gian
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: CardFooter(date: date, time: time),
            )

          ],
        ),
      ),
    );
  }
}
