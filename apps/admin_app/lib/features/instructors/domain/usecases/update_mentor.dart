import 'dart:developer';

import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:admin_app/features/instructors/domain/repos/mentor_managment.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class UpdateMentorUseCase implements Usecase<Either, MentorEntity> {  // Use nullable type
  @override
  Future<Either> call({ dynamic params}) async {  // Optional params
    log('hihihihihihihi');
    try {
      Either response =
          await serviceLocator<MentorsRepo>().updateUser(params);

          log("got the responce");
      return response;
    } catch (e) {
      log("brrrrr $e");
      return Left("updation: $e");
    }
  }
}
