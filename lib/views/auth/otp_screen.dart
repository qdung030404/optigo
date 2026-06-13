import 'package:optigo/config/routes.dart';
import 'package:optigo/models/user_model.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _pinController = TextEditingController();

  void _handleVerify() async {
    if (_pinController.text.length != 6) return;

    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.verifyOtp(_pinController.text); 
      if (!mounted) return;
      if (authProvider.status == AuthStatus.unregistered) {
        Navigator.pushReplacementNamed(context, Routes.setUserName); 
      } else if (authProvider.status == AuthStatus.authenticated) {
        if (authProvider.user?.role == UserRole.driver) {
          Navigator.pushReplacementNamed(context, Routes.driverHome);
        } else {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color(0xff176bac);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color(0xfffedd59);

    final isLoading = context.watch<AuthProvider>().isLoading;

    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'Xác thực số điện thoại',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Vui lòng nhập mã gồm 6 chữ số được gửi đến số điện thoại của bạn',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            SizedBox(height: 48.h),
            Center(
              child: Pinput(
                length: 6,
                controller: _pinController,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => SizedBox(width: 8.w),
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) => _handleVerify(),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(height: 48.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleVerify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfffedd59),
                  foregroundColor: const Color(0xff176bac),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                  'Xác nhận',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Center(
              child: TextButton(
                onPressed: isLoading ? null : () {
                  // Logic gửi lại mã
                },
                child: Text(
                  "Bạn không nhận được mã? Gửi lại mã",
                  style: TextStyle(
                    color: const Color(0xff176bac),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
