// getenrolled_usecase.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/home/domain/entity/course_privew.dart';
import  'package:user_app/features/library/domain/repo/library_repo.dart';
import  'package:user_app/service_locator.dart';

class GetEnrolledCoursesUseCase implements Usecase<Either<String, List<CoursePreview>>, String> {
  @override
  Future<Either<String, List<CoursePreview>>> call({required String params}) {
    log('[GetEnrolledCoursesUseCase] Fetching enrolled courses for user: $params');
    return serviceLocator<LibraryRepository>().getEnrolledCourses(params);
  }
}