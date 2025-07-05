class MentorEntity {
  final String tutorId;
  final String? username;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String? bio;
  final bool isblocked;
  final bool emailVerified;
  final bool isVerified;
  final bool? status;
  final List<String>? courseIds;
  final List<String>? categories;
  final DateTime? lastActive;
  final DateTime? lastLogin;
  final DateTime createdDate;
  final DateTime updatedDate;

  MentorEntity({
    required this.tutorId,
    required this.name,
    this.username,
    required this.email,
    this.phone,
    this.image,
    this.bio,
    required this.isblocked,
    required this.emailVerified,
    required this.isVerified,
    this.status,
    this.courseIds,
    this.categories,
    this.lastActive,
    this.lastLogin,
    required this.createdDate,
    required this.updatedDate,
  });

  MentorEntity copyWith({
    String? tutorId,
    String? username,
    String? name,
    String? email,
    String? phone,
    String? image,
    String? bio,
    bool? isblocked,
    bool? emailVerified,
    bool? isVerified,
    bool? status,
    List<String>? courseIds,
    List<String>? categories,
    DateTime? lastActive,
    DateTime? lastLogin,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return MentorEntity(
      tutorId: tutorId ?? this.tutorId,
      username: username ?? this.username,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      isblocked: isblocked ?? this.isblocked,
      emailVerified: emailVerified ?? this.emailVerified,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      courseIds: courseIds ?? this.courseIds,
      categories: categories ?? this.categories,
      lastActive: lastActive ?? this.lastActive,
      lastLogin: lastLogin ?? this.lastLogin,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}
