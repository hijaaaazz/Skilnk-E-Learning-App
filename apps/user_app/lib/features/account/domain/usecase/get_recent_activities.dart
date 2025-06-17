
// GetCurrentUserUseCase.dart
import 'package:dartz/dartz.dart';
import 'package:user_app/core/usecase/usecase.dart';
import 'package:user_app/features/account/data/models/activity_model.dart';
import 'package:user_app/features/account/domain/repo/profile_repo.dart';
import 'package:user_app/service_locator.dart';

class GetRecentActivitiesUseCase implements Usecase<Either<String, List<Activity>>, String> {
  @override
  Future<Either<String, List<Activity>>> call({required String params}) {
    return serviceLocator<ProfileRepository>().getRecentEnrollments(params);
  }
}