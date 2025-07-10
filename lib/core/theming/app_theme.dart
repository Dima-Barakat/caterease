import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightGray = Color(0xFFE6E6E6);
  static const Color lightGreen = Color(0xFFB7D6B7);
  static const Color lightBlue = Color(0xFFC0CCD8);
  static const Color darkBlue = Color(0xFF314E76);

  static ThemeData lightTheme = ThemeData(
    primaryColor: darkBlue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: darkBlue,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: darkBlue,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    ),
    cardColor: lightGray,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: darkBlue,
      secondary: lightGreen,
      surface: lightGray,
      background: Colors.white,
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
  );
}
