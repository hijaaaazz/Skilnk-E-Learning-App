part of 'courses_bloc.dart';

@immutable
sealed class CoursesEvent {
  const CoursesEvent();
}

class LoadCourses extends CoursesEvent {
  final bool forceReload;
  
  const LoadCourses({this.forceReload = false});
}

class LoadMoreCourses extends CoursesEvent {
  const LoadMoreCourses();
}

class RefreshCourses extends CoursesEvent {
  const RefreshCourses();
}

class SearchCourses extends CoursesEvent {
  final String query;
  
  const SearchCourses(this.query);
}

class LoadCourseDetail extends CoursesEvent {
  final String courseId;
  
  const LoadCourseDetail(this.courseId);
}

class ToggleCourseStatus extends CoursesEvent {
  final String courseId;
  final bool isActive;
  
  const ToggleCourseStatus({
    required this.courseId,
    required this.isActive,
  });
}

class DeleteCourse extends CoursesEvent {
  final String courseId;
  
  const DeleteCourse(this.courseId);
}
