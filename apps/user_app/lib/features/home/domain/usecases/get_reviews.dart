import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/data/models/review_model.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class GetReviewsUseCase
    implements Usecase<Either<String, List<ReviewModel>>, String> {
  
  @override
  Future<Either<String, List<ReviewModel>>> call({required String params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final coursePreviews = await repo.getReviews (params);

    return coursePreviews.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}