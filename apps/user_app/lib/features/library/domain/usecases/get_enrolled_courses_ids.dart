// getenrolled_usecase.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/library/domain/repo/library_repo.dart';
import 'package:user_app/service_locator.dart';

class GetEnrolledCoursesIdsUseCase implements Usecase<Either<String, List<String>>, String> {
  @override
  Future<Either<String, List<String>>> call({required String params}) {
    log('[GetEnrolledCoursesUseCase] Fetching enrolled courses for user: $params');
    return serviceLocator<LibraryRepository>().getEnrolledCoursesIds(params);
  }
}