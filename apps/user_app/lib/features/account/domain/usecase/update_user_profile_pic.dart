// GetCurrentUserUseCase.dart
import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/account/data/models/activity_model.dart';
import 'package:user_app/features/account/data/models/update_dp_params.dart';
import 'package:user_app/features/account/domain/repo/profile_repo.dart';
import 'package:user_app/service_locator.dart';

class UpdateDpUserUseCase implements Usecase<Either<String, String>, UpdateDpParams> {
  @override
  Future<Either<String, String>> call({required UpdateDpParams params}) {
    return serviceLocator<ProfileRepository>().updateProfilePic(params);
  }
}