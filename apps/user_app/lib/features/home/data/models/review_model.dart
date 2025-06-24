import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String courseId;
  final double rating;
  final String reviewerName;
  final String reviewerImage;
  final String review;
  final DateTime reviewedAt;
  final List<String> likes; // List of user IDs who liked the review

  ReviewModel({
    required this.courseId,
    required this.rating,
    required this.reviewerName,
    required this.reviewerImage,
    required this.review,
    required this.reviewedAt,
    required this.likes,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, String courseId) {
    return ReviewModel(
      courseId: courseId,
      rating: (json['rating'] ?? 0).toDouble(),
      reviewerName: json['reviewerName'] ?? '',
      reviewerImage: json['reviewerImage'] ?? '',
      review: json['review'] ?? '',
      reviewedAt: _parseTimestamp(json['reviewedAt']),
      likes: List<String>.from(json['likes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'rating': rating,
      'reviewerName': reviewerName,
      'reviewerImage': reviewerImage,
      'review': review,
      'reviewedAt': reviewedAt.toIso8601String(),
      'likes': likes,
    };
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is String) return DateTime.tryParse(timestamp) ?? DateTime.now();
    return DateTime.now();
  }

  // Helper method to get like count
  int get likeCount => likes.length;

  // Helper method to check if a user has liked the review
  bool hasLiked(String userId) => likes.contains(userId);

  // Helper method to create a copy with updated likes
  ReviewModel copyWith({List<String>? likes}) {
    return ReviewModel(
      courseId: courseId,
      rating: rating,
      reviewerName: reviewerName,
      reviewerImage: reviewerImage,
      review: review,
      reviewedAt: reviewedAt,
      likes: likes ?? this.likes,
    );
  }
}