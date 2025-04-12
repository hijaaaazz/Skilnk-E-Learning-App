import 'dart:convert';

import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';

class MentorModel {
  final String name;
  final String email;
  final String password;

  MentorModel({
    required this.name,
    required this.email,
    required this.password,
  });

  // Convert MentorModel to a Map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };
  }

  // Create a MentorModel instance from a Map
  factory MentorModel.fromMap(Map<String, dynamic> map) {
  return MentorModel(
    name: map['name'] ?? '',
    email: map['email'] ?? '',
    password: map['password'] ?? '',
  );
}


  // Convert MentorModel to JSON string
  String toJson() => json.encode(toMap());

  // Create a MentorModel instance from a JSON string
  factory MentorModel.fromJson(String source) {
    return MentorModel.fromMap(json.decode(source));
  }
}


// Extension on MentorModel to convert it to MentorEntity
extension UserXModel on MentorModel {
  MentorEntity toEntity() {
    return MentorEntity(
      name: name,
      email: email,
      password: password,
    );
  }
}
