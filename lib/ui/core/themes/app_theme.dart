import 'package:flutter/material.dart';

import './app_colors.dart';
import './app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.blackLight,
        selectionColor: AppColors.greyLight,
        selectionHandleColor: AppColors.blackLight,
      ),
      iconTheme: IconThemeData(color: AppColors.blackLight),
      primarySwatch: AppColors.greyLight,
      primaryColor: AppColors.primaryLight,
      hintColor: AppColors.primaryLight,
      scaffoldBackgroundColor: AppColors.background,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.whiteLight,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blackLight),
              borderRadius: AppConstants.borderRadius,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blackLight),
              borderRadius: AppConstants.borderRadius,
            ),
          ),
          textStyle: TextStyle(color: AppColors.whiteLight),
          menuStyle: MenuStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.grey3Light),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: AppConstants.borderRadius,
              ),
            ),
          )),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.grey3Light),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: AppConstants.borderRadius,
            ),
          ),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.primary),
        bodyMedium: TextStyle(color: AppColors.primary),
        titleMedium: TextStyle(color: AppColors.primary),
        labelMedium: TextStyle(color: AppColors.primary),
        labelLarge: TextStyle(color: AppColors.primary),
        labelSmall: TextStyle(color: AppColors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusColor: AppColors.blackLight,
        labelStyle: TextStyle(color: AppColors.primary),
        floatingLabelStyle: TextStyle(color: AppColors.primary),
        hintStyle: TextStyle(color: AppColors.primary.withOpacity(0.7)),
        outlineBorder: BorderSide(
          color: AppColors.blue,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue),
          borderRadius: AppConstants.borderRadius,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue),
          borderRadius: AppConstants.borderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue),
          borderRadius: AppConstants.borderRadius,
        ),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(color: AppColors.primary, fontSize: 20),
        color: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.primary),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.whiteLight,
        textTheme: ButtonTextTheme.normal,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.whiteLight,
          textStyle: TextStyle(color: AppColors.whiteLight),
          backgroundColor: AppColors.primary,
          // side : BorderSide(color: AppColors.blackLight),
          shape: RoundedRectangleBorder(
            borderRadius: AppConstants.borderRadius,
          ),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: AppColors.background,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.grey,
        selectedItemColor: AppColors.blue,
        unselectedItemColor: AppColors.grey2,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppColors.transparent),
          iconColor: MaterialStateProperty.all(AppColors.primary),
          // foregroundColor: MaterialStateProperty.all(AppColors.blackLight),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: AppConstants.borderRadius,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(Color(0xFF0055CC)),
        trackColor: MaterialStateProperty.all(Color(0xFFDCE1E4)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData();
  }
}
