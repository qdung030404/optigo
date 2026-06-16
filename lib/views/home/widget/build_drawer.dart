import 'package:flutter/material.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/models/user_model.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:optigo/utils/currency_formatter.dart';
import 'package:provider/provider.dart';

class BuildDrawer extends StatelessWidget {
  final UserModel? user;

  const BuildDrawer({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // ── Gradient header ────────────────────────────────────────────
          _buildHeader(context),

          const SizedBox(height: 8),

          // ── Menu items ─────────────────────────────────────────────────
          _drawerItem(
            context,
            'Chỉnh sửa hồ sơ',
            Icons.person_outline_rounded,
            () {},
          ),
          _drawerItem(
            context,
            'Lịch sử chuyến đi',
            Icons.history_rounded,
            () {},
          ),
          _drawerItem(
            context,
            'Quản lí đặt chỗ',
            Icons.confirmation_number_outlined,
            () => Navigator.pushNamed(context, Routes.bookingManager),
          ),
          _drawerItem(
            context,
            'Cài đặt',
            Icons.settings_outlined,
            () {},
          ),

          const Spacer(),
          const Divider(height: 1, indent: 16, endIndent: 16),
          const SizedBox(height: 8),

          // ── Logout ─────────────────────────────────────────────────────
          _drawerItem(
            context,
            'Đăng xuất',
            Icons.logout_rounded,
            () async {
              authProvider.signOut();
              Navigator.pushReplacementNamed(context, Routes.login);
            },
            color: Colors.redAccent,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff176bac), Color(0xff2196F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(child: _defaultAvatar()),
          ),
          const SizedBox(height: 14),
          // Name
          Text(
            user?.userName ?? 'Chưa đặt tên',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 4),
          // Phone
          Text(
            Formatter.phoneFormatter(user?.phoneNumber ?? 'Chưa có số điện thoại'),
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultAvatar() {
    return Container(
      color: Colors.white,
      child: const Icon(Icons.person, size: 40, color: Color(0xff176bac)),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
  }) {
    final itemColor = color ?? const Color(0xff2d2d2d);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: const Color(0xff176bac).withOpacity(0.08),
        highlightColor: const Color(0xff176bac).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: ListTile(
            leading: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: (color ?? const Color(0xff176bac)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color ?? const Color(0xff176bac), size: 20),
            ),
            title: Text(
              title,
              style: TextStyle(
                color: itemColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: color == null
                ? Icon(Icons.chevron_right, color: Colors.grey[400], size: 20)
                : null,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
