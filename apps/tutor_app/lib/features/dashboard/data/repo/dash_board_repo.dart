import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';
import '../models/activity_item.dart';
import '../src/firebase_dashboard_service.dart';
import '../../domain/entity/dash_board_data_entity.dart';
import '../../domain/repo/dashboard_repo.dart';
import '../../../../service_locator.dart';

class DashBoardRepoImp extends DashBoardRepo {
  final FirebaseDashboardService _firebaseDashboardService = serviceLocator<FirebaseDashboardService>();

  @override
  Future<Either<String, DashBoardDataEntity>> getDashBoarddatas(String mentorId, {TimePeriod? timePeriod}) async {
    try {
      final result = await _firebaseDashboardService.getDashBoardData(
        mentorId, 
        timePeriod: timePeriod ?? TimePeriod.thisMonth,
      );

      return result.fold(
        (error) => Left(error),
        (dashboardDataEntity) async {
          final updatedActivities = <ActivityItem>[];

          for (final activity in dashboardDataEntity.activities) {
            final courseResult = await _firebaseDashboardService.getCourseName(activity.course);
            final courseName = courseResult.fold(
              (error) {
                log('Error fetching course name: $error');
                return activity.course;
              },
              (name) => name,
            );

            final studentResult = await _firebaseDashboardService.getStudentName(activity.userName);
            final studentName = studentResult.fold(
              (error) {
                log('Error fetching student name: $error');
                return activity.userName;
              },
              (name) => name,
            );

            final updatedActivity = ActivityItem(
              userName: studentName,
              action: activity.action,
              course: courseName,
              time: activity.time,
            );

            updatedActivities.add(updatedActivity);
          }

          return Right(DashBoardDataEntity(
            activities: updatedActivities,
            data: dashboardDataEntity.data,
          ));
        },
      );
    } catch (e) {
      log('Error in dashboard repository: $e');
      return Left('Error fetching dashboard data: $e');
    }
  }
}
