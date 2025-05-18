class CoursePreview{
  final String thumbnail;
  final String id;
  final String categoryname;
  final String courseTitle;
  final String price;
  final double averageRating;

  CoursePreview({
    required this.averageRating,
    required this.categoryname,
    required this.courseTitle,
    required this.price,
    required this.id,
    required this.thumbnail
  });

}