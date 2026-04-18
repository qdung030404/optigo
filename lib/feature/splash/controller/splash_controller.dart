import 'package:get/get.dart';
import 'package:optigo/feature/auth/view/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../main_screen/view/main_screen.dart';

class SplashController extends GetxController {
  final supabase = Supabase.instance.client;

  @override
  void onInit() {
    super.onInit();
    nextScreen();
  }

  Future<void> nextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (supabase.auth.currentSession == null) {
      Get.offAll(() => const LogInScreen());
    } else {
      Get.offAll(() => const MainScreen());
    }
  }
}
