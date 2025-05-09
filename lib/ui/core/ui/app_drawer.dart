import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/splash/view_model/splash_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/services/api_db_connection.dart';

import '../../../domain/models/user.dart';
import '../../about/widgets/about_screen.dart';
import '../../contact_information/contact_screen.dart';
import '../../settings_screen.dart';
import '../../admin/widgets/admin_screen.dart';
import '../../splash/widgets/splash_screen.dart';
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
    if  (context.mounted){
      final splashViewModel = context.read<SplashViewModel>();
      await splashViewModel.init();
    }
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SplashScreen()),
            (route) => false,
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
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/Logo_App_Drawer.png',
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
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
              ],
            ),
          ),
          const Divider(thickness: 1, indent: 0, endIndent: 0),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildDrawerItem(
              icon: Icons.exit_to_app,
              title: 'Logout',
              onTap: () => logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
