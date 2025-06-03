import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/explore/domain/repos/search_repo.dart';
import 'package:user_app/features/library/domain/repo/library_repo.dart';
import 'package:user_app/service_locator.dart';

class GetSavedCoursesUseCase implements Usecase<Either<String, List<CoursePreview>>, String> {
  @override
  Future<Either<String, List<CoursePreview>>> call({required String params}) {
    return serviceLocator<LibraryRepository>().getSavedCourses(params);
  }
}
