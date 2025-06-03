import 'package:user_app/features/home/domain/entity/course_privew.dart';
import 'package:user_app/features/home/domain/entity/instructor_entity.dart';
import 'package:user_app/features/home/domain/entity/lecture_entity.dart';

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
  final Duration duration;
  final bool isActive;
  final bool isSaved;
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
  final MentorEntity mentor;
  final bool isEnrolled;

  const CourseEntity({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.language,
    required this.offerPercentage,
    required this.tutorId,
    required this.isSaved,
    required this.categoryName,
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
    required this.mentor,
    required this.isEnrolled
  });

CourseEntity copyWith({
  String? id,
  String? title,
  String? categoryId,
  String? description,
  int? price,
  int? offerPercentage,
  String? categoryName,
  String? tutorId,
  String? language,
  Duration? duration,
  bool? isActive,
  bool? isSaved,
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
  MentorEntity? mentor,
  bool? isEnrolled,
}) {
  return CourseEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    categoryId: categoryId ?? this.categoryId,
    description: description ?? this.description,
    price: price ?? this.price,
    offerPercentage: offerPercentage ?? this.offerPercentage,
    categoryName: categoryName ?? this.categoryName,
    tutorId: tutorId ?? this.tutorId,
    language: language ?? this.language,
    duration: duration ?? this.duration,
    isActive: isActive ?? this.isActive,
    isSaved: isSaved ?? this.isSaved,
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
    mentor: mentor ?? this.mentor,
    isEnrolled: isEnrolled ?? this.isEnrolled
  );
}

}

extension CourseEntityExtension on CourseEntity {
  CoursePreview toPreview() {
    return CoursePreview(
      id: id,
      courseTitle: title,
      categoryname: categoryName,
      price: price.toString(), // Convert int to String as required
      averageRating: averageRating,
      thumbnail: courseThumbnail,
    );
  }
}
