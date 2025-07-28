// FILE: course_repo.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/courses/data/models/course_creation_req.dart';
import 'package:tutor_app/features/courses/data/models/course_model.dart';
import 'package:tutor_app/features/courses/data/models/course_options_model.dart';
import 'package:tutor_app/features/courses/data/models/course_upload_progress.dart';
import 'package:tutor_app/features/courses/data/models/get_course_req.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';
import 'package:tutor_app/features/courses/data/models/lecture_model.dart';
import 'package:tutor_app/features/courses/data/models/review_model.dart';
import 'package:tutor_app/features/courses/data/models/toggle_params.dart';
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


Stream<Either<String, Either<UploadProgress, CourseEntity>>> addNewCourse(CourseCreationReq req) async* {
  try {
    final cloudinaryService = serviceLocator<CourseCloudinaryServices>();
    final firebaseService = serviceLocator<CourseFirebaseService>();
    String? updatedThumbnailUrl = req.courseThumbnail;
    List<LectureCreationReq> updatedLectures = [];

    log("Starting course creation: title=${req.title}, tutorId=${req.tutorId}");

    yield Right(Left(UploadProgress.started));

    // Upload thumbnail
    if (req.courseThumbnail != null && req.courseThumbnail!.isNotEmpty) {
      log("Uploading thumbnail: ${req.courseThumbnail}");
      final thumbnailResult = await cloudinaryService.uploadFile(req.courseThumbnail!, req.title!, req.tutorId!);
      if (thumbnailResult.isLeft()) {
        final error = thumbnailResult.fold((e) => e, (_) => "");
        log("Thumbnail upload failed: $error");
        yield Left("Failed to upload course thumbnail: $error");
        return;
      }
      updatedThumbnailUrl = thumbnailResult.fold((_) => null, (success) => success);
      log("Thumbnail uploaded: $updatedThumbnailUrl");
      yield Right(Left(UploadProgress.thumbnailUploaded));
    } else {
      log("No thumbnail provided");
    }

    // Upload lectures
    if (req.lectures != null && req.lectures!.isNotEmpty) {
      log("Uploading ${req.lectures!.length} lectures");
      yield Right(Left(UploadProgress.lecturesUploading));

      for (final lecture in req.lectures!) {
        String? videoUrl = lecture.videoUrl;
        String? notesUrl = lecture.notesUrl;

        if (lecture.videoUrl != null && lecture.videoUrl!.isNotEmpty) {
          log("Uploading video for lecture '${lecture.title}': ${lecture.videoUrl}");
          final videoResult = await cloudinaryService.uploadFile(lecture.videoUrl!, req.title!, req.tutorId!);
          if (videoResult.isLeft()) {
            final error = videoResult.fold((e) => e, (_) => "");
            log("Video upload failed for '${lecture.title}': $error");
            yield Left("Failed to upload lecture video for '${lecture.title}': $error");
            return;
          }
          videoUrl = videoResult.fold((_) => null, (success) => success);
          log("Video uploaded for '${lecture.title}': $videoUrl");
        }

        if (lecture.notesUrl != null && lecture.notesUrl!.isNotEmpty) {
          log("Uploading notes for lecture '${lecture.title}': ${lecture.notesUrl}");
          final notesResult = await cloudinaryService.uploadFile(lecture.notesUrl!, req.title!, req.tutorId!);
          if (notesResult.isLeft()) {
            final error = notesResult.fold((e) => e, (_) => "");
            log("Notes upload failed for '${lecture.title}': $error");
            // Don't fail for notes, just log
            notesUrl = null;
          } else {
            notesUrl = notesResult.fold((_) => null, (success) => success);
            log("Notes uploaded for '${lecture.title}': $notesUrl");
          }
        }

        updatedLectures.add(lecture.copyWith(
          videoUrl: videoUrl,
          notesUrl: notesUrl,
        ));
      }

      yield Right(Left(UploadProgress.lecturesUploaded));
    } else {
      log("No lectures provided");
      yield Left("At least one lecture is required");
      return;
    }

    // Final Firebase creation
    log("Creating course in Firebase with thumbnail: $updatedThumbnailUrl, lectures: ${updatedLectures.length}");
    var updatedReq = req.copyWith(
      lectures: updatedLectures,
      courseThumbnail: updatedThumbnailUrl,
    );

    final result = await firebaseService.createCourse(updatedReq);

    if (result.isRight()) {
      final courseModel = result.fold((_) => null, (r) => r);
      if (courseModel != null && courseModel.categoryId.isNotEmpty) {
        log("Updating category and tutor course list");
        await firebaseService.updateCategoryWithCourse(
          categoryId: courseModel.categoryId,
          courseId: courseModel.id,
        );

        final saveResult = await firebaseService.saveCourseForUser(
          userId: req.tutorId!,
          courseId: courseModel.id,
        );

        if (saveResult.isLeft()) {
          log("Failed to save course for tutor: ${saveResult.fold((l) => l, (_) => "")}");
        } else {
          log("Course saved for tutor: ${req.tutorId}");
        }
      }
      yield Right(Right(courseModel!.toEntity()));
    } else {
      final error = result.fold((l) => l, (_) => "");
      log("Firebase course creation failed: $error");
      yield Left(error);
    }

    yield Right(Left(UploadProgress.courseUploaded));
  } catch (e) {
    log("Repository error: $e");
    yield Left("Repository error: $e");
  }
}


  @override
  Future<Either<String, List<CoursePreview>>> getCourses({required CourseParams params}) async {
    final result = await serviceLocator<CourseFirebaseService>().getCourses(params: params);
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

  @override
  Future<Either<String, bool>> deleteCourse({required String courseId}) async {
    // First get the course details to know which category to update
    final courseDetails = await serviceLocator<CourseFirebaseService>().getCourseDetails(courseId: courseId);
    
    if (courseDetails.isRight()) {
      final course = courseDetails.fold((_) => null, (r) => r);
      if (course != null && course.categoryId.isNotEmpty) {
        // Remove the course ID from the category
        await serviceLocator<CourseFirebaseService>().removeCourseFromCategory(
          categoryId: course.categoryId,
          courseId: courseId,
        );
      }
    }
    
    final result = await serviceLocator<CourseFirebaseService>().deleteCourse(courseId);

    return result.fold(
      (l) => Left(l),
      (r) => Right(r));
  }
  
  @override
  Stream<Either<String, Either<UploadProgress, CourseEntity>>> updateCourse({required CourseEntity course}) async* {
    try {
      log("updateion happening hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
      log(course.lessons.map((e) => e.notesUrl).toList().toString());

      final cloudinaryService = serviceLocator<CourseCloudinaryServices>();
      final firebaseService = serviceLocator<CourseFirebaseService>();
      String? updatedThumbnailUrl = course.courseThumbnail;
      final courseModel = CourseModel.fromEntity(course);
      List<LectureModel> updatedLectures = [];
      String? oldCategoryId;

      yield Right(Left(UploadProgress.started));

      // Get current course details to check if category changed
      if (course.id.isNotEmpty) {
        final currentCourse = await firebaseService.getCourseDetails(courseId: course.id);
        if (currentCourse.isRight()) {
          oldCategoryId = currentCourse.fold((_) => null, (r) => r.categoryId);
        }
      }

      // Upload course thumbnail if it's a local file
      if (course.courseThumbnail.isNotEmpty &&
          !course.courseThumbnail.startsWith('http')) {
        final thumbnailResult = await cloudinaryService.uploadFile(course.courseThumbnail,course.title,course.tutorId);
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

      // Upload lecture files if any
      if (course.lessons.isNotEmpty) {
        yield Right(Left(UploadProgress.lecturesUploading));

        for (final lecture in course.lessons) {
          String? videoUrl = lecture.videoUrl;
          String? notesUrl = lecture.notesUrl;

          // Upload video
          if (lecture.videoUrl.isNotEmpty &&
              !lecture.videoUrl.startsWith('http')) {
            final videoResult = await cloudinaryService.uploadFile(lecture.videoUrl,course.title,course.tutorId);
            if (videoResult.isLeft()) {
              yield Left("Failed to upload lecture video: ${videoResult.fold((e) => e, (_) => "")}");
              return;
            }
            videoResult.fold((_) => null, (success) => videoUrl = success);
          }

          // Upload notes
          if (lecture.notesUrl.isNotEmpty &&
              !lecture.notesUrl.startsWith('http')) {
            final notesResult = await cloudinaryService.uploadFile(lecture.notesUrl,course.title,course.tutorId);
            if (notesResult.isLeft()) {
              yield Left("Failed to upload lecture notes: ${notesResult.fold((e) => e, (_) => "")}");
              return;
            }
            notesResult.fold((_) => null, (success) => notesUrl = success);
          }

          // Add updated lecture
          updatedLectures.add(
            LectureModel(
              title: lecture.title,
              description: lecture.description,
              videoUrl: videoUrl ?? '',
              notesUrl: notesUrl ?? '',
              durationInSeconds: lecture.durationInSeconds,
            ),
          );
        }

        yield Right(Left(UploadProgress.lecturesUploaded));
      }

      // Create updated course model
      final updatedCourseModel = courseModel.copyWith(
        courseThumbnail: updatedThumbnailUrl,
        lessons: updatedLectures.isEmpty ? courseModel.lessons : updatedLectures,
      );

      // Update course in Firebase
      final result = await firebaseService.updateCourse(updatedCourseModel);

      // Handle category updates if course was updated successfully
      if (result.isRight()) {
        final updatedCourse = result.fold((_) => null, (r) => r);
        if (updatedCourse != null) {
          // If category changed, update both old and new categories
          if (oldCategoryId != null && 
              oldCategoryId != updatedCourse.categoryId && 
              oldCategoryId.isNotEmpty) {
            // Remove course from old category
            await firebaseService.removeCourseFromCategory(
              categoryId: oldCategoryId,
              courseId: updatedCourse.id,
            );
          }
          
          // Add to new category if needed
          if (updatedCourse.categoryId.isNotEmpty) {
            await firebaseService.updateCategoryWithCourse(
              categoryId: updatedCourse.categoryId,
              courseId: updatedCourse.id,
            );
          }
        }
      }

      yield result.fold(
        (error) => Left(error),
        (updated) => Right(Right(updated.toEntity())),
      );

      yield Right(Left(UploadProgress.courseUploaded));
    } catch (e) {
      log("Repository update error: ${e.toString()}");
      yield Left("Repository update error: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, bool>> toggleActivationCourse({required courseToggleParams isactive}) async{
   final result = await serviceLocator<CourseFirebaseService>().activateToggleCourse(isactive);
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
  Future<Either<String, List<ReviewModel>>> getReviews({required List<String> reviewIds})async{
   final result = await serviceLocator<CourseFirebaseService>().getReviews(reviewIds);
    return result.fold(
      (l) {
        return left(l);
      },
      (r) {
        return right(r);
      },
    );
  }
}