import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optigo/models/booking_model.dart';

class CardHeader extends StatefulWidget {
  final bool isReadOnly;
  final String code;
  final BookingStatus status;
  final BookingModel booking;

  const CardHeader({
    super.key,
    required this.code,
    required this.status,
    required this.booking,
    this.isReadOnly = false,
  });

  @override
  State<CardHeader> createState() => _CardHeaderState();
}

class _CardHeaderState extends State<CardHeader> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Nếu đơn đang chờ và chưa hết hạn, bắt đầu chạy Timer để cập nhật UI mỗi giây
    if (widget.status == BookingStatus.pending && !widget.booking.isExpired) {
      _startLocalTimer();
    }
  }

  void _startLocalTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Khi đã hết hạn, dừng timer
          if (widget.booking.isExpired) {
            _timer?.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // isExpired sẽ được tính toán lại mỗi khi setState được gọi nhờ vào DateTime.now()
    final bool isExpired = widget.status == BookingStatus.pending && widget.booking.isExpired;
    final String displayLabel = isExpired ? 'Hết hạn' : widget.status.label;
    final Color displayColor = isExpired ? Colors.grey : widget.status.color;
    final IconData displayIcon = isExpired ? Icons.timer_off : widget.status.icon;

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
                widget.code,
                style: TextStyle(
                  fontSize: widget.isReadOnly == true ? 16.sp : 24.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: displayColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(displayIcon, size: 14, color: displayColor),
                    SizedBox(width: 4.w),
                    Text(
                      displayLabel,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: displayColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.status == BookingStatus.pending && !isExpired)
                Builder(
                  builder: (context) {
                    final diff = const Duration(minutes: 5) -
                        DateTime.now().difference(widget.booking.createdAt!);
                    
                    if (diff.isNegative) return const SizedBox.shrink();

                    final minutes = diff.inMinutes.toString().padLeft(2, '0');
                    final seconds = (diff.inSeconds % 60).toString().padLeft(2, '0');
                    
                    return Text(
                      "$minutes:$seconds",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    );
                  }
                ),
            ],
          ),
        ],
      ),
    );
  }
}
