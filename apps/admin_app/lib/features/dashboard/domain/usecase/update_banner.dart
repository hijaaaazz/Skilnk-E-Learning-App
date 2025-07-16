
import 'dart:developer';

import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/dashboard/data/models/banner_model.dart';
import 'package:admin_app/features/dashboard/domain/repo/repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class UpdateBannerUseCase implements Usecase<Either<String, BannerModel>, BannerModel> {
  @override
  Future<Either<String, BannerModel>> call({required BannerModel params}) async {
    try {
      final response = await serviceLocator<DashboardRepository>().updateBanner(params);
      log('Updated banner');
      return response;
    } catch (e) {
      log('Error updating banner: $e');
      return Left('Failed to update banner: $e');
    }
  }
}
