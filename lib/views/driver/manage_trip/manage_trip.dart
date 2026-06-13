import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optigo/models/trip_model.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:optigo/views/driver/manage_trip/widget/driver_drawer.dart';
import 'package:optigo/views/driver/manage_trip/widget/trip_card.dart';
import 'package:provider/provider.dart';

class ManageTrip extends StatefulWidget {
  const ManageTrip({super.key});

  @override
  State<ManageTrip> createState() => _ManageTripState();
}

class _ManageTripState extends State<ManageTrip> {
  late Future<List<TripModel>> _driverTripsFuture;

  @override
  void initState() {
    super.initState();
    // Lấy ID của tài xế hiện tại từ Firebase
    final driverId = FirebaseAuth.instance.currentUser?.uid;

    if (driverId != null) {
      _driverTripsFuture = context.read<TripProvider>().loadTripsByDriverId(
        driverId,
      );
    } else {
      _driverTripsFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DriverDrawer(),
      appBar: AppBar(
        title: const Text('Chuyến đi của tôi'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<List<TripModel>>(
        future: _driverTripsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final trips = snapshot.data ?? [];

          if (trips.isEmpty) {
            return const Center(child: Text('Bạn chưa tạo chuyến đi nào.'));
          }

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return TripCard(trip: trip, status: trip.status);
            },
          );
        },
      ),
    );
  }
}
