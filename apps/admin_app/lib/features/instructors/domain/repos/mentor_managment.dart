import 'package:dartz/dartz.dart';

abstract class MentorsRepo{

  Future<Either> getUsers();

}