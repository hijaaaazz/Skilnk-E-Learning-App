import 'package:user_app/features/home/data/models/review_model.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/entity/saving_status.dart';

sealed class CourseState {
  final CourseEntity? course;
  final List<ReviewModel>? reviews; // Add reviews to base state
  
  CourseState({this.course, this.reviews});
}

final class CourseInitial extends CourseState {}

final class CourseDetailsLoadingState extends CourseState {}

final class CourseDetailsLoadedState extends CourseState {
  final CourseEntity coursedetails;
  
  CourseDetailsLoadedState({
    required this.coursedetails,
    super.reviews, // Preserve reviews if they exist
  }) : super(course: coursedetails);
}

final class CourseDetailsErrorState extends CourseState {
  final String errorMessage;
  
  CourseDetailsErrorState({required this.errorMessage});
}

final class CourseFavoriteLoading extends CourseDetailsLoadedState {
  final SavingStatus status;
  
  CourseFavoriteLoading({
    required super.coursedetails, 
    required this.status,
    super.reviews, // Preserve reviews
  });
}

final class CourseFavoriteSuccess extends CourseDetailsLoadedState {
  final SavingStatus status;
  
  CourseFavoriteSuccess({
    required super.coursedetails, 
    required this.status,
    super.reviews, // Preserve reviews
  });
}

final class CourseFavoriteFailure extends CourseDetailsLoadedState {
  final SavingStatus status;
  
  CourseFavoriteFailure({
    required super.coursedetails, 
    required this.status,
    super.reviews, // Preserve reviews
  });
}

final class CoursePurchaseProcessing extends CourseDetailsLoadedState {
  CoursePurchaseProcessing({
    required super.coursedetails,
    super.reviews, // Preserve reviews
  });
}

final class CoursePurchaseSuccess extends CourseDetailsLoadedState {
  CoursePurchaseSuccess({
    required super.coursedetails,
    super.reviews, // Preserve reviews
  });
}

final class ReviewsLoadingState extends CourseDetailsLoadedState {
  ReviewsLoadingState({
    required super.coursedetails,
    super.reviews, // Preserve existing reviews during loading
  });
}

final class ReviewsLoadedState extends CourseDetailsLoadedState {
  ReviewsLoadedState({
    required super.coursedetails, 
    required List<ReviewModel> reviews,
  }) : super(reviews: reviews);
}

final class ReviewsErrorState extends CourseDetailsLoadedState {
  final String error;
  
  ReviewsErrorState({
    required this.error, 
    required super.coursedetails,
    super.reviews, // Preserve reviews even on error
  });
}