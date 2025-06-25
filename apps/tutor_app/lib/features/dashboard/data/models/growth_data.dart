import 'package:equatable/equatable.dart';

class GrowthData extends Equatable {
  final double studentsGrowth;
  final double coursesGrowth;
  final double earningsGrowth;
  final double salesGrowth;
  final bool hasComparisonData;

  const GrowthData({
    required this.studentsGrowth,
    required this.coursesGrowth,
    required this.earningsGrowth,
    required this.salesGrowth,
    required this.hasComparisonData,
  });

  factory GrowthData.fromJson(Map<String, dynamic> json) {
    return GrowthData(
      studentsGrowth: (json['studentsGrowth'] ?? 0).toDouble(),
      coursesGrowth: (json['coursesGrowth'] ?? 0).toDouble(),
      earningsGrowth: (json['earningsGrowth'] ?? 0).toDouble(),
      salesGrowth: (json['salesGrowth'] ?? 0).toDouble(),
      hasComparisonData: json['hasComparisonData'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentsGrowth': studentsGrowth,
      'coursesGrowth': coursesGrowth,
      'earningsGrowth': earningsGrowth,
      'salesGrowth': salesGrowth,
      'hasComparisonData': hasComparisonData,
    };
  }

  String getGrowthString(double growth) {
    if (!hasComparisonData) return 'N/A';
    return '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%';
  }

  @override
  List<Object?> get props => [
        studentsGrowth,
        coursesGrowth,
        earningsGrowth,
        salesGrowth,
        hasComparisonData,
      ];
}
