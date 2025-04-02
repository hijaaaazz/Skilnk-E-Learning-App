import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  final Color successColor;
  final Color warningColor;
  final Color infoColor;

  const CustomColors({
    required this.successColor,
    required this.warningColor,
    required this.infoColor,
  });

  @override
  CustomColors copyWith({
    Color? successColor,
    Color? warningColor,
    Color? infoColor,
  }) {
    return CustomColors(
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      successColor: Color.lerp(successColor, other.successColor, t) ?? successColor,
      warningColor: Color.lerp(warningColor, other.warningColor, t) ?? warningColor,
      infoColor: Color.lerp(infoColor, other.infoColor, t) ?? infoColor,
    );
  }
}
