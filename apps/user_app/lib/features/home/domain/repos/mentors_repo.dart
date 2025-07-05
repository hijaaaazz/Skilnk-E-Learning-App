import 'package:dartz/dartz.dart';
import  'package:user_app/features/home/domain/entity/instructor_entity.dart';

abstract class MentorsRepo {
  Future<Either<String, List<MentorEntity>>> getMentors();
}
