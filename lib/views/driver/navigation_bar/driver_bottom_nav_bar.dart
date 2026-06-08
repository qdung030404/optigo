import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:optigo/services/notification_service.dart';
import 'package:optigo/services/realtime_notification_service.dart';
import 'package:optigo/views/driver/booking_management/booking_management.dart';
import 'package:optigo/views/driver/manage_trip/manage_trip.dart';
import 'package:optigo/views/driver/post_a_trip/create_trip.dart';

class DriverBottomNavBar extends StatefulWidget {
  const DriverBottomNavBar({super.key});

  @override
  State<DriverBottomNavBar> createState() => _DriverBottomNavBarState();
}

class _DriverBottomNavBarState extends State<DriverBottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ManageTrip(),
    CreateTrip(),
    CombineTripsManagement(),
  ];


  @override
  void initState() {
    super.initState();
    final driverId = FirebaseAuth.instance.currentUser?.uid;
    if (driverId != null) {
      RealtimeNotificationService().subscribeToBookings(driverId, (bookingData) {
        _showNotification(bookingData);
      });
    }
  }

  void _showNotification(Map<String, dynamic> booking) {
    NotificationService().showNotification(
      title: 'bạn có yêu cầu ghép chuyến mới!',
      body: 'Có hành khách muốn đặt chuyến của bạn.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Quản lý chuyến',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Đăng chuyến',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Ghép chuyến',
          ),
        ],
      ),
    );
  }
}

