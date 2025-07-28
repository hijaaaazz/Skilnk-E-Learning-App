import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/account/data/models/update_category_params.dart';
import 'package:tutor_app/features/account/domain/repo/profile_repo.dart';
import 'package:tutor_app/service_locator.dart';

class AddCategoryUseCase implements Usecase<Either<String,List<String>>, UpdateCategoryParams> {
  @override
  Future<Either<String, List<String>>> call({required UpdateCategoryParams params}) {
    return serviceLocator<ProfileRepository>().addCategory(params);
  }
}
