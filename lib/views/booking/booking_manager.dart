import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/providers/trip_provider.dart';
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
          onPressed: () => Navigator.popUntil(context, ModalRoute.withName(Routes.home)),
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
      body: bookings.isEmpty ?
      _buildEmptyState(context) :
      ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        itemCount: bookings.length,
        itemBuilder: (BuildContext context, int index) {
          final booking = bookings[index];
          final trip = trips.firstWhere((trip) => trip.id == booking.tripId, orElse: () => trips[0]);
          return _buildTripCard(
            from: trip.originName,
            to: trip.destinationName,
            code: booking.id.toString(),
            pickup: booking.pickupLocation!,
            date: DateFormat('dd/MM/yyyy').format(trip.departureTime),
            time: DateFormat('HH:mm').format(trip.departureTime),
            status: trip.status,
          );
        },
      ),
    );
  }
  Widget _buildEmptyState( BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_month_outlined, size: 80.sp, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            'Bạn không có lịch cho chuyến đi nào',
            style: GoogleFonts.lexend(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width *0.5,
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
                  'Đặt chuyến ngay'
              ),
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
    required String status,
  }) {
    return Container(
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
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MÃ ĐẶT CHUYẾN',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, size: 14, color: Colors.green),
                      SizedBox(width: 4.w),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Đường gạch đứt phân cách nhẹ
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(height: 1, color: Colors.grey[100]),
          ),


          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Row(
              children: [
                _buildStation(getInitials(from), from),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            FDottedLine(
                              color: Colors.grey[300]!,
                              strokeWidth: 1.5,
                              dottedLength: 5,
                              space: 3,
                              width: double.infinity,
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF0F7FF),
                                shape: BoxShape.circle,
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.busSide,
                                color: const Color(0xFF176BAC),
                                size: 16.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStation(getInitials(to), to, isEnd: true),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.grey[300],
            ),
            child: Text(pickup, style: TextStyle(fontSize: 12.sp,color: Colors.grey[600]), maxLines: 1,),
          ),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(Icons.calendar_today_outlined, 'Ngày đi', date),
                Container(width: 1, height: 25, color: Colors.grey.withOpacity(0.5)),
                _buildInfoItem(Icons.access_time, 'Thời gian', time),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStation(String code, String name, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [

        Text(
          code,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF176BAC),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[400]),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
