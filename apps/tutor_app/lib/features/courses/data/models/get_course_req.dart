import 'package:cloud_firestore/cloud_firestore.dart';

class CourseParams {
  final int page;
  final int limit;
  final String? searchQuery;
  final String? categoryId;
  final DocumentSnapshot? lastDoc;
  final String? tutorId;
  final bool? isActive;
  final String? level;

  const CourseParams({
    this.page = 1,
    this.limit = 10,
    this.searchQuery,
    this.categoryId,
    this.lastDoc,
    this.tutorId,
    this.isActive,
    this.level,
  });

  CourseParams copyWith({
    int? page,
    int? limit,
    String? searchQuery,
    String? categoryId,
    DocumentSnapshot? lastDoc,
    String? tutorId,
    bool? isActive,
    String? level,
  }) {
    return CourseParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
      lastDoc: lastDoc ?? this.lastDoc,
      tutorId: tutorId ?? this.tutorId,
      isActive: isActive ?? this.isActive,
      level: level ?? this.level,
    );
  }
}
