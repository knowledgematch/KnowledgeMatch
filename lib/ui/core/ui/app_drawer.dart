import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:knowledgematch/ui/login/login_screen.dart';
import '../../../data/services/api_db_connection.dart';

import '../../../domain/models/user.dart';
import '../../about/widgets/about_screen.dart';
import '../../contact_information/contact_screen.dart';
import '../../settings_screen.dart';
import '../../admin/widgets/admin_screen.dart';
import '../themes/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Future<void> logout(BuildContext context) async {
    ApiDbConnection().deleteFcmToken(User.instance.id ?? 0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    User.instance.reset();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      {
        'icon': Icons.contact_mail,
        'title': 'Contact',
        'screen': const ContactScreen(),
      },
      {
        'icon': Icons.settings,
        'title': 'Settings',
        'screen': SettingsScreen(),
      },
      {
        'icon': Icons.info,
        'title': 'About',
        'screen': const AboutScreen(),
      },
      if (User.instance.isAdmin ?? false)
        {
          'icon': Icons.admin_panel_settings,
          'title': 'Admin',
          'screen': const AdminScreen(),
        },
    ];

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.primary),
                  child: Center(
                    child: Column(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset(
                              'assets/images/Logo_NoBackground.png',
                              height: 90,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(
                          'KnowledgeMatch',
                          style: TextStyle(
                            color: AppColors.whiteLight,
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ...drawerItems.map((item) => _buildDrawerItem(
                  icon: item['icon'] as IconData,
                  title: item['title'] as String,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => item['screen'] as Widget),
                    );
                  },
                )),
                const Divider(),
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () => logout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
