import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:provider/provider.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final paymentMethod = context.watch<BookingProvider>().paymentMethod;
    
    return Row(
      children: [
        // Payment Method Side
        Expanded(
          child: _BuildMethodCard(
            icon: Icons.account_balance_wallet_rounded,
            title: 'Thanh toán',
            value: paymentMethod,
            onTap: () {
              // TODO: Mở bottom sheet chọn phương thức
            },
          ),
        ),
        const SizedBox(width: 12),
        // Discount Side
        Expanded(
          child: _BuildMethodCard(
            icon: Icons.local_offer_rounded,
            title: 'Ưu đãi',
            value: 'Nhập mã uư đãi',
            onTap: () {
              // TODO: Logic nhập mã giảm giá
            },
          ),
        ),
      ],
    );
  }
}

class _BuildMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _BuildMethodCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xfffedd59).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xff176bac),
                size: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.lexend(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
