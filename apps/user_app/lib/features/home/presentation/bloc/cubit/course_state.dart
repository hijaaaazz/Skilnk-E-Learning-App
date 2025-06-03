import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/entity/saving_status.dart';

sealed class CourseState {
  final CourseEntity? course;

  CourseState({this.course});
}

final class CourseInitial extends CourseState {}

final class CourseDetailsLoadingState extends CourseState {}

final class CourseDetailsLoadedState extends CourseState {
  final CourseEntity coursedetails;
  CourseDetailsLoadedState({required this.coursedetails}) : super(course: coursedetails);
}

final class CourseDetailsErrorState extends CourseState {
  final String errorMessage;
  CourseDetailsErrorState({required this.errorMessage});
}

// --- Save/Favorite Course Operation States ---

final class CourseFavoriteLoading extends CourseDetailsLoadedState {
  SavingStatus status;
  CourseFavoriteLoading({required super.coursedetails,required this.status});
  
}

final class CourseFavoriteSuccess extends CourseDetailsLoadedState {
  SavingStatus staus;
  CourseFavoriteSuccess({required super.coursedetails,required this.staus});
}

final class CourseFavoriteFailure extends CourseDetailsLoadedState {
  SavingStatus status;
  CourseFavoriteFailure({required super.coursedetails,required this.status});
}
final class CoursePurchaseProcessing extends CourseDetailsLoadedState {
  CoursePurchaseProcessing({required super.coursedetails});
}

final class CoursePurchaseSuccess extends CourseDetailsLoadedState {
  CoursePurchaseSuccess({required super.coursedetails});
}
