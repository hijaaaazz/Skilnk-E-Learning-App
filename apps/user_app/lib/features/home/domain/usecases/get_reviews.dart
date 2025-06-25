import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/data/models/review_model.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GetReviewsUseCase implements Usecase<Either<String, List<ReviewModel>>, GetReviewsParams> {
  @override
  Future<Either<String, List<ReviewModel>>> call({required GetReviewsParams params}) async {
    final repo = serviceLocator<CoursesRepository>();
    final coursePreviews = await repo.getReviews(params);

    return coursePreviews.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}

class GetReviewsParams {
  final String courseId;
  final int page;
  final int limit;

  GetReviewsParams({
    required this.courseId,
    this.page = 1,
    this.limit = 5,
  });
}