part of 'library_bloc.dart';

@immutable
sealed class LibraryEvent {}

final class LoadSavedCoursesEvent extends LibraryEvent {
  final String userId;
  
   LoadSavedCoursesEvent({required this.userId});
}

final class LoadEnrolledCoursesEvent extends LibraryEvent {
  final String userId;
  
   LoadEnrolledCoursesEvent({required this.userId});
}

final class RefreshSavedCoursesEvent extends LibraryEvent {
  final String userId;
  
   RefreshSavedCoursesEvent({required this.userId});
}

final class RefreshEnrolledCoursesEvent extends LibraryEvent {
  final String userId;
  
   RefreshEnrolledCoursesEvent({required this.userId});
}


final class SaveCourseEvent extends LibraryEvent{
  final CoursePreview course;

  SaveCourseEvent({required this.course});
}

final class EnrollCourseEvent extends LibraryEvent{
  final CoursePreview course;

  EnrollCourseEvent({required this.course});
}

final class UnSaveCourseEvent extends LibraryEvent{
  final CoursePreview course;

  UnSaveCourseEvent({required this.course});
}