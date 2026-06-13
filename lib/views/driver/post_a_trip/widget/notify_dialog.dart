import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifyDialog extends StatelessWidget {
  final String title;
  final String buttonText;
  final IconData icon;
  final VoidCallback onTap;

  const NotifyDialog({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xff176bac), size: 80.sp),
          SizedBox(height: 16.h),
          Text(
            title,
            style: GoogleFonts.lexend(fontSize: 16.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 20.h),
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
              onPressed: onTap,
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
