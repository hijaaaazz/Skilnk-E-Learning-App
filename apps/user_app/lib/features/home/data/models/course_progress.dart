import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/features/home/data/models/lecture_progress_model.dart';
import 'package:user_app/features/home/domain/entity/lecture_entity.dart';

class CourseProgressModel {
  final String id;
  final String userId;
  final String courseId;
  final String courseTitle;
  final String courseThumbnail;
  final List<LectureProgressModel> lectures;
  final double overallProgress;
  final int completedLectures;
  final DateTime enrolledAt;
  final DateTime lastAccessedAt;

  const CourseProgressModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.courseTitle,
    required this.courseThumbnail,
    required this.lectures,
    required this.overallProgress,
    required this.completedLectures,
    required this.enrolledAt,
    required this.lastAccessedAt,
  });

  factory CourseProgressModel.fromJson(Map<String, dynamic> json, String docId) {
    return CourseProgressModel(
      id: docId,
      userId: json['userId'] ?? '',
      courseId: json['courseId'] ?? '',
      courseTitle: json['courseTitle'] ?? '',
      courseThumbnail: json['courseThumbnail'] ?? '',
      lectures: _parseLectureProgress(json['lectures']),
      overallProgress: (json['overallProgress'] ?? 0.0).toDouble(),
      completedLectures: json['completedLectures'] ?? 0,
      enrolledAt: _parseTimestamp(json['enrolledAt']),
      lastAccessedAt: _parseTimestamp(json['lastAccessedAt']),
    );
  }

  static List<LectureProgressModel> _parseLectureProgress(dynamic data) {
    if (data == null) return [];

    try {
      return (data as List<dynamic>).map((lectureData) {
        if (lectureData is Map<String, dynamic>) {
          return LectureProgressModel.fromJson(lectureData);
        }
        // Fallback for invalid data
        return LectureProgressModel(
          watchedDuration: const Duration(),
          isCompleted: false,
          isLocked: true,
          index: 0,
          lecture: const LectureEntity(
            title: '',
            description: '',
            videoUrl: '',
            notesUrl: '',
            durationInSeconds: 0,
          ),
        );
      }).toList();
    } catch (e) {
      log('[CourseProgressModel] Error parsing lecture progress: $e');
      return [];
    }
  }

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'courseId': courseId,
      'courseTitle': courseTitle,
      'courseThumbnail': courseThumbnail,
      'lectures': lectures.map((lecture) => lecture.toJson()).toList(),
      'overallProgress': overallProgress,
      'completedLectures': completedLectures,
      'enrolledAt': Timestamp.fromDate(enrolledAt),
      'lastAccessedAt': Timestamp.fromDate(lastAccessedAt),
    };
  }

  CourseProgressModel copyWith({
    String? id,
    String? userId,
    String? courseId,
    String? courseTitle,
    String? courseThumbnail,
    List<LectureProgressModel>? lectures,
    double? overallProgress,
    int? completedLectures,
    DateTime? enrolledAt,
    DateTime? lastAccessedAt,
  }) {
    return CourseProgressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      courseTitle: courseTitle ?? this.courseTitle,
      courseThumbnail: courseThumbnail ?? this.courseThumbnail,
      lectures: lectures ?? this.lectures,
      overallProgress: overallProgress ?? this.overallProgress,
      completedLectures: completedLectures ?? this.completedLectures,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
    );
  }
}