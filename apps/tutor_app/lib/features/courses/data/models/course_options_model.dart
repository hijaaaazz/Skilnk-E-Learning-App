import 'package:tutor_app/features/courses/data/models/category_model.dart';
import 'package:tutor_app/features/courses/data/models/lang_model.dart';
import 'package:tutor_app/features/courses/domain/entities/course_options.dart';

class CourseOptionsModel{
  final List<CategoryModel> categories;
  final List<LanguageModel> langs;
  final List<String> levels;

  CourseOptionsModel({
    required this.categories,
    required this.langs,
    required this.levels,
  });

  factory CourseOptionsModel.fromJson(Map<String, dynamic> json) {
    return CourseOptionsModel(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      langs: (json['languages'] as List<dynamic>)
          .map((e) => LanguageModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      levels: (json['levels'] as List<String>)
    );
  }

  CourseOptionsEntity toEntity() {
    return CourseOptionsEntity(
      categories: categories.map((e) => e.toEntity()).toList(),
      languages: langs.map((e) => e.toEntity()).toList(),
      levels: levels,
    );
  }
 
}