import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_app/features/courses/data/models/lecture_model.dart';
import 'package:tutor_app/features/courses/domain/entities/course_entity.dart';

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
  final List<LectureModel> lessons;
  final String courseThumbnail;
  final String level;
  final bool notificationSent;
  final bool listed;
  final bool isBanned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? language;

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
    this.language,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json, String docId) {
    return CourseModel(
      id: docId,
      title: json['title'] ?? '',
      categoryId: json['category'] is Map ? json['category']['_id'] ?? '' : json['category'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      offerPercentage: json['offer_percentage'] ?? 0,
      tutorId: json['tutor'] is Map ? json['tutor']['_id'] ?? '' : json['tutor'] ?? '',
      duration: json['duration'] ?? 0,
      isActive: json['isActive'] ?? false,
      enrolledCount: json['enrolled_count'] ?? 0,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      ratingBreakdown: _parseRatingBreakdown(json['rating_breakdown']),
      totalReviews: json['total_reviews'] ?? 0,
      reviews: _parseReviews(json['reviews']),
      lessons: _parseLessons(json['lessons']),
      courseThumbnail: json['course_thumbnail'] ?? '',
      level: json['level'] ?? '',
      notificationSent: json['notificationSent'] ?? false,
      listed: json['listed'] ?? false,
      isBanned: json['isBanned'] ?? false,
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
      language: json['language'],
    );
  }

  static Map<String, int> _parseRatingBreakdown(dynamic data) {
    if (data == null) {
      return {
        "five_star": 0,
        "four_star": 0,
        "three_star": 0,
        "two_star": 0,
        "one_star": 0,
      };
    }
    
    try {
      return Map<String, int>.from(data);
    } catch (e) {
      return {
        "five_star": 0,
        "four_star": 0,
        "three_star": 0,
        "two_star": 0,
        "one_star": 0,
      };
    }
  }
  
  static List<String> _parseReviews(dynamic data) {
    if (data == null) return [];
    
    try {
      return (data as List).map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }
  
  static List<LectureModel> _parseLessons(dynamic data) {
    if (data == null) return [];
    
    try {
      return (data as List<dynamic>).map((lessonData) {
        if (lessonData is Map<String, dynamic>) {
          return LectureModel.fromJson(lessonData);
        } else {
          // If the lesson is just an ID string or other format
          return LectureModel(
            title: '',
            description: '',
            videoUrl: '',
            notesUrl: '',
            durationInSeconds: 0,
          );
        }
      }).toList();
    } catch (e) {
      return [];
    }
  }
  
  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.now();
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
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
      'course_thumbnail': courseThumbnail,
      'level': level,
      'language': language ?? '',
      'notificationSent': notificationSent,
      'listed': listed,
      'isBanned': isBanned,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
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
    List<LectureModel>? lessons,
    String? courseThumbnail,
    String? level,
    bool? notificationSent,
    bool? listed,
    bool? isBanned,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? language,
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
      language: language ?? this.language,
    );
  }

  CourseEntity toEntity() {
    return CourseEntity(
      id: id,
      title: title,
      categoryId: categoryId,
      description: description,
      price: price,
      offerPercentage: offerPercentage,
      tutorId: tutorId,
      duration: duration,
      isActive: isActive,
      enrolledCount: enrolledCount,
      averageRating: averageRating,
      ratingBreakdown: ratingBreakdown,
      totalReviews: totalReviews,
      reviews: reviews,
      lessons: lessons.map((e) => e.toEntity()).toList(),
      courseThumbnail: courseThumbnail,
      level: level,
      notificationSent: notificationSent,
      listed: listed,
      isBanned: isBanned,
      createdAt: createdAt,
      updatedAt: updatedAt
    );
  }
}
