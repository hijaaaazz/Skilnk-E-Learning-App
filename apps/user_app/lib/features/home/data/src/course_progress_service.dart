
// Abstract service interface
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:user_app/features/home/data/models/course_progress.dart';
import 'package:user_app/features/home/data/models/lecture_model.dart';
import 'package:user_app/features/home/data/models/lecture_progress_model.dart';

abstract class CourseProgressService {
  Future<void> createCourseProgress({
    required CourseProgressModel initialprogress
  });

  Future<Either<String,CourseProgressModel>> getCourseProgress({
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


class CourseProgressServiceImpl extends CourseProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'course_progress';

  @override
  Future<void> createCourseProgress({
    required CourseProgressModel initialprogress, // Match exact parameter name
  }) async {
    try {
      log('[CourseProgressService] Creating progress for course: ${initialprogress.courseId}, user: ${initialprogress.userId}');

      // Check if progress already exists
      final existingProgress = await getCourseProgress(
        userId: initialprogress.userId,
        courseId: initialprogress.courseId,
      );

      if (existingProgress.isRight()) {
        log('[CourseProgressService] Course progress already exists, skipping creation');
        return;
      }

      // Generate document ID
      final docRef = _firestore.collection(_collectionName).doc();

      // Create a new progress model with the generated ID
      final progressModel = initialprogress.copyWith(id: docRef.id);

      await docRef.set(progressModel.toJson());

      log('[CourseProgressService] Course progress created successfully with ID: ${docRef.id}');
    } catch (e, stackTrace) {
      log('[CourseProgressService] Error creating course progress: $e');
      log('[CourseProgressService] Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<Either<String, CourseProgressModel>> getCourseProgress({
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
        return Left("Failed: No progress found");
      }

      final doc = querySnapshot.docs.first;
      final progress = CourseProgressModel.fromJson(doc.data(), doc.id);

      log('[CourseProgressService] Progress fetched successfully');
      return Right(progress);
    } catch (e) {
      log('[CourseProgressService] Error fetching course progress: $e');
      return Left("Failed to fetch course progress: ${e.toString()}");
    }
  }

  @override
  Future<Either<String, void>> updateLectureProgress({
    required String userId,
    required String courseId,
    required String lectureId,
    required Duration watchedDuration,
    bool? isCompleted,
  }) async {
    try {
      log('[CourseProgressService] Updating lecture progress: $lectureId');

      final progressResult = await getCourseProgress(
        userId: userId,
        courseId: courseId,
      );

      return await progressResult.fold(
        (failure) {
          // If getting progress failed, return failure left
          return Left(failure);
        },
        (progress) async {
          // Find and update the specific lecture
          final updatedLectures = progress.lectures.map((lecture) {
            if (lecture.index.toString() == lectureId) {
              return lecture.copyWith(
                watchedDuration: watchedDuration,
                isCompleted: isCompleted ?? lecture.isCompleted,
              );
            }
            return lecture;
          }).toList();

          // Unlock next lecture if current is completed
          final currentLectureIndex = updatedLectures.indexWhere((l) => l.index.toString() == lectureId);
          if (currentLectureIndex != -1 &&
              (isCompleted ?? false) &&
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
            return Right(null);
          } else {
            return Left('Course progress document not found in Firestore');
          }
        },
      );
    } catch (e) {
      log('[CourseProgressService] Error updating lecture progress: $e');
      return Left('Error updating lecture progress: ${e.toString()}');
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