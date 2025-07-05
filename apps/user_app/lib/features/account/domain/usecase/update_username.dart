
// GetCurrentUserUseCase.dart
import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/account/data/models/activity_model.dart';
import  'package:user_app/features/account/data/models/update_dp_params.dart';
import  'package:user_app/features/account/data/models/update_name_params.dart';
import  'package:user_app/features/account/domain/repo/profile_repo.dart';
import  'package:user_app/service_locator.dart';

class UpdateNameUserUseCase implements Usecase<Either<String, String>, UpdateNameParams> {
  @override
  Future<Either<String, String>> call({required UpdateNameParams params}) {
    return serviceLocator<ProfileRepository>().updateName(params);
  }
}