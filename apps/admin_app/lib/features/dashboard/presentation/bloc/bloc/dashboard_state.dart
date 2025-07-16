
// BLoC States
import 'package:admin_app/features/dashboard/data/models/activity_model.dart';
import 'package:admin_app/features/dashboard/data/models/banner_model.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<Activity> activities;
  final List<BannerModel> banners;

  DashboardLoaded({required this.activities, required this.banners});
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
