import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:optigo/feature/auth/controller/auth_controller.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color(0xff176bac);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color(0xfffedd59);

    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: const Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
              'Vui lòng nhập mã gồm 6 chữ số được gửi đến\n${controller.phoneController.text}',
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
                controller: controller.pinController,
                focusNode: controller.focusNode,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => SizedBox(width: 8.w),
                validator: (value) {
                  return value?.length == 6 ? null : 'Pin is incorrect';
                },
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {
                  controller.verifyOtp(pin);
                },
                onChanged: (value) {
                  debugPrint('onChanged: $value');
                },
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 9),
                      width: 22,
                      height: 1,
                      color: focusedBorderColor,
                    ),
                  ],
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: focusedBorderColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(height: 48.h),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                   ? null
                   : () => controller.verifyOtp(controller.pinController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfffedd59),
                  foregroundColor: const Color(0xff176bac),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Color(0xff176bac))
                    : Text(
                        'Xác nhận',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            )),
            SizedBox(height: 24.h),
            Center(
              child: TextButton(
                onPressed: () {
                  controller.sendVerifiedCode();
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
