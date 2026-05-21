import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/models/user_model.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SetUserName extends StatefulWidget {
  const SetUserName({super.key});

  @override
  State<SetUserName> createState() => _SetUserNameState();
}

class _SetUserNameState extends State<SetUserName> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  UserRole _selectedRole = UserRole.passenger;

  void _handleSetName() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!_formKey.currentState!.validate()) return;
    try {
      FocusScope.of(context).unfocus();
      await authProvider.updateProfile(nameController.text, _selectedRole);
      if (!mounted) return;
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),
      body: Column(
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
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên người dùng';
                  }
                  return null;
                },
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
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            child: Row(
              children: [
                Expanded(
                  child: _buildRoleCard(
                    UserRole.passenger,
                    'Hành khách',
                    Icons.person_outline,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildRoleCard(
                    UserRole.driver,
                    'Tài xế',
                    Icons.drive_eta_outlined,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Consumer<AuthProvider>(
            builder: (context, auth, child) {
              final bool isLoading = auth.status == AuthStatus.loading;
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.1,
                padding: EdgeInsets.all(16.sp),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfffedd59),
                    foregroundColor: Color(0xff176bac),
                  ),
                  onPressed: isLoading ? null : _handleSetName,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Color(0xff176bac),
                          strokeWidth: 3,
                        )
                      : Text(
                          'Xác nhận',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(UserRole role, String title, IconData icon) {
    final bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff176bac) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? const Color(0xff176bac) : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xff176bac).withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 44.sp,
              color: isSelected ? Colors.white : Colors.black54,
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: GoogleFonts.beVietnamPro(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
