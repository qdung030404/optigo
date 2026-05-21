import 'package:flutter/material.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/models/user_model.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class BuildDrawer extends StatelessWidget {
  final UserModel? user;

  const BuildDrawer({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
            ),
            accountName: Text(
              user?.userName ?? 'Chưa đặt tên',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            accountEmail: Text(
              user?.phoneNumber ?? 'Chưa có số',
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          _drawerItem('Chỉnh sửa hồ sơ', Icons.edit, () {}),
          _drawerItem('Lịch sử', Icons.history, () {}),
          _drawerItem('Quản lí chuyến đi', Icons.location_on_outlined, () =>Navigator.pushNamed(context, Routes.bookingManager)),
          _drawerItem('Cài đặt', Icons.settings_outlined, () {}),
          const Divider(),
          _drawerItem(
            'Đăng xuất',
            Icons.logout,
                () async {
              // ... logic logout ...
              authProvider.signOut();
            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(String title, IconData icon, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }
}
