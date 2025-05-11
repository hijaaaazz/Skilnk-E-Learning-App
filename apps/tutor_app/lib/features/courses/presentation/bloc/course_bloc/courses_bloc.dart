import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:tutor_app/features/courses/data/models/get_course_req.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/couse_preview.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_course_details.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_course_options.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_courses.dart';
import 'package:tutor_app/features/courses/presentation/widgets/course_price_form.dart';
import 'package:tutor_app/service_locator.dart';
part 'courses_event.dart';
part 'courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final GetCoursesUseCase  _getCourseOptionsUseCase = serviceLocator<GetCoursesUseCase>();
  final GetCourseDetailUseCase _getCourseDetailUseCase = serviceLocator<GetCourseDetailUseCase>();
  //final ToggleCourseStatusUseCase _toggleCourseStatusUseCase = serviceLocator<ToggleCourseStatusUseCase>();
  //final DeleteCourseUseCase _deleteCourseUseCase = serviceLocator<DeleteCourseUseCase>();
  
  CourseParams _currentParams = const CourseParams();
  List<CoursePreview> _courses = [];
  bool _hasReachedMax = false;
  bool _isInitialized = false;

  CoursesBloc() : super(CoursesInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<LoadMoreCourses>(_onLoadMoreCourses);
    on<RefreshCourses>(_onRefreshCourses);
    on<SearchCourses>(_onSearchCourses);
    on<LoadCourseDetail>(_onLoadCourseDetail);
    // on<ToggleCourseStatus>(_onToggleCourseStatus);
    // on<DeleteCourse>(_onDeleteCourse);
  }

  Future<void> _onLoadCourses(LoadCourses event, Emitter<CoursesState> emit) async {
    // Skip loading if already initialized and not forced
    if (_isInitialized && !event.forceReload) {
      emit(CoursesLoaded(
        courses: _courses,
        hasReachedMax: _hasReachedMax,
      ));
      return;
    }
    
    emit(CoursesLoading(courses: _courses));
    
    _currentParams = const CourseParams(page: 1, limit: 10);
    _hasReachedMax = false;
    
    final result = await _getCourseOptionsUseCase(params: _currentParams);
    
    result.fold(
      (error) => emit(CoursesError(message: error)),
      (courses) {
        _courses = courses;
        _hasReachedMax = courses.length < _currentParams.limit;
        _isInitialized = true; // Mark as initialized
        emit(CoursesLoaded(
          courses: _courses,
          hasReachedMax: _hasReachedMax,
        ));
      },
    );
  }


  Future<void> _onLoadMoreCourses(LoadMoreCourses event, Emitter<CoursesState> emit) async {
    if (_hasReachedMax) return;
    
    emit(CoursesLoading(courses: _courses));
    
    _currentParams = _currentParams.copyWith(page: _currentParams.page + 1);
    
    final result = await _getCourseOptionsUseCase(params: _currentParams);
    
    result.fold(
      (error) => emit(CoursesError(message: error)),
      (newCourses) {
        if (newCourses.isEmpty) {
          _hasReachedMax = true;
        } else {
          _courses.addAll(newCourses);
          _hasReachedMax = newCourses.length < _currentParams.limit;
        }
        
        emit(CoursesLoaded(
          courses: _courses,
          hasReachedMax: _hasReachedMax,
        ));
      },
    );
  }

  Future<void> _onRefreshCourses(RefreshCourses event, Emitter<CoursesState> emit) async {
    emit(CoursesLoading(courses: _courses));
    
    _currentParams = _currentParams.copyWith(page: 1);
    _hasReachedMax = false;
    
    final result = await _getCourseOptionsUseCase(params: _currentParams);
    
    result.fold(
      (error) => emit(CoursesError(message: error)),
      (courses) {
        _courses = courses;
        _hasReachedMax = courses.length < _currentParams.limit;
        emit(CoursesLoaded(
          courses: _courses,
          hasReachedMax: _hasReachedMax,
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
    _hasReachedMax = false;
    
    final result = await _getCourseOptionsUseCase(params: _currentParams);
    
    result.fold(
      (error) => emit(CoursesError(message: error)),
      (courses) {
        _courses = courses;
        _hasReachedMax = courses.length < _currentParams.limit;
        emit(CoursesLoaded(
          courses: _courses,
          hasReachedMax: _hasReachedMax,
        ));
      },
    );
  }

  Future<void> _onLoadCourseDetail(LoadCourseDetail event, Emitter<CoursesState> emit) async {
    emit(CourseDetailLoading());
    
    final result = await _getCourseDetailUseCase(params: event.courseId);
    
    result.fold(
      (error) => emit(CourseDetailError(message: error)),
      (course) => emit(CourseDetailLoaded(course: course)),
    );
  }

  // Future<void> _onToggleCourseStatus(ToggleCourseStatus event, Emitter<CoursesState> emit) async {
  //   final currentState = state;
    
  //   if (currentState is CourseDetailLoaded) {
  //     // Optimistic update
  //     final updatedCourse = currentState.course.copyWith(isActive: event.isActive);
  //     emit(CourseDetailLoaded(course: updatedCourse));
      
  //     final result = await _toggleCourseStatusUseCase(
  //       courseId: event.courseId,
  //       isActive: event.isActive,
  //     );
      
  //     result.fold(
  //       (error) {
  //         // Revert to original state on error
  //         emit(CourseDetailLoaded(course: currentState.course));
  //         emit(CourseDetailError(message: error));
  //         emit(CourseDetailLoaded(course: currentState.course));
  //       },
  //       (_) {
  //         // Update the course in the list as well
  //         final index = _courses.indexWhere((c) => c.id == event.courseId);
  //         if (index != -1) {
  //           _courses[index] = _courses[index].copyWith(isActive: event.isActive);
  //         }
  //       },
  //     );
  //   }
  // }

  // Future<void> _onDeleteCourse(DeleteCourse event, Emitter<CoursesState> emit) async {
  //   final result = await _deleteCourseUseCase(courseId: event.courseId);
    
  //   result.fold(
  //     (error) => emit(CoursesError(message: error)),
  //     (_) {
  //       // Remove the course from the list
  //       _courses.removeWhere((course) => course.id == event.courseId);
  //       emit(CoursesLoaded(
  //         courses: _courses,
  //         hasReachedMax: _hasReachedMax,
  //       ));
  //     },
  //   );
  // }
}
