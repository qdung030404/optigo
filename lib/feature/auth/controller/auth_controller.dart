import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:optigo/feature/auth/view/set_user_name.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:optigo/feature/auth/view/otp_screen.dart';
import 'package:optigo/feature/main_screen/view/main_screen.dart';

class AuthController extends GetxController {
  final phoneController = TextEditingController();
  final pinController = TextEditingController();
  final usernameController = TextEditingController();
  final focusNode = FocusNode();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  var verificationId = ''.obs;
  var isLoading = false.obs;

  Future<void> sendVerifiedCode() async {
    print('DEBUG: Sending code to: ${phoneController.text}');
    if (phoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a phone number', 
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Tự động xác thực trên một số thiết bị Android
          await _firebaseAuth.signInWithCredential(credential);
          Get.offAll(() => const MainScreen());
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          Get.snackbar('Error', e.message ?? 'Verification failed',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        },
        codeSent: (String vId, int? resendToken) {
          isLoading.value = false;
          verificationId.value = vId;
          Get.to(() => const OtpScreen());
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    final phoneNumber = phoneController.text; // Sao lưu giá trị trước khi xử lý bất đồng bộ
    print('DEBUG: Verification ID: ${verificationId.value}');
    print('DEBUG: SMS Code entered: $smsCode');

    if (verificationId.value.isEmpty) {
      Get.snackbar('Error', 'Lỗi: Không tìm thấy Verification ID. Vui lòng gửi lại mã.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId.value, smsCode: smsCode);

      // 1. Đăng nhập vào Firebase
      await _firebaseAuth.signInWithCredential(credential);

      // 2. Đồng bộ thông tin user sang Supabase
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await _supabaseClient.from('profiles').upsert({
          'id': user.uid,
          'phone': phoneNumber, // Sử dụng biến cục bộ
          'updated_at': DateTime.now().toIso8601String(),
        });
        
        // Trước khi chuyển màn hình, hãy đóng bàn phím
        focusNode.unfocus();
        
        // Sau khi đồng bộ, kiểm tra xem đã có username chưa
        await checkProfile();
      }

    } catch (e) {
      print('DEBUG: Firebase Auth Error: $e');
      isLoading.value = false;
      Get.snackbar('Lỗi', 'Mã OTP không chính xác hoặc đã hết hạn.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
  Future<void> checkProfile() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    try {
      final data = await _supabaseClient
          .from('profiles')
          .select('user_name')
          .eq('id', user.uid)
          .maybeSingle();

      if (data != null && data['user_name'] != null && data['user_name'].toString().isNotEmpty) {
        Get.offAll(() => const MainScreen());
      } else {
        Get.offAll(() => const SetUserName());
      }
    } catch (e) {
      print('Lỗi checkProfile: $e');
    }
  }

  Future<void> updateUserName() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    final newUsername = usernameController.text.trim(); // Sao lưu giá trị text

    if (newUsername.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng nhập tên người dùng");
      return;
    }

    isLoading.value = true;
    try {
      // Đóng bàn phím để tránh lỗi Flutter framework khi chuyển màn hình nhanh
      focusNode.unfocus();

      await _supabaseClient
          .from('profiles')
          .update({
            'user_name': newUsername, // Sử dụng biến cục bộ
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.uid);

      Get.offAll(() => const MainScreen());
      Get.snackbar("Welcome", "Chào mừng bạn đến với Optigo");
    } catch (e) {
      print('Lỗi updateUserName: $e');
      Get.snackbar("Lỗi", "Không thể cập nhật tên. Vui lòng thử lại.");
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onClose() {
    // Không nên gọi dispose thủ công ở đây khi dùng Get.offAll để tránh lỗi race condition với Gesture
    // usernameController.dispose();
    // phoneController.dispose();
    // pinController.dispose();
    // focusNode.dispose();
    super.onClose();
  }
}