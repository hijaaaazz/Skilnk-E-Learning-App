import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class MentorsFirebaseService {
  Future<Either<String, List<Map<String, dynamic>>>> getUsers();
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
}
