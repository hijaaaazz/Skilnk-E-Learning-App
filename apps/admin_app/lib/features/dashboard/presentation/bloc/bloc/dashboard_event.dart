
import 'package:admin_app/features/dashboard/data/models/activity_model.dart';
import 'package:admin_app/features/dashboard/data/models/banner_model.dart';

abstract class DashboardEvent {}

class LoadActivities extends DashboardEvent {}

class LoadBanners extends DashboardEvent {}

class AddActivity extends DashboardEvent {
  final Activity activity;
  AddActivity(this.activity);
}

class UpdateBanner extends DashboardEvent {
  final BannerModel banner;
  UpdateBanner(this.banner);
}

class DeleteBanner extends DashboardEvent {
  final String bannerId;
  DeleteBanner(this.bannerId);
}

class CreateBanner extends DashboardEvent {
  final BannerModel banner;
  CreateBanner(this.banner);
}

class ToggleBannerStatus extends DashboardEvent {
  final String bannerId;
  ToggleBannerStatus(this.bannerId);
}
