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
  final bool? isBlocked;
  final List<String>? courseIds;
  final List<String>? categories;
  final List<String>? savedCourses;
  final DateTime? lastActive;
  final DateTime? lastLogin;
  final DateTime createdDate;
  final DateTime updatedDate;

  UserEntity({
    required this.tutorId,
    required this.name,
    required this.email,
    this.username,
    this.phone,
    this.image,
    this.bio,
    required this.emailVerified,
    required this.isVerified,
    this.status,
    this.isBlocked,
    this.courseIds,
    this.categories,
    this.savedCourses,
    this.lastActive,
    this.lastLogin,
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
    bool? isBlocked,
    List<String>? courseIds,
    List<String>? categories,
    List<String>? savedCourses,
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
      isBlocked: isBlocked ?? this.isBlocked,
      courseIds: courseIds ?? this.courseIds,
      categories: categories ?? this.categories,
      savedCourses: savedCourses ?? this.savedCourses,
      lastActive: lastActive ?? this.lastActive,
      lastLogin: lastLogin ?? this.lastLogin,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}