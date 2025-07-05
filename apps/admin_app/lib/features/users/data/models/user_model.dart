import 'dart:convert';
import 'package:admin_app/features/users/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String? image;
  final bool emailVerified;
  final bool isBlocked;
  final DateTime? lastLogin;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.image,
    required this.emailVerified,
    required this.isBlocked,
    this.lastLogin,
    required this.createdAt,
  });

  // Convert UserModel to a Map for Firebase
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'email': email,
      'image': image,
      'emailVerified': emailVerified,
      'isBlocked': isBlocked,
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create a UserModel instance from Firebase Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      image: map['image'],
      emailVerified: map['emailVerified'] ?? false,
      isBlocked: map['isBlocked'] ?? false,
      lastLogin: (map['lastLogin'] as Timestamp?)?.toDate(),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert UserModel to JSON string
  String toJson() => json.encode(toMap());

  // Create a UserModel instance from a JSON string
  factory UserModel.fromJson(String source) {
    return UserModel.fromMap(json.decode(source));
  }

  // From Entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      image: entity.image,
      emailVerified: entity.emailVerified,
      isBlocked: entity.isBlocked,
      lastLogin: entity.lastLogin,
      createdAt: entity.createdAt,
    );
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      image: image,
      emailVerified: emailVerified,
      isBlocked: isBlocked,
      lastLogin: lastLogin,
      createdAt: createdAt,
    );
  }

  // copyWith method
  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? image,
    bool? emailVerified,
    bool? isBlocked,
    DateTime? lastLogin,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      emailVerified: emailVerified ?? this.emailVerified,
      isBlocked: isBlocked ?? this.isBlocked,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
