import 'package:flutter/material.dart';
import 'package:tutor_app/features/dashboard/data/models/toime_period_dart';
import 'package:flutter/material.dart';
import 'package:tutor_app/features/dashboard/presentation/widgets/skeltons/skelton_loader.dart';
class DurationSelector extends StatelessWidget {
  final TimePeriod selectedPeriod;
  final Function(TimePeriod) onPeriodChanged;
  final bool isLoading;

  const DurationSelector({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SkeletonLoader(
          width: double.infinity,
          height: 48,
          borderRadius: BorderRadius.circular(16),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          _buildPeriodChip(TimePeriod.today, 'Today'),
          _buildPeriodChip(TimePeriod.thisWeek, 'Week'),
          _buildPeriodChip(TimePeriod.thisMonth, 'Month'),
          _buildPeriodChip(TimePeriod.allTime, 'All Time'),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(TimePeriod period, String label) {
    final isSelected = selectedPeriod == period;
    
    return Expanded(
      child: GestureDetector(
        onTap: isLoading ? null : () => onPeriodChanged(period),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ] : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Color(0xFF1A1A1A) : Color(0xFF6B7280),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
