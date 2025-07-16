import 'package:admin_app/features/dashboard/data/models/activity_model.dart';
import 'package:admin_app/features/dashboard/data/models/banner_model.dart';
import 'package:admin_app/features/dashboard/data/service/firebase_service.dart';
import 'package:admin_app/features/dashboard/domain/repo/repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardFirebaseService _firebaseService = serviceLocator<DashboardFirebaseService>();

  @override
  Future<Either<String, List<Activity>>> getActivities() async {
    try {
      final activities = await _firebaseService.fetchActivities();
      return Right(activities);
    } catch (e) {
      return Left('Failed to fetch activities: $e');
    }
  }

  @override
  Future<Either<String, List<BannerModel>>> getBanners() async {
    try {
      final banners = await _firebaseService.fetchBanners();
      return Right(banners);
    } catch (e) {
      return Left('Failed to fetch banners: $e');
    }
  }

  @override
  Future<Either<String, BannerModel>> createBanner(BannerModel banner) async {
    try {
      final createdBanner = await _firebaseService.createBanner(banner);
      return Right(createdBanner);
    } catch (e) {
      return Left('Failed to create banner: $e');
    }
  }

  @override
  Future<Either<String, BannerModel>> updateBanner(BannerModel banner) async {
    try {
      final updatedBanner = await _firebaseService.updateBanner(banner);
      return Right(updatedBanner);
    } catch (e) {
      return Left('Failed to update banner: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteBanner(String bannerId) async {
    try {
      await _firebaseService.deleteBanner(bannerId);
      return const Right(null);
    } catch (e) {
      return Left('Failed to delete banner: $e');
    }
  }

  @override
  Future<Either<String, BannerModel>> toggleBannerStatus(String bannerId) async {
    try {
      final banner = await _firebaseService.toggleBannerStatus(bannerId, true); // Toggle logic can be adjusted
      return Right(banner);
    } catch (e) {
      return Left('Failed to toggle banner status: $e');
    }
  }
}