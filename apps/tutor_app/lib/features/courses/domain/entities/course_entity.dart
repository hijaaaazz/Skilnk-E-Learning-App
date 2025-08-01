import 'package:tutor_app/features/courses/domain/entities/couse_preview.dart';
import 'package:tutor_app/features/courses/domain/entities/lecture_entity.dart';

class CourseEntity {
  final String id;
  final String title;
  final String categoryId;
  final String description;
  final int price;
  final int offerPercentage;
  final String categoryName;
  final String tutorId;
  final String language;
  final int duration;
  final int enrolledCount;
  final double averageRating;
  final Map<String, int> ratingBreakdown;
  final int totalReviews;
  final List<String> reviews;
  final List<LectureEntity> lessons;
  final String courseThumbnail;
  final String level;
  final bool notificationSent;
  final bool listed;
  final bool isBanned;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseEntity({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.language,
    required this.offerPercentage,
    required this.tutorId,
    required this.categoryName,
    required this.duration,
    required this.enrolledCount,
    required this.averageRating,
    required this.ratingBreakdown,
    required this.totalReviews,
    required this.reviews,
    required this.lessons,
    required this.courseThumbnail,
    required this.level,
    required this.notificationSent,
    required this.listed,
    required this.isBanned,
    required this.createdAt,
    required this.updatedAt,
  });

  CourseEntity copyWith({
  String? id,
  String? title,
  String? categoryId,
  String? description,
  int? price,
  String? language,
  int? offerPercentage,
  String? tutorId,
  String? categoryName,
  int? duration,
  bool? isActive,
  int? enrolledCount,
  double? averageRating,
  Map<String, int>? ratingBreakdown,
  int? totalReviews,
  List<String>? reviews,
  List<LectureEntity>? lessons,
  String? courseThumbnail,
  String? level,
  bool? notificationSent,
  bool? listed,
  bool? isBanned,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return CourseEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    categoryId: categoryId ?? this.categoryId,
    description: description ?? this.description,
    price: price ?? this.price,
    language: language ?? this.language,
    offerPercentage: offerPercentage ?? this.offerPercentage,
    tutorId: tutorId ?? this.tutorId,
    categoryName: categoryName ?? this.categoryName,
    duration: duration ?? this.duration,
    enrolledCount: enrolledCount ?? this.enrolledCount,
    averageRating: averageRating ?? this.averageRating,
    ratingBreakdown: ratingBreakdown ?? this.ratingBreakdown,
    totalReviews: totalReviews ?? this.totalReviews,
    reviews: reviews ?? this.reviews,
    lessons: lessons ?? this.lessons,
    courseThumbnail: courseThumbnail ?? this.courseThumbnail,
    level: level ?? this.level,
    notificationSent: notificationSent ?? this.notificationSent,
    listed: listed ?? this.listed,
    isBanned: isBanned ?? this.isBanned,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

}


extension CourseEntityCopyWith on CourseEntity {
  CourseEntity copyWith({
    String? title,
    String? description,
    String? categoryId,
    String? categoryName,
    bool? isPaid,
    int? price,
    int? offerPercentage,
    String? language,
    String? level,
    int? duration,
    List<LectureEntity>? lessons,
    String? courseThumbnail,
  }) {
    return CourseEntity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      price: price ?? this.price,
      offerPercentage: offerPercentage ?? this.offerPercentage,
      language: language ?? this.language,
      level: level ?? this.level,
      duration: duration ?? this.duration,
      lessons: lessons ?? this.lessons,
      courseThumbnail: courseThumbnail ?? this.courseThumbnail,
      // Keep other values unchanged
      tutorId: tutorId,
      enrolledCount: enrolledCount,
      averageRating: averageRating,
      ratingBreakdown: ratingBreakdown,
      totalReviews: totalReviews,
      reviews: reviews,
      notificationSent: notificationSent,
      listed: listed,
      isBanned: isBanned,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

extension CourseEntityToPreview on CourseEntity {
  CoursePreview toPreview() {
    return CoursePreview(
      id: id,
      listed: listed,
      title: title,
      thumbnailUrl: courseThumbnail,
      rating: averageRating,
      level: level,
      offerPercentage: offerPercentage,
    );
  }
}
