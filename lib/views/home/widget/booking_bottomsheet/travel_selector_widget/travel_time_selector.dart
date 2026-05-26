import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:provider/provider.dart';

import 'build_calendar_card.dart';
import 'build_note_field.dart';

class TravelTimeSelector extends StatefulWidget {
  const TravelTimeSelector({super.key});

  @override
  State<TravelTimeSelector> createState() => _TravelTimeSelectorState();
}

class _TravelTimeSelectorState extends State<TravelTimeSelector> {
  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Thời gian di chuyển',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildSelectionOption(
              title: "DI CHUYỂN NGAY",
              isSelected: bookingProvider.isNow,
              onTap: () {
                context.read<BookingProvider>().setIsNow(true);
              },
              highlightColor: bookingProvider.isNow ? const Color(0xfffedd59) : Colors.grey[300],
            ),
            SizedBox(height: 12.h),
            _buildSelectionOption(
              title: "LÊN LỊCH TRÌNH",
              isSelected: !bookingProvider.isNow,
              onTap: () {
                context.read<BookingProvider>().setIsNow(false);
              },
              highlightColor: !bookingProvider.isNow ? const Color(0xfffedd59) : Colors.grey[300],
            ),
            if (!bookingProvider.isNow) ...[
              SizedBox(height: 24.h),
              BuildCalendarCard(),
            ],
            SizedBox(height: 16.h),
            BuildNoteField(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: ElevatedButton(
          onPressed: () {
            context.read<BookingProvider>().confirmTime();
            Navigator.pop(context, {
              'isNow': bookingProvider.isNow,
              'selectedDate': bookingProvider.selectedDate,
              'note': bookingProvider.note,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xfffedd59),
            minimumSize: Size(double.infinity, 50.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'XÁC NHẬN',
            style: TextStyle(
              color: const Color(0xff176bac),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    Color? highlightColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? (highlightColor ?? Colors.black) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: isSelected && highlightColor != null ? highlightColor : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: isSelected ? (highlightColor ?? Colors.grey[300]) : Colors.grey[200],
                borderRadius: BorderRadius.circular(6),
              ),
              child: isSelected
                  ? Icon(Icons.stop, size: 16.w, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
