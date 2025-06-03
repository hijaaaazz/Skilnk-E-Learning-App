import 'package:flutter/material.dart';
import 'package:user_app/features/home/data/models/course_progress.dart';

class ProgressOverviewCard extends StatelessWidget {
  final CourseProgressModel courseProgress;

  const ProgressOverviewCard({
    super.key,
    required this.courseProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Course Progress',
            style: TextStyle(
              color: Color(0xFF202244),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(courseProgress.overallProgress * 100).toInt()}% Complete',
                      style: const TextStyle(
                        color: Color(0xFF202244),
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${courseProgress.completedLectures} of ${courseProgress.lectures.length} lectures completed',
                      style: const TextStyle(
                        color: Color(0xFF545454),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Circular Progress Indicator
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: courseProgress.overallProgress,
                        strokeWidth: 8,
                        backgroundColor: const Color(0xFFF0F0F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF6636),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '${(courseProgress.overallProgress * 100).toInt()}%',
                        style: const TextStyle(
                          color: Color(0xFF202244),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Linear Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: const Color(0xFFF0F0F0),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: courseProgress.overallProgress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF6636),
                      Color(0xFFFF8A50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}