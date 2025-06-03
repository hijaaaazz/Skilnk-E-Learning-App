part of 'course_bloc_bloc.dart';

@immutable
sealed class CourseBlocEvent {}

final class FetchCategories extends CourseBlocEvent {}

final class FetchCourses extends CourseBlocEvent {}
