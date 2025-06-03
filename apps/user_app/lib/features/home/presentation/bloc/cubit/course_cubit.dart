import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_app/features/home/data/models/getcourse_details_params.dart';
import 'package:user_app/features/home/data/models/save_course_params.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/entity/saving_status.dart';
import 'package:user_app/features/home/domain/usecases/get_course_details.dart';
import 'package:user_app/features/home/domain/usecases/save_course.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_state.dart';
import 'package:user_app/features/library/presentation/bloc/library_bloc.dart';
import 'package:user_app/service_locator.dart';

class CourseCubit extends Cubit<CourseState> {
  
  CourseCubit() : super(CourseInitial());

  Future<void> fetchCourseDetails(GetCourseDetailsParams params) async {
    emit(CourseDetailsLoadingState());

    final result = await serviceLocator<GetCourseDetailsUseCase>().call(params: params);

    result.fold(
      (failure) => emit(CourseDetailsErrorState(errorMessage: failure)),
      (course) => emit(CourseDetailsLoadedState(coursedetails: course)),
    );
  }


Future<void> toggleSaveCourse(BuildContext context, SaveCourseParams params) async {
  emit(CourseFavoriteLoading(coursedetails: state.course!, status: SavingStatus.loading));

  final result = await serviceLocator<SaveCourseUseCase>().call(params: params);

  result.fold(
    (failure) {
      emit(CourseFavoriteFailure(coursedetails: state.course!, status: SavingStatus.unsaved));
    },
    (isSaved) {
      final updatedCourse = state.course!.copyWith(isSaved: isSaved);

      emit(CourseFavoriteSuccess(coursedetails: updatedCourse, staus: SavingStatus.saved));

      /// 🔁 Notify the LibraryBloc here
      final event = isSaved
          ? SaveCourseEvent(course: updatedCourse.toPreview())
          : UnSaveCourseEvent(course: updatedCourse.toPreview());

      context.read<LibraryBloc>().add(event);
    },
  );
}Future<void> onPurchase(BuildContext context, CourseEntity course) async {
  try {
    // Check if the cubit is still active
    if (isClosed) {
      log('CourseCubit is closed, cannot emit states');
      return;
    }

    emit(CoursePurchaseProcessing(coursedetails: course));

    final updatedCourse = course.copyWith(isEnrolled: true);
    
    emit(CoursePurchaseSuccess(coursedetails: updatedCourse));

    

      context.read<LibraryBloc>().add(EnrollCourseEvent(course: updatedCourse.toPreview()));

    // Show success message
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
    
    // Emit error state if cubit is still active
    if (!isClosed) {
      emit(CourseDetailsErrorState(errorMessage: 'Failed to complete enrollment'));
    }
    
    // Show error message
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


}
