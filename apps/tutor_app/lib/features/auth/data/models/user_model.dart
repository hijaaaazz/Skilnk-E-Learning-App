
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_app/features/auth/domain/entity/user.dart';

class UserModel {
  final String tutorId;
  final String? username;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String? bio;
  final bool infoSubmitted;
  final bool emailVerified;
  final bool? isVerified;
  final bool? status;
  final List<String>? courseIds;
  final DateTime? lastActive;
  final DateTime? lastLogin;
  final DateTime createdDate;
  final DateTime updatedDate;

  UserModel({
    required this.tutorId,
    required this.name,
    this.username,
    required this.email,
     this.phone,
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
 factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    tutorId: json['tutor_id'] ?? '',
    name: json['full_name'] ?? '',
    email: json['email'] ?? '',
    username: json['username'],
    phone: json['phone'],
    image: json['profile_image'],
    bio: json['bio'],
    emailVerified: json['email_verified'] ?? false,
    isVerified: json['is_verified'],
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
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
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
      
      courseIds: entity.courseIds,
      lastActive: entity.lastActive,
      lastLogin: entity.lastLogin,
      createdDate: entity.createdDate,
      updatedDate: entity.updatedDate,
    );
  }

  //  To Entity
  UserEntity toEntity() {
    return UserEntity(
      name: name,
      username: username,
      email: email,
      phone: phone,
      image: image,
      bio: bio,
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
  UserModel copyWith({
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
    bool? status,
    String? tutorId,
    List<String>? courseIds,
    DateTime? lastActive,
    DateTime? lastLogin,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return UserModel(
      tutorId: tutorId ?? this.tutorId,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      infoSubmitted: infoSubmitted ?? this.infoSubmitted,
      emailVerified: emailVerified ?? this.emailVerified,
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
