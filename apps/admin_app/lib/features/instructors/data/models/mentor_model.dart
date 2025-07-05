import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MentorModel {
  final String tutorId;
  final String? username;
  final String name;
  final String nameLower;
  final String email;
  final String? phone;
  final String? profileImage;
  final String? bio;
  final bool emailVerified;
  final bool? isVerified;
  final bool? status;
  final List<String>? courseIds;
  final List<String>? categories;
  final DateTime? lastActive;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final DateTime updatedAt;

  MentorModel({
    required this.tutorId,
    required this.name,
    required this.nameLower,
    this.username,
    required this.email,
    this.phone,
    this.profileImage,
    this.bio,
    required this.emailVerified,
    this.isVerified,
    this.status,
    this.courseIds,
    this.categories,
    this.lastActive,
    this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  // From Firebase JSON
  factory MentorModel.fromJson(Map<String, dynamic> json) {
    return MentorModel(
      tutorId: json['tutor_id'] ?? '',
      name: json['full_name'] ?? '',
      nameLower: json['name_lower'] ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      phone: json['phone'],
      profileImage: json['profile_image'],
      bio: json['bio'],
      emailVerified: json['email_verified'] ?? false,
      isVerified: json['is_verified'],
      status: json['status'],
      courseIds: (json['courses'] as List<dynamic>?)?.cast<String>(),
      categories: (json['categories'] as List<dynamic>?)?.cast<String>(),
      lastActive: (json['lastActive'] as Timestamp?)?.toDate(),
      lastLogin: (json['lastLogin'] as Timestamp?)?.toDate(),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // To Firebase JSON
  Map<String, dynamic> toJson() {
    return {
      'tutor_id': tutorId,
      'full_name': name,
      'name_lower': nameLower,
      'email': email,
      'username': username,
      'phone': phone,
      'profile_image': profileImage,
      'bio': bio,
      'email_verified': emailVerified,
      'is_verified': isVerified,
      'status': status,
      'courses': courseIds,
      'categories': categories,
      'lastActive': lastActive != null ? Timestamp.fromDate(lastActive!) : null,
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // From Entity
  factory MentorModel.fromEntity(MentorEntity entity) {
    return MentorModel(
      tutorId: entity.tutorId,
      name: entity.name,
      nameLower: entity.name.toLowerCase(),
      username: entity.username,
      email: entity.email,
      phone: entity.phone,
      profileImage: entity.image,
      bio: entity.bio,
      emailVerified: entity.emailVerified,
      isVerified: entity.isVerified,
      status: entity.status,
      courseIds: entity.courseIds,
      categories: entity.categories,
      lastActive: entity.lastActive,
      lastLogin: entity.lastLogin,
      createdAt: entity.createdDate,
      updatedAt: entity.updatedDate,
    );
  }

  // To Entity
  MentorEntity toEntity() {
    return MentorEntity(
      name: name,
      username: username,
      email: email,
      phone: phone,
      image: profileImage,
      bio: bio,
      isblocked: false, // Default value, update based on your needs
      emailVerified: emailVerified,
      isVerified: isVerified ?? false,
      status: status,
      tutorId: tutorId,
      courseIds: courseIds,
      categories: categories,
      lastActive: lastActive,
      lastLogin: lastLogin,
      createdDate: createdAt,
      updatedDate: updatedAt,
    );
  }

  // copyWith method
  MentorModel copyWith({
    String? tutorId,
    String? name,
    String? nameLower,
    String? username,
    String? email,
    String? phone,
    String? profileImage,
    String? bio,
    bool? emailVerified,
    bool? isVerified,
    bool? status,
    List<String>? courseIds,
    List<String>? categories,
    DateTime? lastActive,
    DateTime? lastLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MentorModel(
      tutorId: tutorId ?? this.tutorId,
      name: name ?? this.name,
      nameLower: nameLower ?? this.nameLower,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      emailVerified: emailVerified ?? this.emailVerified,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      courseIds: courseIds ?? this.courseIds,
      categories: categories ?? this.categories,
      lastActive: lastActive ?? this.lastActive,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
