class StudentEntity {
  final String name;
  final String imageUrl;
  final String id;
  final String specialization;
  final double rating;
  final List<String> sessions;
  
  StudentEntity({
    required this.id, 
    required this.imageUrl,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.sessions,
  });

factory StudentEntity.fromJson(Map<String, dynamic> json, String id) {
  return StudentEntity(
    id: id,
    name: json['name'] as String? ?? '',
    imageUrl: json['image'] as String? ?? '',
    specialization: json['specialization'] as String? ?? '',
    rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    sessions: List<String>.from(json['sessions'] ?? []),
  );
}
}