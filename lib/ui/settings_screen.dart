import 'package:flutter/material.dart';
import 'package:knowledgematch/ui/core/themes/theme_provider.dart';
import 'package:provider/provider.dart';

import 'core/themes/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.getTheme() == AppTheme.darkTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(isDarkMode ? 'Dark Mode' : 'Light Mode'),
            subtitle: Text(isDarkMode
                ? 'You have enabled dark mode'
                : 'You have enabled light mode'),
            secondary:
                Icon(isDarkMode ? Icons.nightlight_round : Icons.wb_sunny),
            value: isDarkMode,
            onChanged: (value) {
              themeProvider.swapTheme();
            },
          ),
        ],
      ),
    );
  }
}
