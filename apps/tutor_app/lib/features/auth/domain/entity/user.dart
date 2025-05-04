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

  UserEntity copyWith({
  String? tutorId,
  String? name,
  String? username,
  String? email,
  String? phone,
  String? image,
  String? bio,
  bool? emailVerified,
  bool? isVerified,
  bool? status,
  List<String>? courseIds,
  DateTime? lastActive,
  DateTime? lastLogin,
  DateTime? createdDate,
  DateTime? updatedDate,
}) {
  return UserEntity(
    tutorId: tutorId ?? this.tutorId,
    name: name ?? this.name,
    username: username ?? this.username,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    image: image ?? this.image,
    bio: bio ?? this.bio,
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
