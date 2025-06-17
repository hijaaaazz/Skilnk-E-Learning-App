import 'package:dartz/dartz.dart';
import 'package:tutor_app/core/usecase/usecase.dart';
import 'package:tutor_app/features/dashboard/domain/entity/dash_board_data_entity.dart';
import 'package:tutor_app/features/dashboard/domain/repo/dashboard_repo.dart';
import 'package:tutor_app/service_locator.dart';

class GetDashboardItemUsecase implements Usecase<Either<String, DashBoardDataEntity>, String> {
  @override
  Future<Either<String, DashBoardDataEntity>> call({required String params}) {

    
    return serviceLocator<DashBoardRepo>().getDashBoarddatas(params);
  }
}
