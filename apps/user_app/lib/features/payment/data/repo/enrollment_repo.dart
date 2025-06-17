import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/data/models/course_progress.dart';
import 'package:user_app/features/home/data/models/getcourse_details_params.dart';
import 'package:user_app/features/home/data/models/lecture_model.dart';
import 'package:user_app/features/home/data/models/lecture_progress_model.dart';
import 'package:user_app/features/home/data/src/course_progress_service.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/features/payment/data/models/add_purchase_params.dart';
import 'package:user_app/features/payment/data/src/enrollment_firebase_service.dart';
import 'package:user_app/features/payment/domain/repo/enrollment_repo.dart';
import 'package:user_app/service_locator.dart';

class EnrollmentRepositoryImp extends EnrollmentRepository {
  EnrollmentRepositoryImp();

  @override
  Future<Either<String, CourseEntity>> enrollCourse(AddPurchaseParams params) async {
    try {
      log('[EnrollmentRepo] Starting enrollment process for course: ${params.courseId}');
      
      // Validate params
      if (params.courseId.isEmpty || params.userId.isEmpty || params.tutorId.isEmpty) {
        return Left("Invalid parameters: courseId, userId, and tutorId are required");
      }

      // Add purchase to Firestore first
      log('[EnrollmentRepo] Adding purchase to Firestore');
      await serviceLocator<EnrollmentFirebaseService>().addPurchase(
        courseId: params.courseId,
        userId: params.userId,
        tutorId: params.tutorId,
        amount: params.amount,
        purchaseId: params.purchaseId,
      );
      log('[EnrollmentRepo] Purchase added successfully');

      // Now use the existing course repository to get course details with mentor
      log('[EnrollmentRepo] Fetching course details using course repository');
      final courseDetailsParams = GetCourseDetailsParams(
        courseId: params.courseId,
        userId: params.userId, // This will ensure saved/enrolled status is checked
      );

      final courseResult = await serviceLocator<CoursesRepository>()
    .getCoursedetails(courseDetailsParams);

      return await courseResult.fold(
        (error) {
          log('[EnrollmentRepo] Error fetching course details: $error');
          return Left("Failed to fetch course details: $error");
        },
        (courseEntity) async {
          log('[EnrollmentRepo] Course details fetched successfully');

          await serviceLocator<CourseProgressService>().createCourseProgress(
            initialprogress: CourseProgressModel(
              id: "",
              userId: params.userId,
              courseId: params.courseId,
              courseTitle: courseEntity.title,
              courseThumbnail: courseEntity.courseThumbnail,
             lectures: courseEntity.lessons.asMap().entries.map((entry) {
              final index = entry.key;
              final lesson = entry.value;

              return LectureProgressModel(
                lecture: lesson,
                watchedDuration: Duration.zero,
                isCompleted: false,
                isLocked: index != 0, // Unlock only the first lecture
                index: index,
              );
            }).toList(),

              overallProgress:0,
              completedLectures: 0,
              enrolledAt:DateTime.now(),
              lastAccessedAt:DateTime.now()),

          );

          return Right(courseEntity);
        },
      );


    } catch (e, stackTrace) {
      log('[EnrollmentRepo] Unexpected error: $e');
      log('[EnrollmentRepo] Stack trace: $stackTrace');
      return Left("Failed to enroll course: ${e.toString()}");
    }
  }
}