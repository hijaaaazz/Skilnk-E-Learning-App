import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/courses/data/models/course_creation_req.dart';
import 'package:tutor_app/features/courses/domain/usecases/create_course.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_course_options.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/add_new_couse_ui_state.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/extentions/course_info.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/extentions/file_selection.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/extentions/lecture_management.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/extentions/util_handlers.dart';
import 'package:tutor_app/features/courses/presentation/bloc/cubit/extentions/validation.dart';
import 'package:tutor_app/service_locator.dart';


class AddCourseCubit extends Cubit<AddCourseState>
    with
        CourseInfoHandlers,
        LectureManagementHandlers,
        FileSelectionHandlers,
        ValidationHandlers,
        UtilityHandlers {
  AddCourseCubit() : super(const AddCourseState());

  Future<void> loadCourseOptions() async {
    emit(state.copyWith(isOptionsLoading: true, optionsError: null));

    final result = await serviceLocator<GetCourseOptionsUseCase>().call(params: NoParams());

    result.fold(
      (error) {
        emit(state.copyWith(
          isOptionsLoading: false,
          optionsError: error,
        ));
      },
      (data) {
        emit(state.copyWith(
          isOptionsLoading: false,
          options: data,
        ));
      },
    );
  }

 Future<void> uploadCourse(String tutorId) async {
  log("Started uploading course");

  try {
    final totalDuration = calculateTotalDuration(state.lessons);

    final courseReq = CourseCreationReq(
      title: state.title,
      description: state.description,
      isPaid: state.isPaid,
      offerPercentage: state.offer,
      categoryId: state.category?.id,
      price: state.isPaid ? state.price : "",
      language: state.language,
      level: state.level,
      duration: totalDuration,
      lectures: state.lessons,
      tutorId: tutorId,
      courseThumbnail: state.thumbnailPath,
    );

    final stream = serviceLocator<CreateCourseUseCase>().call(params: courseReq);

    await for (final result in stream) {
      result.fold(
        (error) {
          log("Course upload failed: $error");
          // emit error state here if using BLoC or setState
        },
        (data) {
          data.fold(
            (progress) {
              log("Upload progress: $progress");
              // emit progress status here if needed
            },
            (course) {
              log("Course upload successful: ${course.title}");
              // emit success state here
            },
          );
        },
      );
    }
  } catch (e) {
    log("Error uploading course: $e");
  }
}

}