import 'package:flutter/material.dart';
import 'custom_colors.dart';

extension CustomColorsExtension on BuildContext {
  CustomColors get customColors {
    return Theme.of(this).extension<CustomColors>() ??
        CustomColors.light; // Use the default light theme colors
  }
}
