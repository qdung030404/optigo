import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverInfomationCard extends StatelessWidget {
  final String driverName;
  final String driverLicensePlate;
  const DriverInfomationCard({super.key, required this.driverName,required this.driverLicensePlate});

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
                  FaIcon(FontAwesomeIcons.addressCard, color: const Color(0xff176bac), size: 24.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'thông tin tài xế',
                    style: GoogleFonts.lexend(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDriverInfo('Họ và tên', driverName ),
                    SizedBox(height: 16.h),
                    _buildDriverInfo('Biển số xe', driverLicensePlate),
                  ]
              )
            ]
        )
    );
  }
  Widget _buildDriverInfo(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lexend(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F4F9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            content,
            style: GoogleFonts.lexend(
              color: Colors.grey[600],
              fontSize: 20.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
        )
      ],
    );
  }
}
