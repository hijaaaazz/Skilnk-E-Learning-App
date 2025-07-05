import 'package:admin_app/features/instructors/data/models/update_params.dart';
import 'package:dartz/dartz.dart';


abstract class MentorsRepo{

  Future<Either> getUsers();
  Future<Either> verifyMentor(UpdateParams params);
  Future<Either> toggleBlock(UpdateParams params);

}