import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:optigo/models/booking_model.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/utils/currency_formatter.dart';
import 'package:optigo/widgets/build_widget.dart';
import 'package:provider/provider.dart';

class CombineTripsCard extends StatelessWidget {
  final String driverId;
  final BookingModel booking;
  const CombineTripsCard({super.key, required this.booking, required this.driverId});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return Container(
      padding: EdgeInsets.all(16.sp),
      margin: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.passengerName ?? "", style: GoogleFonts.lexend(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  Text(Formatter.phoneFormatter(booking.passengerPhone ?? ""), style: GoogleFonts.lexend(fontSize: 14.sp, fontWeight: FontWeight.normal)),
                ]
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(currencyFormat.format(booking.totalFare), style: GoogleFonts.lexend(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  Text('${booking.paymentMethod}', style: GoogleFonts.lexend(fontSize: 14.sp, fontWeight: FontWeight.normal)),
                ]
              )
            ]
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.my_location,
                    color: const Color(0xff176bac),
                    size: 20.sp,
                  ),
                  Container(
                    width: 1.w,
                    height: MediaQuery.of(context).size.width * 0.15,
                    color: Colors.grey[300],
                  ),
                  Icon(Icons.location_on, color: Colors.red, size: 20.sp),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildWidget.buildLocation(
                      fullAddress: booking.pickupLocation! ,
                    ),
                    SizedBox(height: 25.h),
                    BuildWidget.buildLocation(
                      fullAddress: booking.dropOffLocation!,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child: Divider(height: 1, color: Colors.grey[400]),
          ),
          IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Quãng đường', style: GoogleFonts.lexend(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      Text('${booking.distance?.toStringAsFixed(2)} km', style: GoogleFonts.lexend(fontSize: 14.sp, fontWeight: FontWeight.normal)),
                    ],
                  ),
                  VerticalDivider(thickness: 2, color: Colors.grey[400],),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Thời gian dự kiến', style: GoogleFonts.lexend(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      Text('${booking.duration}', style: GoogleFonts.lexend(fontSize: 14.sp, fontWeight: FontWeight.normal)),
                    ],
                  )
                ]
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.sp),
            child: Consumer<BookingProvider>(
              builder: (context, provider, _) {
                return Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: ElevatedButton(
                        onPressed: provider.isLoading ? null : () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xff176bac),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: BorderSide(width: 2.w, color: const Color(0xff176bac)),
                          ),
                        ),
                        child: Text(
                          'Từ chối',
                          style: GoogleFonts.lexend(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                await provider.confirmBooking(driverId, booking.id!);
                                if (context.mounted) {
                                  if (provider.isSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Đã xác nhận chuyến thành công!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else if (provider.bookingErrorMessage != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(provider.bookingErrorMessage!),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfffedd59),
                          foregroundColor: const Color(0xff176bac),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: provider.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                'Chấp nhận',
                                style: GoogleFonts.lexend(fontSize: 16.sp, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ]
      ),
    );
  }
}
