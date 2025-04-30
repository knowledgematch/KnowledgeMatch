import 'package:flutter/material.dart';

import 'app_theme.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _selectedTheme;

  ThemeData light = AppTheme.lightTheme;
  ThemeData dark = AppTheme.darkTheme;

  ThemeProvider({required bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark : light;
  }

  Future<void> swapTheme() async {
    //TODO implement when DarkTheme is implemented
  }

  ThemeData getTheme() => _selectedTheme;
}
