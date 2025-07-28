

class ReviewModel {
  final String id;
  final String courseId;
  final List<String> likes;
  final int rating;
  final String review;
  final DateTime reviewedAt;
  final String reviewerImage;
  final String reviewerName;

  ReviewModel({
    required this.id,
    required this.courseId,
    required this.likes,
    required this.rating,
    required this.review,
    required this.reviewedAt,
    required this.reviewerImage,
    required this.reviewerName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, String docId) {
  return ReviewModel(
    id: docId,
    courseId: json['courseId'] ?? '',
    likes: _parseLikes(json['likes']),
    rating: (json['rating'] as num?)?.toInt() ?? 0,
    review: json['review'] ?? '',
    reviewedAt: _parseReviewedAt(json['reviewedAt']),
    reviewerImage: json['reviewerImage'] ?? '',
    reviewerName: json['reviewerName'] ?? '',
  );
}


  static List<String> _parseLikes(dynamic data) {
    if (data == null) return [];
    try {
      return (data as List).map((e) => e.toString()).toList();
    } catch (e) {
      return [];
    }
  }

  static DateTime _parseReviewedAt(dynamic data) {
    if (data is String) {
      try {
        return DateTime.parse(data);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'likes': likes,
      'rating': rating,
      'review': review,
      'reviewedAt': reviewedAt.toIso8601String(),
      'reviewerImage': reviewerImage,
      'reviewerName': reviewerName,
    };
  }

  ReviewModel copyWith({
    String? id,
    String? courseId,
    List<String>? likes,
    int? rating,
    String? review,
    DateTime? reviewedAt,
    String? reviewerImage,
    String? reviewerName,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      likes: likes ?? this.likes,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewerImage: reviewerImage ?? this.reviewerImage,
      reviewerName: reviewerName ?? this.reviewerName,
    );
  }
}