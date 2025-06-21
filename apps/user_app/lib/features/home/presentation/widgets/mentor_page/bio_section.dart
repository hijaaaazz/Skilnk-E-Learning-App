import 'package:flutter/material.dart';

class BioSection extends StatelessWidget {
  final String bio;

  const BioSection({super.key, required this.bio});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Text(
        '"$bio"',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: Color(0xFF545454),
          height: 1.5,
        ),
      ),
    );
  }
}