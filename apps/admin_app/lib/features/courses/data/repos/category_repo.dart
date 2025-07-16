import 'package:admin_app/features/courses/data/models/category_model.dart';
import 'package:admin_app/features/courses/data/models/course_model.dart';
import 'package:admin_app/features/courses/data/src/firebase_service.dart';
import 'package:admin_app/features/courses/domain/entities/category_entity.dart';
import 'package:admin_app/features/courses/domain/repositories/category_repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class CourseRepoImplementation extends CourseRepository {
  @override
Future<Either<String, List<CategoryEntity>>> getCategories() async {
  final result = await serviceLocator<CategoryFirebaseService>().getCategories();

  return result.fold(
    (l) {
      return left(l); // Returning the error message if failed
    },
    (r) {
      // Map each Map<String, dynamic> to CategoryEntity
      return right(r.map((json) {
        // CategoryModel.fromJson expects a Map<String, dynamic>
        return CategoryModel.fromJson(json).toEntity();
      }).toList());
    },
  );
}

  @override
Future<Either<String, CategoryEntity>> addNewCategories(CategoryEntity category) async {
  final result = await serviceLocator<CategoryFirebaseService>().addnewCategories(CategoryModel.fromEntity(category));

  return result.fold(
    (l) => left(l),
    (r) => right(r.toEntity()),
  );
}

  
  @override
  Future<Either<String, bool>> deleteCategories(String id) async {
    final result = await serviceLocator<CategoryFirebaseService>().deleteCategories(id);

  return result.fold(
    (l) => left(l),
    (r) => right(r),
  );
  }
  
  @override
  Future<Either<String, CategoryEntity>> updateCategories(CategoryEntity category) async{
    final result = await serviceLocator<CategoryFirebaseService>().updateCategories(CategoryModel.fromEntity(category));

  return result.fold(
    (l) => left(l),
    (r) => right(r.toEntity()),
  );
  }

  @override
  Future<Either<String, CourseModel>> getCourseDetails(String id)async{
    final result = await serviceLocator<CategoryFirebaseService>().getCourseDetails(id);

  return result.fold(
    (l) => left(l),
    (r) => right(r),
  );
  }

  @override
  Future<Either<String, List<CourseModel>>> getCourses()async{
   final result = await serviceLocator<CategoryFirebaseService>().getCourses();

  return result.fold(
    (l) => left(l),
    (r) => right(r),
  );
  }
  
  @override
  Future<Either<String, bool>> bantCourse(String id)async {
    final result = await serviceLocator<CategoryFirebaseService>().banCourse(id);

  return result.fold(
    (l) => left(l),
    (r) => right(r),
  );
  }
}
