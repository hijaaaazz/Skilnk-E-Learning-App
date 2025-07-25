import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/common/widgets/snackbar.dart';
import  'package:user_app/features/home/data/models/getcourse_details_params.dart';
import  'package:user_app/features/home/data/models/review_model.dart';
import  'package:user_app/features/home/data/models/save_course_params.dart';
import  'package:user_app/features/home/domain/entity/course-entity.dart';
import  'package:user_app/features/home/domain/entity/saving_status.dart';
import  'package:user_app/features/home/domain/usecases/add_new_review.dart';
import  'package:user_app/features/home/domain/usecases/get_course_details.dart';
import  'package:user_app/features/home/domain/usecases/get_reviews.dart';
import  'package:user_app/features/home/domain/usecases/save_course.dart';
import  'package:user_app/features/home/presentation/bloc/cubit/course_state.dart';
import  'package:user_app/features/library/presentation/bloc/library_bloc.dart';
import  'package:user_app/service_locator.dart';
//import 'get_reviews_params.dart';

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
        SnackBarUtils.showMinimalSnackBar(context,'${course.title} enrolled successfully!');
      }
    } catch (e) {
      log('Error in onPurchase: $e');
      if (!isClosed) {
        emit(CourseDetailsErrorState(errorMessage: 'Failed to complete enrollment'));
      }
      if (context.mounted) {
        SnackBarUtils.showMinimalSnackBar(context,'Failed to complete enrollment: $e');
      }
    }
  }

  Future<void> loadReviews(BuildContext context, CourseEntity course) async {
  try {
    if (isClosed) {
      log('CourseCubit is closed, cannot emit states');
      return;
    }

    final currentReviews = state.reviews;

    emit(ReviewsLoadingState(
      coursedetails: course,
      reviews: currentReviews,
    ));

    // Load only 3 reviews initially
    final result = await serviceLocator<GetReviewsUseCase>().call(
      params: GetReviewsParams(courseId: course.id, page: 1, limit: 3),
    );
    
    result.fold(
      (errorMessage) {
        emit(ReviewsErrorState(
          error: errorMessage,
          coursedetails: course,
          reviews: currentReviews,
        ));
      },
      (reviews) {
        final updatedCourse = course.copyWith(totalReviews: reviews.length);
        emit(ReviewsLoadedState(
          coursedetails: updatedCourse,
          reviews: reviews,
          displayedReviewCount: reviews.length, // Show all loaded reviews initially
          hasMoreReviews: reviews.length == 3, // Assume there might be more if we got exactly 3
        ));
      },
    );
  } catch (e) {
    log('Error in loading reviews: $e');
    if (!isClosed) {
      emit(ReviewsErrorState(
        error: 'Failed to load reviews',
        coursedetails: course,
        reviews: state.reviews,
      ));
    }
  }
}

Future<void> loadMoreReviews(BuildContext context, CourseEntity course) async {
  try {
    if (isClosed) {
      log('CourseCubit is closed, cannot emit states');
      return;
    }

    if (state is! ReviewsLoadedState) {
      log('Cannot load more reviews: Not in ReviewsLoadedState');
      return;
    }

    final currentState = state as ReviewsLoadedState;
    final currentReviews = currentState.reviews ?? [];
    final currentDisplayedCount = currentState.displayedReviewCount;

    // Check if we need to load more from backend or just display more from existing
    if (currentDisplayedCount < currentReviews.length) {
      // We have more reviews cached, just display more
      final newDisplayedCount = (currentDisplayedCount + 5).clamp(0, currentReviews.length);
      emit(ReviewsLoadedState(
        coursedetails: course,
        reviews: currentReviews,
        displayedReviewCount: newDisplayedCount,
        hasMoreReviews: newDisplayedCount < currentReviews.length,
      ));
      return;
    }

    // Need to load more from backend
    final currentPage = (currentReviews.length ~/ 5) + 1;

    emit(ReviewsLoadingState(
      coursedetails: course,
      reviews: currentReviews,
      isLoadingMore: true, // Indicate loading more reviews
    ));

    final result = await serviceLocator<GetReviewsUseCase>().call(
      params: GetReviewsParams(courseId: course.id, page: currentPage, limit: 5),
    );

    result.fold(
      (errorMessage) {
        emit(ReviewsErrorState(
          error: errorMessage,
          coursedetails: course,
          reviews: currentReviews,
        ));
      },
      (newReviews) {
        final updatedReviews = [...currentReviews, ...newReviews];
        final updatedCourse = course.copyWith(totalReviews: updatedReviews.length);
        final newDisplayedCount = currentDisplayedCount + 5;

        emit(ReviewsLoadedState(
          coursedetails: updatedCourse,
          reviews: updatedReviews,
          displayedReviewCount: newDisplayedCount > updatedReviews.length
              ? updatedReviews.length
              : newDisplayedCount,
          hasMoreReviews: newReviews.length == 5, // Assume more if we got exactly 5
        ));
      },
    );
  } catch (e) {
    log('Error in loading more reviews: $e');
    if (!isClosed) {
      emit(ReviewsErrorState(
        error: 'Failed to load more reviews',
        coursedetails: course,
        reviews: (state as ReviewsLoadedState).reviews,
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
            reviews: currentReviews,
          ));
          if (context.mounted) {
            SnackBarUtils.showMinimalSnackBar(context,'Failed to add review: $error');
          }
        },
        (addedReview) async {
          final loadResult = await serviceLocator<GetReviewsUseCase>().call(
            params: GetReviewsParams(courseId: course.id, page: 1, limit: 5),
          );

          loadResult.fold(
            (loadError) {
              emit(ReviewsErrorState(
                error: loadError,
                coursedetails: course,
                reviews: currentReviews,
              ));
            },
            (reviews) {
              final updatedCourse = course.copyWith(totalReviews: reviews.length);
              emit(ReviewsLoadedState(
                coursedetails: updatedCourse,
                reviews: reviews,
                displayedReviewCount: reviews.isEmpty ? 0 : 2,
                hasMoreReviews: reviews.length > 2,
              ));
              if (context.mounted) {
                SnackBarUtils.showMinimalSnackBar(context,'Review added successfully');
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
        reviews: state.reviews,
      ));
    }
  }
}