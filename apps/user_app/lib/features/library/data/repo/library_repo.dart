// library_repo.dart
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/features/library/data/src/firebase_service.dart';
import 'package:user_app/features/library/domain/repo/library_repo.dart';
import 'package:user_app/features/payment/data/src/enrollment_firebase_service.dart';
import 'package:user_app/service_locator.dart';



class LibraryRepositoryImpl extends LibraryRepository {
  
  @override
Future<Either<String, List<CoursePreview>>> getSavedCourses(String userId) async {
  try {
    log('[LibraryRepo] Fetching saved courses for user: $userId');

    // Get the saved course IDs (returns Either<String, List<String>>)
    final result = await serviceLocator<LibraryFirebaseService>().getSavedCoursesIds(userId);

    // Handle the Either result
    return await result.fold(
      (error) {
        return Left(error); // Pass the error as-is
      },
      (courseIds) async {
        // Now that we have the List<String> courseIds, fetch the actual course previews
        final courseResult = await serviceLocator<LibraryFirebaseService>().getSavedCourses(courseIds);
        return courseResult.fold(
          (error) => Left(error),
          (courses) => Right(courses),
        );
      },
    );
  } catch (e) {
    log('[LibraryRepo] Error fetching saved courses: $e');
    return Left('Failed to fetch saved courses: ${e.toString()}');
  }
}


  @override
Future<Either<String, List<CoursePreview>>> getEnrolledCourses(String userId) async {
  try {
    log('[LibraryRepo] Fetching enrolled courses for user: $userId');

    final enrollmentService = serviceLocator<EnrollmentFirebaseService>();
    final enrolledCourseIds = await enrollmentService.getEnrolledCourseIds(userId);

    if (enrolledCourseIds.isEmpty) {
      log('[LibraryRepo] No enrolled courses found');
      return const Right([]);
    }

    log('[LibraryRepo] Found ${enrolledCourseIds.length} enrolled course IDs');

    final coursesRepository = serviceLocator<LibraryFirebaseService>();
    final courseResult = await coursesRepository.getSavedCourses(enrolledCourseIds);

    return courseResult.fold(
      (error) {
        log('[LibraryRepo] Error fetching enrolled course details: $error');
        return Left(error);
      },
      (courses) {
        log('[LibraryRepo] Successfully fetched ${courses.length} enrolled courses');
        return Right(courses);
      },
    );

  } catch (e) {
    log('[LibraryRepo] Error fetching enrolled courses: $e');
    return Left('Failed to fetch enrolled courses: ${e.toString()}');
  }
}

}