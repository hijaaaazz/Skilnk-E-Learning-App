// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';
import 'package:tutor_app/features/dashboard/presentation/bloc/dash_board_bloc.dart';
import 'package:tutor_app/features/dashboard/presentation/bloc/dash_board_state.dart';
import '../../data/models/dashboard_data.dart';

class ModernEarningsCard extends StatelessWidget {
  final DashboardData data;
  final Function(TimePeriod)? onPeriodChanged;

  const ModernEarningsCard({
    super.key,
    required this.data,
    this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final currentEarnings = data.metrics.currentPeriodEarnings;
    final chartData = data.earningsChart;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6366F1),
            Color(0xFF8B5CF6),
          ],
        ),
        borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child:Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    _buildHeader(isMobile, isTablet),
    SizedBox(height: isMobile ? 16 : 20),
    _buildEarningsAmount(currentEarnings, isMobile, isTablet),
    SizedBox(height: 4),
    _buildPeriodAndGrowth(isMobile, isTablet),
    SizedBox(height: isMobile ? 20 : 24),
    
    if (context.read<DashboardBloc>().state is DashboardLoaded) 
      ...() {
        final state = context.read<DashboardBloc>().state as DashboardLoaded;
        if (state.currentPeriod != TimePeriod.allTime) {
          if (chartData.dataPoints.isNotEmpty) {
            return [_buildModernChart(chartData, isMobile, isTablet)];
          } else {
            return [_buildNoDataState(isMobile)];
          }
        }
        return []; 
      }(),
  ],
),

    );
  }

  Widget _buildHeader(bool isMobile, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 2,
          child: Text(
            'Earnings',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
      ],
    );
  }

 


  Widget _buildEarningsAmount(double currentEarnings, bool isMobile, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth,
            ),
            child: Text(
              '\$${currentEarnings.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 28 : (isTablet ? 32 : 36),
                fontWeight: FontWeight.w800,
                height: 1.0,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodAndGrowth(bool isMobile, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.6,
              ),
              child: Text(
                _getPeriodDisplayName(data.currentPeriod),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (data.growthData.hasComparisonData)
              _buildGrowthBadge(isMobile),
          ],
        );
      },
    );
  }

  String _getPeriodDisplayName(TimePeriod period) {
    switch (period) {
      case TimePeriod.today:
        return 'Today';
      case TimePeriod.thisWeek:
        return 'This Week';
      case TimePeriod.thisMonth:
        return 'This Month';
      case TimePeriod.allTime:
        return 'All Time';
      }
  }

  Widget _buildGrowthBadge(bool isMobile) {
    final growth = data.growthData.earningsGrowth;
    final isPositive = growth >= 0;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 6 : 8, 
        vertical: isMobile ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: isMobile ? 12 : 14,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            '${isPositive ? '+' : ''}${growth.toStringAsFixed(1)}%',
            style: TextStyle(
              color: Colors.white,
              fontSize: isMobile ? 10 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernChart(chartData, bool isMobile, bool isTablet) {
    return SizedBox(
      height: isMobile ? 100 : (isTablet ? 110 : 120),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: chartData.dataPoints.asMap().entries.map<Widget>((entry) {
              final index = entry.key;
              final point = entry.value;
              final maxHeight = isMobile ? 60.0 : (isTablet ? 70.0 : 80.0);
              final barHeight = chartData.maxValue > 0
                  ? (point.value / chartData.maxValue) * maxHeight
                  : 0.0;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 1 : 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (point.value > 0) ...[
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth / chartData.dataPoints.length - 4,
                          ),
                          child: FittedBox(
                            child: Text(
                              '#${point.value.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: isMobile ? 8 : 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                      Container(
                        width: double.infinity,
                        height: barHeight.clamp(2.0, maxHeight),
                        decoration: BoxDecoration(
                          color: point.isCurrent 
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(isMobile ? 3 : 4),
                        ),
                      ),
                      SizedBox(height: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.maxWidth / chartData.dataPoints.length - 4,
                        ),
                        child: FittedBox(
                          child: Text(
                            _getCorrectLabel(index, data.currentPeriod, isMobile),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: isMobile ? 8 : 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  String _getCorrectLabel(int index, TimePeriod period, bool isMobile) {
    final now = DateTime.now();
    
    switch (period) {
      case TimePeriod.today:
        final date = now.subtract(Duration(days: 6 - index));
        if (index == 6) return 'Today';
        return isMobile ? DateFormat('E').format(date) : DateFormat('EEE').format(date);
        
      case TimePeriod.thisWeek:
        if (index == 3) return isMobile ? 'Now' : 'This Week';
        return isMobile ? 'W${4-index}' : 'Week ${4-index}';
        
      case TimePeriod.thisMonth:
        final month = DateTime(now.year, now.month - (5 - index));
        if (index == 5) return isMobile ? 'Now' : 'This Month';
        return DateFormat(isMobile ? 'MMM' : 'MMM').format(month);
        
      case TimePeriod.allTime:
        final month = DateTime(now.year, now.month - (5 - index));
        return DateFormat(isMobile ? 'MMM' : 'MMM').format(month);
        
      }
  }

  Widget _buildNoDataState(bool isMobile) {
    return SizedBox(
      height: isMobile ? 100 : 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              color: Colors.white.withOpacity(0.6),
              size: isMobile ? 24 : 32,
            ),
            SizedBox(height: 8),
            Text(
              'No data available',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: isMobile ? 12 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
