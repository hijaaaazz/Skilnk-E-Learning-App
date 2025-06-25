import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/courses/data/models/review_model.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/service_locator.dart';

class GetReviewsUseCase
    implements Usecase<Either<String, List<ReviewModel>>, List<String>> {
  
  @override
  Future<Either<String, List<ReviewModel>>> call({required List<String> params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final coursePreviews = await repo.getReviews (reviewIds:   params);
  
    return coursePreviews.fold(
      (l) => Left(l),
      (r) {
        log(r.toString());
        return Right(r);
      } 
    );
  }
}
