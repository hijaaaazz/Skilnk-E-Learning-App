class CoursePreview {
  final String id;
  final bool isActive;
  final String title;
  final String thumbnailUrl;
  final double rating;
  final String level;
  final int offerPercentage;

  CoursePreview({
    required this.offerPercentage,
    required this.level,
    required this.id,
    required this.isActive,
    required this.title,
    required this.thumbnailUrl,
    required this.rating,
  });

  CoursePreview copyWith({
    String? id,
    bool? isActive,
    String? title,
    String? thumbnailUrl,
    double? rating,
    String? level,
    int? offerPercentage,
  }) {
    return CoursePreview(
      id: id ?? this.id,
      isActive: isActive ?? this.isActive,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      rating: rating ?? this.rating,
      level: level ?? this.level,
      offerPercentage: offerPercentage ?? this.offerPercentage,
    );
  }
}
