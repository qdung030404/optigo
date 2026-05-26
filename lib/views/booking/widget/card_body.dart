import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardBody extends StatelessWidget {
  final String from;
  final String to;
  final String pickup;

  const CardBody({
    super.key,
    required this.from,
    required this.to,
    required this.pickup,
  });

  String getInitials(String text) {
    if (text.isEmpty) return "";
    List<String> words = text.split(' ');
    String initials = "";
    for (var word in words) {
      if (word.isNotEmpty) {
        if (word.contains('.')) {
          initials += word;
        } else {
          initials += word[0].toUpperCase();
        }
      }
    }
    return initials;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Row(
            children: [
              _buildStation(getInitials(from), from),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FDottedLine(
                            color: Colors.grey[300]!,
                            strokeWidth: 1.5,
                            dottedLength: 5,
                            space: 3,
                            width: double.infinity,
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF0F7FF),
                              shape: BoxShape.circle,
                            ),
                            child: FaIcon(
                              FontAwesomeIcons.busSide,
                              color: const Color(0xFF176BAC),
                              size: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildStation(getInitials(to), to, isEnd: true),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.grey[300],
          ),
          child: Text(
            pickup,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildStation(String code, String name, {bool isEnd = false}) {
    return Column(
      crossAxisAlignment: isEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF176BAC),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          name,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
