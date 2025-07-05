
// course_progress_state.dart
import  'package:user_app/features/home/data/models/course_progress.dart';

abstract class CourseProgressState {
  const CourseProgressState();

}

class CourseProgressInitial extends CourseProgressState {}

class CourseProgressLoading extends CourseProgressState {}

class CourseProgressLoaded extends CourseProgressState {
  final CourseProgressModel courseProgress;

  const CourseProgressLoaded({required this.courseProgress});

}

class CourseProgressError extends CourseProgressState {
  final String message;

  const CourseProgressError({required this.message});

}