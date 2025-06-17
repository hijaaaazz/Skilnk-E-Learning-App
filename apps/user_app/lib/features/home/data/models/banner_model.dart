import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String badge;
  final String title;
  final String description;
  final String image;
  final DateTime? timestamp; // optional

  BannerModel({
    required this.badge,
    required this.title,
    required this.description,
    required this.image,
    this.timestamp,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      badge: json['badge'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate(),
    );
  }
}
