
import 'dart:developer';

import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/dashboard/domain/repo/repo.dart';
import 'package:admin_app/service_provider.dart';
import 'package:dartz/dartz.dart';

class DeleteBannerUseCase implements Usecase<Either<String, void>, String> {
  @override
  Future<Either<String, void>> call({required String params}) async {
    try {
      final response = await serviceLocator<DashboardRepository>().deleteBanner(params);
      log('Deleted banner');
      return response;
    } catch (e) {
      log('Error deleting banner: $e');
      return Left('Failed to delete banner: $e');
    }
  }
}
