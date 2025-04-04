class User {
  final String id;
  final String email;
  final bool isBlocked;

  User({
    required this.id,
    required this.email,
    required this.isBlocked,
  });

  bool canLogin() {
    return !isBlocked;
  }
}
