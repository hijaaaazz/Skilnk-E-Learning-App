import 'package:cloud_firestore/cloud_firestore.dart';

enum ActivityType { courseUpload, studentEnrollment, bannerUpdate, mentorRegistration }

class Activity {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final ActivityType type;
  final String adminId;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    required this.adminId,
  });

  Activity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? timestamp,
    ActivityType? type,
    String? adminId,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      adminId: adminId ?? this.adminId,
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      type: ActivityType.values.firstWhere(
        (type) => type.toString().split('.').last == json['type'],
        orElse: () => ActivityType.studentEnrollment,
      ),
      adminId: json['adminId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type.toString().split('.').last,
      'adminId': adminId,
    };
  }
}