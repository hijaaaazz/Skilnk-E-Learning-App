
// course_progress_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/features/home/data/models/course_progress.dart';
import 'package:user_app/features/home/data/models/get_progress_params.dart';
import 'package:user_app/features/home/domain/usecases/get_course_progress.dart';
import 'dart:developer';

import 'package:user_app/features/home/presentation/bloc/progress_bloc/course_progress_event.dart';
import 'package:user_app/features/home/presentation/bloc/progress_bloc/course_progress_state.dart';

class CourseProgressBloc extends Bloc<CourseProgressEvent, CourseProgressState> {
  final GetCourseProgressUseCase getCourseProgressUseCase;

  CourseProgressBloc({required this.getCourseProgressUseCase}) 
      : super(CourseProgressInitial()) {
    
    on<LoadCourseProgressEvent>(_onLoadCourseProgress);
    on<RefreshCourseProgressEvent>(_onRefreshCourseProgress);
  }

  Future<void> _onLoadCourseProgress(
    LoadCourseProgressEvent event,
    Emitter<CourseProgressState> emit,
  ) async {
    emit(CourseProgressLoading());
    
    final result = await getCourseProgressUseCase(
      params: GetCourseProgressParams(
        courseId: event.courseId,
        userId: event.userId),
    );
    
    result.fold(
      (failure) {
        log('Failed to load course progress: failure');
        emit(CourseProgressError(message: failure));
      },
      (courseProgress) {
        emit(CourseProgressLoaded(courseProgress: courseProgress));
      },
    );
  }

  Future<void> _onRefreshCourseProgress(
    RefreshCourseProgressEvent event,
    Emitter<CourseProgressState> emit,
  ) async {
    // Don't show loading for refresh, keep current state
    final result = await getCourseProgressUseCase(
      params: GetCourseProgressParams(
        courseId: event.courseId,
        userId: event.userId),
    );
    
    result.fold(
      (failure) {
        log('Failed to refresh course progress: failure');
        emit(CourseProgressError(message: failure));
      },
      (courseProgress) {
        emit(CourseProgressLoaded(courseProgress: courseProgress));
      },
    );
  }
}