import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

class CourseFeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const CourseFeatureItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: const Color(0xFFFF6636),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            ReCase(text).titleCase,
            style: TextStyle(
              color: const Color(0xFF545454),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
