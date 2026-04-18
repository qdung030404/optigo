import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo controller
    Get.put(SplashController());

    return Scaffold(
      backgroundColor: Color(0xfffedd59),
      body: Center(child: Image.asset('assets/image/splash_logo.png')),
    );
  }
}
