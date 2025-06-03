import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/data/models/category_model.dart';
import 'package:user_app/features/home/data/models/courses_model.dart';
import 'package:user_app/features/home/data/models/getcourse_details_params.dart';
import 'package:user_app/features/home/data/models/mentor_mode.dart';
import 'package:user_app/features/home/data/models/save_course_params.dart';
import 'package:user_app/features/home/data/src/firebase_service.dart';
import 'package:user_app/features/home/domain/entity/category_entity.dart';
import 'package:user_app/features/home/domain/entity/course-entity.dart';
import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/repos/repository.dart';
import 'package:user_app/service_locator.dart';

class CoursesRepositoryImp extends CoursesRepository {
  @override
  Future<Either<String, List<CategoryEntity>>> getGategories() async {
    final result = await serviceLocator<CoursesFirebaseService>().getCategories();
    return result.fold(
      (l) => Left(l),
      (r) => Right(
        r.map((data) {
          final categoryModel = CategoryModel.fromJson(data);
          return categoryModel.toEntity();
        }).where((entity) => entity.courses.isNotEmpty).toList(),
      ),
    );
  }

  @override
  Future<Either<String, List<CoursePreview>>> getCourses() async {
    final result = await serviceLocator<CoursesFirebaseService>().getCourses();
    return result.fold(
      (l) => Left(l),
      (r) => Right(
        r.map((data) => CoursePreview(
              id: data['id'],
              courseTitle: data['title'],
              thumbnail: data['course_thumbnail'],
              averageRating: (data['average_rating'] ?? 0).toDouble(),
              price: (data['price'] ?? 0).toString(),
              categoryname: data['category_name'],
            )).toList(),
      ),
    );
  }

  @override
  Future<Either<String, CourseEntity>> getCoursedetails(
      GetCourseDetailsParams params) async {
    final courseResult = await serviceLocator<CoursesFirebaseService>()
        .getCourseDetails(params.courseId);

    return await courseResult.fold(
      (l) async => Left(l),
      (courseData) async {
        try {
          final mentorId = courseData['tutor'] is Map
              ? courseData['tutor']['_id'] ?? ''
              : courseData['tutor'] ?? '';
          final mentorResult =
              await serviceLocator<CoursesFirebaseService>().getMentor(mentorId);

          return await mentorResult.fold(
            (mentorError) async => Left(mentorError),
            (mentorData) async {
              final mentorModel = MentorModel.fromJson(mentorData);

              // Check if course is saved and enrolled (if userId is provided)
              bool isSaved = false;
              bool isEnrolled = false;
              if (params.userId.isNotEmpty) {
                // Check saved status
                final savedResult = await serviceLocator<CoursesFirebaseService>()
                    .checkIsSaved(params.courseId, params.userId);
                isSaved = savedResult.fold((error) => false, (saved) => saved);

                // Check enrolled status
                final enrolledResult = await serviceLocator<
                        CoursesFirebaseService>()
                    .checkIsEnrolled(params.courseId, params.userId);
                isEnrolled =
                    enrolledResult.fold((error) => false, (enrolled) => enrolled);
              }

              // Create course model with correct saved and enrolled status
              final courseModel = CourseModel.fromJson(
                courseData,
                courseData['id'],
                isSaved,
                isEnrolled,
              );

              final courseModelWithMentor =
                  courseModel.copyWith(mentor: mentorModel);
              return Right(courseModelWithMentor.toEntity());
            },
          );
        } catch (e) {
          return Left('Error processing course data: $e');
        }
      },
    );
  }

  @override
  Future<Either<String, bool>> saveCoursedetails(SaveCourseParams params) async {
    final result =
        await serviceLocator<CoursesFirebaseService>().saveCourseDetails(params);
    return result.fold(
      (l) => Left(l),
      (courseData) async {
        try {
          // Check the updated saved status after save/unsave operation
          final savedResult = await serviceLocator<CoursesFirebaseService>()
              .checkIsSaved(params.courseId, params.userId);
          return savedResult.fold(
            (l) => Left(l),
            (r) => Right(r),
          );
        } catch (e) {
          return Left('Error updating saved status: $e');
        }
      },
    );
  }

 
}