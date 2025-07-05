import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import  'package:user_app/features/course_list/data/models/load_course_params.dart';
import  'package:user_app/features/course_list/domain/usecase/get_list.dart';
import  'package:user_app/features/course_list/presentation/bloc/course_list_event.dart';
import  'package:user_app/features/course_list/presentation/bloc/course_list_state.dart';

import  'package:user_app/features/home/domain/entity/course_privew.dart';
import  'package:user_app/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseListBloc extends Bloc<CourseListEvent, CourseListState> {
  final _batchSize = 7;
  int _currentBatchIndex = 0;
  List<String> _allCourseIds = [];

  CourseListBloc() : super(CourseListInitial()) {
    on<LoadList>((event, emit) async {
      emit(CourseListLoading());
      _currentBatchIndex = 0;
      _allCourseIds = event.courseIds;

      final result = await _loadCoursesBatch();

      result.fold(
        (failure) => emit(CourseListError(message: failure)),
        (courses) {
          // Check if there are more batches AFTER loading current batch
          _currentBatchIndex++; // Increment after loading
          final hasMore = _hasMoreBatches();
          emit(CourseListLoaded(
            courses: courses,
            hasReachedMax: !hasMore,
            lastDocument: null,
          ));
        },
      );
    });

    on<FetchPage>((event, emit) async {
      if (state is CourseListLoaded || state is CourseListLoadingMore) {
        final currentCourses = state is CourseListLoaded
            ? (state as CourseListLoaded).courses
            : (state as CourseListLoadingMore).courses;

        if (!_hasMoreBatches()) {
          return; // No more data to load
        }

        emit(CourseListLoadingMore(
          courses: currentCourses,
          lastDocument: null,
        ));

        final result = await _loadCoursesBatch();

        result.fold(
          (failure) => emit(CourseListError(message: failure)),
          (newCourses) {
            final updatedCourses = [...currentCourses, ...newCourses];
            // Increment batch index AFTER loading
            _currentBatchIndex++;
            final hasMore = _hasMoreBatches();

            emit(CourseListLoaded(
              courses: updatedCourses,
              hasReachedMax: !hasMore,
              lastDocument: null,
            ));
          },
        );
      }
    });
  }

  bool _hasMoreBatches() {
    final startIndex = _currentBatchIndex * _batchSize;
    final hasMore = startIndex < _allCourseIds.length;
    log('Checking for more batches: currentIndex=$_currentBatchIndex, startIndex=$startIndex, totalIds=${_allCourseIds.length}, hasMore=$hasMore');
    return hasMore;
  }

  List<String> _getCurrentBatch() {
    final startIndex = _currentBatchIndex * _batchSize;
    final endIndex = (startIndex + _batchSize).clamp(0, _allCourseIds.length);
    final batch = _allCourseIds.sublist(startIndex, endIndex);
        
    log('Loading batch $_currentBatchIndex: IDs $batch (${batch.length} items)');
    log('Total IDs: ${_allCourseIds.length}, Start: $startIndex, End: $endIndex');
        
    return batch;
  }

  Future<Either<String, List<CoursePreview>>> _loadCoursesBatch() async {
    if (!_hasMoreBatches()) {
      return Right([]);
    }

    final currentBatch = _getCurrentBatch();
        
    final result = await serviceLocator<GetCourseListUseCase>().call(
      params: LoadCourseParams(
        courseIds: currentBatch,
        lastDoc: null,
        pageSize: _batchSize,
      ),
    );

    return result.fold(
      (failure) => Left(failure),
      (data) => Right(data['courses'] as List<CoursePreview>),
    );
  }
}