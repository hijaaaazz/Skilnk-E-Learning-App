class CoursePreview {
  final String id;
  final bool listed;
  final String title;
  final String thumbnailUrl;
  final double rating;
  final String level;
  final int offerPercentage;

  CoursePreview({
    required this.offerPercentage,
    required this.level,
    required this.id,
    required this.listed,
    required this.title,
    required this.thumbnailUrl,
    required this.rating,
  });

  CoursePreview copyWith({
    String? id,
    bool? listed,
    String? title,
    String? thumbnailUrl,
    double? rating,
    String? level,
    int? offerPercentage,
  }) {
    return CoursePreview(
      id: id ?? this.id,
      listed: listed ?? this.listed,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      rating: rating ?? this.rating,
      level: level ?? this.level,
      offerPercentage: offerPercentage ?? this.offerPercentage,
    );
  }
}
