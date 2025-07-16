import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/dashboard/data/models/activity_model.dart';
import 'package:admin_app/features/dashboard/domain/repo/repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';
import 'dart:developer';

class GetActivities implements Usecase<Either<String, List<Activity>>, NoParams> {
  @override
  Future<Either<String, List<Activity>>> call({NoParams? params}) async {
    try {
      final response = await serviceLocator<DashboardRepository>().getActivities();
      log('Fetched activities');
      return response;
    } catch (e) {
      log('Error fetching activities: $e');
      return Left('Failed to fetch activities: $e');
    }
  }
}
