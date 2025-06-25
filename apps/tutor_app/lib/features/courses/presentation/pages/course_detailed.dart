import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/courses/presentation/bloc/course_bloc/courses_bloc.dart';
import 'package:tutor_app/features/courses/presentation/widgets/course_details_appbar.dart';
import 'package:tutor_app/features/courses/presentation/widgets/course_details_contexnt.dart';
import 'package:tutor_app/features/courses/presentation/widgets/details_skelton.dart';


class CourseDetailPage extends StatefulWidget {
  final String courseId;

  const CourseDetailPage({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  bool _hasLoadedReviews = false;

  @override
  void initState() {
    super.initState();
    context.read<CoursesBloc>().add(LoadCourseDetail(widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CoursesBloc, CoursesState>(
        listener: (context, state) {
          if (state is CourseDetailLoaded && !_hasLoadedReviews) {
            final reviewIds = state.course.reviews;
            if (reviewIds.isNotEmpty) {
              _hasLoadedReviews = true;
              context
                  .read<CoursesBloc>()
                  .add(LoadReiviews(course: state.course, reviewIds: reviewIds));
            }
          }
        },
        child: BlocBuilder<CoursesBloc, CoursesState>(
          builder: (context, state) {
            if (state is CourseDetailLoading) {
              return const CourseDetailSkeleton();
            }

            if (state is CourseDetailError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.deepOrange),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _hasLoadedReviews = false; // Reset flag on retry
                        context
                            .read<CoursesBloc>()
                            .add(LoadCourseDetail(widget.courseId));
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            }

            if (state is CourseDetailLoaded ||
                state is ReviewsLoadedState ||
                state is ReviewsErrorState ||
                state is ReviewsLoadingState) {
              final course = (state as dynamic).course;
              return CustomScrollView(
                slivers: [
                  CourseDetailAppBar(course: course),
                  CourseDetailContent(course: course),
                ],
              );
            }

            return const Center(child: Text('Course not found'));
          },
        ),
      ),
    );
  }
}
