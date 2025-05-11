import 'package:tutor_app/features/courses/domain/entities/category_entity.dart';
import 'package:tutor_app/features/courses/domain/entities/language_entity.dart';

class CourseOptionsEntity {
  final List<CategoryEntity> categories;
  final List<LanguageEntity> languages;
  final List<String> levels;

  CourseOptionsEntity({required this.levels, required this.categories, required this.languages});
}
