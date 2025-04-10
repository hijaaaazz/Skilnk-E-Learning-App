// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:user_app/data/auth/models/user_model.dart';

// abstract class AuthLocalDataSource {
//   Future<void> cacheUser(UserModel user);
//   Future<UserModel?> getCachedUser();
//   Future<void> clearCachedUser();
// }

// class AuthLocalDataSourceImpl implements AuthLocalDataSource {
//   final String boxName = 'userBox';

//   @override
//   Future<void> cacheUser(UserModel user) async {
//     final box = await Hive.openBox(boxName);
//     await box.put('user', user.toJson());
//   }

//   @override
//   Future<UserModel?> getCachedUser() async {
//     final box = await Hive.openBox(boxName);
//     final userMap = box.get('user');
//     if (userMap != null) {
//       return UserModel.fromJson(Map<String, dynamic>.from(userMap));
//     }
//     return null;
//   }

//   @override
//   Future<void> clearCachedUser() async {
//     final box = await Hive.openBox(boxName);
//     await box.delete('user');
//   }
// }
