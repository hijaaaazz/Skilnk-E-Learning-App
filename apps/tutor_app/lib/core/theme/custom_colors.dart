import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color primaryOrange;
  final Color primaryRed;
  final Color neutralGrey;
  final Color backgroundGrey;
  final Color primaryWhite;

  const CustomColors({
    required this.primaryOrange,
    required this.primaryRed,
    required this.neutralGrey,
    required this.backgroundGrey,
    required this.primaryWhite,
  });

  @override
  CustomColors copyWith({
    Color? primaryOrange,
    Color? primaryRed,
    Color? neutralGrey,
    Color? backgroundGrey,
    Color? primaryWhite,
  }) {
    return CustomColors(
      primaryOrange: primaryOrange ?? this.primaryOrange,
      primaryRed: primaryRed ?? this.primaryRed,
      neutralGrey: neutralGrey ?? this.neutralGrey,
      backgroundGrey: backgroundGrey ?? this.backgroundGrey,
      primaryWhite: primaryWhite ?? this.primaryWhite,
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
    );
  }

  static const light = CustomColors(
    primaryOrange: Color.fromARGB(255, 255, 106, 60),
    primaryRed: Color.fromARGB(255, 255, 0, 0),
    neutralGrey: Color.fromARGB(255, 134, 134, 134),
    backgroundGrey: Color.fromARGB(255, 240, 240, 240),
    primaryWhite: Colors.white,
  );

  static const dark = CustomColors(
    primaryOrange: Color.fromARGB(255, 255, 106, 60),
    primaryRed: Color.fromARGB(255, 139, 33, 0),
    neutralGrey: Color.fromARGB(255, 134, 134, 134),
    backgroundGrey: Color.fromARGB(255, 240, 240, 240),
    primaryWhite: Colors.white,
  );
}