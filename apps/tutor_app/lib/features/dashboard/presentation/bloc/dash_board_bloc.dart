import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/dashboard/data/models/activity_item.dart';
import 'package:tutor_app/features/dashboard/data/models/dashboard_data.dart';
import 'package:tutor_app/features/dashboard/domain/entity/dash_board_data_entity.dart';
import 'package:tutor_app/features/dashboard/domain/usecase/get_dashboard_item_usecase.dart';
import 'package:tutor_app/features/dashboard/presentation/bloc/dash_board_event.dart';
import 'package:tutor_app/features/dashboard/presentation/bloc/dash_board_state.dart';
import 'package:tutor_app/service_locator.dart';

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<LoadDashboardData>(_onLoadDashboardData);
  }

  void _onLoadDashboardData(
  LoadDashboardData event,
  Emitter<DashboardState> emit,
) async {
  emit(DashboardLoading());

  try {
    final result = await serviceLocator<GetDashboardItemUsecase>().call(params: event.userId);

    result.fold(
      (failure) {
        // Show dummy data when failed
        final fallback = DashBoardDataEntity(
          data: DashboardData(
            students: '1,674,767',
            courses: '3',
            totalEarning: '\$7,461,767',
            courseSold: '56,489',
            todayEarning: '\$7,443',
            earningDescription: 'USD Dollar you earned.',
          ),
          activities: [
            ActivityItem(
              userName: 'Kevin',
              action: 'comments on your lecture',
              course: '"What is ux" in "2021 ui/ux design with figma"',
              time: 'Just now',
            ),
            ActivityItem(
              userName: 'John',
              action: 'give a 5 star rating on your course',
              course: '"2021 ui/ux design with figma"',
              time: '5 mins ago',
            ),
            ActivityItem(
              userName: 'Sraboni',
              action: 'purchase your course',
              course: '"2021 ui/ux design with figma"',
              time: '6 mins ago',
            ),
            ActivityItem(
              userName: 'Arif',
              action: 'purchase your course',
              course: '"2021 ui/ux design with figma"',
              time: '19 mins ago',
            ),
            ActivityItem(
              userName: 'Monir',
              action: 'give a 5 star rating on your course',
              course: '"2021 ui/ux design with figma"',
              time: '5 mins ago',
            ),
          ],
        );

        emit(DashboardLoaded(data: fallback));
      },
      (dashboardData) {
        emit(DashboardLoaded(data: dashboardData));
      },
    );
  } catch (e) {
    emit(DashboardError(message: e.toString()));
  }
}

}