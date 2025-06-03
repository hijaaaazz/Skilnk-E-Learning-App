
// Abstract service interface
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_app/features/home/data/models/course_progress.dart';
import 'package:user_app/features/home/data/models/lecture_model.dart';
import 'package:user_app/features/home/data/models/lecture_progress_model.dart';

abstract class CourseProgressService {
  Future<void> createCourseProgress({
    required String userId,
    required String courseId,
    required String courseTitle,
    required String courseThumbnail,
    required List<LectureModel> lectures,
  });

  Future<CourseProgressModel?> getCourseProgress({
    required String userId,
    required String courseId,
  });

  Future<void> updateLectureProgress({
    required String userId,
    required String courseId,
    required String lectureId,
    required Duration watchedDuration,
    bool? isCompleted,
  });

  Future<List<CourseProgressModel>> getUserCourseProgresses(String userId);
}

// Implementation
class CourseProgressServiceImpl extends CourseProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'course_progress';

  @override
  Future<void> createCourseProgress({
    required String userId,
    required String courseId,
    required String courseTitle,
    required String courseThumbnail,
    required List<LectureModel> lectures,
  }) async {
    try {
      log('[CourseProgressService] Creating progress for course: $courseId, user: $userId');

      // Check if progress already exists
      final existingProgress = await getCourseProgress(
        userId: userId,
        courseId: courseId,
      );

      if (existingProgress != null) {
        log('[CourseProgressService] Course progress already exists, skipping creation');
        return;
      }

      // Convert lectures to progress models
      final lectureProgresses = lectures.asMap().entries.map((entry) {
        final index = entry.key;
        final lecture = entry.value;
        
        return LectureProgressModel(
          id:  'lecture_$index',
          title: lecture.title,
          duration: Duration(seconds: lecture.durationInSeconds),
          watchedDuration: const Duration(),
          isCompleted: false,
          isLocked: index > 0, // First lecture is unlocked, rest are locked
          videoUrl: lecture.videoUrl,
          lectureNumber: index + 1,
        );
      }).toList();

      final progressModel = CourseProgressModel(
        id: '',
        userId: userId,
        courseId: courseId,
        courseTitle: courseTitle,
        courseThumbnail: courseThumbnail,
        lectures: lectureProgresses,
        overallProgress: 0.0,
        completedLectures: 0,
        enrolledAt: DateTime.now(),
        lastAccessedAt: DateTime.now(),
      );

      // Generate document ID
      final docRef = _firestore.collection(_collectionName).doc();
      
      await docRef.set(progressModel.toJson());
      
      log('[CourseProgressService] Course progress created successfully with ID: ${docRef.id}');
    } catch (e, stackTrace) {
      log('[CourseProgressService] Error creating course progress: $e');
      log('[CourseProgressService] Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<CourseProgressModel?> getCourseProgress({
    required String userId,
    required String courseId,
  }) async {
    try {
      log('[CourseProgressService] Fetching progress for course: $courseId, user: $userId');

      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        log('[CourseProgressService] No progress found');
        return null;
      }

      final doc = querySnapshot.docs.first;
      final progress = CourseProgressModel.fromJson(doc.data(), doc.id);
      
      log('[CourseProgressService] Progress fetched successfully');
      return progress;
    } catch (e) {
      log('[CourseProgressService] Error fetching course progress: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateLectureProgress({
    required String userId,
    required String courseId,
    required String lectureId,
    required Duration watchedDuration,
    bool? isCompleted,
  }) async {
    try {
      log('[CourseProgressService] Updating lecture progress: $lectureId');

      final progress = await getCourseProgress(
        userId: userId,
        courseId: courseId,
      );

      if (progress == null) {
        throw Exception('Course progress not found');
      }

      // Find and update the specific lecture
      final updatedLectures = progress.lectures.map((lecture) {
        if (lecture.id == lectureId) {
          return LectureProgressModel(
            id: lecture.id,
            title: lecture.title,
            duration: lecture.duration,
            watchedDuration: watchedDuration,
            isCompleted: isCompleted ?? lecture.isCompleted,
            isLocked: lecture.isLocked,
            videoUrl: lecture.videoUrl,
            lectureNumber: lecture.lectureNumber,
          );
        }
        return lecture;
      }).toList();

      // Unlock next lecture if current is completed
      final currentLectureIndex = updatedLectures.indexWhere((l) => l.id == lectureId);
      if (currentLectureIndex != -1 && 
          isCompleted == true && 
          currentLectureIndex + 1 < updatedLectures.length) {
        updatedLectures[currentLectureIndex + 1] = updatedLectures[currentLectureIndex + 1].copyWith(
          isLocked: false,
        );
      }

      // Calculate overall progress
      final completedCount = updatedLectures.where((l) => l.isCompleted).length;
      final overallProgress = updatedLectures.isEmpty ? 0.0 : completedCount / updatedLectures.length;

      final updatedProgress = progress.copyWith(
        lectures: updatedLectures,
        completedLectures: completedCount,
        overallProgress: overallProgress,
        lastAccessedAt: DateTime.now(),
      );

      // Update in Firestore
      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .where('courseId', isEqualTo: courseId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update(updatedProgress.toJson());
        log('[CourseProgressService] Lecture progress updated successfully');
      }
    } catch (e) {
      log('[CourseProgressService] Error updating lecture progress: $e');
      rethrow;
    }
  }

  @override
  Future<List<CourseProgressModel>> getUserCourseProgresses(String userId) async {
    try {
      log('[CourseProgressService] Fetching all progresses for user: $userId');

      final querySnapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('lastAccessedAt', descending: true)
          .get();

      final progresses = querySnapshot.docs
          .map((doc) => CourseProgressModel.fromJson(doc.data(), doc.id))
          .toList();

      log('[CourseProgressService] Found ${progresses.length} course progresses');
      return progresses;
    } catch (e) {
      log('[CourseProgressService] Error fetching user course progresses: $e');
      rethrow;
    }
  }
}
