import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/account/data/models/update_bio_params.dart';
import 'package:tutor_app/features/account/domain/repo/profile_repo.dart';
import 'package:tutor_app/service_locator.dart';

class UpdateBioUseCase implements Usecase<Either<String, String>, UpdateBioParams> {
  @override
  Future<Either<String, String>> call({required UpdateBioParams params}) {
    return serviceLocator<ProfileRepository>().updateBio(params);
  }
}
