import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optigo/models/booking_model.dart';

class CardHeader extends StatelessWidget {
  final bool isReadOnly;
  final String code;
  final BookingStatus status;
  const CardHeader({super.key, required this.code, required this.status, this.isReadOnly = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  fontSize: isReadOnly == true ? 16.sp : 24.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: status.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(status.icon, size: 14, color: status.color),
                SizedBox(width: 4.w),
                Text(
                  status.label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: status.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
