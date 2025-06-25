import 'package:flutter/material.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/presentation/widgets/build_stat_item.dart';
import 'package:tutor_app/features/courses/presentation/widgets/rating_bar.dart';
import 'package:tutor_app/features/courses/presentation/widgets/reviews_breakdown_section.dart';

class CourseDetailContent extends StatelessWidget {
  final CourseEntity course;

  const CourseDetailContent({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final discountedPrice =
        course.price - (course.price * course.offerPercentage / 100).round();

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (course.offerPercentage > 0) ...[
                  Text(
                    '\$$discountedPrice',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '\$${course.price}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${course.offerPercentage}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    '\$${course.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildStatItem(Icons.people, '${course.enrolledCount}', 'Students'),
                buildStatItem(Icons.access_time, '${formatDurationVerbose(course.duration)} min', 'Duration'),
                buildStatItem(Icons.signal_cellular_alt, course.level, 'Level'),
                buildStatItem(Icons.star, course.averageRating.toStringAsFixed(1), 'Rating'),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              course.categoryName,
              style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'About This Course',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              course.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[800], height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Course Content',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${course.lessons.length} lectures • ${formatDurationVerbose(course.duration) }  total',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ...course.lessons.asMap().entries.map((entry) {
              final index = entry.key;
              final lecture = entry.value;
              return buildLectureItem(context, lecture, index + 1);
            }),
            const SizedBox(height: 24),
            ReviewBreakDown()
            
          ],
        ),
      ),
    );
  }
  String formatDurationVerbose(int totalSeconds) {
  final duration = Duration(seconds: totalSeconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  final parts = <String>[];
  if (hours > 0) parts.add('${hours}h');
  if (minutes > 0) parts.add('${minutes}m');
  if (seconds > 0 || parts.isEmpty) parts.add('${seconds}s');

  return parts.join(' ');
}

}