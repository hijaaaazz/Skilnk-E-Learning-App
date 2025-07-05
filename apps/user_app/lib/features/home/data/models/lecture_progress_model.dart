import  'package:user_app/features/home/domain/entity/lecture_entity.dart';


class LectureProgressModel {
  final Duration watchedDuration;
  final bool isCompleted;
  final bool isLocked;
  final int index;
  final LectureEntity lecture;

  const LectureProgressModel({
    required this.watchedDuration,
    required this.isCompleted,
    required this.isLocked,
    required this.index,
    required this.lecture,
  });

  factory LectureProgressModel.fromJson(Map<String, dynamic> json) {
    return LectureProgressModel(
      watchedDuration: Duration(seconds: json['watchedDurationSeconds'] ?? 0),
      isCompleted: json['isCompleted'] ?? false,
      isLocked: json['isLocked'] ?? true,
      index: json['index'] ?? 0,
      lecture: LectureEntity(
        title: json['lecture']['title'] ?? '',
        description: json['lecture']['description'] ?? '',
        videoUrl: json['lecture']['videoUrl'] ?? '',
        notesUrl: json['lecture']['notesUrl'] ?? '',
        durationInSeconds: json['lecture']['durationInSeconds'] ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'watchedDurationSeconds': watchedDuration.inSeconds,
      'isCompleted': isCompleted,
      'isLocked': isLocked,
      'index': index,
      'lecture': {
        'title': lecture.title,
        'description': lecture.description,
        'videoUrl': lecture.videoUrl,
        'notesUrl': lecture.notesUrl,
        'durationInSeconds': lecture.durationInSeconds,
      },
    };
  }

  double get progressPercentage {
    if (lecture.durationInSeconds == 0) return 0.0;
    return (watchedDuration.inSeconds / lecture.durationInSeconds).clamp(0.0, 1.0);
  }

  LectureProgressModel copyWith({
    Duration? watchedDuration,
    bool? isCompleted,
    bool? isLocked,
    int? index,
    LectureEntity? lecture,
  }) {
    return LectureProgressModel(
      watchedDuration: watchedDuration ?? this.watchedDuration,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      index: index ?? this.index,
      lecture: lecture ?? this.lecture,
    );
  }
}
