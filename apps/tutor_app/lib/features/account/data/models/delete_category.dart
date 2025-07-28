import 'package:tutor_app/features/courses/data/models/category_model.dart';

class DeleteCategoryParams{
  final CategoryModel category;
  final String userId;

  DeleteCategoryParams({
    required this.category,
    required this.userId
  });
}