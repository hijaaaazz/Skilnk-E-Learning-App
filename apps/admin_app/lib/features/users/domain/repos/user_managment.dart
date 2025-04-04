import 'package:admin_app/features/users/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class UsersRepo{

  Future<Either> getUsers();

}