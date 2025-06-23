class UpdateProgressParam {
  final String userId;
  final String courseId;
  final int lectureIndex;
  final bool isCompleted;
  final int watchedDurationSeconds;
  final DateTime lastAccessedAt;

  UpdateProgressParam({
    required this.userId,
    required this.courseId,
    required this.lectureIndex,
    required this.isCompleted,
    required this.watchedDurationSeconds,
    required this.lastAccessedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'courseId': courseId,
      'lectureIndex': lectureIndex,
      'isCompleted': isCompleted,
      'watchedDurationSeconds': watchedDurationSeconds,
      'lastAccessedAt': lastAccessedAt.toIso8601String(),
    };
  }
}
