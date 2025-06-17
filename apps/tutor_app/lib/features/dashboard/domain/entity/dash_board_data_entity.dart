import 'package:tutor_app/features/dashboard/data/models/activity_item.dart';
import 'package:tutor_app/features/dashboard/data/models/dashboard_data.dart';

class DashBoardDataEntity{
   final DashboardData data;
  final List<ActivityItem> activities;


  DashBoardDataEntity({
    required this.activities,
    required this.data
  });
}