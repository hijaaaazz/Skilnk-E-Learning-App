import 'package:tutor_app/features/courses/domain/entities/lecture_entity.dart';

class LectureModel {
  final String title;
  final String description;
  final String videoUrl;
  final String notesUrl;
  final int durationInSeconds;
  
  LectureModel({
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.notesUrl,
    required this.durationInSeconds,
  });
  
  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      notesUrl: json['notesUrl'] ?? '',
      durationInSeconds: json['durationInSeconds'] ?? json['duration'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'notesUrl': notesUrl,
      'durationInSeconds': durationInSeconds,
    };
  }
  
  LectureEntity toEntity() {
    return LectureEntity(
      title: title,
      description: description,
      videoUrl: videoUrl,
      notesUrl: notesUrl,
      durationInSeconds: durationInSeconds,
    );
  }
  factory LectureModel.fromEntity(LectureEntity entity) {
  return LectureModel(
    title: entity.title,
    description: entity.description,
    videoUrl: entity.videoUrl,
    notesUrl: entity.notesUrl,
    durationInSeconds: entity.durationInSeconds,
  );
}

}