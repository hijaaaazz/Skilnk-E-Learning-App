import 'package:flutter/material.dart';

class MentorStats extends StatelessWidget {
  final String coursesCount;
  final String studentsCount;

  const MentorStats({
    super.key,
    required this.coursesCount,
    required this.studentsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatItem(context, coursesCount, 'Courses'),
        Container(
          height: 40,
          width: 1,
          color: Colors.grey.withOpacity(0.3),
          margin: const EdgeInsets.symmetric(horizontal: 20),
        ),
        _buildStatItem(context, studentsCount, 'Students'),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF202244),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF545454),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}