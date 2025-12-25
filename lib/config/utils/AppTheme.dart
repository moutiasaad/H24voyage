import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1E324B);
  static const Color accent = Color(0xFF26B0C5);
  static const Color orange = Color(0xFFD68338);
  static const Color background = Color(0xFFFCFCFC);
  static const Color beige = Color(0xFFF7EFE8);
  static const Color darkText = Color(0xFF0C0C0F);
  static const Color grey = Color(0xFFA3AAB6);

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: accent,
      background: background,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: darkText,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: darkText,
        fontSize: 14,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
  );
}
