import 'package:user_app/features/home/domain/entity/category_entity.dart';

class CategoryModel {
  final String id;
  final String title;
  final String description;
  final List<String> courses;

  CategoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.courses,
  });

  // ✅ Converts CategoryModel to CategoryEntity
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      title: title,
      description: description,
      courses: courses,
    );
  }

  CategoryModel copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? courses,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      courses: courses ?? this.courses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courses': courses,
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
  return CategoryModel(
    id: json['_id']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
    courses: (json['courses'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
  );
}


}
