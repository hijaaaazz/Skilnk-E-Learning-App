class SaveCourseParams {
  final String userId;
  final String courseId;
  final bool isSave;

  SaveCourseParams({
    required this.courseId,
    required this.userId,
    required this.isSave

  });
}