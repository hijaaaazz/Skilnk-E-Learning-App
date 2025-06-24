import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/home/data/models/getcourse_details_params.dart';
import 'package:user_app/features/home/data/models/review_model.dart';
import 'package:user_app/features/home/data/models/save_course_params.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/entity/saving_status.dart';
import 'package:user_app/features/home/domain/usecases/add_new_review.dart';
import 'package:user_app/features/home/domain/usecases/get_course_details.dart';
import 'package:user_app/features/home/domain/usecases/get_reviews.dart';
import 'package:user_app/features/home/domain/usecases/save_course.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_state.dart';
import 'package:user_app/features/library/presentation/bloc/library_bloc.dart';
import 'package:user_app/service_locator.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit() : super(CourseInitial());

  @override
  void onChange(Change<CourseState> change) {
    super.onChange(change);
    log('CourseCubit state: ${change.nextState}');
  }

  Future<void> fetchCourseDetails(GetCourseDetailsParams params) async {
    log('Fetching course details for courseId: ${params.courseId}');
    emit(CourseDetailsLoadingState());

    final result = await serviceLocator<GetCourseDetailsUseCase>().call(params: params);

    result.fold(
      (failure) => emit(CourseDetailsErrorState(errorMessage: failure)),
      (course) => emit(CourseDetailsLoadedState(coursedetails: course)),
    );
  }

  Future<void> toggleSaveCourse(BuildContext context, SaveCourseParams params) async {
    // Preserve current reviews
    final currentReviews = state.reviews;
    
    emit(CourseFavoriteLoading(
      coursedetails: state.course!, 
      status: SavingStatus.loading,
      reviews: currentReviews,
    ));

    final result = await serviceLocator<SaveCourseUseCase>().call(params: params);

    result.fold(
      (failure) {
        emit(CourseFavoriteFailure(
          coursedetails: state.course!, 
          status: SavingStatus.unsaved,
          reviews: currentReviews,
        ));
      },
      (isSaved) {
        final updatedCourse = state.course!.copyWith(isSaved: isSaved);
        emit(CourseFavoriteSuccess(
          coursedetails: updatedCourse, 
          status: SavingStatus.saved,
          reviews: currentReviews,
        ));
        final event = isSaved
            ? SaveCourseEvent(course: updatedCourse.toPreview())
            : UnSaveCourseEvent(course: updatedCourse.toPreview());
        context.read<LibraryBloc>().add(event);
      },
    );
  }

  Future<void> onPurchase(BuildContext context, CourseEntity course) async {
    try {
      if (isClosed) {
        log('CourseCubit is closed, cannot emit states');
        return;
      }
      
      // Preserve current reviews
      final currentReviews = state.reviews;
      
      emit(CoursePurchaseProcessing(
        coursedetails: course,
        reviews: currentReviews,
      ));
      
      final updatedCourse = course.copyWith(isEnrolled: true);
      emit(CoursePurchaseSuccess(
        coursedetails: updatedCourse,
        reviews: currentReviews,
      ));
      
      context.read<LibraryBloc>().add(EnrollCourseEvent(course: updatedCourse.toPreview()));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${course.title} enrolled successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      log('Error in onPurchase: $e');
      if (!isClosed) {
        emit(CourseDetailsErrorState(errorMessage: 'Failed to complete enrollment'));
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to complete enrollment: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> loadReviews(BuildContext context, CourseEntity course) async {
    try {
      if (isClosed) {
        log('CourseCubit is closed, cannot emit states');
        return;
      }
      
      // Preserve existing reviews during loading
      final currentReviews = state.reviews;
      
      emit(ReviewsLoadingState(
        coursedetails: course,
        reviews: currentReviews,
      ));
      
      final result = await serviceLocator<GetReviewsUseCase>().call(params: course.id);
      result.fold(
        (errorMessage) {
          emit(ReviewsErrorState(
            error: errorMessage, 
            coursedetails: course,
            reviews: currentReviews, // Keep old reviews on error
          ));
        },
        (reviews) {
          // Update totalReviews in CourseEntity
          final updatedCourse = course.copyWith(totalReviews: reviews.length);
          emit(ReviewsLoadedState(
            reviews: reviews, 
            coursedetails: updatedCourse,
          ));
        },
      );
    } catch (e) {
      log('Error in loading reviews: $e');
      if (!isClosed) {
        emit(ReviewsErrorState(
          error: 'Failed to load reviews', 
          coursedetails: course,
          reviews: state.reviews, // Preserve existing reviews
        ));
      }
    }
  }

  Future<void> addReview(BuildContext context, ReviewModel review) async {
    final course = state.course;
    if (course == null) {
      log('No course loaded to add review');
      return;
    }

    try {
      // Preserve current reviews during loading
      final currentReviews = state.reviews;
      
      emit(ReviewsLoadingState(
        coursedetails: course,
        reviews: currentReviews,
      ));

      final result = await serviceLocator<AddReviewUseCase>().call(params: review);

      result.fold(
        (error) {
          emit(ReviewsErrorState(
            error: error, 
            coursedetails: course,
            reviews: currentReviews, // Keep existing reviews on error
          ));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to add review: $error'), backgroundColor: Colors.red),
            );
          }
        },
        (addedReview) async {
          final loadResult = await serviceLocator<GetReviewsUseCase>().call(params: course.id);

          loadResult.fold(
            (loadError) {
              emit(ReviewsErrorState(
                error: loadError, 
                coursedetails: course,
                reviews: currentReviews, // Keep existing reviews on error
              ));
            },
            (reviews) {
              final updatedCourse = course.copyWith(totalReviews: reviews.length);
              emit(ReviewsLoadedState(
                reviews: reviews, 
                coursedetails: updatedCourse,
              ));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Review added successfully'), backgroundColor: Colors.green),
                );
              }
            },
          );
        },
      );
    } catch (e) {
      log('Error in addReview: $e');
      emit(ReviewsErrorState(
        error: 'Something went wrong', 
        coursedetails: course,
        reviews: state.reviews, // Preserve existing reviews
      ));
    }
  }
}