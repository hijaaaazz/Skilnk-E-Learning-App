class LectureCreationReq {
  String? title;
  String? description;
  String? videoUrl;
  String? notesUrl;
  Duration? duration;

  LectureCreationReq({
    this.title,
    this.description,
    this.videoUrl,
    this.notesUrl,
    this.duration,
  });

  LectureCreationReq copyWith({
    String? title,
    String? description,
    String? videoUrl,
    String? notesUrl,
    Duration? duration,
  }) {
    return LectureCreationReq(
      title: title ?? this.title,
      description: description ?? this.description,
      videoUrl: videoUrl ?? this.videoUrl,
      notesUrl: notesUrl ?? this.notesUrl,
      duration: duration ?? this.duration,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'notesUrl': notesUrl,
      'durationInSeconds': duration?.inSeconds,
    };
  }
}