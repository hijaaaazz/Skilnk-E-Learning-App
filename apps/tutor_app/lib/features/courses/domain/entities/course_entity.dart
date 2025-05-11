import 'package:tutor_app/features/courses/domain/entities/lecture_entity.dart';

class CourseEntity {
  final String id;
  final String title;
  final String categoryId;
  final String description;
  final int price;
  final int offerPercentage;
  final String tutorId;
  final int duration;
  final bool isActive;
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
    required this.offerPercentage,
    required this.tutorId,
    required this.duration,
    required this.isActive,
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
}
