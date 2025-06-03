
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/payment/data/models/add_purchase_params.dart';
import 'package:user_app/features/payment/domain/repo/enrollment_repo.dart';
import 'package:user_app/service_locator.dart';

class EnrollCoursesUseCase implements Usecase<Either<String, CourseEntity>, AddPurchaseParams> {
  @override
  Future<Either<String, CourseEntity>> call({required AddPurchaseParams params}) async {
    try {
      log('[UseCase] Enrollment use case started');
      final result = await serviceLocator<EnrollmentRepository>().enrollCourse(params);
      log('[UseCase] Enrollment use case completed');
      return result;
    } catch (e) {
      log('[UseCase] Error in use case: $e');
      return Left("Use case error: ${e.toString()}");
    }
  }
}