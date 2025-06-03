
// Models for Firestore serialization
class LectureProgressModel {
  final String id;
  final String title;
  final Duration duration;
  final Duration watchedDuration;
  final bool isCompleted;
  final bool isLocked;
  final String videoUrl;
  final int lectureNumber;

  const LectureProgressModel({
    required this.id,
    required this.title,
    required this.duration,
    required this.watchedDuration,
    required this.isCompleted,
    required this.isLocked,
    required this.videoUrl,
    required this.lectureNumber,
  });

  factory LectureProgressModel.fromJson(Map<String, dynamic> json) {
    return LectureProgressModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      duration: Duration(seconds: json['durationSeconds'] ?? 0),
      watchedDuration: Duration(seconds: json['watchedDurationSeconds'] ?? 0),
      isCompleted: json['isCompleted'] ?? false,
      isLocked: json['isLocked'] ?? true,
      videoUrl: json['videoUrl'] ?? '',
      lectureNumber: json['lectureNumber'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'durationSeconds': duration.inSeconds,
      'watchedDurationSeconds': watchedDuration.inSeconds,
      'isCompleted': isCompleted,
      'isLocked': isLocked,
      'videoUrl': videoUrl,
      'lectureNumber': lectureNumber,
    };
  }

  double get progressPercentage {
    if (duration.inSeconds == 0) return 0.0;
    return (watchedDuration.inSeconds / duration.inSeconds).clamp(0.0, 1.0);
  }

   LectureProgressModel copyWith({
    String? id,
    String? title,
    Duration? duration,
    Duration? watchedDuration,
    bool? isCompleted,
    bool? isLocked,
    String? videoUrl,
    int? lectureNumber,
  }) {
    return LectureProgressModel(
      id: id ?? this.id,
      title: title ?? this.title,
      duration: duration ?? this.duration,
      watchedDuration: watchedDuration ?? this.watchedDuration,
      isCompleted: isCompleted ?? this.isCompleted,
      isLocked: isLocked ?? this.isLocked,
      videoUrl: videoUrl ?? this.videoUrl,
      lectureNumber: lectureNumber ?? this.lectureNumber,
    );
  }
}
