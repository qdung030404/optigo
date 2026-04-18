import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:optigo/core/widgets/base_screen.dart';
import 'package:optigo/feature/auth/controller/auth_controller.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    return BaseScreen(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Get started',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                IntlPhoneField(
                  decoration: InputDecoration(
                    hintText: '9 1234 5678',
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.withOpacity(0.5)
                    ),
                    border: UnderlineInputBorder(),
                    counterText: "",
                  ),
                  initialCountryCode: 'VN',
                  disableLengthCheck: true,
                  onChanged: (phone) {
                    String number = phone.number;
                    if (number.startsWith('0')) {
                      number = number.substring(1);
                    }
                    controller.phoneController.text = '${phone.countryCode}$number';
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                )
              ],
            )
          ),
          Spacer(),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.1,
            padding: EdgeInsets.all(16.sp),
            child: Obx(() => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xfffedd59),
                foregroundColor: Color(0xff176bac)
              ),
              onPressed: controller.isLoading.value 
                  ? null 
                  : () => controller.sendVerifiedCode(),
              child: controller.isLoading.value
                  ? CircularProgressIndicator()
                  : Text('Sign Up'),
            )),
          ),
        ],
      ),
    );
  }
}
