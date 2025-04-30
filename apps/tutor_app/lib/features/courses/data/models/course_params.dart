
class CourseParams {
  final String title;
  final String description;
  final String categoryId;
  final int price;
  final int offerPercentage;
  final String tutorId;
  final String level;
  final List<String> lessons;
  final String courseThumbnail;

  const CourseParams({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.price,
    required this.offerPercentage,
    required this.tutorId,
    required this.level,
    required this.lessons,
    required this.courseThumbnail,
  });

  @override
  List<Object> get props => [
        title,
        description,
        categoryId,
        price,
        offerPercentage,
        tutorId,
        level,
        lessons,
        courseThumbnail,
      ];
}