

// States
import 'package:tutor_app/features/dashboard/data/models/activity_item.dart';
import 'package:tutor_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:tutor_app/features/dashboard/domain/entity/dash_board_data_entity.dart';

abstract class DashboardState{}


class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashBoardDataEntity data;

  DashboardLoaded({required this.data});

}

class DashboardError extends DashboardState {
  final String message;

  DashboardError({required this.message});

}