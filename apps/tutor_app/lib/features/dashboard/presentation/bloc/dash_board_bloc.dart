import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';
import '../../domain/usecase/get_dashboard_item_usecase.dart';
import 'dash_board_event.dart';
import 'dash_board_state.dart';
import '../../../../service_locator.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  TimePeriod _currentPeriod = TimePeriod.today; // Changed default to today
  
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<ChangeDashboardTimePeriod>(_onChangeDashboardTimePeriod);
  }

  void _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    final timePeriod = event.timePeriod ?? _currentPeriod;
    _currentPeriod = timePeriod;
    
    emit(DashboardLoading(currentPeriod: timePeriod));

    try {
      final result = await serviceLocator<GetDashboardItemUsecase>().call(
        params: GetDashboardParams(
          userId: event.userId,
          timePeriod: timePeriod,
        ),
      );

      result.fold(
        (failure) {
          emit(DashboardError(
            message: failure,
            currentPeriod: timePeriod,
          ));
        },
        (dashboardData) {
          emit(DashboardLoaded(
            data: dashboardData,
            currentPeriod: timePeriod,
          ));
        },
      );
    } catch (e) {
      emit(DashboardError(
        message: e.toString(),
        currentPeriod: timePeriod,
      ));
    }
  }

  void _onChangeDashboardTimePeriod(
    ChangeDashboardTimePeriod event,
    Emitter<DashboardState> emit,
  ) async {
    _currentPeriod = event.timePeriod;
    
    emit(DashboardLoading(currentPeriod: event.timePeriod));

    try {
      final result = await serviceLocator<GetDashboardItemUsecase>().call(
        params: GetDashboardParams(
          userId: event.userId,
          timePeriod: event.timePeriod,
        ),
      );

      result.fold(
        (failure) {
          emit(DashboardError(
            message: failure,
            currentPeriod: event.timePeriod,
          ));
        },
        (dashboardData) {
          emit(DashboardLoaded(
            data: dashboardData,
            currentPeriod: event.timePeriod,
          ));
        },
      );
    } catch (e) {
      emit(DashboardError(
        message: e.toString(),
        currentPeriod: event.timePeriod,
      ));
    }
  }
}

// Update the use case params
class GetDashboardParams {
  final String userId;
  final TimePeriod timePeriod;

  GetDashboardParams({
    required this.userId,
    required this.timePeriod,
  });
}
