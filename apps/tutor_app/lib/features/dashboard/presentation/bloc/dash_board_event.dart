import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';


abstract class DashboardEvent {}

class LoadDashboardData extends DashboardEvent {
  final String userId;
  final TimePeriod? timePeriod;

  LoadDashboardData({
    required this.userId,
    this.timePeriod,
  });
}

class ChangeDashboardTimePeriod extends DashboardEvent {
  final String userId;
  final TimePeriod timePeriod;

  ChangeDashboardTimePeriod({
    required this.userId,
    required this.timePeriod,
  });
}
