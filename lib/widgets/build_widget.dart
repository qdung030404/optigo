import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/utils/address_utils.dart';

class BuildWidget {
  static Widget buildLocation({required String fullAddress}){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AddressUtils.getLast(fullAddress),
            style: GoogleFonts.lexend(
              color: Color(0xff176bac),
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            AddressUtils.getFullAddress(fullAddress),
            style: GoogleFonts.lexend(
              fontSize: 10.sp,
              fontWeight: FontWeight.normal,
            ),
          ),
        ]
    );

  }
}