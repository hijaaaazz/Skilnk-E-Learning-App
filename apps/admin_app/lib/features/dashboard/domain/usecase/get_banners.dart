
import 'dart:developer';

import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/dashboard/data/models/banner_model.dart';
import 'package:admin_app/features/dashboard/domain/repo/repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class GetBanners implements Usecase<Either<String, List<BannerModel>>, NoParams> {
  @override
  Future<Either<String, List<BannerModel>>> call({NoParams? params}) async {
    try {
      final response = await serviceLocator<DashboardRepository>().getBanners();
      log('Fetched banners');
      return response;
    } catch (e) {
      log('Error fetching banners: $e');
      return Left('Failed to fetch banners: $e');
    }
  }
}
