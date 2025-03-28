import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color primaryOrange;
  final Color primaryRed;
  final Color neutralGrey;
  final Color backgroundGrey;
  final Color primaryWhite;
  final Color backgroundLightBlue;
  final Color textBlack;
  final Color textWhite;
  final Color cardBackground;
  final Color borderGrey;

  const CustomColors({
    required this.primaryOrange,
    required this.primaryRed,
    required this.neutralGrey,
    required this.backgroundGrey,
    required this.primaryWhite,
    required this.backgroundLightBlue,
    required this.textBlack,
    required this.textWhite,
    required this.cardBackground,
    required this.borderGrey,
  });

  @override
  CustomColors copyWith({
    Color? primaryOrange,
    Color? primaryRed,
    Color? neutralGrey,
    Color? backgroundGrey,
    Color? primaryWhite,
    Color? backgroundLightBlue,
    Color? textBlack,
    Color? textWhite,
    Color? cardBackground,
    Color? borderGrey,
  }) {
    return CustomColors(
      primaryOrange: primaryOrange ?? this.primaryOrange,
      primaryRed: primaryRed ?? this.primaryRed,
      neutralGrey: neutralGrey ?? this.neutralGrey,
      backgroundGrey: backgroundGrey ?? this.backgroundGrey,
      primaryWhite: primaryWhite ?? this.primaryWhite,
      backgroundLightBlue: backgroundLightBlue ?? this.backgroundLightBlue,
      textBlack: textBlack ?? this.textBlack,
      textWhite: textWhite ?? this.textWhite,
      cardBackground: cardBackground ?? this.cardBackground,
      borderGrey: borderGrey ?? this.borderGrey,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      primaryOrange: Color.lerp(primaryOrange, other.primaryOrange, t) ?? primaryOrange,
      primaryRed: Color.lerp(primaryRed, other.primaryRed, t) ?? primaryRed,
      neutralGrey: Color.lerp(neutralGrey, other.neutralGrey, t) ?? neutralGrey,
      backgroundGrey: Color.lerp(backgroundGrey, other.backgroundGrey, t) ?? backgroundGrey,
      primaryWhite: Color.lerp(primaryWhite, other.primaryWhite, t) ?? primaryWhite,
      backgroundLightBlue: Color.lerp(backgroundLightBlue, other.backgroundLightBlue, t) ?? backgroundLightBlue,
      textBlack: Color.lerp(textBlack, other.textBlack, t) ?? textBlack,
      textWhite: Color.lerp(textWhite, other.textWhite, t) ?? textWhite,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t) ?? cardBackground,
      borderGrey: Color.lerp(borderGrey, other.borderGrey, t) ?? borderGrey,
    );
  }

  static const light = CustomColors(
    primaryOrange: Color(0xFFFF6A3C), // Vibrant Orange
    primaryRed: Color(0xFFFF0000), // Bright Red
    neutralGrey: Color(0xFF868686), // Medium Grey
    backgroundGrey: Color(0xFFF0F0F0), // Light Grey Background
    primaryWhite: Colors.white, // White
    backgroundLightBlue: Color(0xFFEBEBFF), // Light Blue
    textBlack: Colors.black, // Text color for Light Mode
    textWhite: Colors.white, // White text for contrast
    cardBackground: Color(0xFFFFFFFF), // White card background
    borderGrey: Color(0xFFD1D1D1), // Light Grey for Borders
  );

  static const dark = CustomColors(
    primaryOrange: Color(0xFFE65C30), // Darker Orange
    primaryRed: Color(0xFF8B2100), // Darker Red
    neutralGrey: Color(0xFF666666), // Darker Neutral Grey
    backgroundGrey: Color(0xFF1E1E1E), // Dark Grey Background
    primaryWhite: Color(0xFFC8C8C8), // Off-White for readability
    backgroundLightBlue: Color(0xFF2A2A40), // Dark Blue for contrast
    textBlack: Color.fromARGB(255, 85, 85, 85), // White text for Dark Mode
    textWhite: Colors.black, // Black text for contrast
    cardBackground: Color(0xFF2A2A2A), // Dark card background
    borderGrey: Color(0xFF444444), // Darker Grey for Borders
  );
}
