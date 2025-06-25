import 'package:flutter/material.dart';

class ModernStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final double? growth;
  final bool isFullWidth;

  const ModernStatCard({
    Key? key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.growth,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(isMobile ? 10 : 12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isMobile ? 20 : 24,
                ),
              ),
              if (growth != null) 
                Flexible(
                  child: _buildGrowthIndicator(isMobile, isTablet),
                ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 24 : (isTablet ? 26 : 28),
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                height: 1.0,
              ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthIndicator(bool isMobile, bool isTablet) {
    if (growth == null) return SizedBox();
    
    final isPositive = growth! >= 0;
    final color = isPositive ? Color(0xFF10B981) : Color(0xFFEF4444);
    final growthText = '${growth!.abs().toStringAsFixed(1)}%';
    
    return Container(
      constraints: BoxConstraints(
        maxWidth: isMobile ? 80 : (isTablet ? 90 : 100),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 6 : 8, 
        vertical: isMobile ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            size: isMobile ? 10 : 12,
            color: color,
          ),
          SizedBox(width: 2),
          Flexible(
            child: Text(
              growthText,
              style: TextStyle(
                fontSize: isMobile ? 10 : 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
