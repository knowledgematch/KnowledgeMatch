import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _selectedTheme;

  ThemeData light = AppTheme.lightTheme;
  ThemeData dark = AppTheme.darkTheme;

  ThemeProvider({required bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark : light;
  }

  Future<void> swapTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_selectedTheme == dark) {
      _selectedTheme = light;
      await prefs.setBool('isDark', false);
    } else {
      _selectedTheme = dark;
      await prefs.setBool('isDark', true);
    }
    notifyListeners();
  }

  ThemeData getTheme() => _selectedTheme;
}
