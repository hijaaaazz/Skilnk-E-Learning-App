import 'dart:developer';
import 'package:admin_app/features/dashboard/data/models/activity_model.dart';
import 'package:admin_app/features/dashboard/data/models/banner_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardFirebaseService {
  Future<List<Activity>> fetchActivities();
  Future<List<BannerModel>> fetchBanners();
  Future<BannerModel> createBanner(BannerModel banner);
  Future<BannerModel> updateBanner(BannerModel banner);
  Future<void> deleteBanner(String bannerId);
  Future<BannerModel> toggleBannerStatus(String bannerId, bool isActive);
}

class DashboardFirebaseServiceImpl implements DashboardFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Activity>> fetchActivities() async {
    try {
      // Fetch enrollments
      final enrollmentSnapshot = await _firestore
          .collection('enrollments')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      // Fetch courses and users in parallel
      final coursesSnapshot = await _firestore.collection('courses').get();
      final usersSnapshot = await _firestore.collection('users').get();

      // Create maps for quick lookup
      final coursesMap = {
        for (var doc in coursesSnapshot.docs) doc.id: doc.data()
      };
      final usersMap = {
        for (var doc in usersSnapshot.docs) doc.id: doc.data()
      };

      final courseActivities = coursesSnapshot.docs.map((doc) {
        final data = doc.data();
        final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
        (data['updatedAt'] as Timestamp?)?.toDate();
        final tutorId = data['tutor'] as String;
        final tutorName = usersMap[tutorId]?['name'] ?? 'Unknown Tutor';

        // Create activity for course creation
        final activity = Activity(
          id: '${doc.id}_create',
          title: 'Course Upload',
          description: '$tutorName uploaded new course: ${data['title']}',
          timestamp: createdAt ?? DateTime.now(),
          type: ActivityType.courseUpload,
          adminId: 'admin_sid',
        );

        return activity;
      }).toList();

      // Map enrollments to activities
      final enrollmentActivities = enrollmentSnapshot.docs.map((doc) {
        final data = doc.data();
        final courseId = data['courseId'] as String;
        final userId = data['userId'] as String;
        final courseTitle = coursesMap[courseId]?['title'] ?? 'Unknown Course';
        final userName = usersMap[userId]?['name'] ?? 'Unknown User';

        return Activity(
          id: data['purchaseId'] as String,
          title: 'Student Enrollment',
          description: '$userName enrolled in $courseTitle',
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          type: ActivityType.studentEnrollment,
          adminId: 'admin_sid',
        );
      }).toList();

      // Combine and sort activities by timestamp
      final allActivities = [...courseActivities, ...enrollmentActivities]
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return allActivities.take(10).toList(); // Limit to 10 for performance
    } catch (e) {
      log('Error fetching activities: $e');
      rethrow;
    }
  }

  @override
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final snapshot = await _firestore
          .collection('banner')
          .get();

      return snapshot.docs
          .map((doc) => BannerModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      log('Error fetching banners: $e');
      rethrow;
    }
  }

  @override
  Future<BannerModel> createBanner(BannerModel banner) async {
    try {
      final docRef = _firestore.collection('banner').doc();
      final newBanner = banner.copyWith(id: docRef.id);
      await docRef.set(newBanner.toJson());
      
      // Log activity for banner creation
      await _logActivity(
        id: docRef.id + '_create',
        title: 'Banner Created',
        description: 'Created new banner: ${banner.title}',
        type: ActivityType.bannerUpdate,
      );

      return newBanner;
    } catch (e) {
      log('Error creating banner: $e');
      rethrow;
    }
  }

  @override
  Future<BannerModel> updateBanner(BannerModel banner) async {
    try {
      final docRef = _firestore.collection('banner').doc(banner.id);
      final updatedBanner = banner;
      await docRef.update(updatedBanner.toJson());

      // Log activity for banner update
      await _logActivity(
        id: '${banner.id}_update_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Banner Updated',
        description: 'Updated banner: ${banner.title}',
        type: ActivityType.bannerUpdate,
      );

      return updatedBanner;
    } catch (e) {
      log('Error updating banner: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBanner(String bannerId) async {
    try {
      final docRef = _firestore.collection('banner').doc(bannerId);
      final bannerSnapshot = await docRef.get();
      final bannerData = bannerSnapshot.data();
      if (bannerData != null) {
        await docRef.delete();

        // Log activity for banner deletion
        await _logActivity(
          id: '${bannerId}_delete_${DateTime.now().millisecondsSinceEpoch}',
          title: 'Banner Deleted',
          description: 'Deleted banner: ${bannerData['title']}',
          type: ActivityType.bannerUpdate,
        );
      }
    } catch (e) {
      log('Error deleting banner: $e');
      rethrow;
    }
  }

  @override
  Future<BannerModel> toggleBannerStatus(String bannerId, bool isActive) async {
    try {
      final docRef = _firestore.collection('banner').doc(bannerId);
      final bannerSnapshot = await docRef.get();
      if (!bannerSnapshot.exists) {
        throw Exception('Banner not found');
      }

      final currentBanner = BannerModel.fromJson({
        'id': bannerSnapshot.id,
        ...bannerSnapshot.data()!,
      });

      final updatedBanner = currentBanner;

      await docRef.update({
        'isActive': isActive,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Log activity for banner status toggle
      await _logActivity(
        id: '${bannerId}_toggle_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Banner Status Changed',
        description: 'Changed status of banner: ${currentBanner.title} to ${isActive ? 'Active' : 'Inactive'}',
        type: ActivityType.bannerUpdate,
      );

      return updatedBanner;
    } catch (e) {
      log('Error toggling banner status: $e');
      rethrow;
    }
  }

  Future<void> _logActivity({
    required String id,
    required String title,
    required String description,
    required ActivityType type,
  }) async {
    try {
      final activity = Activity(
        id: id,
        title: title,
        description: description,
        timestamp: DateTime.now(),
        type: type,
        adminId: 'admin_sid',
      );
      await _firestore.collection('activities').doc(id).set(activity.toJson());
    } catch (e) {
      log('Error logging activity: $e');
    }
  }
}