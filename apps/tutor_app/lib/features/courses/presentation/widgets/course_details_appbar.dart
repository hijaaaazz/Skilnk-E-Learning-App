import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/core/routes/app_route_constants.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/presentation/bloc/course_bloc/courses_bloc.dart';
import 'package:tutor_app/features/courses/presentation/widgets/build_stat_item.dart';

class CourseDetailAppBar extends StatelessWidget {
  final CourseEntity course;

  const CourseDetailAppBar({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              course.courseThumbnail,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, size: 48),
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          course.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            context.pushNamed(
              AppRouteConstants.addCourse,
              extra: course,
            );
          },
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              showDeleteConfirmation(context, course);
            } else if (value == 'toggle') {
              context.read<CoursesBloc>().add(
                    ToggleCourseStatus(
                      courseId: course.id,
                      isActive: !course.isActive,
                    ),
                  );
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'toggle',
              child: Text(
                course.isActive ? 'Deactivate Course' : 'Activate Course',
              ),
            ),
          ],
        ),
      ],
    );
  }
}