import 'dart:developer';

import 'package:user_app/features/home/domain/entity/instructor_entity.dart';

class MentorModel {
  final String id;
  final String imageUrl;
  final String name;
  final List<String> courseIds;

  MentorModel({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.courseIds
  });

  // From JSON (Map) to MentorModel object
  factory MentorModel.fromJson(Map<String, dynamic> json) {
  log('[MentorModel.fromJson] Raw JSON: $json');

  return MentorModel(
    id: json['tutor_id'] as String? ?? '',
    imageUrl: json['profile_image'] as String? ?? '',
    name: json['full_name'] as String? ?? '',
    courseIds: (json['courses'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList(),
    
    // Add these if your model has more fields:
    // bio: json['bio'] as String? ?? '',
    // email: json['email'] as String? ?? '',
    // isVerified: json['is_verified'] as bool? ?? false,
    // lastActive: json['lastActive'], // handle timestamp parsing if needed
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
      rating: 2,
      specialization: "Good"

    );
  }
}
