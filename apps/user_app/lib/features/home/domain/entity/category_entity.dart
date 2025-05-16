class CategoryEntity {
  final String id;
  final String title;
  final String description;
  final List<String> courses;
  

  CategoryEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.courses,
  
  });

  CategoryEntity copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? courses,
    bool? isVisible,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      courses: courses ?? this.courses,
     
    );
  }
}
