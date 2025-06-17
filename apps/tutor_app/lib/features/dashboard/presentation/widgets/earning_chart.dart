import 'package:flutter/material.dart';

class EarningsChart extends StatelessWidget {
  final String todayEarning;
  final String description;

  const EarningsChart({
    Key? key,
    required this.todayEarning,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Earnings',
                style: TextStyle(
                  color: Color(0xFF1D1F26),
                  fontSize: isMobile ? 14 : 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    'Today',
                    style: TextStyle(
                      color: Color(0xFF6E7484),
                      fontSize: isMobile ? 12 : 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Color(0xFF6E7484),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            todayEarning,
            style: TextStyle(
              color: Color(0xFF1D1F26),
              fontSize: isMobile ? 18 : 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Color(0xFF6E7484),
              fontSize: isMobile ? 12 : 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: isMobile ? 150 : 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(9, (index) {
                final heights = [159.0, 212.0, 94.0, 224.0, 108.0, 159.0, 74.0, 128.0, 110.0];
                final maxHeight = isMobile ? 120.0 : 180.0;
                final barHeight = (heights[index] / 224.0) * maxHeight;
                
                return Container(
                  width: isMobile ? 12 : 18,
                  height: barHeight,
                  decoration: BoxDecoration(
                    color: Color(0xFF23BD32),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}