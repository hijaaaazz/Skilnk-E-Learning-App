import 'package:flutter/material.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';

class CurriculumTab extends StatelessWidget {
  final CourseEntity course;

  const CurriculumTab({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        course.lessons.length,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F8FE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8F1FF)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: Color(0xFFFF6636), shape: BoxShape.circle),
                child: Center(child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.lessons[index].title,
                      style: TextStyle(
                        color: course.isEnrolled ? const Color(0xFF202244) : const Color(0xFF888888),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatDuration(course.lessons[index].duration),
                      style: TextStyle(
                        color: course.isEnrolled ? const Color(0xFF545454) : const Color(0xFF999999),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                course.isEnrolled ? Icons.lock_open : Icons.lock,
                color: course.isEnrolled ? const Color(0xFF4CAF50) : const Color(0xFF888888),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }
}