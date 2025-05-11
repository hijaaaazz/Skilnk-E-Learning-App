import 'dart:ui';

import 'package:flutter/material.dart';

class BlurredLoading extends StatelessWidget {
  const BlurredLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return  BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: const Color.fromARGB(54, 0, 0, 0),
        alignment: Alignment.center,
        child: const SizedBox(
          width: 200, // Adjust width as needed
          child: LinearProgressIndicator(
            color: Colors.deepOrange,
            backgroundColor: Colors.white24,
          ),
        ),
      ),
    );
  }
}