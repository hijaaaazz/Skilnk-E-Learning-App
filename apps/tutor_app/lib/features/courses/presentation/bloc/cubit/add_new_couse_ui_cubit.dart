import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/courses/data/models/course_creation_req.dart';
import 'package:tutor_app/features/courses/data/models/course_upload_progress.dart';
import 'package:tutor_app/features/courses/domain/entities/lecture_entity.dart';
import 'package:tutor_app/features/courses/domain/usecases/course_edit.dart';
import 'package:tutor_app/features/courses/domain/usecases/create_course.dart';
import 'package:tutor_app/features/courses/domain/usecases/get_course_options.dart';
import 'package:tutor_app/features/courses/presentation/bloc/course_bloc/courses_bloc.dart';
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
      log(state.isOptionsLoading.toString());
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

 Future<void> uploadCourse(String tutorId,BuildContext context) async {
  log("Started uploading course");

  try {
    final totalDuration = calculateTotalDuration(state.lessons);

    final courseReq = CourseCreationReq(
      title: state.title,
      description: state.description,
      categoryName: state.category?.title ?? "",
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
          emit(CourseUploadErrorState(error: error));
          // emit error state here if using BLoC or setState
        },
        (data) {
          data.fold(
            (progress) {
              log("Upload progress: $progress");
              emit(CourseUploadLoading(progress: progress,message: "Uploading"));
              
              // emit progress status here if needed
            },
            (course) {
              log("Course upload successful: ${course.title}");
              emit(CourseUploadSuccessStaete(course: course));
              context.read<CoursesBloc>().add(AddCourseEvent(course: course));
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

Future<void> uploadEditedCourse(BuildContext context) async {
  log("🚀 Started uploading course");

  try {
    final totalDuration = calculateTotalDuration(state.lessons);
    log("📏 Total Duration: ${totalDuration?.inSeconds}");

    log("🧠 Lessons Data:");
    for (var lesson in state.lessons) {
      log("""
      - Title: ${lesson.title}
      - Description: ${lesson.description}
      - Video URL: ${lesson.videoUrl}
      - Notes URL: ${lesson.notesUrl}
      - Duration: ${lesson.duration?.inSeconds}
      """);
    }

    log("🧾 Course Info:");
    log("Title: ${state.title}");
    log("Description: ${state.description}");
    log("Category ID: ${state.category?.id}");
    log("Category Name: ${state.category?.title}");
    log("Price: ${state.price}");
    log("Offer %: ${state.offer}");
    log("Language: ${state.language}");
    log("Level: ${state.level}");
    log("Thumbnail Path: ${state.thumbnailPath}");

    final courseReq = state.editingCourse!.copyWith(
      title: state.title,
      description: state.description,
      categoryId: state.category?.id,
      categoryName: state.category?.title,
      price: state.isPaid ? int.tryParse(state.price!) ?? 0 : 0,
      offerPercentage: state.offer,
      language: state.language,
      level: state.level,
      duration: totalDuration?.inSeconds,
      lessons: state.lessons.map((e) {
        return LectureEntity(
          title: e.title!,
          description: e.description ?? "",
          videoUrl: e.videoUrl!,
          notesUrl: e.notesUrl ?? "",
          durationInSeconds: e.duration!.inSeconds,
        );
      }).toList(),
      courseThumbnail: state.thumbnailPath,
    );

    emit(CourseUploadLoading(
      progress: UploadProgress.lecturesUploading,
      message: "Uploading...",
    ));

    final useCase = serviceLocator<UpdateCourseUseCase>();
    final result = await useCase(params: courseReq);

    result.fold(
  (error) {
    log("❌ Course upload failed: $error");
    if (!isClosed) {
      emit(CourseUploadErrorState(error: error));
    }
  },
  (course) {
    log("✅ Course upload successful: ${course.title}");
    if (!isClosed) {
      context.read<CoursesBloc>().add(UpdateCourseEvent(course: course));
      emit(CourseUploadSuccessStaete(course: course));
    }
  },
);

  } catch (e) {
  log("❗ Error uploading course: $e");
  if (!isClosed) {
    emit(CourseUploadErrorState(error: e.toString()));
  }
}

}



}