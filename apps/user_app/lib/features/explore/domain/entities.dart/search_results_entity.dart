import  'package:user_app/features/home/domain/entity/category_entity.dart';
import  'package:user_app/features/home/domain/entity/course_privew.dart';
import  'package:user_app/features/home/domain/entity/instructor_entity.dart';

abstract class SearchResult {}

class MentorResult extends SearchResult {
  final MentorEntity mentor;
  MentorResult(this.mentor);
}

class CourseResult extends SearchResult {
  final CoursePreview course;
  CourseResult(this.course);
}

class CategoryResult extends SearchResult {
  final CategoryEntity category;
  CategoryResult(this.category);
}
