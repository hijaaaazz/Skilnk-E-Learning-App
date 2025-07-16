import 'package:admin_app/core/usecase/usecase.dart';
import 'package:admin_app/features/dashboard/data/models/activity_model.dart';
import 'package:admin_app/features/dashboard/data/models/banner_model.dart';
import 'package:admin_app/features/dashboard/domain/usecase/create_banner.dart';
import 'package:admin_app/features/dashboard/domain/usecase/delete_banner.dart';
import 'package:admin_app/features/dashboard/domain/usecase/get_activities.dart';
import 'package:admin_app/features/dashboard/domain/usecase/get_banners.dart';
import 'package:admin_app/features/dashboard/domain/usecase/update_banner.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_event.dart';
import 'package:admin_app/features/dashboard/presentation/bloc/bloc/dashboard_state.dart';
import 'package:bloc/bloc.dart';
import 'dart:developer';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetActivities _getActivities = GetActivities();
  final GetBanners _getBanners = GetBanners();
  final CreateBannerUseCase _createBanner = CreateBannerUseCase();
  final UpdateBannerUseCase _updateBanner = UpdateBannerUseCase();
  final DeleteBannerUseCase _deleteBanner = DeleteBannerUseCase();

  List<Activity> _activities = [];
  List<BannerModel> _banners = [];

  DashboardBloc() : super(DashboardInitial()) {
    on<LoadActivities>(_onLoadActivities);
    on<LoadBanners>(_onLoadBanners);
    on<AddActivity>(_onAddActivity);
    on<CreateBanner>(_onCreateBanner);
    on<UpdateBanner>(_onUpdateBanner);
    on<DeleteBanner>(_onDeleteBanner);
  }

  Future<void> _onLoadActivities(LoadActivities event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    final result = await _getActivities.call();
    result.fold(
      (error) {
        log('Error loading activities: $error');
        emit(DashboardError(error));
      },
      (activities) {
        _activities = activities;
        emit(DashboardLoaded(activities: _activities, banners: _banners));
      },
    );
  }

  Future<void> _onLoadBanners(LoadBanners event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    final result = await _getBanners.call();
    result.fold(
      (error) {
        log('Error loading banners: $error');
        emit(DashboardError(error));
      },
      (banners) {
        _banners = banners;
        emit(DashboardLoaded(activities: _activities, banners: _banners));
      },
    );
  }

  void _onAddActivity(AddActivity event, Emitter<DashboardState> emit) {
    _activities.insert(0, event.activity);
    emit(DashboardLoaded(activities: _activities, banners: _banners));
  }

  Future<void> _onCreateBanner(CreateBanner event, Emitter<DashboardState> emit) async {
    final result = await _createBanner.call(params: event.banner);
    result.fold(
      (error) {
        log('Error creating banner: $error');
        emit(DashboardError(error));
      },
      (createdBanner) {
        _banners.add(createdBanner);
        final activity = Activity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Banner Created',
          description: 'Created new banner: ${createdBanner.title}',
          timestamp: DateTime.now(),
          type: ActivityType.bannerUpdate,
          adminId: 'admin_sid',
        );
        _activities.insert(0, activity);
        emit(DashboardLoaded(activities: _activities, banners: _banners));
      },
    );
  }

  Future<void> _onUpdateBanner(UpdateBanner event, Emitter<DashboardState> emit) async {
    final result = await _updateBanner.call(params: event.banner);
    result.fold(
      (error) {
        log('Error updating banner: $error');
        emit(DashboardError(error));
      },
      (updatedBanner) {
        final index = _banners.indexWhere((banner) => banner.id == updatedBanner.id);
        if (index != -1) {
          _banners[index] = updatedBanner;
          final activity = Activity(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'Banner Updated',
            description: 'Updated banner: ${updatedBanner.title}',
            timestamp: DateTime.now(),
            type: ActivityType.bannerUpdate,
            adminId: 'admin_sid',
          );
          _activities.insert(0, activity);
          emit(DashboardLoaded(activities: _activities, banners: _banners));
        }
      },
    );
  }

  Future<void> _onDeleteBanner(DeleteBanner event, Emitter<DashboardState> emit) async {
    final banner = _banners.firstWhere(
      (b) => b.id == event.bannerId,
      orElse: () => BannerModel(id: '', badge: '', title: '', description: ''),
    );
    if (banner.id.isEmpty) {
      emit(DashboardError('Banner not found'));
      return;
    }
    final result = await _deleteBanner.call(params: event.bannerId);
    result.fold(
      (error) {
        log('Error deleting banner: $error');
        emit(DashboardError(error));
      },
      (_) {
        _banners.removeWhere((banner) => banner.id == event.bannerId);
        final activity = Activity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Banner Deleted',
          description: 'Deleted banner: ${banner.title}',
          timestamp: DateTime.now(),
          type: ActivityType.bannerUpdate,
          adminId: 'admin_sid',
        );
        _activities.insert(0, activity);
        emit(DashboardLoaded(activities: _activities, banners: _banners));
      },
    );
  }
}