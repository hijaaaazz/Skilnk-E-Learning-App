import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class UsersFirebaseService {
  Future<Either<String, List<Map<String, dynamic>>>> getUsers();
}

class UsersFirebaseServiceImp extends UsersFirebaseService {
  @override
  Future<Either<String, List<Map<String, dynamic>>>> getUsers() async {
    print("callled");
    try {
      // Fetching users from Firestore
      var snapshot = await FirebaseFirestore.instance.collection('users').get();

      // Convert the snapshot to a list of maps
      List<Map<String, dynamic>> users = snapshot.docs
          .map((doc) => doc.data())  // convert each document to Map
          .toList();

      // Log the name of the first user (for debugging purposes)
      if (users.isNotEmpty) {
        log(users[0]['name'].toString());
      }

      log("call ended");

      // Return the users as the right side of the Either
      return Right(users);
    } catch (e) {
      // If there's an error, return it as the left side of the Either
      return Left("Failed to fetch users: $e");
    }
  }
}
