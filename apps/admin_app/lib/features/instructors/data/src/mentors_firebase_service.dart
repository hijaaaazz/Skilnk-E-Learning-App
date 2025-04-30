import 'dart:developer';

import 'package:admin_app/features/instructors/data/models/mentor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class MentorsFirebaseService {
  Future<Either<String, List<Map<String, dynamic>>>> getUsers();
  Future<Either<String, Map<String, dynamic>>> updateUser(MentorModel user);
}

class MentorsFirebaseServiceImp extends MentorsFirebaseService {
  @override
  Future<Either<String, List<Map<String, dynamic>>>> getUsers() async {
    print("callled");
    try {
      // Fetching users from Firestore
      var snapshot = await FirebaseFirestore.instance.collection('mentors').get();

      List<Map<String, dynamic>> users = snapshot.docs
          .map((doc) => doc.data())  // convert each document to Map
          .toList();
  log(users.join());
      // Return the users as the right side of the Either
      return Right(users);
    } catch (e) {
      // If there's an error, return it as the left side of the Either
      return Left("Failed to fetch users: $e");
    }
  }
  
  @override
Future<Either<String, Map<String, dynamic>>> updateUser(MentorModel user) async {
  try {
    final userDocRef = FirebaseFirestore.instance.collection('mentors').doc(user.tutorId);

    // Perform update
    await userDocRef.update(user.toJson());

    // Fetch updated document
    final updatedSnapshot = await userDocRef.get();
    final updatedData = updatedSnapshot.data();

    if (updatedData != null) {
      return Right(updatedData);
    } else {
      return Left("User not found after update.");
    }
  } catch (e) {
    return Left("Failed to update user: $e");
  }
}


}
