import 'package:tutor_app/features/courses/presentation/bloc/course_bloc/courses_bloc.dart';

class CourseDetailsArgs {
  final CoursesBloc bloc;
  final String courseId;

  CourseDetailsArgs({required this.bloc, required this.courseId});
}
