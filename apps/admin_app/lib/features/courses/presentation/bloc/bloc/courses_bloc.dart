import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/courses/data/models/course_model.dart';
import 'package:admin_app/features/courses/domain/usecases/ban_course.dart';
import 'package:admin_app/features/courses/domain/usecases/get_courses.dart';
import 'package:admin_app/service_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'courses_event.dart';
part 'courses_state.dart';
class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final GetCoursesUsecase _getCoursesUsecase = serviceLocator<GetCoursesUsecase>();
  final BanCourseUsecase _banCourseUsecase = serviceLocator<BanCourseUsecase>();

  CoursesBloc() : super(CoursesInitial()) {
    on<FetchCourses>(_onFetchCourses);
    on<BanCourse>(_onBanCourse);
  }


  Future<void> _onFetchCourses(FetchCourses event, Emitter<CoursesState> emit) async {
    emit(CoursesLoading());

    final result = await _getCoursesUsecase.call(params: NoParams());

    result.fold(
      (failure) => emit(CoursesError(failure)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }


   Future<void> _onBanCourse(BanCourse event, Emitter<CoursesState> emit) async {
  final currentState = state;

  if (currentState is CoursesLoaded) {
    final oldCourses = currentState.courses;
    emit(CoursesLoading());

    final result = await _banCourseUsecase.call(params: event.courseId);

    result.fold(
      (failure) => emit(CoursesError(failure)),
      (newIsBanned) {
        final updatedCourses = oldCourses.map((course) {
          if (course.id == event.courseId) {
            return course.copyWith(isBanned: newIsBanned);
          }
          return course;
        }).toList();

        emit(CoursesLoaded(updatedCourses));
      },
    );
  }
}

}
