


class LectureEntity {
  final String title;
  final String description;
  final String videoUrl;
  final String notesUrl;
  final int durationInSeconds;
  
  
  const LectureEntity({
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.notesUrl,
    required this.durationInSeconds,
  });
  
  Duration get duration => Duration(seconds: durationInSeconds);
}