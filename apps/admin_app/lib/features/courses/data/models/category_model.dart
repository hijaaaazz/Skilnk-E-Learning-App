import 'package:admin_app/features/courses/domain/entities/category_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String title;
  final String description;
  final List<String> courses;
  final bool? isVisible;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.courses,
    this.isVisible,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
  return CategoryModel(
    id: json['id'] ?? '', // Make sure this won't be null
    title: json['title'] ?? '', // Make sure this won't be null
    description: json['description'] ?? '',
    courses: List<String>.from(json['courses'] ?? []),
    isVisible: json['isVisible'],
    createdAt: _parseDateTime(json['createdAt']),
    updatedAt: _parseDateTime(json['updatedAt']),
  );
}


  static DateTime? _parseDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is Map && value['_seconds'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(value['_seconds'] * 1000);
    }
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courses': courses,
      'isVisible': isVisible,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      title: title,
      description: description,
      courses: courses,
      isVisible: isVisible,
    );
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      courses: entity.courses,
      isVisible: entity.isVisible,
    );
  }

  CategoryModel copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? courses,
    bool? isVisible,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      courses: courses ?? this.courses,
      isVisible: isVisible ?? this.isVisible,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
