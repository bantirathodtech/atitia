// lib/core/models/analytics/occupancy_trend_model.dart

/// Model for tracking occupancy trends over time
/// Used to display historical occupancy data and identify patterns
library;

import '../../../common/utils/date/converter/date_service_converter.dart';

class OccupancyTrendModel {
  final String pgId;
  final DateTime date;
  final int totalBeds;
  final int occupiedBeds;
  final int vacantBeds;
  final double occupancyRate;
  final int newBookings;
  final int checkOuts;
  final double revenueGenerated;

  OccupancyTrendModel({
    required this.pgId,
    required this.date,
    required this.totalBeds,
    required this.occupiedBeds,
    this.vacantBeds = 0,
    required this.occupancyRate,
    this.newBookings = 0,
    this.checkOuts = 0,
    this.revenueGenerated = 0.0,
  });

  factory OccupancyTrendModel.fromMap(Map<String, dynamic> map) {
    return OccupancyTrendModel(
      pgId: map['pgId'] as String,
      date: DateServiceConverter.fromService(map['date'] as String),
      totalBeds: map['totalBeds'] as int,
      occupiedBeds: map['occupiedBeds'] as int,
      vacantBeds: map['vacantBeds'] as int? ?? 0,
      occupancyRate: (map['occupancyRate'] as num).toDouble(),
      newBookings: map['newBookings'] as int? ?? 0,
      checkOuts: map['checkOuts'] as int? ?? 0,
      revenueGenerated: (map['revenueGenerated'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pgId': pgId,
      'date': DateServiceConverter.toService(date),
      'totalBeds': totalBeds,
      'occupiedBeds': occupiedBeds,
      'vacantBeds': vacantBeds,
      'occupancyRate': occupancyRate,
      'newBookings': newBookings,
      'checkOuts': checkOuts,
      'revenueGenerated': revenueGenerated,
    };
  }

  // Getters
  String get formattedDate => '${date.day}/${date.month}';
  String get formattedOccupancyRate =>
      '${(occupancyRate * 100).toStringAsFixed(1)}%';
  String get formattedRevenue => '₹${revenueGenerated.toStringAsFixed(0)}';

  bool get isFullyOccupied => occupiedBeds >= totalBeds;
  bool get isFullyVacant => occupiedBeds == 0;
  bool get isHighOccupancy => occupancyRate >= 0.8;
  bool get isMediumOccupancy => occupancyRate >= 0.5 && occupancyRate < 0.8;
  bool get isLowOccupancy => occupancyRate < 0.5;
}
