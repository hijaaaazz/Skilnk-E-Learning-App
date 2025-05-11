
import 'dart:developer';

import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/courses/domain/entities/category_entity.dart';
import 'package:admin_app/features/courses/domain/repositories/category_repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';


class DeleteCategoryuseCase implements Usecase<Either<String, bool>, String> {
  @override
  Future<Either<String, bool>> call({required String params}) async {
    final result = await serviceLocator<CategoryRepository>().deleteCategories(params);
    return result.fold(
      (l) {
        return Left(l); // Returning the error message if failed
      },
      (r) {
        log(r.toString());
        return Right(r);
      }
    );
  }
}
