import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:provider/provider.dart';
class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}
class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _completePhoneNumber = "";

  void _handleSignUp() async{
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    try{
      await authProvider.sendOtp(_completePhoneNumber);
      if (!mounted) return;
      if (authProvider.status == AuthStatus.codeSent){
        Navigator.pushNamed(context, Routes.otp);
      }
    }catch(e){
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? e.toString())),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Phone Input
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Form(
            key: _formKey,
            child: IntlPhoneField(
              disableLengthCheck: true,
              decoration: InputDecoration(
                hintText: '99 1234 5678',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              initialCountryCode: 'VN',
              showDropdownIcon: true,
              dropdownIconPosition: IconPosition.trailing,
              flagsButtonPadding: const EdgeInsets.only(left: 12, right: 4),
              validator: (phone) {
                if (phone == null || phone.number.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                return null;
              },
              onChanged: (phone) {
                String number = phone.number;
                if (number.startsWith('0')) {
                  number = number.substring(1);
                }
                _completePhoneNumber = '${phone.countryCode}$number';
              },
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
            ),
          )
        ),
        
        const SizedBox(height: 16),

        Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            return ElevatedButton(
              onPressed: authProvider.isLoading ? null : _handleSignUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfffedd59),
                foregroundColor: const Color(0xff176bac),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: const Color(0xfffedd59).withOpacity(0.6),
              ),
              child: authProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xff176bac),
                      ),
                    )
                  : Text(
                      'Đăng nhập',
                      style: GoogleFonts.lexend(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            );
          },
        ),
        
        const SizedBox(height: 24),
        
        // Divider
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Hoặc tiếp tục với',
                style: GoogleFonts.lexend(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey.shade200, thickness: 1)),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Google Button
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.white,
            side: BorderSide.none, // Make it look like the image (no border, just icon)
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                height: 24,
                width: 24,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.g_mobiledata, 
                  size: 32, 
                  color: Color(0xff176bac),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
