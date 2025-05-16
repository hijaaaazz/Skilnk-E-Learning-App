import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class GetCategoriesUseCase
    implements Usecase<Either<String, List<CategoryEntity>>, NoParams> {
  
  @override
  Future<Either<String, List<CategoryEntity>>> call({required NoParams params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final coursePreviews = await repo.getGategories ();

    return coursePreviews.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}