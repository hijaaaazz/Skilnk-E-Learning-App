part of 'course_bloc_bloc.dart';

@immutable
sealed class CourseBlocEvent {}

class FetchCategories extends CourseBlocEvent {}

class FetchCourses extends CourseBlocEvent {}


