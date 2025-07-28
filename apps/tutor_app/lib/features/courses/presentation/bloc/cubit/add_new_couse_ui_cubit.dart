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
import 'package:flutter/foundation.dart';
import 'dart:convert' show base64Decode;

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
    log("Loading course options: ${state.isOptionsLoading}");
    final result = await serviceLocator<GetCourseOptionsUseCase>().call(params: NoParams());

    result.fold(
      (error) {
        log("Failed to load course options: $error");
        emit(state.copyWith(
          isOptionsLoading: false,
          optionsError: error.toString(),
        ));
      },
      (data) {
        log("Course options loaded: ${data.toString()}");
        emit(state.copyWith(
          isOptionsLoading: false,
          options: data,
        ));
      },
    );
  }

  Future<void> uploadCourse(String tutorId, BuildContext context) async {
  log("Started uploading course for tutorId: $tutorId");

  try {
    // Validate before uploading
    if (!validateBasicInfo(context)) {
      log("Basic info validation failed");
      return; // Error snackbar is shown in validateBasicInfo
    }
    if (!validateAdvancedInfo(context)) {
      log("Advanced info validation failed");
      emit(CourseUploadErrorState(error: "Invalid thumbnail or description"));
      return;
    }
    if (!validateCurriculum(context)) {
      log("Curriculum validation failed");
      emit(CourseUploadErrorState(error: "Invalid curriculum data"));
      return;
    }

    final totalDuration = calculateTotalDuration(state.lessons);
    log("Total duration: ${totalDuration?.inSeconds} seconds");

    // Log course data
    log("Course data: title=${state.title}, description=${state.description}, "
        "category=${state.category?.title}, isPaid=${state.isPaid}, "
        "price=${state.price}, offer=${state.offer}, language=${state.language}, "
        "level=${state.level}, thumbnail=${state.thumbnailPath}, "
        "lessons=${state.lessons.length}");

    // Prepare course request
    final courseReq = CourseCreationReq(
      title: state.title,
      description: state.description,
      categoryName: state.category?.title ?? "",
      categoryId: state.category?.id,
      isPaid: state.isPaid,
      price: state.isPaid ? state.price : "",
      offerPercentage: state.offer,
      language: state.language,
      level: state.level,
      duration: totalDuration,
      lectures: state.lessons,
      tutorId: tutorId,
      courseThumbnail: state.thumbnailPath,
    );

    if (kIsWeb) {
      log("Web: Validating Base64 data for upload");
      if (state.thumbnailPath.startsWith('data:image/')) {
        try {
          final base64String = state.thumbnailPath.split(',').last;
          final thumbnailBytes = base64Decode(base64String);
          log("Thumbnail Base64 decoded, bytes length: ${thumbnailBytes.length}");
        } catch (e) {
          log("Error decoding thumbnail Base64: $e");
          emit(CourseUploadErrorState(error: "Invalid thumbnail data"));
          return;
        }
      }
      for (var lecture in state.lessons) {
        if (lecture.videoUrl != null && lecture.videoUrl!.startsWith('data:video/')) {
          try {
            final base64String = lecture.videoUrl!.split(',').last;
            final videoBytes = base64Decode(base64String);
            log("Lecture '${lecture.title}' video bytes length: ${videoBytes.length}");
          } catch (e) {
            log("Error decoding video Base64 for lecture '${lecture.title}': $e");
            emit(CourseUploadErrorState(error: "Invalid video data for lecture '${lecture.title}'"));
            return;
          }
        }
        if (lecture.notesUrl != null && lecture.notesUrl!.startsWith('data:application/pdf')) {
          try {
            final base64String = lecture.notesUrl!.split(',').last;
            final pdfBytes = base64Decode(base64String);
            log("Lecture '${lecture.title}' PDF bytes length: ${pdfBytes.length}");
          } catch (e) {
            log("Error decoding PDF Base64 for lecture '${lecture.title}': $e");
            // Don't fail for notes
          }
        }
      }
    }

    final stream = serviceLocator<CreateCourseUseCase>().call(params: courseReq);

    await for (final result in stream) {
      result.fold(
        (error) {
          log("Course upload failed: $error");
          emit(CourseUploadErrorState(error: error));
        },
        (data) {
          data.fold(
            (progress) {
              log("Upload progress: ${progress.toString()}");
              emit(CourseUploadLoading(
                progress: progress,
                message: "Uploading",
              ));
            },
            (course) {
              log("Course upload successful: ${course.title}");
              emit(CourseUploadSuccessStaete(course: course)); // Fixed typo
              context.read<CoursesBloc>().add(AddCourseEvent(course: course));
            },
          );
        },
      );
    }
  } catch (e) {
    log("Error uploading course: $e");
    emit(CourseUploadErrorState(error: e.toString()));
  }
}

  Future<void> uploadEditedCourse(BuildContext context) async {
    log("Started uploading edited course");

    try {
      // Validate before uploading
      if (!validateBasicInfo(context)) {
        log("Basic info validation failed");
        emit(CourseUploadErrorState(error: "Invalid basic course information"));
        return;
      }
      if (!validateAdvancedInfo(context)) {
        log("Advanced info validation failed");
        emit(CourseUploadErrorState(error: "Invalid thumbnail or description"));
        return;
      }
      if (!validateCurriculum(context)) {
        log("Curriculum validation failed");
        emit(CourseUploadErrorState(error: "Invalid curriculum data"));
        return;
      }

      final totalDuration = calculateTotalDuration(state.lessons);
      log("Total Duration: ${totalDuration?.inSeconds} seconds");

      log("Lessons Data:");
      for (var lesson in state.lessons) {
        log("""
        - Title: ${lesson.title}
        - Description: ${lesson.description}
        - Video URL: ${lesson.videoUrl}
        - Notes URL: ${lesson.notesUrl}
        - Duration: ${lesson.duration?.inSeconds}
        """);
      }

      log("Course Info:");
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
            durationInSeconds: e.duration?.inSeconds ?? 0, // Fallback to 0 if null
          );
        }).toList(),
        courseThumbnail: state.thumbnailPath,
      );

      // For web, validate Base64 data
      if (kIsWeb) {
        if (courseReq.courseThumbnail.startsWith('data:image/')) {
          try {
            final base64String = courseReq.courseThumbnail.split(',').last;
            final thumbnailBytes = base64Decode(base64String);
            log("Thumbnail Base64 decoded, bytes length: ${thumbnailBytes.length}");
          } catch (e) {
            log("Error decoding thumbnail Base64: $e");
            emit(CourseUploadErrorState(error: "Invalid thumbnail data"));
            return;
          }
        }
        for (var lecture in courseReq.lessons) {
          if (lecture.videoUrl.startsWith('data:video/')) {
            try {
              final base64String = lecture.videoUrl.split(',').last;
              final videoBytes = base64Decode(base64String);
              log("Lecture '${lecture.title}' video bytes length: ${videoBytes.length}");
            } catch (e) {
              log("Error decoding video Base64 for lecture '${lecture.title}': $e");
              emit(CourseUploadErrorState(error: "Invalid video data for lecture '${lecture.title}'"));
              return;
            }
          }
          if (lecture.notesUrl.isNotEmpty && lecture.notesUrl.startsWith('data:application/pdf')) {
            try {
              final base64String = lecture.notesUrl.split(',').last;
              final pdfBytes = base64Decode(base64String);
              log("Lecture '${lecture.title}' PDF bytes length: ${pdfBytes.length}");
            } catch (e) {
              log("Error decoding PDF Base64 for lecture '${lecture.title}': $e");
              // Don't fail for notes
            }
          }
        }
      }

      emit(CourseUploadLoading(
        progress: UploadProgress.lecturesUploading,
        message: "Uploading...",
      ));

      final useCase = serviceLocator<UpdateCourseUseCase>();
      final result = await useCase(params: courseReq);

      result.fold(
        (error) {
          log("Course upload failed: $error");
          if (!isClosed) {
            emit(CourseUploadErrorState(error: error.toString()));
          }
        },
        (course) {
          log("Course upload successful: ${course.title}");
          if (!isClosed) {
            context.read<CoursesBloc>().add(UpdateCourseEvent(course: course));
            emit(CourseUploadSuccessStaete(course: course));
          }
        },
      );
    } catch (e) {
      log("Error uploading course: $e");
      if (!isClosed) {
        emit(CourseUploadErrorState(error: e.toString()));
      }
    }
  }
}