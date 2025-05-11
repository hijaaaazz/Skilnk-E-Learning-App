import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/courses/domain/entities/course_options.dart';
import 'package:tutor_app/features/courses/domain/repo/course_repo.dart';
import 'package:tutor_app/service_locator.dart';

class GetCourseOptionsUseCase
    implements Usecase<Either<String, CourseOptionsEntity>, NoParams> {
  @override
  Future<Either<String, CourseOptionsEntity>> call({required params}) async {
    final repo = serviceLocator<CoursesRepository>();

    final optionsResult = await repo.getCourseOptions();
    final categoriesResult = await repo.getCategories();

    if (optionsResult.isLeft()) return Left(optionsResult.swap().getOrElse(() => 'Unknown Error'));
    if (categoriesResult.isLeft()) return Left(categoriesResult.swap().getOrElse(() => 'Unknown Error'));

    final options = optionsResult.getOrElse(() => throw Exception("Invalid"));
    final categories = categoriesResult.getOrElse(() => []);

    final mergedOptions = CourseOptionsEntity(
      categories: categories,
      languages: options.langs.map((l) => l.toEntity()).toList(),
      levels: options.levels,
    );

    return Right(mergedOptions);
  }
}
