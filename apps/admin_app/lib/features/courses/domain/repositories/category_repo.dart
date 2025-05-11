import 'package:admin_app/features/courses/domain/entities/category_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryRepository {
  Future<Either<String, List<CategoryEntity>>> getCategories();
  Future<Either<String, CategoryEntity>> addNewCategories(CategoryEntity category);
  Future<Either<String, CategoryEntity>> updateCategories(CategoryEntity category);
  Future<Either<String, bool>> deleteCategories(String id);
}
