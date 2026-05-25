import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/views/home/widget/booking_bottomsheet/travel_selector_widget/travel_time_selector.dart';
import 'package:provider/provider.dart';

class TripTime extends StatefulWidget {
  const TripTime({super.key});

  @override
  State<TripTime> createState() => _TripTimeState();
}

class _TripTimeState extends State<TripTime> {
  Map<String, dynamic>? _selectedTravelTime;
  String _displayTime(BookingProvider bookingProvider) {
    if (!bookingProvider.isTimeSelected) return 'Vui lòng chọn thời gian di chuyển';
    if (bookingProvider.isNow) return "Ngay bây giờ";

    final date = bookingProvider.selectedDate;

    final year = date.year.toString();
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return "$day/$month/$year";
  }
  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    return GestureDetector(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TravelTimeSelector()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thời gian di chuyển',
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _displayTime(bookingProvider),
                    style: GoogleFonts.lexend(
                      fontSize: 14,
                      color: bookingProvider.isTimeSelected ? const Color(0xff176bac) : Colors.grey,
                      fontWeight: bookingProvider.isTimeSelected ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
