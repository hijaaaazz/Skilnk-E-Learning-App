import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
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
  final List<String> lessons;
  final String courseThumbnail;
  final String level;
  final bool notificationSent;
  final bool listed;
  final bool isBanned;
  final DateTime createdAt;
  final DateTime updatedAt;
  //final String? quizId;

  CourseModel({
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
    //this.quizId,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json, String docId) {
    return CourseModel(
      id: docId,
      title: json['title'] ?? '',
      categoryId: json['category']?['_id'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      offerPercentage: json['offer_percentage'] ?? 0,
      tutorId: json['tutor']?['_id'] ?? '',
      duration: json['duration'] ?? 0,
      isActive: json['isActive'] ?? false,
      enrolledCount: json['enrolled_count'] ?? 0,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      ratingBreakdown: Map<String, int>.from(json['rating_breakdown'] ?? {
        "five_star": 0,
        "four_star": 0,
        "three_star": 0,
        "two_star": 0,
        "one_star": 0,
      }),
      totalReviews: json['total_reviews'] ?? 0,
      reviews: List<String>.from(json['reviews'] ?? []),
      lessons: List<String>.from(
        (json['lessons'] as List<dynamic>? ?? []).map((e) => e['_id'] ?? ''),
      ),
      courseThumbnail: json['course_thumbnail'] ?? '',
      level: json['level'] ?? '',
      notificationSent: json['notificationSent'] ?? false,
      listed: json['listed'] ?? false,
      isBanned: json['isBanned'] ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      //quizId: json['quiz']?['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': categoryId,
      'description': description,
      'price': price,
      'offer_percentage': offerPercentage,
      'tutor': tutorId,
      'duration': duration,
      'isActive': isActive,
      'enrolled_count': enrolledCount,
      'average_rating': averageRating,
      'rating_breakdown': ratingBreakdown,
      'total_reviews': totalReviews,
      'reviews': reviews,
      'lessons': lessons,
      'course_thumbnail': courseThumbnail,
      'level': level,
      'notificationSent': notificationSent,
      'listed': listed,
      'isBanned': isBanned,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      //'quiz': quizId,
    };
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? categoryId,
    String? description,
    int? price,
    int? offerPercentage,
    String? tutorId,
    int? duration,
    bool? isActive,
    int? enrolledCount,
    double? averageRating,
    Map<String, int>? ratingBreakdown,
    int? totalReviews,
    List<String>? reviews,
    List<String>? lessons,
    String? courseThumbnail,
    String? level,
    bool? notificationSent,
    bool? listed,
    bool? isBanned,
    DateTime? createdAt,
    DateTime? updatedAt,
    //String? quizId,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      price: price ?? this.price,
      offerPercentage: offerPercentage ?? this.offerPercentage,
      tutorId: tutorId ?? this.tutorId,
      duration: duration ?? this.duration,
      isActive: isActive ?? this.isActive,
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
      //quizId: quizId ?? this.quizId,
    );
  }
}
