import 'dart:developer';

import 'package:user_app/features/home/domain/entity/instructor_entity.dart';

class MentorModel {
  final String id;
  final String imageUrl;
  final String name;
  final List<String> courseIds;
  final String bio;
  final List<String>category;

  MentorModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.courseIds,
    required this.bio,
    required this.category
  });

  factory MentorModel.fromJson(Map<String, dynamic> json) {
  log('[MentorModel.fromJson] Raw JSON: $json');

  return MentorModel(
    id: json['tutor_id'] as String? ?? '',
    imageUrl: json['profile_image'] as String? ?? '',
    name: json['full_name'] as String? ?? '',
    courseIds: (json['courses'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
    bio: json['bio'] ?? '',
    category: (json['categories'] is List)
        ? (json['categories'] as List).map((e) => e.toString()).toList()
        : [json['categories'].toString()],
  );
}




  // To JSON (MentorModel object to Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'name': name,
    };
  }

  MentorEntity toEntity(){
    return MentorEntity(
      id: id,
      imageUrl: imageUrl,
      name: name,
      sessions: courseIds,
      bio: bio,
      specialization: category

    );
  }
}
