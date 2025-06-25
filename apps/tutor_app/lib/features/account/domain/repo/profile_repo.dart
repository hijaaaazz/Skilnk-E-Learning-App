import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/account/data/models/update_dp_params.dart';
import 'package:tutor_app/features/account/data/models/update_name_params.dart';
abstract class ProfileRepository {
  Future<Either<String, String>> updateProfilePic(UpdateDpParams params);
  Future<Either<String, String>> updateName(UpdateNameParams params);
}
