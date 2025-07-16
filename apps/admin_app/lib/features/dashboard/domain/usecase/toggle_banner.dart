
import 'dart:developer';

import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/dashboard/data/models/banner_model.dart';
import 'package:admin_app/features/dashboard/domain/repo/repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class ToggleBannerStatusUseCase implements Usecase<Either<String, BannerModel>, String> {
  @override
  Future<Either<String, BannerModel>> call({required String params}) async {
    try {
      final response = await serviceLocator<DashboardRepository>().toggleBannerStatus(params);
      log('Toggled banner status');
      return response;
    } catch (e) {
      log('Error toggling banner status: $e');
      return Left('Failed to toggle banner status: $e');
    }
  }
}