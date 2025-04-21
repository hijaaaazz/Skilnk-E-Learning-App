class UserEntity {
  final String userId;
  final String name;
  final String email;
  final String? image;
  final bool emailVerified;
  final DateTime createdDate;

  UserEntity({
    required this.userId,
    required this.email,
     this.image,
    required this.name,
    required this.emailVerified,
    required this.createdDate
  });
}