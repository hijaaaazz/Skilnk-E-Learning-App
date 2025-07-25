import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (matching your home page)
  static const Color primaryOrange = Color(0xFFFF6B35);
  static const Color deepOrange = Color(0xFFE55722);
  static const Color lightOrange = Color(0xFFFF8A65);
  static const Color accentOrange = Color(0xFFFFAB91);
  
  // Blue Gradient Colors (for featured content)
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color lightBlue = Color(0xFF64B5F6);
  
  // Neutral Colors
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryOrange, lightOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient blueGradient = LinearGradient(
    colors: [primaryBlue, lightBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
