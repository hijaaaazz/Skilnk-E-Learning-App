
import 'package:dartz/dartz.dart';
import  'package:user_app/core/usecase/usecase.dart';
import  'package:user_app/features/home/data/models/banner_model.dart';
import  'package:user_app/features/home/domain/repos/repository.dart';
import  'package:user_app/service_locator.dart';

class GetBannerInfoUseCase
    implements Usecase<Either<String, List<BannerModel>>, NoParams> {
  
  @override
  Future<Either<String, List<BannerModel>>> call({required NoParams params}) async {
    try {
      final result = await serviceLocator<CoursesRepository>().getBannerInfo();
      // result is already Either<String, CourseProgressModel>, just return it
      return result;
    } catch (e) {
      return Left('Failed to load banners: ${e.toString()}');
    }
  }
}
