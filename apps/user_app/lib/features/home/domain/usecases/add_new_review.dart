import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/home/data/models/review_model.dart';
import  'package:user_app/features/home/domain/repos/repository.dart';
import  'package:user_app/service_locator.dart';

class AddReviewUseCase implements Usecase<Either<String, ReviewModel>, ReviewModel> {
  @override
  Future<Either<String, ReviewModel>> call({required ReviewModel params}) async {
    final repo = serviceLocator<CoursesRepository>();
    return await repo.addReviews(params);
  }
}
