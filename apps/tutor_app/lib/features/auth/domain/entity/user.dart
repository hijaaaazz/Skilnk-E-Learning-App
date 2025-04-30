class UserEntity {
  final String tutorId;
  final String name;
  final String? username;
  final String email;
  final String? phone;
  final String? image;
  final String? bio;
  final bool emailVerified;
  final bool isVerified;
  final bool? status;
  final List<String>? courseIds;
  final DateTime? lastActive;
  final DateTime? lastLogin;
  final DateTime createdDate;
  final DateTime updatedDate;

  UserEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.username,
    this.image,
    required this.bio,
    required this.emailVerified,
    required this.isVerified,
    required this.status,
    required this.tutorId,
    required this.courseIds,
    required this.lastActive,
    required this.lastLogin,
    required this.createdDate,
    required this.updatedDate,
  });
}
