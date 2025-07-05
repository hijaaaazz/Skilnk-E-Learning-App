import  'package:user_app/features/auth/domain/entity/user.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String? image;
  final bool emailVerified;
  final DateTime createdDate;
  final List<String> savedCourses;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.image,
    required this.emailVerified,
    required this.createdDate,
    required this.savedCourses,
  });

  // ✅ From JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
  return UserModel(
    userId: json['userId'] ?? '',
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    image: json['image'],
    emailVerified: json['emailVerified'] ?? false,
    createdDate: DateTime.parse(json['createdDate'] ?? DateTime.now().toIso8601String()),
    savedCourses: List<String>.from(json['savedCourses'] ?? []),
  );
}


  // ✅ To JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'image': image,
      'emailVerified': emailVerified,
      'createdAt': createdDate.toIso8601String(),
      'savedCourses' : savedCourses,
    };
  }

  // ✅ From Entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      image: entity.image,
      emailVerified: entity.emailVerified,
      createdDate: entity.createdDate,
      savedCourses: entity.savedCourses
    );
  }

  // ✅ To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      image: image,
      emailVerified: emailVerified,
      createdDate: createdDate,
      savedCourses: savedCourses
    );
  }

  // ✅ copyWith method
  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? image,
    bool? emailVerified,
    DateTime? createdDate,
    List<String>? savedCourses,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      emailVerified: emailVerified ?? this.emailVerified,
      createdDate: createdDate ?? this.createdDate,
      savedCourses: savedCourses ?? this.savedCourses
    );
  }
}
