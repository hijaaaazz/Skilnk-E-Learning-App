import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';
import '../entity/dash_board_data_entity.dart';

abstract class DashBoardRepo {
  Future<Either<String, DashBoardDataEntity>> getDashBoarddatas(
    String mentorId, {
    TimePeriod? timePeriod,
  });
}
