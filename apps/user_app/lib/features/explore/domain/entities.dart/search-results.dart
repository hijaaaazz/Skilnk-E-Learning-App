// ignore_for_file: file_names

import  'package:user_app/features/home/domain/entity/category_entity.dart';
import  'package:user_app/features/home/domain/entity/course_privew.dart';
import  'package:user_app/features/home/domain/entity/instructor_entity.dart';

abstract class SearchResult {}

class MentorResult extends SearchResult {
  final List<MentorEntity> mentors;
  MentorResult(this.mentors);
}

class CourseResult extends SearchResult {
  final List<CoursePreview> courses;
  CourseResult(this.courses);
}

class CategoryResult extends SearchResult {
  final List<CategoryEntity> categories;
  CategoryResult(this.categories);
}
