import 'package:flutter/material.dart';
import 'package:knowledgematch/theme.dart';
import 'package:knowledgematch/theme/theme.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
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
