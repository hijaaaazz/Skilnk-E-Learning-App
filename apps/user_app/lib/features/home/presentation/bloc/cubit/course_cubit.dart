import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_app/features/home/domain/usecases/get_course_details.dart';
import 'package:user_app/features/home/presentation/bloc/cubit/course_state.dart';
import 'package:user_app/service_locator.dart';


class CourseCubit extends Cubit<CourseState> {
  CourseCubit() : super(CourseInitial());

  Future<void> fetchCourseDetails(String courseId) async {
    emit(CourseDetailsLoadingState());

    final result = await serviceLocator<GetCourseDetailsUseCase>().call(params: courseId);

    result.fold(
      (failure) => emit(CourseDetailsErrorState(errorMessage: failure)),
      (course) => emit(CourseDetailsLoadedState(coursedetails: course)),
    );
  }
}
