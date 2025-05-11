import 'package:tutor_app/features/courses/data/models/lecture_creation_req.dart';

class CourseCreationReq {
  final String? title;
  final bool? isPaid;
  final String? description;
  final String? categoryId;
  final int? price;
  final Duration? duration;
  final int? offerPercentage;
  final String? tutorId;
  final String? language;
  final String? level;
  final List<LectureCreationReq>? lectures;
  final String? courseThumbnail;

  const CourseCreationReq({
    this.title,
    this.description,
    this.isPaid,
    this.categoryId,
    this.duration,
    this.price,
    this.language,
    this.offerPercentage,
    this.tutorId,
    this.level,
    this.lectures,
    this.courseThumbnail,
  });

  CourseCreationReq copyWith({
    String? title,
    bool? isPaid,
    String? description,
    String? categoryId,
    int? price,
    Duration? duration,
    int? offerPercentage,
    String? tutorId,
    String? language,
    String? level,
    List<LectureCreationReq>? lectures,
    String? courseThumbnail,
  }) {
    return CourseCreationReq(
      title: title ?? this.title,
      isPaid: isPaid ?? this.isPaid,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      offerPercentage: offerPercentage ?? this.offerPercentage,
      tutorId: tutorId ?? this.tutorId,
      language: language ?? this.language,
      level: level ?? this.level,
      lectures: lectures ?? this.lectures,
      courseThumbnail: courseThumbnail ?? this.courseThumbnail,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isPaid': isPaid,
      'description': description,
      'categoryId': categoryId,
      'price': price,
      'duration': duration?.inSeconds,
      'offerPercentage': offerPercentage,
      'tutorId': tutorId,
      'language': language,
      'level': level,
      'lectures': lectures?.map((lecture) => lecture.toJson()).toList(),
      'courseThumbnail': courseThumbnail,
    };
  }
  
  factory CourseCreationReq.fromJson(Map<String, dynamic> json) {
    return CourseCreationReq(
      title: json['title'],
      isPaid: json['isPaid'],
      description: json['description'],
      categoryId: json['categoryId'],
      price: json['price'],
      duration: json['duration'] != null ? Duration(seconds: json['duration']) : null,
      offerPercentage: json['offerPercentage'],
      tutorId: json['tutorId'],
      language: json['language'],
      level: json['level'],
      lectures: json['lectures'] != null 
          ? (json['lectures'] as List).map((e) => 
              LectureCreationReq(
                title: e['title'],
                description: e['description'],
                videoUrl: e['videoUrl'],
                notesUrl: e['notesUrl'],
                duration: e['durationInSeconds'] != null ? Duration(seconds: e['durationInSeconds']) : null,
              )).toList() 
          : null,
      courseThumbnail: json['courseThumbnail'],
    );
  }
}