import 'dart:convert';

import 'package:admin_app/features/users/domain/entities/user_entity.dart';

class UserModel {
  final String name;
  final String email;
  final String password;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
  });

  // Convert UserModel to a Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Create a UserModel instance from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }

  // Convert UserModel to JSON string
  String toJson() => json.encode(toMap());

  // Create a UserModel instance from a JSON string
  factory UserModel.fromJson(String source) {
    return UserModel.fromMap(json.decode(source));
  }
}


// Extension on UserModel to convert it to UserEntity
extension UserXModel on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      name: name,
      email: email,
      password: password,
    );
  }
}
