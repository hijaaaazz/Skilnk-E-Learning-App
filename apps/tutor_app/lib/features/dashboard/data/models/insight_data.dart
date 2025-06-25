import 'package:equatable/equatable.dart';

class InsightsData extends Equatable {
  final String primaryInsight;
  final String trendAnalysis;
  final String recommendation;
  final String peakPeriod;
  final List<String> keyHighlights;

  const InsightsData({
    required this.primaryInsight,
    required this.trendAnalysis,
    required this.recommendation,
    required this.peakPeriod,
    required this.keyHighlights,
  });

  factory InsightsData.fromJson(Map<String, dynamic> json) {
    return InsightsData(
      primaryInsight: json['primaryInsight'] ?? '',
      trendAnalysis: json['trendAnalysis'] ?? '',
      recommendation: json['recommendation'] ?? '',
      peakPeriod: json['peakPeriod'] ?? '',
      keyHighlights: List<String>.from(json['keyHighlights'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primaryInsight': primaryInsight,
      'trendAnalysis': trendAnalysis,
      'recommendation': recommendation,
      'peakPeriod': peakPeriod,
      'keyHighlights': keyHighlights,
    };
  }

  @override
  List<Object?> get props => [
        primaryInsight,
        trendAnalysis,
        recommendation,
        peakPeriod,
        keyHighlights,
      ];
}
