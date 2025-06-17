// library_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/library/domain/usecases/get_enrolled_courses_ids.dart';
import 'package:user_app/features/library/domain/usecases/get_saved_courses_ids.dart';
import 'package:user_app/features/library/domain/usecases/get_user_courses.dart';
import 'package:user_app/features/library/domain/usecases/getsaved_usecase.dart';
import 'package:user_app/service_locator.dart';

part 'library_event.dart';
part 'library_state.dart';
class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryInitial()) {
    on<LoadSavedCoursesEvent>(_onLoadSavedCourses);
    on<LoadEnrolledCoursesEvent>(_onLoadEnrolledCourses);
    on<RefreshSavedCoursesEvent>(_onRefreshSavedCourses);
    on<RefreshEnrolledCoursesEvent>(_onRefreshEnrollCourses);
    on<SaveCourseEvent>(_onSaveCourse);
    on<EnrollCourseEvent>(_onEnrollCourse);
    on<UnSaveCourseEvent>(_onUnSaveCourse);
  }

  // ---------- LOAD ENROLLED COURSES ----------
  Future<void> _onLoadEnrolledCourses(
    LoadEnrolledCoursesEvent event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoading());

    final coursesResult = await serviceLocator<GetEnrolledCoursesUseCase>().call(params: event.userId);
    final idsResult = await serviceLocator<GetEnrolledCoursesIdsUseCase>().call(params: event.userId);

    coursesResult.fold(
      (error) => emit(LibraryError(message: error)),
      (enrolledCourses) {
        idsResult.fold(
          (idError) => emit(LibraryError(message: idError)),
          (enrolledIds) {
            final currentState = state;
            if (currentState is LibraryLoaded) {
              emit(LibraryLoaded(
                savedCourses: currentState.savedCourses,
                enrolledCourses: enrolledCourses,
                savedIds: currentState.savedIds,
                enrolledIds: enrolledIds,
              ));
            } else {
              emit(LibraryLoaded(
                savedCourses: [],
                enrolledCourses: enrolledCourses,
                savedIds: [],
                enrolledIds: enrolledIds,
              ));
            }
          },
        );
      },
    );
  }

  // ---------- REFRESH ENROLLED ----------
  Future<void> _onRefreshEnrollCourses(
    RefreshEnrolledCoursesEvent event,
    Emitter<LibraryState> emit,
  ) async {
    final coursesResult = await serviceLocator<GetEnrolledCoursesUseCase>().call(params: event.userId);
    final idsResult = await serviceLocator<GetEnrolledCoursesIdsUseCase>().call(params: event.userId);

    coursesResult.fold(
      (error) => emit(LibraryError(message: error)),
      (enrolledCourses) {
        idsResult.fold(
          (idError) => emit(LibraryError(message: idError)),
          (enrolledIds) {
            final currentState = state;
            if (currentState is LibraryLoaded) {
              emit(LibraryLoaded(
                savedCourses: currentState.savedCourses,
                enrolledCourses: enrolledCourses,
                savedIds: currentState.savedIds,
                enrolledIds: enrolledIds,
              ));
            } else {
              emit(LibraryLoaded(
                savedCourses: [],
                enrolledCourses: enrolledCourses,
                savedIds: [],
                enrolledIds: enrolledIds,
              ));
            }
          },
        );
      },
    );
  }

  // ---------- LOAD SAVED COURSES ----------
  Future<void> _onLoadSavedCourses(
    LoadSavedCoursesEvent event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoading());

    final coursesResult = await serviceLocator<GetSavedCoursesUseCase>().call(params: event.userId);
    final idsResult = await serviceLocator<GetSavedCoursesIdsUseCase>().call(params: event.userId);

    coursesResult.fold(
      (error) => emit(LibraryError(message: error)),
      (savedCourses) {
        idsResult.fold(
          (idError) => emit(LibraryError(message: idError)),
          (savedIds) {
            final currentState = state;
            if (currentState is LibraryLoaded) {
              emit(LibraryLoaded(
                savedCourses: savedCourses,
                enrolledCourses: currentState.enrolledCourses,
                savedIds: savedIds,
                enrolledIds: currentState.enrolledIds,
              ));
            } else {
              emit(LibraryLoaded(
                savedCourses: savedCourses,
                enrolledCourses: [],
                savedIds: savedIds,
                enrolledIds: [],
              ));
            }
          },
        );
      },
    );
  }

  // ---------- REFRESH SAVED ----------
  Future<void> _onRefreshSavedCourses(
    RefreshSavedCoursesEvent event,
    Emitter<LibraryState> emit,
  ) async {
    final coursesResult = await serviceLocator<GetSavedCoursesUseCase>().call(params: event.userId);
    final idsResult = await serviceLocator<GetSavedCoursesIdsUseCase>().call(params: event.userId);

    coursesResult.fold(
      (error) => emit(LibraryError(message: error)),
      (savedCourses) {
        idsResult.fold(
          (idError) => emit(LibraryError(message: idError)),
          (savedIds) {
            final currentState = state;
            if (currentState is LibraryLoaded) {
              emit(LibraryLoaded(
                savedCourses: savedCourses,
                enrolledCourses: currentState.enrolledCourses,
                savedIds: savedIds,
                enrolledIds: currentState.enrolledIds,
              ));
            } else {
              emit(LibraryLoaded(
                savedCourses: savedCourses,
                enrolledCourses: [],
                savedIds: savedIds,
                enrolledIds: [],
              ));
            }
          },
        );
      },
    );
  }

  // ---------- SAVE COURSE ----------
  void _onSaveCourse(
    SaveCourseEvent event,
    Emitter<LibraryState> emit,
  ) {
    if (state is LibraryLoaded) {
      final current = state as LibraryLoaded;

      final updatedSaved = List<CoursePreview>.from(current.savedCourses);
      final updatedSavedIds = List<String>.from(current.savedIds);

      if (!updatedSaved.any((c) => c.id == event.course.id)) {
        updatedSaved.add(event.course);
        updatedSavedIds.add(event.course.id);
      }

      emit(LibraryLoaded(
        savedCourses: updatedSaved,
        enrolledCourses: current.enrolledCourses,
        savedIds: updatedSavedIds,
        enrolledIds: current.enrolledIds,
      ));
    }
  }

  // ---------- ENROLL COURSE ----------
  void _onEnrollCourse(
    EnrollCourseEvent event,
    Emitter<LibraryState> emit,
  ) {
    if (state is LibraryLoaded) {
      final current = state as LibraryLoaded;

      final updatedEnrolled = List<CoursePreview>.from(current.enrolledCourses);
      final updatedEnrolledIds = List<String>.from(current.enrolledIds);

      if (!updatedEnrolled.any((c) => c.id == event.course.id)) {
        updatedEnrolled.add(event.course);
        updatedEnrolledIds.add(event.course.id);
      }

      emit(LibraryLoaded(
        savedCourses: current.savedCourses,
        enrolledCourses: updatedEnrolled,
        savedIds: current.savedIds,
        enrolledIds: updatedEnrolledIds,
      ));
    }
  }

  // ---------- UNSAVE COURSE ----------
  void _onUnSaveCourse(
    UnSaveCourseEvent event,
    Emitter<LibraryState> emit,
  ) {
    if (state is LibraryLoaded) {
      final current = state as LibraryLoaded;

      final updatedSaved = current.savedCourses.where((c) => c.id != event.course.id).toList();
      final updatedSavedIds = current.savedIds.where((id) => id != event.course.id).toList();

      emit(LibraryLoaded(
        savedCourses: updatedSaved,
        enrolledCourses: current.enrolledCourses,
        savedIds: updatedSavedIds,
        enrolledIds: current.enrolledIds,
      ));
    }
  }
}
