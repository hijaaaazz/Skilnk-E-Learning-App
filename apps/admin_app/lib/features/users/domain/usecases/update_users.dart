// import 'package:admin_app/core/usecase/usecase.dart';           // defines abstract class Usecase<Type, Params>
// import 'package:admin_app/features/users/domain/entities/user_entity.dart';
// import 'package:admin_app/features/users/domain/repos/user_managment.dart';
// import 'package:admin_app/service_provider.dart';
// import 'package:dartz/dartz.dart';

// class UpdateUserUseCase 
//     implements Usecase<Either<String, bool>, UserEntity> {
//   // field name starts lowercase, points at the UsersRepo from your locator
//   final UsersRepo _repository = serviceLocator<UsersRepo>();

//   @override
//   Future<Either<String, bool>> call({required UserEntity params}) {
//     // no null-check needed since params is non-nullable
//     return _repository.updateUser(params);
//   }
// }
