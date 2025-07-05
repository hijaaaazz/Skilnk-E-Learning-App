import 'dart:developer';

import 'package:admin_app/features/instructors/data/models/mentor_model.dart';
import 'package:admin_app/features/instructors/data/models/update_params.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class MentorsFirebaseService {
  Future<Either<String, List<Map<String, dynamic>>>> getUsers();
  Future<Either<String, Map<String, dynamic>>> verifyMentor(UpdateParams params);
  Future<Either<String, bool>> toggleBlock(UpdateParams params);

}
class MentorsFirebaseServiceImp extends MentorsFirebaseService {
  @override
  Future<Either<String, List<Map<String, dynamic>>>> getUsers() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('mentors').get();

      List<Map<String, dynamic>> users =
          snapshot.docs.map((doc) => doc.data()).toList();

      log(users.join());
      return Right(users);
    } catch (e) {
      return Left("Failed to fetch users: $e");
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> verifyMentor(UpdateParams params) async {
    try {
      final userDocRef = FirebaseFirestore.instance.collection('mentors').doc(params.tutorId);

      await userDocRef.update({
        'is_verified': params.toggle,
      });

      final updatedSnapshot = await userDocRef.get();
      final updatedData = updatedSnapshot.data();

      if (updatedData != null) {
        return Right(updatedData);
      } else {
        return Left("User not found after update.");
      }
    } catch (e) {
      return Left("Failed to update verification: $e");
    }
  }

  @override
  Future<Either<String, bool>> toggleBlock(UpdateParams params) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('mentors').doc(params.tutorId);

      await docRef.update({
        'is_blocked': params.toggle
      });

      return Right(true);
    } catch (e) {
      return Left("Failed to update block status: $e");
    }
  }
}
