// lib/feature/admin_dashboard/revenue/viewmodel/admin_revenue_viewmodel.dart

import 'package:flutter/foundation.dart';

import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../core/repositories/revenue/revenue_repository.dart';
import '../../../../../core/repositories/subscription/owner_subscription_repository.dart';
import '../../../../../core/repositories/featured/featured_listing_repository.dart';
import '../../../../../core/interfaces/analytics/analytics_service_interface.dart';
import '../../../../../core/models/revenue/revenue_record_model.dart';
import '../../../../../core/models/subscription/owner_subscription_model.dart';
import '../../../../../core/models/featured/featured_listing_model.dart';
import '../../../../../common/lifecycle/state/provider_state.dart';
import '../../../../../common/lifecycle/mixin/stream_subscription_mixin.dart';

/// ViewModel for Admin Revenue Dashboard
/// Aggregates app-level revenue metrics, subscription stats, and featured listing stats
class AdminRevenueViewModel extends BaseProviderState
    with StreamSubscriptionMixin {
  final RevenueRepository _revenueRepo;
  final OwnerSubscriptionRepository _subscriptionRepo;
  final FeaturedListingRepository _featuredListingRepo;
  final IAnalyticsService _analyticsService;

  // Revenue data
  double _totalRevenue = 0.0;
  double _monthlyRevenue = 0.0;
  double _yearlyRevenue = 0.0;
  Map<RevenueType, double> _revenueByType = {};
  Map<String, double> _monthlyBreakdown = {};

  // Subscription stats
  int _activeSubscriptionsCount = 0;
  int _totalSubscriptionsCount = 0;
  Map<String, int> _subscriptionsByTier = {};

  // Featured listing stats
  int _activeFeaturedListingsCount = 0;
  int _totalFeaturedListingsCount = 0;

  // Conversion metrics
  double _conversionRate = 0.0; // Free to Premium conversion rate
  double _averageRevenuePerOwner = 0.0; // ARPO

  // Selected period for filtering
  String _selectedPeriod = 'month'; // 'month', 'year', 'all'
  int _selectedYear = DateTime.now().year;
  int _selectedMonth = DateTime.now().month;

  AdminRevenueViewModel({
    RevenueRepository? revenueRepo,
    OwnerSubscriptionRepository? subscriptionRepo,
    FeaturedListingRepository? featuredListingRepo,
    IAnalyticsService? analyticsService,
  })  : _revenueRepo = revenueRepo ?? RevenueRepository(),
        _subscriptionRepo = subscriptionRepo ?? OwnerSubscriptionRepository(),
        _featuredListingRepo =
            featuredListingRepo ?? FeaturedListingRepository(),
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  // Getters
  double get totalRevenue => _totalRevenue;
  double get monthlyRevenue => _monthlyRevenue;
  double get yearlyRevenue => _yearlyRevenue;
  Map<RevenueType, double> get revenueByType =>
      Map.unmodifiable(_revenueByType);
  Map<String, double> get monthlyBreakdown =>
      Map.unmodifiable(_monthlyBreakdown);
  int get activeSubscriptionsCount => _activeSubscriptionsCount;
  int get totalSubscriptionsCount => _totalSubscriptionsCount;
  Map<String, int> get subscriptionsByTier =>
      Map.unmodifiable(_subscriptionsByTier);
  int get activeFeaturedListingsCount => _activeFeaturedListingsCount;
  int get totalFeaturedListingsCount => _totalFeaturedListingsCount;
  double get conversionRate => _conversionRate;
  double get averageRevenuePerOwner => _averageRevenuePerOwner;
  String get selectedPeriod => _selectedPeriod;
  int get selectedYear => _selectedYear;
  int get selectedMonth => _selectedMonth;

  /// Initialize ViewModel and load all admin revenue data
  Future<void> initialize() async {
    try {
      setLoading(true);
      clearError();

      await _analyticsService.logEvent(
        name: 'admin_revenue_dashboard_initialized',
        parameters: {},
      );

      // Load all data in parallel
      await Future.wait([
        _loadRevenueData(),
        _loadSubscriptionStats(),
        _loadFeaturedListingStats(),
        _calculateMetrics(),
      ]);

      // Start real-time streams
      _startDataStreams();

      setLoading(false);
    } catch (e) {
      setError(true, 'Failed to initialize admin revenue dashboard: $e');
      debugPrint('❌ Error initializing admin revenue dashboard: $e');
    }
  }

  /// Load revenue data
  Future<void> _loadRevenueData() async {
    try {
      final now = DateTime.now();

      // Load total revenue
      _totalRevenue = await _revenueRepo.getTotalRevenue();

      // Load monthly revenue
      _monthlyRevenue =
          await _revenueRepo.getMonthlyRevenue(now.year, now.month);

      // Load yearly revenue
      _yearlyRevenue = await _revenueRepo.getYearlyRevenue(now.year);

      // Load revenue breakdown by type
      _revenueByType = await _revenueRepo.getRevenueBreakdownByType();

      // Load monthly breakdown for charts
      _monthlyBreakdown = await _revenueRepo.getMonthlyRevenueBreakdown();

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading revenue data: $e');
      rethrow;
    }
  }

  /// Load subscription statistics
  Future<void> _loadSubscriptionStats() async {
    try {
      // Get all subscriptions
      final allSubscriptions =
          await _subscriptionRepo.getAllSubscriptionsAdmin();

      _totalSubscriptionsCount = allSubscriptions.length;

      // Count active subscriptions
      final now = DateTime.now();
      _activeSubscriptionsCount = allSubscriptions
          .where((sub) =>
              sub.status == SubscriptionStatus.active &&
              sub.endDate.isAfter(now))
          .length;

      // Count by tier
      _subscriptionsByTier = {
        'free': 0,
        'premium': 0,
        'enterprise': 0,
      };

      // Count owners by tier (use active subscriptions)
      final activeSubs = allSubscriptions.where((sub) =>
          sub.status == SubscriptionStatus.active && sub.endDate.isAfter(now));

      for (final sub in activeSubs) {
        final tier = sub.tier.firestoreValue;
        _subscriptionsByTier[tier] = (_subscriptionsByTier[tier] ?? 0) + 1;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading subscription stats: $e');
      rethrow;
    }
  }

  /// Load featured listing statistics
  Future<void> _loadFeaturedListingStats() async {
    try {
      // Get all featured listings
      final allListings =
          await _featuredListingRepo.getAllFeaturedListingsAdmin();

      _totalFeaturedListingsCount = allListings.length;

      // Count active featured listings
      final now = DateTime.now();
      _activeFeaturedListingsCount = allListings
          .where((listing) =>
              listing.status == FeaturedListingStatus.active &&
              listing.endDate.isAfter(now))
          .length;

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading featured listing stats: $e');
      rethrow;
    }
  }

  /// Calculate conversion metrics
  Future<void> _calculateMetrics() async {
    try {
      // Calculate conversion rate (Free → Premium)
      // Get all owners with subscriptions
      final allSubscriptions =
          await _subscriptionRepo.getAllSubscriptionsAdmin();

      // Group by owner ID to get unique owners
      final ownerTiers = <String, String>{};
      final now = DateTime.now();

      for (final sub in allSubscriptions) {
        if (sub.status == SubscriptionStatus.active &&
            sub.endDate.isAfter(now)) {
          ownerTiers[sub.ownerId] = sub.tier.firestoreValue;
        }
      }

      final premiumCount =
          ownerTiers.values.where((tier) => tier != 'free').length;
      final totalOwners = ownerTiers.length;

      if (totalOwners > 0) {
        _conversionRate = (premiumCount / totalOwners) * 100;
      }

      // Calculate Average Revenue Per Owner (ARPO)
      if (totalOwners > 0) {
        _averageRevenuePerOwner = _totalRevenue / totalOwners;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error calculating metrics: $e');
      // Don't rethrow - metrics are not critical
    }
  }

  /// Start real-time data streams
  void _startDataStreams() {
    // Stream revenue data
    addSubscription(
      _revenueRepo.streamAllRevenue().listen(
        (revenues) {
          _updateRevenueFromStream(revenues);
        },
        onError: (error) {
          debugPrint('❌ Error streaming revenue: $error');
        },
      ),
    );

    // Stream subscriptions
    addSubscription(
      _subscriptionRepo.streamAllSubscriptionsAdmin().listen(
        (subscriptions) {
          _updateSubscriptionStatsFromStream(subscriptions);
        },
        onError: (error) {
          debugPrint('❌ Error streaming subscriptions: $error');
        },
      ),
    );

    // Stream featured listings
    addSubscription(
      _featuredListingRepo.streamAllFeaturedListingsAdmin().listen(
        (listings) {
          _updateFeaturedListingStatsFromStream(listings);
        },
        onError: (error) {
          debugPrint('❌ Error streaming featured listings: $error');
        },
      ),
    );
  }

  /// Update revenue data from stream
  void _updateRevenueFromStream(List<RevenueRecordModel> revenues) {
    final completedRevenues =
        revenues.where((r) => r.status == PaymentStatus.completed).toList();

    _totalRevenue = completedRevenues.fold<double>(
      0.0,
      (sum, revenue) => sum + revenue.amount,
    );

    final now = DateTime.now();
    _monthlyRevenue = completedRevenues
        .where((r) =>
            r.paymentDate.year == now.year && r.paymentDate.month == now.month)
        .fold<double>(0.0, (sum, revenue) => sum + revenue.amount);

    _yearlyRevenue = completedRevenues
        .where((r) => r.paymentDate.year == now.year)
        .fold<double>(0.0, (sum, revenue) => sum + revenue.amount);

    // Update breakdown by type
    _revenueByType = {
      RevenueType.subscription: 0.0,
      RevenueType.featuredListing: 0.0,
      RevenueType.successFee: 0.0,
    };

    for (final revenue in completedRevenues) {
      _revenueByType[revenue.type] =
          (_revenueByType[revenue.type] ?? 0.0) + revenue.amount;
    }

    // Update monthly breakdown
    _monthlyBreakdown.clear();
    for (final revenue in completedRevenues) {
      final monthYear = revenue.monthYear;
      _monthlyBreakdown[monthYear] =
          (_monthlyBreakdown[monthYear] ?? 0.0) + revenue.amount;
    }

    notifyListeners();
  }

  /// Update subscription stats from stream
  void _updateSubscriptionStatsFromStream(
      List<OwnerSubscriptionModel> subscriptions) {
    _totalSubscriptionsCount = subscriptions.length;

    final now = DateTime.now();
    _activeSubscriptionsCount = subscriptions
        .where((sub) =>
            sub.status == SubscriptionStatus.active && sub.endDate.isAfter(now))
        .length;

    // Update by tier
    _subscriptionsByTier = {
      'free': 0,
      'premium': 0,
      'enterprise': 0,
    };

    final activeSubs = subscriptions.where((sub) =>
        sub.status == SubscriptionStatus.active && sub.endDate.isAfter(now));

    for (final sub in activeSubs) {
      final tier = sub.tier.firestoreValue;
      _subscriptionsByTier[tier] = (_subscriptionsByTier[tier] ?? 0) + 1;
    }

    notifyListeners();
  }

  /// Update featured listing stats from stream
  void _updateFeaturedListingStatsFromStream(
      List<FeaturedListingModel> listings) {
    _totalFeaturedListingsCount = listings.length;

    final now = DateTime.now();
    _activeFeaturedListingsCount = listings
        .where((listing) =>
            listing.status == FeaturedListingStatus.active &&
            listing.endDate.isAfter(now))
        .length;

    notifyListeners();
  }

  /// Refresh all data
  Future<void> refresh() async {
    await initialize();
  }

  /// Set selected period for filtering
  void setSelectedPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
    _loadRevenueData();
  }

  /// Set selected year for filtering
  void setSelectedYear(int year) {
    _selectedYear = year;
    notifyListeners();
    _loadRevenueData();
  }

  /// Set selected month for filtering
  void setSelectedMonth(int month) {
    _selectedMonth = month;
    notifyListeners();
    _loadRevenueData();
  }

  @override
  void dispose() {
    cancelAllSubscriptions();
    super.dispose();
  }
}
