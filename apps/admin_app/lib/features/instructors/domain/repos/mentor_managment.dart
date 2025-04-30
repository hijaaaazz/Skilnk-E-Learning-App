import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:admin_app/features/users/data/models/user_model.dart';
import 'package:admin_app/features/users/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MentorsRepo{

  Future<Either> getUsers();
  Future<Either> updateUser(MentorEntity user);

}