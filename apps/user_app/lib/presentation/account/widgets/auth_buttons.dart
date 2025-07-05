import 'package:flutter/material.dart';
import  'package:user_app/common/widgets/app_text.dart';

class AuthButtons extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color? color;
  final VoidCallback? onPressed;

  const AuthButtons({
    super.key,
    required this.text,
    required this.backgroundColor,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: AppText(
            text: text,
            color: color,
            weight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

