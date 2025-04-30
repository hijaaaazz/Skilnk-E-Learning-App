
import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MentorModel {
  final String tutorId;
  final String? username;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String? bio;
  final bool infoSubmitted;
  final bool emailVerified;
  final bool isblocked;
  final bool? isVerified;
  final bool? status;
  final List<String>? courseIds;
  final DateTime? lastActive;
  final DateTime? lastLogin;
  final DateTime createdDate;
  final DateTime updatedDate;

  MentorModel({
    required this.tutorId,
    required this.name,
    this.username,
    required this.email,
     this.phone,
     required this.isblocked,
    this.image,
    this.infoSubmitted = false,
     this.bio,
    required this.emailVerified,
     this.isVerified,
     this.status,
     this.courseIds,
     this.lastActive,
     this.lastLogin,
    required this.createdDate,
    required this.updatedDate,
  });

  // From JSON
 factory MentorModel.fromJson(Map<String, dynamic> json) {
  return MentorModel(
    tutorId: json['tutor_id'] ?? '',
    name: json['full_name'] ?? '',
    email: json['email'] ?? '',
    username: json['username'],
    phone: json['phone'],
    image: json['profile_image'],
    bio: json['bio'],
    emailVerified: json['email_verified'] ?? false,
    isVerified: json['is_verified'],
    isblocked: json['is_blocked'] ?? false,
    status: json['status'],
    courseIds: (json['courses'] as List<dynamic>?)?.cast<String>(),
    lastActive: (json['lastActive'] as Timestamp?)?.toDate(),
    lastLogin: (json['lastLogin'] as Timestamp?)?.toDate(),
    createdDate: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    updatedDate: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
  );
}

  //  To JSON
 Map<String, dynamic> toJson() {
  return {
    'tutor_id': tutorId,
    'full_name': name,
    'email': email,
    'username': username,
    'phone': phone,
    'profile_image': image,
    'bio': bio,
    'email_verified': emailVerified,
    'is_verified': isVerified,
    'status': status,
    'courses': courseIds,
    'lastActive': lastActive,
    'lastLogin': lastLogin,
    'createdAt': createdDate,
    'updatedAt': updatedDate,
  };
}


  //  From Entity
  factory MentorModel.fromEntity(MentorEntity entity) {
    return MentorModel(
      tutorId: entity.tutorId,
      name: entity.name,
      username: entity.username, 
      email: entity.email,
      phone: entity.phone,
      image: entity.image,
      bio: entity.bio,
      emailVerified: entity.emailVerified,
      isVerified: entity.isVerified,
      status: entity.status,
      isblocked: entity.isblocked,
      courseIds: entity.courseIds,
      lastActive: entity.lastActive,
      lastLogin: entity.lastLogin,
      createdDate: entity.createdDate,
      updatedDate: entity.updatedDate,
    );
  }

  //  To Entity
  MentorEntity toEntity() {
    return MentorEntity(
      name: name,
      username: username,
      email: email,
      phone: phone,
      image: image,
      bio: bio,
      isblocked: isblocked,
      emailVerified: emailVerified,
      isVerified: isVerified ?? false,
      status: status,
      tutorId: tutorId,
      courseIds: courseIds,
      lastActive: lastActive,
      lastLogin: lastLogin,
      createdDate: createdDate,
      updatedDate: updatedDate,
    );
  }

  //  copyWith method
  MentorModel copyWith({
    String? userId,
    String? name,
    String? username,
    String? email,
    String? phone,
    String? image,
    String? bio,
    bool? infoSubmitted,
    bool? emailVerified,
    bool? isVerified,
    bool? isblocked,
    bool? status,
    String? tutorId,
    List<String>? courseIds,
    DateTime? lastActive,
    DateTime? lastLogin,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return MentorModel(
      tutorId: tutorId ?? this.tutorId,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      infoSubmitted: infoSubmitted ?? this.infoSubmitted,
      emailVerified: emailVerified ?? this.emailVerified,
      isblocked: isblocked ?? this.isblocked,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      courseIds: courseIds ?? this.courseIds,
      lastActive: lastActive ?? this.lastActive,
      lastLogin: lastLogin ?? this.lastLogin,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}
