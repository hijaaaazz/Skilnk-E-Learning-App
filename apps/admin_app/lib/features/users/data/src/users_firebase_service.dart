import 'dart:developer';
import 'package:admin_app/features/instructors/data/models/update_params.dart';
import 'package:admin_app/features/users/data/models/user-update_params.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

abstract class UsersFirebaseService {
  Future<Either<String, List<Map<String, dynamic>>>> getUsers();
  Future<Either<String, bool>> toggleBlock(UserUpdateParams params);
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
  
  @override
Future<Either<String, bool>> toggleBlock(UserUpdateParams params) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('users').doc(params.userId); // assuming tutorId = userId
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      return Left("User not found");
    }


    final newStatus = params.toggle;

    await docRef.update({'isBlocked': newStatus});

    return Right(newStatus);
  } catch (e) {
    return Left("Failed to toggle block status: $e");
  }
}

}
