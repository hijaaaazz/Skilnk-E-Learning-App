import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/courses/data/models/course_model.dart';
import 'package:admin_app/features/courses/domain/repositories/category_repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';


class GetCoursesUsecase implements Usecase<Either<String, List<CourseModel>>, NoParams> {
  @override
  Future<Either<String, List<CourseModel>>> call({required NoParams params}) async {
    return await serviceLocator<CategoryRepository>().getCourses();
  }
}
