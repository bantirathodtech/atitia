// lib/core/models/subscription/subscription_plan_model.dart

/// Model defining subscription plan tiers with pricing and features
/// Used for displaying plan options and enforcing subscription limits
library;

/// Subscription tier enumeration
enum SubscriptionTier {
  free,
  premium,
  enterprise;

  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.premium:
        return 'Premium';
      case SubscriptionTier.enterprise:
        return 'Enterprise';
    }
  }

  String get firestoreValue => name;
  
  static SubscriptionTier? fromFirestoreValue(String? value) {
    if (value == null) return null;
    try {
      return SubscriptionTier.values.firstWhere((tier) => tier.name == value);
    } catch (e) {
      return null;
    }
  }
}

/// Subscription plan configuration with features and pricing
class SubscriptionPlanModel {
  final SubscriptionTier tier;
  final String planId;
  final String name;
  final String description;
  final double monthlyPrice; // In INR
  final double yearlyPrice; // In INR (optional, can be null)
  final int maxPGs; // Maximum number of PGs allowed
  final List<String> features; // List of feature descriptions
  final bool isActive; // Whether this plan is available for subscription
  final Map<String, dynamic>? metadata; // Additional plan metadata

  const SubscriptionPlanModel({
    required this.tier,
    required this.planId,
    required this.name,
    required this.description,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.maxPGs,
    required this.features,
    this.isActive = true,
    this.metadata,
  });

  /// Factory constructor to create plan from Firestore document
  factory SubscriptionPlanModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionPlanModel(
      tier: SubscriptionTier.fromFirestoreValue(map['tier']) ?? SubscriptionTier.free,
      planId: map['planId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      monthlyPrice: (map['monthlyPrice'] as num?)?.toDouble() ?? 0.0,
      yearlyPrice: (map['yearlyPrice'] as num?)?.toDouble() ?? 0.0,
      maxPGs: (map['maxPGs'] as num?)?.toInt() ?? 1,
      features: List<String>.from(map['features'] ?? []),
      isActive: map['isActive'] as bool? ?? true,
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  /// Convert to map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'tier': tier.firestoreValue,
      'planId': planId,
      'name': name,
      'description': description,
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'maxPGs': maxPGs,
      'features': features,
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  /// Predefined plan configurations
  static const SubscriptionPlanModel freePlan = SubscriptionPlanModel(
    tier: SubscriptionTier.free,
    planId: 'free',
    name: 'Free',
    description: 'Basic features to get started',
    monthlyPrice: 0.0,
    yearlyPrice: 0.0,
    maxPGs: 1,
    features: [
      '1 PG listing',
      'Basic analytics',
      'Guest management',
      'Payment tracking',
      'Email support',
    ],
    isActive: true,
  );

  static const SubscriptionPlanModel premiumPlan = SubscriptionPlanModel(
    tier: SubscriptionTier.premium,
    planId: 'premium',
    name: 'Premium',
    description: 'Unlimited PGs with advanced features',
    monthlyPrice: 499.0,
    yearlyPrice: 4990.0, // ~2 months free when paid yearly
    maxPGs: -1, // -1 means unlimited
    features: [
      'Unlimited PG listings',
      'Advanced analytics',
      'Priority support',
      'Featured listing eligibility',
      'Export reports',
      'Custom branding',
    ],
    isActive: true,
  );

  static const SubscriptionPlanModel enterprisePlan = SubscriptionPlanModel(
    tier: SubscriptionTier.enterprise,
    planId: 'enterprise',
    name: 'Enterprise',
    description: 'Everything in Premium plus dedicated support',
    monthlyPrice: 999.0,
    yearlyPrice: 9990.0,
    maxPGs: -1, // -1 means unlimited
    features: [
      'Unlimited PG listings',
      'Advanced analytics',
      'Dedicated support',
      'Featured listing priority',
      'API access',
      'Custom integrations',
      'Training sessions',
    ],
    isActive: true,
  );

  /// Get all available plans
  static List<SubscriptionPlanModel> get allPlans => [
        freePlan,
        premiumPlan,
        enterprisePlan,
      ];

  /// Get plan by tier
  static SubscriptionPlanModel? getPlanByTier(SubscriptionTier tier) {
    try {
      return allPlans.firstWhere((plan) => plan.tier == tier);
    } catch (e) {
      return null;
    }
  }

  /// Get plan by plan ID
  static SubscriptionPlanModel? getPlanById(String planId) {
    try {
      return allPlans.firstWhere((plan) => plan.planId == planId);
    } catch (e) {
      return null;
    }
  }

  /// Check if plan allows unlimited PGs
  bool get allowsUnlimitedPGs => maxPGs == -1;

  /// Check if plan allows adding more PGs
  bool canAddPG(int currentPGCount) {
    if (allowsUnlimitedPGs) return true;
    return currentPGCount < maxPGs;
  }

  /// Get formatted monthly price
  String get formattedMonthlyPrice {
    if (monthlyPrice == 0) return 'Free';
    return '₹${monthlyPrice.toStringAsFixed(0)}/month';
  }

  /// Get formatted yearly price
  String get formattedYearlyPrice {
    if (yearlyPrice == 0) return 'Free';
    return '₹${yearlyPrice.toStringAsFixed(0)}/year';
  }

  /// Calculate yearly savings percentage
  double get yearlySavingsPercentage {
    if (monthlyPrice == 0 || yearlyPrice == 0) return 0.0;
    final monthlyTotal = monthlyPrice * 12;
    if (monthlyTotal == 0) return 0.0;
    return ((monthlyTotal - yearlyPrice) / monthlyTotal) * 100;
  }

  @override
  String toString() {
    return 'SubscriptionPlanModel(tier: $tier, name: $name, monthlyPrice: $monthlyPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubscriptionPlanModel && other.planId == planId;
  }

  @override
  int get hashCode => planId.hashCode;
}

