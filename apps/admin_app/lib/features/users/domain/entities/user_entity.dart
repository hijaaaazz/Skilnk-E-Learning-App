class UserEntity {
  final String userId;
  final String name;
  final String email;
  final String? image;
  final bool emailVerified;
  final bool isBlocked;
  final DateTime? lastLogin;
  final DateTime createdAt;

  UserEntity({
    required this.userId,
    required this.name,
    required this.email,
    this.image,
    required this.emailVerified,
    required this.isBlocked,
    this.lastLogin,
    required this.createdAt,
  });

  UserEntity copyWith({
    String? userId,
    String? name,
    String? email,
    String? image,
    bool? emailVerified,
    bool? isBlocked,
    DateTime? lastLogin,
    DateTime? createdAt,
  }) {
    return UserEntity(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      emailVerified: emailVerified ?? this.emailVerified,
      isBlocked: isBlocked ?? this.isBlocked,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
