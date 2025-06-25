
import 'dart:developer';

import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:tutor_app/features/courses/data/models/get_course_req.dart';
import 'package:tutor_app/features/courses/data/models/review_model.dart';
import 'package:tutor_app/features/courses/data/models/toggle_params.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/couse_preview.dart';
import 'package:tutor_app/features/courses/domain/usecases/delee_course.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_course_details.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_courses.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_reviews.dart';
import 'package:tutor_app/features/courses/domain/usecases/toggle_activation.dart';
import 'package:tutor_app/service_locator.dart';
part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final GetCoursesUseCase  _getCourse = serviceLocator<GetCoursesUseCase>();
  final GetCourseDetailUseCase _getCourseDetailUseCase = serviceLocator<GetCourseDetailUseCase>();
  final ToggleCourseUseCase _toggleCourseStatusUseCase = serviceLocator<ToggleCourseUseCase>();
  final DeleteCourseUseCase _deleteCourseUseCase = serviceLocator<DeleteCourseUseCase>();
  
  CourseParams _currentParams = const CourseParams();
  List<CoursePreview> _courses = [];
  bool _isInitialized = false;

  CoursesBloc() : super(CoursesInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<RefreshCourses>(_onRefreshCourses);
    on<SearchCourses>(_onSearchCourses);
    on<LoadCourseDetail>(_onLoadCourseDetail);
    on<ToggleCourseStatus>(_onToggleCourseStatus);
    on<DeleteCourse>(_onDeleteCourse);
    on<AddCourseEvent>(_onAddCourse);
    on<UpdateCourseEvent>(_onUpdateCourse);
    on<LoadReiviews>(_onLoadReviews);
  }

  Future<void> _onLoadCourses(LoadCourses event, Emitter<CoursesState> emit) async {
    // Skip loading if already initialized and not forced
    if (_isInitialized && !event.forceReload) {
      emit(CoursesLoaded(
        courses: _courses,
      ));
      return;
    }
    
    emit(CoursesLoading(courses: _courses));
    
    _currentParams = CourseParams(page: 1, limit: 10, tutorId: event.tutorId);
    
    final result = await _getCourse(params: _currentParams);
    
    result.fold(
      (error) => emit(CoursesError(message: error, courses: _courses)),
      (courses) {
        _courses = courses;
        _isInitialized = true; // Mark as initialized
        emit(CoursesLoaded(
          courses: _courses,
        ));
      },
    );
  }

  
  Future<void> _onRefreshCourses(RefreshCourses event, Emitter<CoursesState> emit) async {
    // Keep existing courses during loading for better UX
    emit(CoursesLoading(courses: _courses));
    
    // Reset page to 1 and ensure tutorId is set
    _currentParams = _currentParams.copyWith(
      page: 1,
      tutorId: event.tutorId ?? _currentParams.tutorId,
    );
    
    final result = await _getCourse(params: _currentParams);
    
    result.fold(
      (error) => emit(CoursesError(message: error, courses: _courses)),
      (courses) {
        _courses = courses;
        emit(CoursesLoaded(
          courses: _courses,
        ));
      },
    );
  }

  Future<void> _onSearchCourses(SearchCourses event, Emitter<CoursesState> emit) async {
    emit(CoursesLoading(courses: _courses));
    
    _currentParams = _currentParams.copyWith(
      page: 1,
      searchQuery: event.query.isNotEmpty ? event.query : null,
    );
    
    final result = await _getCourse(params: _currentParams);
    
    result.fold(
      (error) => emit(CoursesError(message: error, courses: _courses)),
      (courses) {
        _courses = courses;
        emit(CoursesLoaded(
          courses: _courses,
        ));
      },
    );
  }

  Future<void> _onToggleCourseStatus(ToggleCourseStatus event, Emitter<CoursesState> emit) async {
    final currentState = state;
    
    if (currentState is CourseDetailLoaded) {
      // Optimistic update
      final updatedCourse = currentState.course.copyWith(isActive: event.isActive);
      emit(CourseDetailLoaded(course: updatedCourse));
      
      final result = await _toggleCourseStatusUseCase(
        params: courseToggleParams(courseId: event.courseId, isActive: event.isActive)
      );
      
      result.fold(
        (error) {
          // Revert to original state on error
          emit(CourseDetailLoaded(course: currentState.course));
          emit(CourseDetailError(message: error));
          emit(CourseDetailLoaded(course: currentState.course));
        },
        (_) {
          // Update the course in the list as well
          final index = _courses.indexWhere((c) => c.id == event.courseId);
          if (index != -1) {
            _courses[index] = _courses[index].copyWith(isActive: event.isActive);
          }
        },
      );
    }
  }

  Future<void> _onLoadCourseDetail(LoadCourseDetail event, Emitter<CoursesState> emit) async {
    // Save the current courses list state to prevent losing it
    
    emit(CourseDetailLoading());
    
    final result = await _getCourseDetailUseCase(params: event.courseId);
    
    result.fold(
      (error) => emit(CourseDetailError(message: error)),
      (course) {
        log(course.categoryName.toString());
        emit(CourseDetailLoaded(course: course));
        
        // Update the course in the courses list if it exists
        final index = _courses.indexWhere((c) => c.id == event.courseId);
        if (index != -1) {
          _courses[index] = _courses[index].copyWith(
            title: course.title,
            
            thumbnailUrl: course.courseThumbnail,
            isActive: course.isActive,
            offerPercentage: course.offerPercentage
          );
        }
      },
    );
  }

  Future<void> _onDeleteCourse(DeleteCourse event, Emitter<CoursesState> emit) async {
    // Keep existing courses during loading for better UX
    emit(CoursesLoading(courses: _courses));
    
    final result = await _deleteCourseUseCase(params: event.courseId);
    
    result.fold(
      (error) => emit(CoursesError(message: error, courses: _courses)),
      (_) {
        // Remove the course from the list
        _courses.removeWhere((course) => course.id == event.courseId);
        emit(CoursesLoaded(
          courses: _courses,
        ));
      },
    );
  }

 Future<void> _onAddCourse(AddCourseEvent event, Emitter<CoursesState> emit) async {
  // Add the new course to the top of the list
  _courses.insert(0, event.course.toPreview()); // Or use add() if you want it at the end
  log(event.course.toString());
  emit(CoursesLoaded(
    courses: _courses,
  ));
}

 Future<void> _onUpdateCourse(UpdateCourseEvent event, Emitter<CoursesState> emit) async {
  final updatedPreview = event.course.toPreview();
  final existingIndex = _courses.indexWhere((course) => course.id == updatedPreview.id);
  log(existingIndex.toString());

  if (existingIndex != -1) {
    // Replace existing course
    _courses[existingIndex] = updatedPreview;
    log('[onUpdateCourse] ✅ Course with id ${updatedPreview.id} updated at index $existingIndex');
  } else {
    // Add as new course
    _courses.insert(0, updatedPreview);
    log('[onUpdateCourse] ➕ Course with id ${updatedPreview.id} added to top of list');
  }

  emit(CoursesLoaded(
    courses: _courses,
  ));
}

Future<void> _onLoadReviews(LoadReiviews event, Emitter<CoursesState> emit) async {
  emit(ReviewsLoadingState(course: event.course));

  try {
    final useCase = serviceLocator<GetReviewsUseCase>();

    final result = await useCase.call(params: event.reviewIds); // Directly from event

    result.fold(
      (errorMessage) {
        log('❌ Failed to load reviews: $errorMessage');
        emit(ReviewsErrorState(course: event.course));
      },
      (reviewList) {
        log("succes");

        emit(ReviewsLoadedState(course: event.course,reviews: reviewList));
      },
    );
  } catch (e, stackTrace) {
    log('Exception in _onLoadReviews: $e\n$stackTrace');
    emit(ReviewsErrorState(course: event.course));
  }
}



}