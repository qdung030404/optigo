import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CancelBookingDialog extends StatelessWidget {
  final Function()? onPressed;

  const CancelBookingDialog({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber,
            color: const Color(0xff176bac),
            size: 80.sp,
          ),
          SizedBox(height: 16.h),
          Text(
            'Xác nhận hủy chuyến?',
            style: GoogleFonts.lexend(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),

          Text(
            'Bạn có chắc chắn muốn hủy chuyến đi này không? Hành động này không thể hoàn tác.',
            style: GoogleFonts.lexend(
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xfffedd59),
                foregroundColor: Color(0xff176bac),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text('Giữ lại', style: GoogleFonts.lexend(fontSize: 16.sp, fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red),
                ),
                elevation: 0,
              ),
              onPressed: onPressed,
              child: onPressed == null
                  ? CircularProgressIndicator()
                  : Text('Xác nhận hủy', style: GoogleFonts.lexend(fontSize: 16.sp, color: Colors.red, fontWeight: FontWeight.bold),),
            ),
          ),
        ],
      ),
    );
  }
}
