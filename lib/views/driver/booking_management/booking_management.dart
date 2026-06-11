import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optigo/models/booking_model.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/views/driver/booking_management/widget/combine_trips_card.dart';
import 'package:provider/provider.dart';

class CombineTripsManagement extends StatefulWidget {
  const CombineTripsManagement({super.key});

  @override
  State<CombineTripsManagement> createState() => _CombineTripsManagementState();
}

class _CombineTripsManagementState extends State<CombineTripsManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<BookingModel>> _driverBookingsFuture;
  final driverId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    loadData();
  }

  void loadData() {
    if (driverId != null) {
      setState(() {
        _driverBookingsFuture = context
            .read<BookingProvider>()
            .loadBookingsForDriver(driverId!);
      });
    } else {
      _driverBookingsFuture = Future.value([]);
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      loadData();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yêu cầu ghép chuyến'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Chờ xử lý'),
            Tab(text: 'Đã xác nhận'),
            Tab(text: 'Đã từ chối'),
          ],
        ),
      ),
      body: FutureBuilder<List<BookingModel>>(
        future: _driverBookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          final allBookings = snapshot.data ?? [];

          final pendingBookings = allBookings
              .where((b) => b.status == BookingStatus.pending)
              .toList();
          final confirmedBookings = allBookings
              .where((b) => b.status == BookingStatus.confirmed)
              .toList();
          final cancelledBookings = allBookings
              .where((b) => b.status == BookingStatus.cancelled)
              .toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildList(pendingBookings),
              _buildList(confirmedBookings),
              _buildList(cancelledBookings),
            ],
          );
        },
      ),
    );
  }

  Widget _buildList(List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return const Center(child: Text('Không có yêu cầu nào'));
    }
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return CombineTripsCard(booking: bookings[index], driverId: driverId!);
      },
    );
  }
}
