import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardHeader extends StatelessWidget {
  final String code;
  final String status;
  const CardHeader({super.key, required this.code, required this.status});

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
                  fontSize: 16.sp,
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
              color: status == 'pending'
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                status == 'pending'
                    ? FaIcon(
                  FontAwesomeIcons.clock,
                  size: 14,
                  color: Colors.orange,
                )
                    : Icon(Icons.verified, size: 14, color: Colors.green),
                SizedBox(width: 4.w),
                Text(
                  status == 'pending' ? 'Đang xử lý' : 'Đã xác nhận',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: status == 'pending'
                        ? Colors.orange[700]
                        : Colors.green[700],
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
