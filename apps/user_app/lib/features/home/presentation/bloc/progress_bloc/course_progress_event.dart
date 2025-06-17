// course_progress_event.dart

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

