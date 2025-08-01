// course_progress_event.dart

import  'package:user_app/features/home/data/models/update_progress_params.dart';

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
  final UpdateProgressParam updatedProgress;
   UpdateCourseProgressEvent({required this.updatedProgress});
}

