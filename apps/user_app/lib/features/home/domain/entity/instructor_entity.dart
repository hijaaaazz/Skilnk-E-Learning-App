class MentorEntity {
  final String name;
  final String imageUrl;
  final String id;
  final List<String> specialization;
  final String bio;
  final List<String> sessions;
  
  MentorEntity({
    required this.id, 
    required this.imageUrl,
    required this.name,
    required this.specialization,
    required this.bio,
    required this.sessions,
  });
}
