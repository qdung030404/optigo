import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/models/trip_model.dart';

class RouteDetailsCard extends StatelessWidget {
  final TripModel trip;
  final String? selectedPickupPoint;
  final String? destinationPoint;
  final VoidCallback onPickupTap;

  const RouteDetailsCard({
    super.key,
    required this.trip,
    this.selectedPickupPoint,
    required this.onPickupTap,
    this.destinationPoint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.alt_route_rounded,
                color: const Color(0xff176bac),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Chi tiết lộ trình',
                style: GoogleFonts.lexend(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          _buildLocationInput(
            label: 'Điểm đón',
            placeholder: selectedPickupPoint ?? 'Chọn điểm đón',
            onTap: onPickupTap,
          ),
          SizedBox(height: 16.h),
          _buildLocationInput(
            label: 'Điểm đến',
            placeholder: destinationPoint ?? trip.destinationName,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInput({
    required String label,
    required String placeholder,
    VoidCallback? onTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 16.w),
        Expanded(
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.lexend(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    placeholder,
                    style: GoogleFonts.lexend(
                      fontSize: 15.sp,
                      color: Colors.grey[500],
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
