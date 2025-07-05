import 'dart:developer';

import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/instructors/data/models/update_params.dart';
import 'package:admin_app/features/instructors/domain/entities/mentor_entity.dart';
import 'package:admin_app/features/instructors/domain/repos/mentor_managment.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class VerifyMentor implements Usecase<Either, UpdateParams> {  // Use nullable type
  @override
  Future<Either> call({required UpdateParams params}) async {  // Optional params
    log('hihihihihihihi');
    try {
      Either response =
          await serviceLocator<MentorsRepo>().verifyMentor(params);

          log("got the responce");
      return response;
    } catch (e) {
      log("brrrrr $e");
      return Left("updation: $e");
    }
  }
}
