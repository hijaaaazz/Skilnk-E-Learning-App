
// FILE: course_repo.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/courses/data/models/course_creation_req.dart';
import 'package:tutor_app/features/courses/data/models/course_options_model.dart';
import 'package:tutor_app/features/courses/data/models/course_upload_progress.dart';
import 'package:tutor_app/features/courses/data/models/get_course_req.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';
import 'package:tutor_app/features/courses/data/src/cloudinary_services.dart';
import 'package:tutor_app/features/courses/data/src/firebase_services.dart';
import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/couse_preview.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/service_locator.dart';

class CoursesRepoImplementation extends CoursesRepository {
  @override
  Future<Either<String, CourseOptionsModel>> getCourseOptions() async {
    final result = await serviceLocator<CourseFirebaseService>().getCourseOptions();
    return result.fold(
      (l) {
        return left(l);
      },
      (r) {
        return right(r);
      },
    );
  }
  
  @override
  Future<Either<String, List<CategoryEntity>>> getCategories() async {
    final result = await serviceLocator<CourseFirebaseService>().getCategories();
    return result.fold(
      (l) => Left(l),
      (r) => Right(r.map((e) => e.toEntity()).toList()),
    );
  }

  @override
Stream<Either<String, Either<UploadProgress, CourseEntity>>> addNewCourse(CourseCreationReq req) async* {
  try {
    final cloudinaryService = serviceLocator<CourseCloudinaryServices>();
    String? updatedThumbnailUrl = req.courseThumbnail;
    List<LectureCreationReq> updatedLectures = [];

    yield Right(Left(UploadProgress.started));

    // Upload thumbnail
    if (req.courseThumbnail != null && req.courseThumbnail!.isNotEmpty) {
      final thumbnailResult = await cloudinaryService.uploadFile(req.courseThumbnail!);
      if (thumbnailResult.isLeft()) {
        yield Left("Failed to upload course thumbnail: ${thumbnailResult.fold((e) => e, (_) => "")}");
        return;
      }
      thumbnailResult.fold(
        (_) => null,
        (success) => updatedThumbnailUrl = success,
      );
      yield Right(Left(UploadProgress.thumbnailUploaded));
    }

    // Upload lectures
    if (req.lectures != null && req.lectures!.isNotEmpty) {
      yield Right(Left(UploadProgress.lecturesUploading));

      for (final lecture in req.lectures!) {
        String? videoUrl = lecture.videoUrl;
        String? notesUrl = lecture.notesUrl;

        if (lecture.videoUrl != null && lecture.videoUrl!.isNotEmpty) {
          final videoResult = await cloudinaryService.uploadFile(lecture.videoUrl!);
          if (videoResult.isLeft()) {
            yield Left("Failed to upload lecture video: ${videoResult.fold((e) => e, (_) => "")}");
            return;
          }
          videoResult.fold((_) => null, (success) => videoUrl = success);
        }

        if (lecture.notesUrl != null && lecture.notesUrl!.isNotEmpty) {
          final notesResult = await cloudinaryService.uploadFile(lecture.notesUrl!);
          if (notesResult.isLeft()) {
            yield Left("Failed to upload lecture notes: ${notesResult.fold((e) => e, (_) => "")}");
            return;
          }
          notesResult.fold((_) => null, (success) => notesUrl = success);
        }

        updatedLectures.add(lecture.copyWith(
          videoUrl: videoUrl,
          notesUrl: notesUrl,
        ));
      }

      yield Right(Left(UploadProgress.lecturesUploaded));
    }

    // Final Firebase creation
    var updatedReq = req.copyWith(
      lectures: updatedLectures,
      courseThumbnail: updatedThumbnailUrl,
    );

    final result = await serviceLocator<CourseFirebaseService>().createCourse(updatedReq);

    yield result.fold(
      (l) => Left(l),
      (r) => Right(Right(r.toEntity())),
    );

    yield Right(Left(UploadProgress.courseUploaded)); // Optional final yield
  } catch (e) {
    log("Repository error: ${e.toString()}");
    yield Left("Repository error: ${e.toString()}");
  }
}

  
  @override
  Future<Either<String, List<CoursePreview>>> getCourses({required CourseParams params})async {
    @override
  
    final result = await serviceLocator<CourseFirebaseService>().getCourses(params:  params);
    return result.fold(
      (l) {
        return left(l);
      },
      (r) {
        return right(r);
      },
    );
  
  }
  
  @override
Future<Either<String, CourseEntity>> getCourseDetails({required String courseId}) async {
  final result = await serviceLocator<CourseFirebaseService>().getCourseDetails(courseId: courseId);

  return result.fold(
    (l) => Left(l),
    (r) => Right(r.toEntity()),
  );
}

}