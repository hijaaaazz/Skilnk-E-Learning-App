part of 'courses_bloc.dart';

@immutable
sealed class CoursesEvent {
  const CoursesEvent();
}

class LoadCourses extends CoursesEvent {
  final String tutorId;
  final bool forceReload;
  
  const LoadCourses({this.forceReload = false, required this.tutorId});
}

class LoadMoreCourses extends CoursesEvent {
  const LoadMoreCourses();
}

class RefreshCourses extends CoursesEvent {
  final String? tutorId;
  
  const RefreshCourses({this.tutorId});
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

class AddCourseEvent extends CoursesEvent{
  final CourseEntity course;

  const AddCourseEvent({required this.course});
}

class UpdateCourseEvent extends CoursesEvent{
  final CourseEntity course;

  const UpdateCourseEvent({required this.course});
}


class LoadReiviews extends CoursesEvent{
  final List<String> reviewIds;
  final CourseEntity course;

  const LoadReiviews({required this.reviewIds,required this.course});
}
