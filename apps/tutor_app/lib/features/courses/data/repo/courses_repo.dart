
// FILE: course_repo.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/courses/data/models/course_creation_req.dart';
import 'package:tutor_app/features/courses/data/models/course_options_model.dart';
import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';
import 'package:tutor_app/features/courses/data/src/cloudinary_services.dart';
import 'package:tutor_app/features/courses/data/src/firebase_services.dart';
import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
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
  Future<Either<String, CourseEntity>> addNewCourse(CourseCreationReq req) async {
    try {
      // Initialize CloudinaryService
      final cloudinaryService = serviceLocator<CourseCloudinaryServices>();
      
      // Create a new request with updated URLs
      String? updatedThumbnailUrl = req.courseThumbnail;
      List<LectureCreationReq> updatedLectures = [];
      
      // Upload course thumbnail if provided
      if (req.courseThumbnail != null && req.courseThumbnail!.isNotEmpty) {
        final thumbnailResult = await cloudinaryService.uploadFile(req.courseThumbnail!);
        if (thumbnailResult.isLeft()) {
          return Left("Failed to upload course thumbnail: ${thumbnailResult.fold(
            (error) => error,
            (success) => "",
          )}");
        }
        
        thumbnailResult.fold(
          (error) => null,
          (success) => updatedThumbnailUrl = success,
        );
      }
      
      // Upload lecture files and create updated lectures list
      if (req.lectures != null && req.lectures!.isNotEmpty) {
        for (final lecture in req.lectures!) {
          String? videoUrl = lecture.videoUrl;
          String? notesUrl = lecture.notesUrl;
          
          // Upload video if provided
          if (lecture.videoUrl != null && lecture.videoUrl!.isNotEmpty) {
            final videoResult = await cloudinaryService.uploadFile(lecture.videoUrl!);
            if (videoResult.isLeft()) {
              return Left("Failed to upload lecture video: ${videoResult.fold(
                (error) => error,
                (success) => "",
              )}");
            }
            
            videoResult.fold(
              (error) => null,
              (success) => videoUrl = success,
            );
          }
          
          // Upload PDF notes if provided
          if (lecture.notesUrl != null && lecture.notesUrl!.isNotEmpty) {
            final notesResult = await cloudinaryService.uploadFile(lecture.notesUrl!);
            if (notesResult.isLeft()) {
              return Left("Failed to upload lecture notes: ${notesResult.fold(
                (error) => error,
                (success) => "",
              )}");
            }
            
            notesResult.fold(
              (error) => null,
              (success) => notesUrl = success,
            );
          }
          
          // Create updated lecture with new URLs
          updatedLectures.add(lecture.copyWith(
            videoUrl: videoUrl,
            notesUrl: notesUrl,
          ));
        }
      }
      
      // Create a new CourseCreationReq with updated URLs
      var updatedReq = CourseCreationReq(
        title: req.title,
        description: req.description,
        categoryId: req.categoryId,
        price: req.price,
        offerPercentage: req.offerPercentage,
        tutorId: req.tutorId,
        level: req.level,
        duration: req.duration,
        isPaid: req.isPaid,
        language: req.language,
        lectures: updatedLectures,
        courseThumbnail: updatedThumbnailUrl,
      );
      
      // Now call the Firebase service with the updated request
      final result = await serviceLocator<CourseFirebaseService>().createCourse(updatedReq);
      return result.fold(
        (l) => Left(l),
        (r) => Right(r.toEntity()),
      );
    } catch (e) {
      log("Repository error: ${e.toString()}");
      return Left("Repository error: ${e.toString()}");
    }
  }
  
  @override
  Future<Either<String, List<CourseEntity>>> getCourses() {
    // TODO: implement getCourses
    throw UnimplementedError();
  }
}