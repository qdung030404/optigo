import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/widgets/build_widget.dart';

class TripCard extends StatefulWidget {
  final TripModel trip;
  final TripStatus status;

  const TripCard({super.key, required this.trip, required this.status});

  @override
  State<TripCard> createState() => _TripCardState();
}

class _TripCardState extends State<TripCard> {
  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
    );

    var bookedSeat = widget.trip.totalSeats - widget.trip.availableSeats;
    bool isFull = widget.trip.totalSeats == bookedSeat;
    return Container(
      padding: EdgeInsets.all(10.sp),
      margin: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: widget.status.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(widget.status.icon, size: 14, color: widget.status.color),
                    SizedBox(width: 4.w),
                    Text(
                      widget.status.label,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: widget.status.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Thời gian khởi hành',
                    style: TextStyle(fontSize: 10.sp),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    children: [
                      Text(
                        DateFormat(
                          'HH:mm - dd/MM/yyyy',
                        ).format(widget.trip.departureTime),
                        style: GoogleFonts.lexend(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.my_location,
                    color: const Color(0xff176bac),
                    size: 20.sp,
                  ),
                  Container(
                    width: 1.w,
                    height: MediaQuery.of(context).size.width * 0.15,
                    color: Colors.grey[300],
                  ),
                  Icon(Icons.location_on, color: Colors.red, size: 20.sp),
                ],
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BuildWidget.buildLocation(
                      fullAddress: widget.trip.originName,
                    ),
                    SizedBox(height: 25.h),
                    BuildWidget.buildLocation(
                      fullAddress: widget.trip.destinationName,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Divider(height: 1, color: Colors.grey[400]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(8.sp),
                    padding: EdgeInsets.all(8.sp),
                    decoration: BoxDecoration(
                      color: Color(0xfffedd59).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.event_seat_outlined,
                      color: Color(0xff176bac),
                      size: 32.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ghế đã đặt', style: TextStyle(fontSize: 16.sp)),
                      SizedBox(height: 5.h),
                      Text(
                        '$bookedSeat/${widget.trip.totalSeats} ghế',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: (bookedSeat == widget.trip.totalSeats)
                              ? Colors.grey[600]
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Giá vé', style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 5.h),
                  Text(
                    currencyFormat.format(widget.trip.price),
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Divider(height: 1, color: Colors.grey[400]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isFull) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    label: Text('Sửa chuyến đi', style: GoogleFonts.lexend(fontSize: 16.sp)),
                    icon: const Icon(Icons.edit_outlined),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        side: const BorderSide(color: Colors.black),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline),
                  label: Text(widget.trip.status == 'open'
                      ? 'Xóa chuyến đi'
                      : 'Hủy chuyến đi', style: GoogleFonts.lexend(fontSize: 16.sp)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.2),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
