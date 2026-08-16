import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        brightness: Brightness.light,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
    );

    return baseTheme.copyWith(
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1A1A2E),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).copyWith(
        displayLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        headlineMedium: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        backgroundColor: Colors.white,
      ),
    );
  }

  static ThemeData darkTheme() {
    return lightTheme().copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2563EB),
        brightness: Brightness.dark,
      ),
    );
  }
}
