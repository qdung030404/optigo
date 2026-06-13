import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverInfomation extends StatelessWidget {
  final bool isReadOnly;
  final String driverName;
  final String driverLicensePlate;

  const DriverInfomation({
    super.key,
    required this.driverName,
    required this.driverLicensePlate,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: isReadOnly
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tài xế',
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      driverName ,
                      style: GoogleFonts.lexend(
                        color: const Color(0xFF176BAC),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Biển số',
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Color(0xFF176BAC).withOpacity(0.2),
                      ),
                      child: Text(
                        driverLicensePlate ,
                        style: GoogleFonts.lexend(
                          color: const Color(0xFF176BAC),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xfffedd59),
                      foregroundColor: Color(0xff176bac),
                      radius: 20.r,
                      child: Icon(Icons.person_outline, size: 24.sp),
                    ),
                    SizedBox(width: 16.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driverName ,
                          style: GoogleFonts.lexend(
                            color: const Color(0xFF176BAC),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Color(0xFF176BAC).withOpacity(0.2),
                          ),
                          child: Text(
                            driverLicensePlate,
                            style: GoogleFonts.lexend(
                              color: const Color(0xFF176BAC),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: Color(0xFF176BAC).withOpacity(0.2),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.phone_outlined, color: Color(0xFF176BAC)),
                  ),
                ),
              ],
            ),
    );
  }
}
