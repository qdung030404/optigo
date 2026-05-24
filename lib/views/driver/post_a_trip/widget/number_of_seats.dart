import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

typedef CarEntries = DropdownMenuEntry<CarType>;

enum CarType {
  sedan('4 ghế', 4),
  suv('7 ghế', 7),
  miniVan('9 ghế', 9),
  miniBus('16 ghế', 16),
  mediumBus('29 ghế', 29);

  final String label;
  final int numberOfSeats;

  const CarType(this.label, this.numberOfSeats);

  static final List<CarEntries> val = UnmodifiableListView<CarEntries>(
    values.map<CarEntries>(
      (CarType seat) => CarEntries(value: seat, label: seat.label),
    ),
  );
}

class NumberOfSeats extends StatefulWidget {
  final ValueChanged<CarType?>? onSelected;
  final CarType? initialValue;

  const NumberOfSeats({super.key, this.onSelected, this.initialValue, });

  @override
  State<NumberOfSeats> createState() => _NumberOfSeatsState();
}

class _NumberOfSeatsState extends State<NumberOfSeats> {
  late final TextEditingController controller;
  CarType? selectedValue;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    selectedValue = widget.initialValue ?? CarType.sedan;
  }

  @override
  void dispose() {
    controller.dispose();
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
                Icons.airline_seat_recline_normal_sharp,
                color: const Color(0xff176bac),
                size: 24.sp,
              ),
              SizedBox(width: 12.w),
              Text(
                'Số ghế',
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
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: DropdownMenu(
              expandedInsets: EdgeInsets.zero,
              controller: controller,
              initialSelection: CarType.sedan,
              onSelected: (CarType? value) {
                setState(() {
                  selectedValue = value;
                });
                widget.onSelected?.call(value);
              },
              dropdownMenuEntries: CarType.val,
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
