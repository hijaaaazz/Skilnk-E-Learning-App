class LectureDetail {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final String notesUrl;
  final Duration duration;
  final int lectureNumber;
  final String courseId;
  final String courseTitle;
  final bool hasNextLecture;
  final bool hasPreviousLecture;
  final String? nextLectureId;
  final String? previousLectureId;
  final List<LectureNote> notes;
  final bool isDownloadable;
  final bool isDownloaded;

  const LectureDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.notesUrl,
    required this.duration,
    required this.lectureNumber,
    required this.courseId,
    required this.courseTitle,
    required this.hasNextLecture,
    required this.hasPreviousLecture,
    this.nextLectureId,
    this.previousLectureId,
    required this.notes,
    required this.isDownloadable,
    required this.isDownloaded,
  });
}

class LectureNote {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;

  const LectureNote({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });
}