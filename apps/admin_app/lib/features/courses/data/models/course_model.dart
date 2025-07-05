import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String title;
  final String description;
  final int durationInSeconds;
  final String videoUrl;
  final String notesUrl;

  Lesson({
    required this.title,
    required this.description,
    required this.durationInSeconds,
    required this.videoUrl,
    required this.notesUrl,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      durationInSeconds: map['durationInSeconds'] ?? 0,
      videoUrl: map['videoUrl'] ?? '',
      notesUrl: map['notesUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'durationInSeconds': durationInSeconds,
      'videoUrl': videoUrl,
      'notesUrl': notesUrl,
    };
  }
}

class RatingBreakdown {
  final int oneStar;
  final int twoStar;
  final int threeStar;
  final int fourStar;
  final int fiveStar;

  RatingBreakdown({
    required this.oneStar,
    required this.twoStar,
    required this.threeStar,
    required this.fourStar,
    required this.fiveStar,
  });

  factory RatingBreakdown.fromMap(Map<String, dynamic> map) {
    return RatingBreakdown(
      oneStar: map['one_star'] ?? 0,
      twoStar: map['two_star'] ?? 0,
      threeStar: map['three_star'] ?? 0,
      fourStar: map['four_star'] ?? 0,
      fiveStar: map['five_star'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'one_star': oneStar,
      'two_star': twoStar,
      'three_star': threeStar,
      'four_star': fourStar,
      'five_star': fiveStar,
    };
  }
}

class CourseModel {
  final String id;
  final String title;
  final String titleLower;
  final String description;
  final int duration;
  final int enrolledCount;
  final int price;
  final int offerPercentage;
  final String category;
  final String categoryName;
  final String courseThumbnail;
  final String language;
  final String level;
  final String tutor;
  final double averageRating;
  final int totalReviews;
  final bool isActive;
  final bool isBanned;
  final bool listed;
  final bool notificationSent;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Lesson> lessons;
  final RatingBreakdown ratingBreakdown;

  CourseModel({
    required this.id,
    required this.title,
    required this.titleLower,
    required this.description,
    required this.duration,
    required this.enrolledCount,
    required this.price,
    required this.offerPercentage,
    required this.category,
    required this.categoryName,
    required this.courseThumbnail,
    required this.language,
    required this.level,
    required this.tutor,
    required this.averageRating,
    required this.totalReviews,
    required this.isActive,
    required this.isBanned,
    required this.listed,
    required this.notificationSent,
    required this.createdAt,
    required this.updatedAt,
    required this.lessons,
    required this.ratingBreakdown,
  });

  factory CourseModel.fromMap(Map<String, dynamic> map,String id) {
    return CourseModel(
      id: id,
      title: map['title'] ?? '',
      titleLower: map['title_lower'] ?? '',
      description: map['description'] ?? '',
      duration: map['duration'] ?? 0,
      enrolledCount: map['enrolled_count'] ?? 0,
      price: map['price'] ?? 0,
      offerPercentage: map['offer_percentage'] ?? 0,
      category: map['category'] ?? '',
      categoryName: map['category_name'] ?? '',
      courseThumbnail: map['course_thumbnail'] ?? '',
      language: map['language'] ?? '',
      level: map['level'] ?? '',
      tutor: map['tutor'] ?? '',
      averageRating: (map['average_rating'] ?? 0).toDouble(),
      totalReviews: map['total_reviews'] ?? 0,
      isActive: map['isActive'] ?? false,
      isBanned: map['isBanned'] ?? false,
      listed: map['listed'] ?? false,
      notificationSent: map['notificationSent'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      lessons: (map['lessons'] as List<dynamic>?)
              ?.map((lesson) => Lesson.fromMap(lesson))
              .toList() ??
          [],
      ratingBreakdown: RatingBreakdown.fromMap(map['rating_breakdown'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'title_lower': titleLower,
      'description': description,
      'duration': duration,
      'enrolled_count': enrolledCount,
      'price': price,
      'offer_percentage': offerPercentage,
      'category': category,
      'category_name': categoryName,
      'course_thumbnail': courseThumbnail,
      'language': language,
      'level': level,
      'tutor': tutor,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'isActive': isActive,
      'isBanned': isBanned,
      'listed': listed,
      'notificationSent': notificationSent,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lessons': lessons.map((e) => e.toMap()).toList(),
      'rating_breakdown': ratingBreakdown.toMap(),
    };
  }
}
