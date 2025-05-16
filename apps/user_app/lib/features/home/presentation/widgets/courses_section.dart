
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/home/presentation/bloc/bloc/course_bloc_bloc.dart';
import 'package:user_app/features/home/presentation/widgets/course_card.dart';

class CoursesSection extends StatelessWidget {
  const CoursesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBlocBloc, CourseBlocState>(
      builder: (context, state) {
        if (state is CourseBlocLoaded) {
          final courses = state.courses;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Courses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Text(
                          'SEE ALL',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(courses.length, (index) {
                    final course = courses[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CourseCard(
                        course: course,
                        isPartiallyVisible: index == courses.length - 1,
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        } else if (state is CourseBlocLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CourseBlocError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
