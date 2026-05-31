import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/utils/address_utils.dart';

class TripListCard extends StatelessWidget {
  final TripModel trip;
  const TripListCard({super.key, required this.trip});
  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              currencyFormat.format(trip.price),
              style: GoogleFonts.lexend(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff176bac),
              ),
            ),
          ),
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
                    height: MediaQuery.of(context).size.width *0.15,
                    color: Colors.grey[300],
                  ),
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 20.sp,
                  ),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLocation(fullAddress: trip.originName),
                    SizedBox(height: 25.h),
                    _buildLocation(fullAddress: trip.destinationName),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.access_time_filled,
                    size: 16.sp,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    DateFormat(
                      'HH:mm - dd/MM/yyyy',
                    ).format(trip.departureTime),
                    style: GoogleFonts.lexend(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.event_seat,
                    size: 16.sp,
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Còn ${trip.availableSeats} chỗ',
                    style: GoogleFonts.lexend(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildLocation({required String fullAddress}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AddressUtils.getLast(fullAddress),
          style: GoogleFonts.lexend(
            color: Color(0xff176bac),
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          AddressUtils.getFullAddress(fullAddress),
          style: GoogleFonts.lexend(
            fontSize: 10.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
      ]
    );

  }
}
