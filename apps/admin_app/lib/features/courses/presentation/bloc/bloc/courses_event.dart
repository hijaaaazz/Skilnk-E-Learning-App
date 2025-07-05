part of 'courses_bloc.dart';

@immutable
sealed class CoursesEvent {}

class FetchCourses extends CoursesEvent {}
