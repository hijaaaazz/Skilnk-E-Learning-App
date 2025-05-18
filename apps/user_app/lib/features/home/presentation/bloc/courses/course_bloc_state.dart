part of 'course_bloc_bloc.dart';

@immutable
sealed class CourseBlocState {}

final class CourseBlocInitial extends CourseBlocState {}

final class CourseBlocLoading extends CourseBlocState {}

final class CourseBlocLoaded extends CourseBlocState {
  final List<CategoryEntity> categories;
  final List<CoursePreview> courses;

  CourseBlocLoaded(this.categories, this.courses);
}


final class CourseBlocError extends CourseBlocState {
  final String message;

  CourseBlocError(this.message);
}
