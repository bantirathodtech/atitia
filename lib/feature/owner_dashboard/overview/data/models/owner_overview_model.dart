// lib/features/owner_dashboard/overview/data/models/owner_overview_model.dart

import 'package:intl/intl.dart';

/// Comprehensive model for owner dashboard overview
/// Contains aggregated data from properties, tenants, bookings, and payments
class OwnerOverviewModel {
  final String ownerId;
  final int totalProperties;
  final double totalRevenue;
  final double pendingRevenue;
  final int activeTenants;
  final int totalTenants;
  final int pendingBookings;
  final int approvedBookings;
  final int totalBeds;
  final int occupiedBeds;
  final int vacantBeds;
  final double monthlyRevenue;
  final double yearlyRevenue;
  final int pendingComplaints;
  final int resolvedComplaints;
  final DateTime? lastUpdated;
  final Map<String, dynamic>? monthlyBreakdown;
  final Map<String, dynamic>? propertyBreakdown;
  final Map<String, dynamic>? metadata;

  OwnerOverviewModel({
    required this.ownerId,
    this.totalProperties = 0,
    this.totalRevenue = 0.0,
    this.pendingRevenue = 0.0,
    this.activeTenants = 0,
    this.totalTenants = 0,
    this.pendingBookings = 0,
    this.approvedBookings = 0,
    this.totalBeds = 0,
    this.occupiedBeds = 0,
    this.vacantBeds = 0,
    this.monthlyRevenue = 0.0,
    this.yearlyRevenue = 0.0,
    this.pendingComplaints = 0,
    this.resolvedComplaints = 0,
    DateTime? lastUpdated,
    this.monthlyBreakdown,
    this.propertyBreakdown,
    this.metadata,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory OwnerOverviewModel.fromJson(Map<String, dynamic> json) {
    return OwnerOverviewModel(
      ownerId: json['ownerId'] ?? '',
      totalProperties: json['totalProperties'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      pendingRevenue: (json['pendingRevenue'] ?? 0).toDouble(),
      activeTenants: json['activeTenants'] ?? 0,
      totalTenants: json['totalTenants'] ?? 0,
      pendingBookings: json['pendingBookings'] ?? 0,
      approvedBookings: json['approvedBookings'] ?? 0,
      totalBeds: json['totalBeds'] ?? 0,
      occupiedBeds: json['occupiedBeds'] ?? 0,
      vacantBeds: json['vacantBeds'] ?? 0,
      monthlyRevenue: (json['monthlyRevenue'] ?? 0).toDouble(),
      yearlyRevenue: (json['yearlyRevenue'] ?? 0).toDouble(),
      pendingComplaints: json['pendingComplaints'] ?? 0,
      resolvedComplaints: json['resolvedComplaints'] ?? 0,
      lastUpdated: json['lastUpdated']?.toDate(),
      monthlyBreakdown: json['monthlyBreakdown'] != null
          ? Map<String, dynamic>.from(json['monthlyBreakdown'])
          : null,
      propertyBreakdown: json['propertyBreakdown'] != null
          ? Map<String, dynamic>.from(json['propertyBreakdown'])
          : null,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'totalProperties': totalProperties,
      'totalRevenue': totalRevenue,
      'pendingRevenue': pendingRevenue,
      'activeTenants': activeTenants,
      'totalTenants': totalTenants,
      'pendingBookings': pendingBookings,
      'approvedBookings': approvedBookings,
      'totalBeds': totalBeds,
      'occupiedBeds': occupiedBeds,
      'vacantBeds': vacantBeds,
      'monthlyRevenue': monthlyRevenue,
      'yearlyRevenue': yearlyRevenue,
      'pendingComplaints': pendingComplaints,
      'resolvedComplaints': resolvedComplaints,
      'lastUpdated': lastUpdated,
      'monthlyBreakdown': monthlyBreakdown,
      'propertyBreakdown': propertyBreakdown,
      'metadata': metadata,
    };
  }

  /// Calculates occupancy rate percentage
  double get occupancyRate {
    if (totalBeds == 0) return 0.0;
    return (occupiedBeds / totalBeds) * 100;
  }

  /// Calculates vacancy rate percentage
  double get vacancyRate {
    if (totalBeds == 0) return 0.0;
    return (vacantBeds / totalBeds) * 100;
  }

  /// Calculates collection rate percentage
  double get collectionRate {
    final total = totalRevenue + pendingRevenue;
    if (total == 0) return 0.0;
    return (totalRevenue / total) * 100;
  }

  /// Calculates average revenue per property
  double get averageRevenuePerProperty {
    if (totalProperties == 0) return 0.0;
    return totalRevenue / totalProperties;
  }

  /// Calculates average tenants per property
  double get averageTenantsPerProperty {
    if (totalProperties == 0) return 0.0;
    return activeTenants / totalProperties;
  }

  /// Returns formatted total revenue
  String get formattedTotalRevenue =>
      '₹${NumberFormat('#,##0').format(totalRevenue)}';

  /// Returns formatted pending revenue
  String get formattedPendingRevenue =>
      '₹${NumberFormat('#,##0').format(pendingRevenue)}';

  /// Returns formatted monthly revenue
  String get formattedMonthlyRevenue =>
      '₹${NumberFormat('#,##0').format(monthlyRevenue)}';

  /// Returns formatted yearly revenue
  String get formattedYearlyRevenue =>
      '₹${NumberFormat('#,##0').format(yearlyRevenue)}';

  /// Returns formatted occupancy rate
  String get formattedOccupancyRate => '${occupancyRate.toStringAsFixed(1)}%';

  /// Returns formatted collection rate
  String get formattedCollectionRate => '${collectionRate.toStringAsFixed(1)}%';

  /// Returns formatted average revenue per property
  String get formattedAvgRevenuePerProperty =>
      '₹${NumberFormat('#,##0').format(averageRevenuePerProperty)}';

  /// Returns performance indicator based on occupancy rate
  String get performanceIndicator {
    final rate = occupancyRate;
    if (rate >= 80) return 'Excellent';
    if (rate >= 60) return 'Good';
    if (rate >= 40) return 'Fair';
    return 'Needs Attention';
  }

  /// Returns performance color based on occupancy rate
  int get performanceColor {
    final rate = occupancyRate;
    if (rate >= 80) return 0xFF4CAF50; // Green
    if (rate >= 60) return 0xFF8BC34A; // Light Green
    if (rate >= 40) return 0xFFFFA726; // Orange
    return 0xFFEF5350; // Red
  }

  /// Checks if owner has any properties
  bool get hasProperties => totalProperties > 0;

  /// Checks if owner has any tenants
  bool get hasTenants => totalTenants > 0;

  /// Checks if owner has any pending bookings
  bool get hasPendingBookings => pendingBookings > 0;

  /// Checks if owner has any pending complaints
  bool get hasPendingComplaints => pendingComplaints > 0;

  /// Returns total bookings count
  int get totalBookings => pendingBookings + approvedBookings;

  /// Returns total complaints count
  int get totalComplaints => pendingComplaints + resolvedComplaints;

  /// Returns occupancy display text
  String get occupancyDisplay => '$occupiedBeds/$totalBeds beds occupied';

  @override
  String toString() {
    return 'OwnerOverviewModel(ownerId: $ownerId, properties: $totalProperties, revenue: $formattedTotalRevenue)';
  }
}
