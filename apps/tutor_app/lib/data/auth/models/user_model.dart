
import 'package:tutor_app/domain/auth/entity/user.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String image;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.image,
  });

  // ✅ From JSON (Firebase or Hive or local)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // ✅ To JSON (for saving in Firebase or Hive or local)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'image': image,
    };
  }

  // ✅ From Entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      image: entity.image,
    );
  }

  // ✅ To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      image: image,
    );
  }
}
