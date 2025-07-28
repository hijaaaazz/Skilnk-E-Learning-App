import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/courses/data/models/category_model.dart';
import 'package:tutor_app/features/account/domain/repo/profile_repo.dart';
import 'package:tutor_app/service_locator.dart';

class GetCategoriesUseCase implements Usecase<Either<String, List<CategoryModel>>, NoParams> {
  @override
  Future<Either<String, List<CategoryModel>>> call({required NoParams params}) {
    return serviceLocator<ProfileRepository>().getCategories();
  }
}
