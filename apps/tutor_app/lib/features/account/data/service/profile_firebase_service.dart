import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/account/data/models/delete_category.dart';
import 'package:tutor_app/features/account/data/models/update_category_params.dart';
import 'package:tutor_app/features/courses/data/models/category_model.dart';

abstract class FirebaseProfileService {
  Future<Either<String, String>> updateProfilePic(String userId, String imageUrl);
  Future<Either<String, String>> updateName(String userId, String newName);
  Future<Either<String, String>> updateBio(String userId, String bio);
  Future<Either<String, List<String>>> addCategory(UpdateCategoryParams params);
  Future<Either<String, List<CategoryModel>>> getCategories();
  Future<Either<String, bool>> deleteCategory(DeleteCategoryParams params);
}

class FirebaseProfileServiceImp extends FirebaseProfileService {
  final CollectionReference _users = FirebaseFirestore.instance.collection('mentors');
  final CollectionReference _categories = FirebaseFirestore.instance.collection('categories');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Either<String, String>> updateProfilePic(String userId, String imageUrl) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.uid != userId) return left("User not authenticated or ID mismatch");
      await user.updatePhotoURL(imageUrl);
      await _users.doc(userId).update({
        'profile_image': imageUrl,
        'updatedAt': DateTime.now(),
      });
      return right("Profile picture updated successfully.");
    } catch (e, stack) {
      log("Profile Pic Update Error: $e", stackTrace: stack);
      return left("Failed to update profile picture: $e");
    }
  }

  @override
  Future<Either<String, String>> updateName(String userId, String newName) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.uid != userId) return left("User not authenticated or ID mismatch");
      await user.updateDisplayName(newName);
      await _users.doc(userId).update({
        'full_name': newName,
        'name_lower': newName.toLowerCase(),
        'updatedAt': DateTime.now(),
      });
      return right(newName);
    } catch (e, stack) {
      log("Update Name Error: $e", stackTrace: stack);
      return left("Failed to update name: $e");
    }
  }

  @override
  Future<Either<String, String>> updateBio(String userId, String bio) async {
    try {
      await _users.doc(userId).update({
        'bio': bio,
        'updatedAt': DateTime.now(),
      });
      return right(bio);
    } catch (e, stack) {
      log("Update Bio Error: $e", stackTrace: stack);
      return left("Failed to update bio: $e");
    }
  }

  @override
Future<Either<String, List<String>>> addCategory(UpdateCategoryParams params) async {
  try {
    final user = _auth.currentUser;
    if (user == null) return left("User not authenticated");

    final userDocRef = _users.doc(user.uid);

    // Overwrite the entire 'categories' list with the new one
    await userDocRef.update({
      'categories': params.category,
      'updatedAt': DateTime.now(),
    });

    return right(params.category);
  } catch (e, stack) {
    log("Replace Category List Error: $e", stackTrace: stack);
    return left("Failed to replace category list: $e");
  }
}



  @override
  Future<Either<String, List<CategoryModel>>> getCategories() async {
    try {
      final querySnapshot = await _categories.get();
      final categories = querySnapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return right(categories);
    } catch (e, stack) {
      log("Get Categories Error: $e", stackTrace: stack);
      return left("Failed to fetch categories: $e");
    }
  }

  @override
  Future<Either<String, bool>> deleteCategory(DeleteCategoryParams params) async {
    try {
      await _categories.doc(params.category.id).delete();
      return right(true);
    } catch (e, stack) {
      log("Delete Category Error: $e", stackTrace: stack);
      return left("Failed to delete category: $e");
    }
  }
}
