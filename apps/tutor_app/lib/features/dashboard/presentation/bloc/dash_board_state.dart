import 'package:equatable/equatable.dart';
import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';
import '../../domain/entity/dash_board_data_entity.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {
  final TimePeriod? currentPeriod;
  
  DashboardLoading({this.currentPeriod});
  
  @override
  List<Object?> get props => [currentPeriod];
}

class DashboardLoaded extends DashboardState {
  final DashBoardDataEntity data;
  final TimePeriod currentPeriod;

  DashboardLoaded({
    required this.data,
    required this.currentPeriod,
  });

  @override
  List<Object?> get props => [data, currentPeriod];
}

class DashboardError extends DashboardState {
  final String message;
  final TimePeriod? currentPeriod;

  DashboardError({
    required this.message,
    this.currentPeriod,
  });

  @override
  List<Object?> get props => [message, currentPeriod];
}
