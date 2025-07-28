// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';
import '../../data/models/dashboard_data.dart';

class EarningsChart extends StatelessWidget {
  final DashboardData data;
  final Function(TimePeriod)? onPeriodChanged;

  const EarningsChart({
    super.key,
    required this.data,
    this.onPeriodChanged,
    // Backward compatibility parameters
    String? thisMonthEarning,
    List<double>? previousMonthEarnings,
    String? description,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final currentEarnings = data.metrics.currentPeriodEarnings;
    final chartData = data.earningsChart;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          SizedBox(height: 24),
          _buildCurrentValue(currentEarnings, isMobile),
          SizedBox(height: 8),
          _buildDescription(isMobile),
          if (data.growthData.hasComparisonData) ...[
            SizedBox(height: 12),
            _buildGrowthIndicator(isMobile),
          ],
          if (data.insights.primaryInsight.isNotEmpty) ...[
            SizedBox(height: 16),
            _buildInsights(isMobile),
          ],
          SizedBox(height: 24),
          if (chartData.dataPoints.isNotEmpty)
            _buildChart(chartData, isMobile)
          else
            _buildNoDataMessage(isMobile),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              color: Color(0xFF23BD32),
              size: isMobile ? 20 : 24,
            ),
            SizedBox(width: 8),
            Text(
              'Earnings',
              style: TextStyle(
                color: Color(0xFF1D1F26),
                fontSize: isMobile ? 16 : 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        
      ],
    );
  }

  Widget _buildCurrentValue(double currentEarnings, bool isMobile) {
    return Text(
      '\$${currentEarnings.toStringAsFixed(2)}',
      style: TextStyle(
        color: Color(0xFF1D1F26),
        fontSize: isMobile ? 24 : 28,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildDescription(bool isMobile) {
    return Text(
      data.currentPeriod.displayName,
      style: TextStyle(
        color: Color(0xFF6E7484),
        fontSize: isMobile ? 13 : 15,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildGrowthIndicator(bool isMobile) {
    final growth = data.growthData.earningsGrowth;
    final isPositive = growth >= 0;
    final color = isPositive ? Color(0xFF28A745) : Color(0xFFDC3545);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: isMobile ? 14 : 16,
            color: color,
          ),
          SizedBox(width: 4),
          Text(
            '${isPositive ? '+' : ''}${growth.toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontSize: isMobile ? 12 : 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4),
          Text(
            'vs previous period',
            style: TextStyle(
              color: color,
              fontSize: isMobile ? 10 : 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFE9ECEF)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Color(0xFF23BD32),
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              data.insights.primaryInsight,
              style: TextStyle(
                color: Color(0xFF495057),
                fontSize: isMobile ? 11 : 13,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart(chartData, bool isMobile) {
    return SizedBox(
      height: isMobile ? 180 : 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: chartData.dataPoints.map<Widget>((point) {
          final barHeight = chartData.maxValue > 0
              ? (point.value / chartData.maxValue) * (isMobile ? 140.0 : 180.0)
              : 0.0;

          return Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (point.value > 0) ...[
                    Text(
                      '\$${point.value.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Color(0xFF6C757D),
                        fontSize: isMobile ? 9 : 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                  ],
                  Container(
                    width: double.infinity,
                    height: barHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: point.isCurrent
                            ? [Color(0xFF23BD32), Color(0xFF28A745)]
                            : [Color(0xFFDEE2E6), Color(0xFFADB5BD)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: point.isCurrent
                          ? [
                              BoxShadow(
                                color: Color(0xFF23BD32).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    point.label,
                    style: TextStyle(
                      color: point.isCurrent ? Color(0xFF1D1F26) : Color(0xFF6C757D),
                      fontSize: isMobile ? 10 : 12,
                      fontWeight: point.isCurrent ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNoDataMessage(bool isMobile) {
    return SizedBox(
      height: isMobile ? 120 : 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart,
              color: Color(0xFFDEE2E6),
              size: isMobile ? 32 : 40,
            ),
            SizedBox(height: 12),
            Text(
              'No historical data available',
              style: TextStyle(
                color: Color(0xFF6C757D),
                fontSize: isMobile ? 12 : 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Start selling courses to see comparisons',
              style: TextStyle(
                color: Color(0xFFADB5BD),
                fontSize: isMobile ? 10 : 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
