import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:provider/provider.dart';
class NumberOfPassenger extends StatefulWidget {
  const NumberOfPassenger({super.key});

  @override
  State<NumberOfPassenger> createState() => _NumberOfPassengerState();
}

class _NumberOfPassengerState extends State<NumberOfPassenger> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider>(
      builder: (context, bookingProvider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [

                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'hành khách',
                            style: GoogleFonts.lexend(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Số lượng hành khách',
                            style: GoogleFonts.lexend(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Row(
                children: [
                  _CountButton(
                    icon: Icons.remove_rounded,
                    onPressed: bookingProvider.passengerCount > 1
                        ? () => bookingProvider.decrementPassenger()
                        : null,
                    color:bookingProvider.passengerCount > 1 ? Color(0xfffedd59) : Colors.grey.shade200,
                    iconColor: bookingProvider.passengerCount > 1 ? const Color(0xff176bac) : Colors.grey,
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 40),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return ScaleTransition(scale: animation, child: child);
                        },
                        child: Text(
                          '${bookingProvider.passengerCount}',
                          key: ValueKey(bookingProvider.passengerCount),
                          style: GoogleFonts.lexend(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _CountButton(
                    icon: Icons.add_rounded,
                    onPressed: () => bookingProvider.incrementPassenger(),
                    color: const Color(0xfffedd59),
                    iconColor: const Color(0xff176bac),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CountButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final Color iconColor;

  const _CountButton({
    required this.icon,
    this.onPressed,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: onPressed == null ? Colors.grey.shade100 : color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

