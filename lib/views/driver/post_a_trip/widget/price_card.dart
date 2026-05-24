import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/utils/currency_formatter.dart';

class PriceCard extends StatefulWidget {
  final int? initialPrice;
  final ValueChanged<int?>? onPriceChanged;

  const PriceCard({
    super.key,
    this.initialPrice,
    this.onPriceChanged,
  });

  @override
  State<PriceCard> createState() => _PriceCardState();
}

class _PriceCardState extends State<PriceCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialPrice != null ? widget.initialPrice.toString() : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                Icons.payments_outlined,
                color: const Color(0xff176bac),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Giá chuyến đi',
                style: GoogleFonts.lexend(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: TextField(
              controller: _controller,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Chặn tất cả ký tự không phải số
                CurrencyFormatter(), // Bộ định dạng dấu chấm tự động của chúng ta
              ],
              keyboardType: TextInputType.number,
              style: GoogleFonts.lexend(
                fontSize: 16.sp,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập giá (VNĐ)',
                hintStyle: GoogleFonts.lexend(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                suffixText: 'VNĐ',
                suffixStyle: GoogleFonts.lexend(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff176bac),
                ),
              ),
              onChanged: (value) {
                final rawNumber = value.replaceAll('.', '');

                final price = int.tryParse(rawNumber);
                widget.onPriceChanged?.call(price);
              },
            ),
          ),
        ],
      ),
    );
  }
}
