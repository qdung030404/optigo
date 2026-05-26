import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class BuildCalendarCard extends StatefulWidget {
  const BuildCalendarCard({super.key});

  @override
  State<BuildCalendarCard> createState() => _BuildCalendarCardState();
}

class _BuildCalendarCardState extends State<BuildCalendarCard> {
  DateTime focusedDate = DateTime.now();
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  int _firstDayOffset(DateTime date) {
    int firstWeekday = DateTime(date.year, date.month, 1).weekday;
    return firstWeekday == 7 ? 0 : firstWeekday;
  }

  void _nextMonth() {
    setState(() {
      focusedDate = DateTime(focusedDate.year, focusedDate.month + 1);
    });
  }

  void _prevMonth() {
    setState(() {
      focusedDate = DateTime(focusedDate.year, focusedDate.month - 1);
    });
  }
  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final selectedDate = bookingProvider.selectedDate;
    final displayMonth = "Tháng ${focusedDate.month}";

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "$displayMonth ${focusedDate.year}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.arrow_forward_ios, size: 14.sp, color: const Color(0xfffedd59)),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: (focusedDate.year <= DateTime.now().year && focusedDate.month <= DateTime.now().month)
                        ? null
                        : _prevMonth,
                    icon: Icon(Icons.chevron_left, size: 24.sp),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(width: 16.w),
                  IconButton(
                    onPressed: _nextMonth,
                    icon: Icon(Icons.chevron_right, size: 24.sp),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              )
            ],
          ),
          SizedBox(height: 16.h),
          _buildCalendarGrid(selectedDate),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime selectedDate) {
    final days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
    final dayCount = _daysInMonth(focusedDate);
    final offset = _firstDayOffset(focusedDate);

    List<Widget> rows = [];
    List<String> currentRow = [];

    // Header Row
    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((d) => SizedBox(
          width: 35.w,
          child: Center(
            child: Text(d, style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.bold)),
          ),
        )).toList(),
      ),
    );
    rows.add(SizedBox(height: 12.h));

    // Padding for first week
    for (int i = 0; i < offset; i++) {
      currentRow.add("");
    }

    // Days filling
    for (int day = 1; day <= dayCount; day++) {
      currentRow.add(day.toString());
      if (currentRow.length == 7) {
        rows.add(_buildDynamicCalendarRow(currentRow, selectedDate));
        currentRow = [];
      }
    }

    // Remaining padding
    if (currentRow.isNotEmpty) {
      while (currentRow.length < 7) {
        currentRow.add("");
      }
      rows.add(_buildDynamicCalendarRow(currentRow, selectedDate));
    }

    return Column(children: rows);
  }

  Widget _buildDynamicCalendarRow(List<String> days, DateTime selectedDate) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((d) {
          if (d.isEmpty) return SizedBox(width: 35.w);

          DateTime cellDate = DateTime(focusedDate.year, focusedDate.month, int.parse(d));
          bool isPast = cellDate.isBefore(today);

          bool isSelected = selectedDate.day == int.parse(d) &&
              selectedDate.month == focusedDate.month &&
              selectedDate.year == focusedDate.year;

          return GestureDetector(
            onTap: isPast ? null : () {
              context.read<BookingProvider>().setDate(
                  DateTime(focusedDate.year, focusedDate.month, int.parse(d))
              );
            },
            child: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xfffedd59) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  d,
                  style: TextStyle(
                    color: isPast ? Colors.grey[300] : (isSelected ? Colors.white : Colors.black),
                    fontSize: 14.sp,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
