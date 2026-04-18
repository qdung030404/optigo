import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/core/widgets/base_screen.dart';
import 'package:optigo/feature/auth/controller/auth_controller.dart';

class SetUserName extends StatefulWidget {
  const SetUserName({super.key});

  @override
  State<SetUserName> createState() => _SetUserNameState();
}

class _SetUserNameState extends State<SetUserName> {
  final controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Text(
            'Thiết lập tên người dùng',
            style: GoogleFonts.beVietnamPro(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.sp),
            child: TextFormField(
              controller: controller.usernameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16.h,
                ),
                labelText: 'Tên người dùng',
                labelStyle: TextStyle(fontSize: 16.sp),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.1,
            padding: EdgeInsets.all(16.sp),
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xfffedd59),
                  foregroundColor: Color(0xff176bac),
                ),
                onPressed: () => controller.updateUserName(),

                child: controller.isLoading.value
                    ? Text('Xác nhận')
                    : CircularProgressIndicator()
              ),
            ),
          ),
        ],
      ),
    );
  }
}
