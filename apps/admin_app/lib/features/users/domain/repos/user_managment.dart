import 'package:admin_app/features/instructors/data/models/update_params.dart';
import 'package:admin_app/features/users/data/models/user-update_params.dart';
import 'package:admin_app/features/users/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class UsersRepo{

  Future<Either> getUsers();
  Future<Either<String,bool>> toggleBlock(UserUpdateParams params);

}