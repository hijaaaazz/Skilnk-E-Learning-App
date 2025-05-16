import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/lecture_entity.dart';

Widget buildStatItem(IconData icon, String value, String label) {
  return Column(
    children: [
      Icon(icon, color: Colors.deepOrange),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      Text(
        label,
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      ),
    ],
  );
}

Widget buildLectureItem(BuildContext context, LectureEntity lecture, int index) {
  return Card(
    margin: const EdgeInsets.only(bottom: 8),
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.deepOrange,
        child: Text('$index', style: const TextStyle(color: Colors.white)),
      ),
      title: Text(lecture.title),
      subtitle: Text('${lecture.duration.inMinutes} min'),
      trailing: const Icon(Icons.play_circle_outline),
      onTap: () {
        context.pushNamed(AppRouteConstants.lectureDetails, extra: lecture);
      },
    ),
  );
}

Widget buildRatingBar(int rating, int count, int total) {
  final percentage = total > 0 ? count / total : 0.0;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2.0),
    child: Row(
      children: [
        Text('$rating', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(width: 4),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        Text('$count', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    ),
  );
}

void showDeleteConfirmation(BuildContext context, CourseEntity course) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Course'),
      content: Text(
        'Are you sure you want to delete "${course.title}"? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
}