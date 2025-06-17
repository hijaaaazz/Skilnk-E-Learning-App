import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/dashboard/domain/entity/dash_board_data_entity.dart';

abstract class DashBoardRepo {

  Future<Either<String,DashBoardDataEntity>> getDashBoarddatas(String params);

}