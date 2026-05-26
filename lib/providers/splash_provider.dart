import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:optigo/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:optigo/providers/booking_provider.dart';
import 'package:optigo/providers/trip_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashProvider extends ChangeNotifier {

  // Logic kiểm tra trạng thái đăng nhập
  Future<void> initSplash(
    AuthProvider authProvider,
    BookingProvider bookingProvider,
    TripProvider tripProvider,
    Function(String) onComplete,
  ) async {
    // 1. Yêu cầu quyền trước
    await _handlePermissions();

    final FirebaseAuth auth = FirebaseAuth.instance;

    await authProvider.checkAuthStatus();

    // Đợi 3 giây để hiển thị Splash Screen
    await Future.delayed(const Duration(seconds: 3));

    String nextRoute;
    if (auth.currentUser != null) {
      if (authProvider.status == AuthStatus.authenticated) {
        // Tải dữ liệu khi đã xác thực thành công
        await Future.wait([
          bookingProvider.loadBookings(),
          tripProvider.loadAllTrips(),
        ]);

        final role = authProvider.user?.role;
        nextRoute = role == UserRole.driver ?  Routes.home : Routes.home;
        print(role);
        if (role == UserRole.driver) {
          nextRoute = Routes.createTrip;
        }
      } else if (authProvider.status == AuthStatus.unregistered) {
        nextRoute = Routes.setUserName;
      } else {
        nextRoute = Routes.home;
      }
    } else {
      nextRoute = Routes.login;
    }

    onComplete(nextRoute);
  }

  Future<void> _handlePermissions() async {
    PermissionStatus status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
  }
}