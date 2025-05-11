import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF1D1F26),
          fontSize: 18,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w500,
          height: 1.33,
        ),
      ),
    );
  }
}