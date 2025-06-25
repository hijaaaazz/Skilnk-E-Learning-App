import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/duaration_selector.dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/recent_activity.dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/skeltons/dash_board_skelton.dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/stats_grid.dart';
import '../../../auth/presentation/blocs/auth_cubit/bloc/auth_status_bloc.dart';
import '../bloc/dash_board_bloc.dart';
import '../bloc/dash_board_event.dart';
import '../bloc/dash_board_state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String get _userId => context.read<AuthBloc>().state.user?.tutorId ?? "";

  @override
  void initState() {
    super.initState();
    // Load with Today as default
    context.read<DashboardBloc>().add(
      LoadDashboardData(
        userId: _userId,
        timePeriod: TimePeriod.today,
      ),
    );
  }

  void _onTimePeriodChanged(TimePeriod timePeriod) {
    context.read<DashboardBloc>().add(
      ChangeDashboardTimePeriod(
        userId: _userId,
        timePeriod: timePeriod,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildHeader(state),
                Expanded(
                  child: _buildBody(state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(DashboardState state) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Spacer(),
              
              ],
            ),
          ),
          
          if (state is DashboardLoaded)
            DurationSelector(
              selectedPeriod: state.currentPeriod,
              onPeriodChanged: _onTimePeriodChanged,
              isLoading: false,
            )
          else if (state is DashboardLoading && state.currentPeriod != null)
            DurationSelector(
              selectedPeriod: state.currentPeriod!,
              onPeriodChanged: _onTimePeriodChanged,
              isLoading: false,
            )
          else
            DurationSelector(
              selectedPeriod: TimePeriod.today, // Default to today
              onPeriodChanged: _onTimePeriodChanged,
              isLoading: true,
            ),
        ],
      ),
    );
  }

  Widget _buildBody(DashboardState state) {
    if (state is DashboardLoading) {
      return _buildLoadingStateWithSkeletons();
    }

    if (state is DashboardError) {
      return _buildErrorState(state);
    }

    if (state is DashboardLoaded) {
      return _buildLoadedState(state);
    }

    return _buildInitialStateWithSkeletons();
  }

  Widget _buildLoadingStateWithSkeletons() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          DashboardSkeletonGrid(),
          SizedBox(height: 24),
          RecentActivitySkeleton(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInitialStateWithSkeletons() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          DashboardSkeletonGrid(),
          SizedBox(height: 24),
          RecentActivitySkeleton(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildErrorState(DashboardError state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade400,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 8),
            Text(
              state.message,
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<DashboardBloc>().add(
                  LoadDashboardData(
                    userId: _userId,
                    timePeriod: state.currentPeriod ?? TimePeriod.today,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6366F1),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'Try Again',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(DashboardLoaded state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(
          LoadDashboardData(
            userId: _userId,
            timePeriod: state.currentPeriod,
          ),
        );
      },
      color: Color(0xFF6366F1),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 20),
            ModernStatsGrid(
              data: state.data.data,
              onPeriodChanged: _onTimePeriodChanged,
            ),
            SizedBox(height: 24),
            ModernRecentActivity(activities: state.data.activities),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
