import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/models/booking_model.dart';
import 'package:provider/provider.dart';
import 'package:optigo/providers/booking_provider.dart';

class PassengerBottomSheet extends StatelessWidget {
  final List<BookingModel> bookings;

  const PassengerBottomSheet({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.3,
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thứ tự đón khách',
                    style: GoogleFonts.lexend(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${bookings.length} khách',
                    style: GoogleFonts.lexend(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: bookings.isEmpty
                  ? Center(
                      child: Text(
                        'Chưa có khách nào xác nhận.',
                        style: GoogleFonts.lexend(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return _buildPassengerItem(context, booking, index + 1);
                      },
                    ),
            ),
          ],
        ));
  }

  Widget _buildPassengerItem(BuildContext context, BookingModel booking,
      int order) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            decoration: const BoxDecoration(
              color: Color(0xff176bac),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$order',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.passengerName ?? 'Khách ẩn danh',
                  style: GoogleFonts.lexend(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  booking.pickupLocation ?? 'Điểm đón chưa xác định',
                  style: GoogleFonts.lexend(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${booking.numberOfPassengers} người',
                  style: GoogleFonts.lexend(
                    fontSize: 12.sp,
                    color: const Color(0xff176bac),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              if (booking.passengerPhone != null) {
                context.read<BookingProvider>().contactDriver(
                    booking.passengerPhone!);
              }
            },
            icon: const Icon(Icons.phone, color: Colors.green),
          ),
        ],
      ),
    );
  }
}
