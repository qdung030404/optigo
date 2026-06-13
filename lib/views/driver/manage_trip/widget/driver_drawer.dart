import 'package:flutter/material.dart';
import 'package:optigo/config/routes.dart';
import 'package:optigo/models/user_model.dart';
import 'package:optigo/providers/auth_provider.dart';
import 'package:optigo/utils/currency_formatter.dart';
import 'package:provider/provider.dart';

class DriverDrawer extends StatelessWidget {
  const DriverDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final UserModel? user = authProvider.user;

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
              Formatter.phoneFormatter(user?.phoneNumber ?? ''),
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          _drawerItem('Chỉnh sửa hồ sơ', Icons.edit, () {
             // Navigator.pushNamed(context, Routes.profile);
          }),
          _drawerItem('Cài đặt', Icons.settings_outlined, () {}),
          const Divider(),
          _drawerItem(
            'Đăng xuất',
            Icons.logout,
            () async {
              authProvider.signOut();
              Navigator.pushReplacementNamed(context, Routes.login);
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
