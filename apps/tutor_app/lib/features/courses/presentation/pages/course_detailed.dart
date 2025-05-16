import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/courses/presentation/bloc/course_bloc/courses_bloc.dart';
import 'package:tutor_app/features/courses/presentation/widgets/course_details_appbar.dart';
import 'package:tutor_app/features/courses/presentation/widgets/course_details_contexnt.dart';
import 'package:tutor_app/features/courses/presentation/widgets/details_skelton.dart';


class CourseDetailPage extends StatelessWidget {
  final String courseId;

  const CourseDetailPage({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    context.read<CoursesBloc>().add(LoadCourseDetail(courseId));

    return Scaffold(
      body: BlocBuilder<CoursesBloc, CoursesState>(
        builder: (context, state) {
          if (state is CourseDetailLoading) {
            return const CourseDetailSkeleton();
          }

          if (state is CourseDetailError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.deepOrange),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CoursesBloc>().add(LoadCourseDetail(courseId));
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is CourseDetailLoaded) {
            return CustomScrollView(
              slivers: [
                CourseDetailAppBar(course: state.course),
                CourseDetailContent(course: state.course),
              ],
            );
          }

          return const Center(child: Text('Course not found'));
        },
      ),
    );
  }
}