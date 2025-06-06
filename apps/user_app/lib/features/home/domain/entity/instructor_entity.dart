class MentorEntity {
  final String name;
  final String imageUrl;
  final String id;
  final String specialization;
  final double rating;
  final List<String> sessions;
  
  MentorEntity({
    required this.id, 
    required this.imageUrl,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.sessions,
  });
}
