class MentorEntity {
  final String tutorId;
  final String name;
  final String? username;
  final String email;
  final String? phone;
  final String? image;
  final String? bio;
  final bool emailVerified;
  final bool isblocked;
  final bool isVerified;
  final bool? status;
  final List<String>? courseIds;
  final DateTime? lastActive;
  final DateTime? lastLogin;
  final DateTime createdDate;
  final DateTime updatedDate;

  MentorEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.username,
    required this.isblocked,
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

  MentorEntity copyWith({
    String? name,
    String? email,
    String? phone,
    String? username,
    bool? isblocked,
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
    return MentorEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      isblocked: isblocked ?? this.isblocked,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      emailVerified: emailVerified ?? this.emailVerified,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      tutorId: tutorId,
      courseIds: courseIds ?? this.courseIds,
      lastActive: lastActive ?? this.lastActive,
      lastLogin: lastLogin ?? this.lastLogin,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }
}
