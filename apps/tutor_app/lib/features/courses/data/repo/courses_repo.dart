
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';

class CoursesRepoImplementation extends CoursesRepository {
  @override
  Future<Either<String, CourseEntity>> addNewCourse() {
    throw UnimplementedError();
  }
  
}