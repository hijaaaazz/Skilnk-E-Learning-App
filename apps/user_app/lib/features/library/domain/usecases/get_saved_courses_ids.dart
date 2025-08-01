// getenrolled_usecase.dart
import 'dart:developer';
import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/library/domain/repo/library_repo.dart';
import  'package:user_app/service_locator.dart';

class GetSavedCoursesIdsUseCase implements Usecase<Either<String, List<String>>, String> {
  @override
  Future<Either<String, List<String>>> call({required String params}) {
    log('[GetEnrolledCoursesUseCase] Fetching enrolled courses for user: $params');
    return serviceLocator<LibraryRepository>().getSavedCoursesIds(params);
  }
}