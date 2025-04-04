import 'package:flutter/material.dart';
import './colors.dart';
import './constants.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
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
        textStyle: TextStyle(color: AppColors.blackLight),
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
      buttonColor: AppColors.primaryLight,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
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

  static ThemeData darkTheme = ThemeData(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.whiteLight,
      selectionColor: AppColors.greyDark,
      selectionHandleColor: AppColors.whiteLight,
    ),
    iconTheme: IconThemeData(color: AppColors.whiteLight),
    primarySwatch: Colors.grey,
    primaryColor: AppColors.primaryDark,
    hintColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.whiteLight,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.whiteLight),
          borderRadius: AppConstants.borderRadius,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.whiteLight),
          borderRadius: AppConstants.borderRadius,
        ),
      ),
      textStyle: TextStyle(color: AppColors.whiteLight),
      menuStyle: MenuStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.grey3Dark),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: AppConstants.borderRadius,
          ),
        ),
      ),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.grey3Dark),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: AppConstants.borderRadius,
          ),
        ),
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.whiteLight),
      bodyMedium: TextStyle(color: AppColors.whiteLight),
      titleMedium: TextStyle(color: AppColors.whiteLight),
      labelMedium: TextStyle(color: AppColors.whiteLight),
      labelLarge: TextStyle(color: AppColors.whiteLight),
      labelSmall: TextStyle(color: AppColors.whiteLight),
    ),
    inputDecorationTheme: InputDecorationTheme(
      focusColor: AppColors.whiteLight,
      labelStyle: TextStyle(color: AppColors.primaryDark),
      floatingLabelStyle: TextStyle(color: AppColors.primaryDark),
      hintStyle: TextStyle(color: AppColors.primaryDark.withOpacity(0.7)),
      outlineBorder: BorderSide(
        color: AppColors.blueDark,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.blueDark),
        borderRadius: AppConstants.borderRadius,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.blueDark),
        borderRadius: AppConstants.borderRadius,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.blueDark),
        borderRadius: AppConstants.borderRadius,
      ),
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(color: AppColors.whiteLight, fontSize: 20),
      color: AppColors.primaryDark,
      iconTheme: IconThemeData(color: AppColors.whiteLight),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryDark,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(
          borderRadius: AppConstants.borderRadius,
        ),
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.backgroundDark,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.greyDark,
      selectedItemColor: AppColors.blueDark,
      unselectedItemColor: AppColors.grey2Dark,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.transparent),
        iconColor: MaterialStateProperty.all(AppColors.whiteLight),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.grey3Dark,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: AppConstants.borderRadius,
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(AppColors.blueDark),
      trackColor: MaterialStateProperty.all(AppColors.grey2Dark),
    ),
  );
}
