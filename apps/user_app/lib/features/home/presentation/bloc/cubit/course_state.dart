import 'package:user_app/features/home/domain/entity/course-entity.dart';





sealed class CourseState {}

final class CourseInitial extends CourseState {}

final class CourseDetailsLoadingState extends CourseState {}

final class CourseDetailsLoadedState extends CourseState {
  final CourseEntity coursedetails;
  CourseDetailsLoadedState({required this.coursedetails});
}

final class CourseDetailsErrorState extends CourseState {
  final String errorMessage;
  CourseDetailsErrorState({required this.errorMessage});
}
