import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';

abstract class FirebaseProfileService {
  Future<Either<String, String>> updateProfilePic(String userId, String imageUrl);
  Future<Either<String, String>> updateName(String userId, String newName);
}

class FirebaseProfileServiceImp extends FirebaseProfileService {
  final CollectionReference _users = FirebaseFirestore.instance.collection('mentors');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<String, String>> updateProfilePic(String userId, String imageUrl) async {
    try {
      log("Starting profile picture update for user: $userId");

      final user = _auth.currentUser;

      if (user == null || user.uid != userId) {
        log("User not authenticated or ID mismatch. Current: ${user?.uid}, Expected: $userId");
        return left("User not authenticated or ID mismatch");
      }

      log("Updating Firebase Auth photoURL...");
      await user.updatePhotoURL(imageUrl);
      log("Firebase Auth photoURL updated.");

      log("Updating Firestore 'profile_image' field...");
      await _users.doc(userId).update({
        'profile_image': imageUrl,
        'updatedAt': DateTime.now(),
      });
      log("Firestore document updated with profile image.");

      return right("Profile picture updated successfully.");
    } catch (e, stack) {
      log("Failed to update profile picture: $e", stackTrace: stack);
      return left("Failed to update profile picture: $e");
    }
  }

  @override
  Future<Either<String, String>> updateName(String userId, String newName) async {
    try {
      log("Starting name update for user: $userId");

      final user = _auth.currentUser;

      if (user == null || user.uid != userId) {
        log("User not authenticated or ID mismatch. Current: ${user?.uid}, Expected: $userId");
        return left("User not authenticated or ID mismatch");
      }

      log("Updating Firebase Auth displayName...");
      await user.updateDisplayName(newName);
      log("Firebase Auth displayName updated.");

      log("Updating Firestore 'full_name' and 'name_lower'...");
      await _users.doc(userId).update({
        'full_name': newName,
        'name_lower': newName.toLowerCase(),
        'updatedAt': DateTime.now(),
      });
      log("Firestore document updated with new name.");

      // Optional: Confirm the update
      final snapshot = await _users.doc(userId).get();
      final data = snapshot.data() as Map<String, dynamic>?;
      final updatedName = data?['full_name'] ?? newName;

      log("Name update successful: $updatedName");
      return right(updatedName);
    } catch (e, stack) {
      log("Failed to update name: $e", stackTrace: stack);
      return left("Failed to update name: $e");
    }
  }
}
