// library_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
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

  Future<void> _onLoadEnrolledCourses(
    LoadEnrolledCoursesEvent event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoading());

    final result = await serviceLocator<GetEnrolledCoursesUseCase>().call(params: event.userId);

    result.fold(
      (error) => emit(LibraryError(message: error)),
      (enrolledCourses) {
        final currentState = state;
        if (currentState is LibraryLoaded) {
          emit(LibraryLoaded(
            savedCourses: currentState.savedCourses,
            enrolledCourses: enrolledCourses,
          ));
        } else {
          emit(LibraryLoaded(
            savedCourses: [],
            enrolledCourses: enrolledCourses,
          ));
        }
      },
    );
  }

  Future<void> _onRefreshEnrollCourses(
    RefreshEnrolledCoursesEvent event,
    Emitter<LibraryState> emit,
  ) async {
    final result = await serviceLocator<GetEnrolledCoursesUseCase>().call(params: event.userId);

    result.fold(
      (error) => emit(LibraryError(message: error)),
      (enrolledCourses) {
        final currentState = state;
        if (currentState is LibraryLoaded) {
          emit(LibraryLoaded(
            savedCourses: currentState.savedCourses,
            enrolledCourses: enrolledCourses,
          ));
        } else {
          emit(LibraryLoaded(
            savedCourses: [],
            enrolledCourses: enrolledCourses,
          ));
        }
      },
    );
  }

  void _onEnrollCourse(
    EnrollCourseEvent event,
    Emitter<LibraryState> emit,
  ) {
    if (state is LibraryLoaded) {
      final current = state as LibraryLoaded;
      final updatedEnrolled = List<CoursePreview>.from(current.enrolledCourses);

      if (!updatedEnrolled.any((c) => c.id == event.course.id)) {
        updatedEnrolled.add(event.course);
      }

      emit(LibraryLoaded(
        savedCourses: current.savedCourses,
        enrolledCourses: updatedEnrolled,
      ));
    }
  }

  Future<void> _onLoadSavedCourses(
    LoadSavedCoursesEvent event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoading());

    final result = await serviceLocator<GetSavedCoursesUseCase>().call(params: event.userId);

    result.fold(
      (error) => emit(LibraryError(message: error)),
      (savedCourses) {
        final currentState = state;
        if (currentState is LibraryLoaded) {
          emit(LibraryLoaded(
            savedCourses: savedCourses,
            enrolledCourses: currentState.enrolledCourses,
          ));
        } else {
          emit(LibraryLoaded(
            savedCourses: savedCourses,
            enrolledCourses: [],
          ));
        }
      },
    );
  }

  Future<void> _onRefreshSavedCourses(
    RefreshSavedCoursesEvent event,
    Emitter<LibraryState> emit,
  ) async {
    final result = await serviceLocator<GetSavedCoursesUseCase>().call(params: event.userId);

    result.fold(
      (error) => emit(LibraryError(message: error)),
      (savedCourses) {
        final currentState = state;
        if (currentState is LibraryLoaded) {
          emit(LibraryLoaded(
            savedCourses: savedCourses,
            enrolledCourses: currentState.enrolledCourses,
          ));
        } else {
          emit(LibraryLoaded(
            savedCourses: savedCourses,
            enrolledCourses: [],
          ));
        }
      },
    );
  }

  void _onSaveCourse(
    SaveCourseEvent event,
    Emitter<LibraryState> emit,
  ) {
    if (state is LibraryLoaded) {
      final current = state as LibraryLoaded;
      final updatedSaved = List<CoursePreview>.from(current.savedCourses);

      if (!updatedSaved.any((c) => c.id == event.course.id)) {
        updatedSaved.add(event.course);
      }

      emit(LibraryLoaded(
        savedCourses: updatedSaved,
        enrolledCourses: current.enrolledCourses,
      ));
    }
  }

  void _onUnSaveCourse(
    UnSaveCourseEvent event,
    Emitter<LibraryState> emit,
  ) {
    if (state is LibraryLoaded) {
      final current = state as LibraryLoaded;
      final updatedSaved = current.savedCourses.where((c) => c.id != event.course.id).toList();

      emit(LibraryLoaded(
        savedCourses: updatedSaved,
        enrolledCourses: current.enrolledCourses,
      ));
    }
  }
}
