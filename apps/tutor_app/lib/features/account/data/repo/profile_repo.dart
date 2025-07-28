import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tutor_app/features/account/data/models/delete_category.dart';
import 'package:tutor_app/features/account/data/models/update_category_params.dart';
import 'package:tutor_app/features/account/data/models/update_dp_params.dart';
import 'package:tutor_app/features/account/data/models/update_name_params.dart';
import 'package:tutor_app/features/account/data/service/profile_cloudinary_service.dart';
import 'package:tutor_app/features/account/data/service/profile_firebase_service.dart';
import 'package:tutor_app/features/account/domain/repo/profile_repo.dart';
import 'package:tutor_app/features/courses/data/models/category_model.dart';
import 'package:tutor_app/service_locator.dart';
class ProfileRepoImp extends ProfileRepository {
  final cloudinaryService = serviceLocator<ProfileCloudinaryService>();
  final firebaseService = serviceLocator<FirebaseProfileService>();
  final auth = FirebaseAuth.instance;

  @override
  Future<Either<String, String>> updateProfilePic(UpdateDpParams params) async {
    try {
      final uploadResult = await cloudinaryService.uploadImage(params.imagePath);
      return await uploadResult.fold(
        (failure) => Left(failure),
        (imageUrl) async {
          await firebaseService.updateProfilePic(params.userId, imageUrl);
          final currentUser = auth.currentUser;
          if (currentUser != null && currentUser.uid == params.userId) {
            await currentUser.updatePhotoURL(imageUrl);
          }
          return Right(imageUrl);
        },
      );
    } catch (e) {
      return Left("Profile update failed: $e");
    }
  }

  @override
  Future<Either<String, String>> updateName(UpdateNameParams params) async {
    try {
      final result = await firebaseService.updateName(params.userId, params.newName);
      return result.fold(
        (failure) => Left(failure),
        (newName) => Right(newName),
      );
    } catch (e) {
      return Left("Name update failed: $e");
    }
  }

  @override
  Future<Either<String, String>> updateBio(params) async {
    try {
      final result = await firebaseService.updateBio(params.userId, params.bio);
      return result.fold(
        (failure) => Left(failure),
        (msg) => Right(msg),
      );
    } catch (e) {
      return Left("Bio update failed: $e");
    }
  }

  @override
  Future<Either<String, List<String>>> addCategory(UpdateCategoryParams category) async {
    return await firebaseService.addCategory(category);
  }

  @override
  Future<Either<String, List<CategoryModel>>> getCategories() async {
    return await firebaseService.getCategories();
  }

  @override
  Future<Either<String, bool>> deleteCategory(DeleteCategoryParams categoryId) async {
    return await firebaseService.deleteCategory(categoryId);
  }
}
