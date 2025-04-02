import 'package:flutter/material.dart';
import 'custom_colors.dart';

extension CustomColorsExtension on BuildContext {
  CustomColors get customColors => Theme.of(this).extension<CustomColors>() ?? 
    const CustomColors(
      successColor: Colors.green,
      warningColor: Colors.orange,
      infoColor: Colors.blueAccent,
    );
}
