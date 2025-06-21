// course_progress_event.dart

import 'package:user_app/features/home/data/models/course_progress.dart';

abstract class CourseProgressEvent {
  const CourseProgressEvent();

}

class LoadCourseProgressEvent extends CourseProgressEvent {
  final String courseId;
  final String userId;

  const LoadCourseProgressEvent({
    required this.courseId,
    required this.userId,
  });
}

class RefreshCourseProgressEvent extends CourseProgressEvent {
  final String courseId;
  final String userId;

  const RefreshCourseProgressEvent({
    required this.courseId,
    required this.userId,
  });

}

class UpdateCourseProgressEvent extends CourseProgressEvent{
  final CourseProgressModel updatedProgress;
   UpdateCourseProgressEvent({required this.updatedProgress});
}

