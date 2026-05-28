import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:optigo/models/trip_model.dart';

class DepartureTimeCard extends StatefulWidget {
  final TripModel trip;

  const DepartureTimeCard({super.key, required this.trip});

  @override
  State<DepartureTimeCard> createState() => _DepartureTimeCardState();
}

class _DepartureTimeCardState extends State<DepartureTimeCard> {
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
                Icons.calendar_today_rounded,
                color: const Color(0xff176bac),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Thời gian xuất phát',
                style: GoogleFonts.lexend(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: _buildTimeInput(
                  label: 'Ngày',
                  placeholder: DateFormat(
                    'dd/MM/yyyy',
                  ).format(widget.trip.departureTime),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTimeInput(
                  label: 'Giờ khởi hành',
                  placeholder: DateFormat(
                    'HH:mm',
                  ).format(widget.trip.departureTime),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput({required String label, required String placeholder}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lexend(fontSize: 13.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 4.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            placeholder,
            style: GoogleFonts.lexend(fontSize: 15.sp, color: Colors.grey[500]),
          ),
        ),
      ],
    );
  }
}
