import 'package:equatable/equatable.dart';

class ChartDataPoint extends Equatable {
  final String label;
  final double value;
  final DateTime date;
  final bool isCurrent;

  const ChartDataPoint({
    required this.label,
    required this.value,
    required this.date,
    required this.isCurrent,
  });

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) {
    return ChartDataPoint(
      label: json['label'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      isCurrent: json['isCurrent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'date': date.toIso8601String(),
      'isCurrent': isCurrent,
    };
  }

  @override
  List<Object?> get props => [label, value, date, isCurrent];
}

class ChartData extends Equatable {
  final List<ChartDataPoint> dataPoints;
  final double maxValue;
  final String chartType;

  const ChartData({
    required this.dataPoints,
    required this.maxValue,
    required this.chartType,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      dataPoints: (json['dataPoints'] as List)
          .map((point) => ChartDataPoint.fromJson(point))
          .toList(),
      maxValue: (json['maxValue'] ?? 0).toDouble(),
      chartType: json['chartType'] ?? 'bar',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dataPoints': dataPoints.map((point) => point.toJson()).toList(),
      'maxValue': maxValue,
      'chartType': chartType,
    };
  }

  @override
  List<Object?> get props => [dataPoints, maxValue, chartType];
}
