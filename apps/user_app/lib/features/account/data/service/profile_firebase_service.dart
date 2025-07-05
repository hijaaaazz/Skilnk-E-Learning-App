import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import  'package:user_app/features/account/data/models/activity_model.dart';

abstract class FirebaseProfileService {
  Future<Either<String, String>> updateProfilePic(String userId, String imageUrl);
  Future<Either<String, String>> updateName(String userId, String newName);
  Future<Either<String, List<Activity>>> getRecentEnrollments(String userId);
}


class FirebaseProfileServiceImp extends FirebaseProfileService {
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<String, String>> updateProfilePic(String userId, String imageUrl) async {
    try {
      final user = _auth.currentUser;

      if (user == null || user.uid != userId) {
        return left("User not authenticated or ID mismatch");
      }

      // Step 1: Update Firebase Auth photoURL
      await user.updatePhotoURL(imageUrl);

      // Step 2: Update Firestore document
      await _users.doc(userId).update({
        'image': imageUrl,
      });

      return right("Profile picture updated successfully.");
    } catch (e) {
      return left("Failed to update profile picture: $e");
    }
  }
  
  @override
Future<Either<String, String>> updateName(String userId, String newName) async {
  try {
    final user = _auth.currentUser;

    if (user == null || user.uid != userId) {
      return left("User not authenticated or ID mismatch");
    }

    // Step 1: Update Firebase Auth displayName
    await user.updateDisplayName(newName);

    // Step 2: Update Firestore
    await _users.doc(userId).update({
      'name': newName,
    });

    // Step 3: Read updated name
    final snapshot = await _users.doc(userId).get();
    final data = snapshot.data() as Map<String, dynamic>?;
    final updatedName = data?['name'] ?? newName;

    return right(updatedName);
  } catch (e) {
    return left("Failed to update name: $e");
  }
}


@override
Future<Either<String, List<Activity>>> getRecentEnrollments(String userId) async {
  try {
    log('📥 Fetching recent enrollments for user: $userId');

    final QuerySnapshot enrollmentSnapshot = await FirebaseFirestore.instance
        .collection('enrollments')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(5)
        .get();

    log('✅ Enrollment documents found: ${enrollmentSnapshot.docs.length}');

    List<Activity> activities = [];

    for (var doc in enrollmentSnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final courseId = data['courseId'];
      final amount = data['amount'] ?? 0;
      final timestamp = (data['timestamp'] as Timestamp).toDate();

      // Format date & time
      final formattedDate = "${timestamp.day} ${_monthName(timestamp.month)} ${timestamp.year}";
      final formattedTime = _formatTime(timestamp);

      // Get course title
      String courseTitle = courseId;
      try {
        final courseSnapshot = await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .get();
        if (courseSnapshot.exists) {
          final courseData = courseSnapshot.data() as Map<String, dynamic>;
          courseTitle = courseData['title'] ?? courseId;
        }
      } catch (e) {
        log('⚠ Failed to fetch course title for $courseId: $e');
      }

      final activity = Activity(
        id: data['purchaseId'] ?? doc.id,
        title: courseTitle,
        description: amount == 0
            ? "You enrolled in this course for free on $formattedDate at $formattedTime"
            : "You enrolled in this course for ₹$amount on $formattedDate at $formattedTime",
        timestamp: timestamp,
        type: 'enrollment',
      );

      log('📝 Activity: ${activity.title} | ${activity.description}');
      activities.add(activity);
    }

    return right(activities);
  } catch (e, stackTrace) {
    log('❌ Error fetching enrollments: $e');
    log('📍 StackTrace: $stackTrace');
    return left("Failed to fetch enrollments: $e");
  }
}

String _monthName(int month) {
  const months = [
    '', // index 0 unused
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  return months[month];
}

String _formatTime(DateTime time) {
  final hour = time.hour > 12 ? time.hour - 12 : time.hour == 0 ? 12 : time.hour;
  final amPm = time.hour >= 12 ? 'PM' : 'AM';
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute $amPm';
}

}
