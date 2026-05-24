import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DepartureTimeCard extends StatefulWidget {
  final DateTime? initialDateTime;
  final void Function(DateTime dateTime) onDateTimeChanged;

  const DepartureTimeCard({
    super.key,
    this.initialDateTime,
    required this.onDateTimeChanged,
  });

  @override
  State<DepartureTimeCard> createState() => _DepartureTimeCardState();
}

class _DepartureTimeCardState extends State<DepartureTimeCard> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.initialDateTime != null) {
      selectedDate = widget.initialDateTime;
      selectedTime = TimeOfDay.fromDateTime(widget.initialDateTime!);
    }
  }

  void _notifyParent() {
    if (selectedDate != null && selectedTime != null) {
      final combined = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      widget.onDateTimeChanged(combined);
    }
  }

  void datePicker() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (selected != null) {
      setState(() {
        selectedDate = selected;
      });
      _notifyParent();
    }
  }

  void timePicker() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (selected != null) {
      setState(() {
        selectedTime = selected;
      });
      _notifyParent();
    }
  }

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
                  placeholder: selectedDate == null
                      ? '--/--/----'
                      : DateFormat('dd/MM/yyyy').format(selectedDate!),
                  onTap: () => datePicker(),
                  icon: Icons.date_range,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTimeInput(
                  label: 'Giờ khởi hành',
                  placeholder: selectedTime == null
                      ? '--:--'
                      : selectedTime!.format(context),
                  onTap: () => timePicker(),
                  icon: Icons.access_time,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput({
    required String label,
    required String placeholder,
    required Function() onTap,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lexend(fontSize: 13.sp, color: Colors.grey[600]),
        ),
        SizedBox(height: 4.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    placeholder,
                    style: GoogleFonts.lexend(
                      fontSize: 15.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Icon(icon, color: const Color(0xff176bac), size: 20.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
