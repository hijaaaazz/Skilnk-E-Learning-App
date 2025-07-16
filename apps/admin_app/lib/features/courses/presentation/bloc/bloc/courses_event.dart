part of 'courses_bloc.dart';

@immutable
sealed class CoursesEvent {}

class FetchCourses extends CoursesEvent {}

class BanCourse extends CoursesEvent {
  final String courseId;

  BanCourse({required this.courseId}); 
}
