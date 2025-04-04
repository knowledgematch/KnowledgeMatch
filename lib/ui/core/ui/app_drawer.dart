import 'package:flutter/material.dart';

import '../../../screens/settings_screen.dart';
import '../../../theme/colors.dart';
import '../../about/widgets/about_screen.dart';
import '../../contact_information/contact_screen.dart';
import '../../profile/widget/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(color: AppColors.primary)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final drawerItems = [
      {
        'icon': Icons.person,
        'title': 'Profile',
        'screen': const ProfileScreen(),
      },
      {
        'icon': Icons.info,
        'title': 'About',
        'screen': const AboutScreen(),
      },
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
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: const Center(
              child: Text(
                'KnowledgeMatch',
                style: TextStyle(
                  color: AppColors.whiteLight,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
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
        ],
      ),
    );
  }
}
