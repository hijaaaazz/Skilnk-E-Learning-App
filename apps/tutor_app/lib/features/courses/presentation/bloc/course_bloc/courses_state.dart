part of 'courses_bloc.dart';

@immutable
sealed class CoursesState {}

final class CoursesInitial extends CoursesState {}

final class CoursesLoading extends CoursesState {
  final List<CoursePreview> courses;
  
  CoursesLoading({required this.courses});
}

final class CoursesLoaded extends CoursesState {
  final List<CoursePreview> courses;
  
  CoursesLoaded({
    required this.courses,
    
  });
}

final class CoursesError extends CoursesState {
  final String message;
  final List<CoursePreview>? courses;
  
  CoursesError({required this.message, this.courses});
}

final class CourseDetailLoading extends CoursesState {}

final class CourseDetailLoaded extends CoursesState {
  final CourseEntity course;
  
  CourseDetailLoaded({required this.course});
}

final class CourseDetailError extends CoursesState {
  final String message;
  
  CourseDetailError({required this.message});
}

final class ReviewsLoadingState extends CourseDetailLoaded{
  ReviewsLoadingState({required super.course});

}

// ignore: must_be_immutable
final class ReviewsLoadedState extends CourseDetailLoaded{
  List<ReviewModel> reviews;
  ReviewsLoadedState({required super.course,required this.reviews});

}

final class ReviewsErrorState extends CourseDetailLoaded{
  ReviewsErrorState({required super.course});

}
