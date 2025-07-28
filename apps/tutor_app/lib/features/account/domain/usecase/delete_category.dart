import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/account/data/models/delete_category.dart';
import 'package:tutor_app/features/account/domain/repo/profile_repo.dart';
import 'package:tutor_app/service_locator.dart';

class DeleteCategoryUseCase implements Usecase<Either<String, bool>, DeleteCategoryParams> {
  @override
  Future<Either<String, bool>> call({required DeleteCategoryParams params}) {
    return serviceLocator<ProfileRepository>().deleteCategory(params);
  }
}
