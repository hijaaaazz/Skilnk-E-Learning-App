import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/courses/domain/entities/category_entity.dart';
import 'package:admin_app/features/courses/domain/repositories/category_repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';


class GetCategoryUsecase implements Usecase<Either<String, List<CategoryEntity>>, NoParams> {
  @override
  Future<Either<String, List<CategoryEntity>>> call({required NoParams params}) async {
    return await serviceLocator<CourseRepository>().getCategories();
  }
}
