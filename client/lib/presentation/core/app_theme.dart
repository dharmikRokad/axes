import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  // Dark Mode Colors (Provided)
  static const Color deepIndigo = Color(0xFF2E3192);
  static const Color softLavender = Color(0xFFE0E7FF);
  static const Color inkBlack = Color(0xFF0F172A);
  static const Color offWhite = Color(0xFFF8FAFC);

  // Deriving Light Mode Colors
  // For Light Mode, we use Off White as background and Ink Black for text/accents
  static const Color lightBackground = offWhite;
  static const Color lightSurface = Colors.white;
  static const Color lightPrimary = deepIndigo;
  static const Color lightOnPrimary = Colors.white;
  static const Color lightSecondary = Color(
    0xFF6366F1,
  ); // Slightly brighter indigo for secondary
  static const Color lightOnSecondary = Colors.white;

  // Dark Mode specifics
  static const Color darkBackground = inkBlack;
  static const Color darkSurface = Color(0xFF1E293B); // Slate-800 for surfaces
  static const Color darkPrimary = deepIndigo;
  static const Color darkOnPrimary = offWhite;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: lightPrimary,
        onPrimary: lightOnPrimary,
        secondary: lightSecondary,
        onSecondary: lightOnSecondary,
        background: lightBackground,
        onBackground: inkBlack,
        surface: lightSurface,
        onSurface: inkBlack,
        outline: Color(0xFFE2E8F0), // slate-200
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: inkBlack,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: inkBlack,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightPrimary,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: darkPrimary,
        onPrimary: darkOnPrimary,
        secondary: softLavender,
        onSecondary: inkBlack,
        background: darkBackground,
        onBackground: offWhite,
        surface: darkSurface,
        onSurface: offWhite,
        outline: Color(0xFF334155), // slate-700
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: offWhite,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: offWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: offWhite,
      ),
    );
  }
}
