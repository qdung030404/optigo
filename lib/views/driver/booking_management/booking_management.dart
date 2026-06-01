import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/booking_model.dart';

class BookingManagement extends StatefulWidget {
  const BookingManagement({super.key});

  @override
  State<BookingManagement> createState() => _BookingManagementState();
}

class _BookingManagementState extends State<BookingManagement> {
  late Future<List<BookingModel>> _driverBookingsFuture;

  @override
  void initState() {
    super.initState();
    // Lấy ID của tài xế hiện tại từ Firebase
    final driverId = FirebaseAuth.instance.currentUser?.uid;

    if (driverId != null) {
      _driverBookingsFuture =
          context.read<BookingProvider>().loadBookingsForDriver(driverId);
    } else {
      _driverBookingsFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yêu cầu ghép chuyến')),
      body: FutureBuilder<List<BookingModel>>(
        future: _driverBookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          final bookings = snapshot.data ?? [];
          if (bookings.isEmpty) {
            return const Center(
              child: Text('Bạn không có yêu cầu ghép chuyến nào'),
            );
          }
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              return Column(
                children: [
                  Text('Điểm đi: ${booking.pickupLocation}'),
                  Text('Điểm đến: ${booking.dropOffLocation}'),
                  Text('Thời gian đi: ${booking.totalFare}'),
                  Text('Số chỗ ngồi: ${booking.numberOfPassengers}'),
                  Text('Trạng thái: ${booking.status}'),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
