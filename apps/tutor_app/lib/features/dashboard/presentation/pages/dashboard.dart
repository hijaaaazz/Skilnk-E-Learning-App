import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import 'package:tutor_app/features/dashboard/presentation/bloc/dash_board_bloc.dart';
import 'package:tutor_app/features/dashboard/presentation/bloc/dash_board_event.dart';
import 'package:tutor_app/features/dashboard/presentation/bloc/dash_board_state.dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/earning_chart.dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/recent_activity.dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/stats_grid.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}



class _DashboardPageState extends State<DashboardPage> {

  @override
  void initState() {
    context.read<DashboardBloc>().add(LoadDashboardData(userId:context.read<AuthBloc>().state.user?.tutorId ?? ""));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is DashboardError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }
            
            if (state is DashboardLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    StatsGrid(data: state.data.data),
                    SizedBox(height: 16),
                    EarningsChart(
                      todayEarning: state.data.data.todayEarning,
                      description: state.data.data.earningDescription,
                    ),
                    SizedBox(height: 16),
                    RecentActivity(activities: state.data.activities),
                  ],
                ),
              );
            }
            
            return Container();
          },
        ),
      ),
    );
  }
}