part of 'course_bloc_bloc.dart';

@immutable
sealed class CourseBlocState {}

final class CourseBlocInitial extends CourseBlocState {}

final class CourseBlocLoading extends CourseBlocState {}

final class CourseBlocLoaded extends CourseBlocState {
  final List<CategoryEntity> categories;
  final List<CoursePreview> courses;
  final List<MentorEntity> mentors;
  final List<BannerModel> banners;

  CourseBlocLoaded(this.categories, this.courses,this.mentors,this.banners);
}

final class CourseBlocError extends CourseBlocState {
  final String message;

  CourseBlocError(this.message);
}

// Save course operation states
final class CourseOpsLoading extends CourseBlocState {}

final class CourseOpsSuccess extends CourseBlocState {
  final CourseEntity course;

  CourseOpsSuccess(this.course);
}

final class CourseOpsFailure extends CourseBlocState {
  final String error;

  CourseOpsFailure(this.error);
}
