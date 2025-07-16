
import 'dart:developer';

import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/dashboard/data/models/banner_model.dart';
import 'package:admin_app/features/dashboard/domain/repo/repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class CreateBannerUseCase implements Usecase<Either<String, BannerModel>, BannerModel> {
  @override
  Future<Either<String, BannerModel>> call({required BannerModel params}) async {
    try {
      final response = await serviceLocator<DashboardRepository>().createBanner(params);
      log('Created banner');
      return response;
    } catch (e) {
      log('Error creating banner: $e');
      return Left('Failed to create banner: $e');
    }
  }
}
