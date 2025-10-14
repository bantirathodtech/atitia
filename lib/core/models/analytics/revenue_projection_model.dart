// lib/core/models/analytics/revenue_projection_model.dart

/// Model for revenue projections and forecasting
/// Used to display projected revenue based on historical data and occupancy trends
class RevenueProjectionModel {
  final String pgId;
  final int month;
  final int year;
  final double projectedRevenue;
  final double actualRevenue;
  final double occupancyRate;
  final double avgRentPerBed;
  final int totalBeds;
  final int occupiedBeds;
  final String projectionMethod; // 'historical', 'occupancy_based', 'manual'
  final DateTime createdAt;

  RevenueProjectionModel({
    required this.pgId,
    required this.month,
    required this.year,
    required this.projectedRevenue,
    this.actualRevenue = 0.0,
    required this.occupancyRate,
    required this.avgRentPerBed,
    required this.totalBeds,
    required this.occupiedBeds,
    this.projectionMethod = 'historical',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory RevenueProjectionModel.fromMap(Map<String, dynamic> map) {
    return RevenueProjectionModel(
      pgId: map['pgId'] as String,
      month: map['month'] as int,
      year: map['year'] as int,
      projectedRevenue: (map['projectedRevenue'] as num).toDouble(),
      actualRevenue: (map['actualRevenue'] as num?)?.toDouble() ?? 0.0,
      occupancyRate: (map['occupancyRate'] as num).toDouble(),
      avgRentPerBed: (map['avgRentPerBed'] as num).toDouble(),
      totalBeds: map['totalBeds'] as int,
      occupiedBeds: map['occupiedBeds'] as int,
      projectionMethod: map['projectionMethod'] as String? ?? 'historical',
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pgId': pgId,
      'month': month,
      'year': year,
      'projectedRevenue': projectedRevenue,
      'actualRevenue': actualRevenue,
      'occupancyRate': occupancyRate,
      'avgRentPerBed': avgRentPerBed,
      'totalBeds': totalBeds,
      'occupiedBeds': occupiedBeds,
      'projectionMethod': projectionMethod,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Getters
  String get formattedProjectedRevenue => '₹${projectedRevenue.toStringAsFixed(2)}';
  String get formattedActualRevenue => '₹${actualRevenue.toStringAsFixed(2)}';
  String get formattedOccupancyRate => '${(occupancyRate * 100).toStringAsFixed(1)}%';
  String get monthName {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }
  
  double get variance => actualRevenue - projectedRevenue;
  double get variancePercentage => projectedRevenue > 0 
      ? ((actualRevenue - projectedRevenue) / projectedRevenue) * 100 
      : 0.0;
  bool get isOverPerforming => actualRevenue > projectedRevenue;
  bool get isUnderPerforming => actualRevenue < projectedRevenue;
}

