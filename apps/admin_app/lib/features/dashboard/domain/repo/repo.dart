import 'package:admin_app/features/dashboard/data/models/activity_model.dart';
import 'package:admin_app/features/dashboard/data/models/banner_model.dart';
import 'package:dartz/dartz.dart';

abstract class DashboardRepository {
  Future<Either<String, List<Activity>>> getActivities();
  Future<Either<String, List<BannerModel>>> getBanners();
  Future<Either<String, BannerModel>> createBanner(BannerModel banner);
  Future<Either<String, BannerModel>> updateBanner(BannerModel banner);
  Future<Either<String, void>> deleteBanner(String bannerId);
  Future<Either<String, BannerModel>> toggleBannerStatus(String bannerId);
}