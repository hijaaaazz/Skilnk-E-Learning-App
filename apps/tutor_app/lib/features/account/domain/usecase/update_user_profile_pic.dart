// GetCurrentUserUseCase.dart
import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/account/data/models/update_dp_params.dart';
import 'package:tutor_app/features/account/domain/repo/profile_repo.dart';
import 'package:tutor_app/service_locator.dart';


class UpdateDpUserUseCase implements Usecase<Either<String, String>, UpdateDpParams> {
  @override
  Future<Either<String, String>> call({required UpdateDpParams params}) {
    return serviceLocator<ProfileRepository>().updateProfilePic(params);
  }
}