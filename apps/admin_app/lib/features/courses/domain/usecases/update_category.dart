import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/courses/domain/entities/category_entity.dart';
import 'package:admin_app/features/courses/domain/repositories/category_repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';


class UpdateCategoryUseCase implements Usecase<Either<String, CategoryEntity>, CategoryEntity> {
  @override
  Future<Either<String, CategoryEntity>> call( {required CategoryEntity params}) async {
    return await serviceLocator<CourseRepository>().updateCategories(params);
  }
}
