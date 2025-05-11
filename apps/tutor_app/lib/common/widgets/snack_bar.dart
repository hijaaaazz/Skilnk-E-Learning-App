import 'package:flutter/material.dart';
import 'package:tutor_app/common/widgets/app_text.dart';

void showAppSnackbar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: AppText(text:  message, color: Colors.deepOrange,),
    behavior: SnackBarBehavior.floating,
    backgroundColor: const Color.fromARGB(221, 255, 255, 255),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    duration: const Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
