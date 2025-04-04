import 'dart:convert';

class UserEntity {
  final String userid;
  final String name;
  final String email;
  final String password;

  UserEntity({
    this.userid = "1122",
    required this.name,
    required this.email,
    required this.password,
  });

}
