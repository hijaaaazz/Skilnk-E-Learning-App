class BannerModel {
  final String id;
  final String badge;
  final String title;
  final String description;

  BannerModel({
    required this.id,
    required this.badge,
    required this.title,
    required this.description,
  });

  BannerModel copyWith({
    String? id,
    String? badge,
    String? title,
    String? description,
  }) {
    return BannerModel(
      id: id ?? this.id,
      badge: badge ?? this.badge,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      badge: json['badge'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'badge': badge,
      'title': title,
      'description': description,
    };
  }
}
