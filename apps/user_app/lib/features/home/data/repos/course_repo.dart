import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/data/src/firebase_service.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class CoursesRepositoryImp extends CoursesRepository{
  @override
  Future<Either<String, List<CategoryEntity>>> getGategories() async {
    final result = await serviceLocator<CoursesFirebaseService>().getCategories();
    return result.fold(
      (l) => Left(l),
      (r) => Right(r.map((e) => e.toEntity()).toList()),
    );
  }

  @override
  Future<Either<String, List<CourseEntity>>> getCourses()async {
    final result = await serviceLocator<CoursesFirebaseService>().getCourses();
    return result.fold(
      (l) => Left(l),
      (r) => Right(r.map((e) => e.toEntity()).toList()),
    );
  }
  
  

}