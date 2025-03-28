import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_colors.dart';

class MyThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepOrange,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    extensions: [CustomColors.light], // Use the predefined light theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: GoogleFonts.outfitTextTheme().apply(
      bodyColor: Colors.black,
      displayColor: Colors.black87,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepOrange, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.deepOrange),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
    ),
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepOrange,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Colors.black,
    extensions: [CustomColors.dark], // Use the predefined dark theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.white,
      elevation: 2,
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: GoogleFonts.outfitTextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white70,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[900],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade600),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.deepOrange, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    iconTheme: const IconThemeData(color: Colors.deepOrange),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.deepOrange,
      unselectedItemColor: Colors.grey,
    ),
    useMaterial3: true,
  );
}
