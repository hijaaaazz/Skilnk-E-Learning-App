import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? size;
  final FontWeight? weight;
  final Color? color;

  const AppText({
    super.key,
    this.text = "Default Text",
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.size,
    this.weight,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? GoogleFonts.outfit(
        fontSize: size ,
        fontWeight: weight,
        color: color 
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}