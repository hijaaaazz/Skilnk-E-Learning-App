import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/dashboard/presentation/bloc/dash_board_bloc.dart';
import '../entity/dash_board_data_entity.dart';
import '../repo/dashboard_repo.dart';
import '../../../../service_locator.dart';

class GetDashboardItemUsecase {
  final DashBoardRepo _repository = serviceLocator<DashBoardRepo>();

  Future<Either<String, DashBoardDataEntity>> call({
    required GetDashboardParams params,
  }) async {
    return await _repository.getDashBoarddatas(
      params.userId,
      timePeriod: params.timePeriod,
    );
  }
}
