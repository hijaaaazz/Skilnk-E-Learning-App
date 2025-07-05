import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import  'package:user_app/features/account/data/models/activity_model.dart';
import  'package:user_app/features/account/data/models/update_dp_params.dart';
import  'package:user_app/features/account/data/models/update_name_params.dart';
import  'package:user_app/features/account/data/service/profile_cloudinary_service.dart';
import  'package:user_app/features/account/data/service/profile_firebase_service.dart';

import  'package:user_app/features/account/domain/repo/profile_repo.dart';
import  'package:user_app/service_locator.dart';

class ProfileRepoImp extends ProfileRepository {
  final cloudinaryService = serviceLocator<ProfileCloudinaryService>();
      final auth = FirebaseAuth.instance;
 @override
Future<Either<String, String>> updateProfilePic(UpdateDpParams params) async {
  try {
    // Step 1: Upload image to Cloudinary
    final uploadResult = await cloudinaryService.uploadImage(params.imagePath);
  log(uploadResult.toString());
    return await uploadResult.fold(
      (failure) => Left(failure),
      (imageUrl) async {
        // Step 2: Update Firestore via FirebaseProfileService
        final firebaseProfileService = serviceLocator<FirebaseProfileService>();
        await firebaseProfileService.updateProfilePic(params.userId, imageUrl);

        // Step 3: Update FirebaseAuth photo URL if user is current user
        final currentUser = auth.currentUser;
        if (currentUser != null && currentUser.uid == params.userId) {
          await currentUser.updatePhotoURL(imageUrl);
        }



        // ✅ Return the image URL
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
    // Step 1: Upload image to Cloudinary
    final uploadResult = await serviceLocator<FirebaseProfileService>().updateName(params.userId,params.newName);
    return await uploadResult.fold(
      (failure) => Left(failure),
      (newName)  {
        return Right(newName);
      },
    );
  } catch (e) {
    return Left("Profile update failed: $e");
  }
  }

  @override
  Future<Either<String, List<Activity>>> getRecentEnrollments(String userId)async{
    try {
    // Step 1: Upload image to Cloudinary
    final uploadResult = await serviceLocator<FirebaseProfileService>().getRecentEnrollments(userId);
    return await uploadResult.fold(
      (failure) => Left(failure),
      (newName)  {
        return Right(newName);
      },
    );
  } catch (e) {
    return Left("Profile update failed: $e");
  }
  }
}
