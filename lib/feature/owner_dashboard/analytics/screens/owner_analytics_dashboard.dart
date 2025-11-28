// lib/feature/owner_dashboard/analytics/screens/owner_analytics_dashboard.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../shared/viewmodel/selected_pg_provider.dart';
import '../../shared/widgets/pg_selector_dropdown.dart';
import '../../shared/widgets/owner_drawer.dart';
import '../../subscription/viewmodel/owner_subscription_viewmodel.dart';
import '../../../../../core/models/subscription/subscription_plan_model.dart';
import '../../../../../common/widgets/dialogs/premium_upgrade_dialog.dart';
import '../widgets/revenue_analytics_widget.dart';
import '../widgets/occupancy_analytics_widget.dart';
import '../../../auth/logic/auth_provider.dart';
import '../../overview/data/repository/owner_overview_repository.dart';
import '../../overview/data/models/owner_overview_model.dart';

/// Advanced analytics dashboard for Owner
/// Provides comprehensive insights into revenue, occupancy, and performance
class OwnerAnalyticsDashboard extends StatefulWidget {
  const OwnerAnalyticsDashboard({super.key});

  @override
  State<OwnerAnalyticsDashboard> createState() =>
      _OwnerAnalyticsDashboardState();
}

class _OwnerAnalyticsDashboardState extends State<OwnerAnalyticsDashboard>
    with SingleTickerProviderStateMixin {
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  late TabController _tabController;
  String? _lastLoadedPgId;
  SelectedPgProvider? _selectedPgProvider;

  // Real data from repositories
  List<Map<String, dynamic>> _revenueData = [];
  List<Map<String, dynamic>> _occupancyData = [];
  Map<String, double> _performanceMetrics = {};
  bool _isLoading = false;
  String? _error;

  // Repository for fetching real analytics data
  final OwnerOverviewRepository _repository = OwnerOverviewRepository();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _setupPgSelectionListener();
      await _loadInitialData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _selectedPgProvider?.removeListener(_onPgSelectionChanged);
    super.dispose();
  }

  Future<void> _setupPgSelectionListener() async {
    _selectedPgProvider =
        Provider.of<SelectedPgProvider>(context, listen: false);
    _selectedPgProvider?.addListener(_onPgSelectionChanged);
  }

  void _onPgSelectionChanged() {
    final currentPgId = _selectedPgProvider?.selectedPgId;
    if (currentPgId != _lastLoadedPgId) {
      _loadDataForPg(currentPgId);
    }
  }

  Future<void> _loadInitialData() async {
    final selectedPgProvider =
        Provider.of<SelectedPgProvider>(context, listen: false);
    final currentPgId = selectedPgProvider.selectedPgId;
    await _loadDataForPg(currentPgId);
  }

  Future<void> _loadDataForPg(String? pgId) async {
    if (pgId == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Get owner ID from AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final ownerId = authProvider.user?.userId;

      if (ownerId == null || ownerId.isEmpty) {
        throw Exception('Owner ID not available. Please log in again.');
      }

      // Load data in parallel for better performance
      final currentYear = DateTime.now().year;
      final results = await Future.wait([
        // Load revenue breakdown with caching
        _repository.getMonthlyRevenueBreakdownCached(ownerId, currentYear),
        // Load overview data for current occupancy
        _repository.fetchOwnerOverviewData(ownerId, pgId: pgId),
        // Load historical occupancy data
        _repository.getHistoricalOccupancyData(pgId, currentYear),
        // Load performance metrics
        _repository.getPerformanceMetrics(ownerId, pgId: pgId),
      ], eagerError: false);

      // Transform revenue data from repository format to widget format
      final monthlyBreakdown = results[0] as Map<String, double>;
      _revenueData = _transformRevenueData(monthlyBreakdown, pgId);

      // Transform occupancy data - use historical if available, otherwise use current
      final overviewData = results[1] as OwnerOverviewModel;
      final historicalOccupancy = results[2] as List<dynamic>; // List<OccupancyTrendModel>
      _occupancyData = _transformOccupancyData(
        overviewData,
        pgId,
        historicalData: historicalOccupancy,
      );

      // Store performance metrics
      _performanceMetrics = results[3] as Map<String, double>;

      _lastLoadedPgId = pgId;
    } catch (e) {
      if (mounted) {
        final loc = AppLocalizations.of(context);
        setState(() {
          _error = loc?.analyticsLoadFailed(e.toString()) ??
              _text(
                'ownerAnalyticsLoadFailed',
                'Failed to load analytics data: {error}',
                parameters: {'error': e.toString()},
              );
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Transforms monthly revenue breakdown from repository format to widget format
  /// Repository format: {'month_1': 50000.0, 'month_2': 55000.0, ...}
  /// Widget format: [{'month': 1, 'amount': 50000, 'pgId': '...', 'timestamp': ...}, ...]
  List<Map<String, dynamic>> _transformRevenueData(
    Map<String, double> monthlyBreakdown,
    String? pgId,
  ) {
    final currentYear = DateTime.now().year;
    final List<Map<String, dynamic>> revenueList = [];

    for (int month = 1; month <= 12; month++) {
      final monthKey = 'month_$month';
      final amount = monthlyBreakdown[monthKey] ?? 0.0;

      // Create timestamp for this month
      final timestamp = DateTime(currentYear, month, 1);

      revenueList.add({
        'month': month,
        'amount': amount.round(),
        'pgId': pgId ?? '',
        'timestamp': timestamp,
        // Note: guestId is not available from monthly breakdown
        // Widgets handle this gracefully with optional guestId
      });
    }

    return revenueList;
  }

  /// Transforms occupancy data from overview model to widget format
  /// Uses historical data if available, otherwise falls back to current occupancy
  /// Widget format: [{'month': 1, 'occupancy': 85, 'isCurrent': false, 'pgId': '...', 'timestamp': ...}, ...]
  List<Map<String, dynamic>> _transformOccupancyData(
    OwnerOverviewModel overviewData,
    String? pgId, {
    List<dynamic>? historicalData,
  }) {
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;
    final List<Map<String, dynamic>> occupancyList = [];

    // Calculate current occupancy rate as fallback
    double currentOccupancyRate = 0.0;
    final totalBeds = overviewData.totalBeds;
    final occupiedBeds = overviewData.occupiedBeds;
    if (totalBeds > 0) {
      currentOccupancyRate = (occupiedBeds / totalBeds) * 100;
    }

    // Create a map of historical data by month for quick lookup
    final Map<int, double> historicalMap = {};
    if (historicalData != null && historicalData.isNotEmpty) {
      for (var trend in historicalData) {
        // Handle both OccupancyTrendModel and Map<String, dynamic>
        int month;
        double occupancyRate;
        
        if (trend is Map<String, dynamic>) {
          final date = trend['date'] is DateTime
              ? trend['date'] as DateTime
              : DateTime.parse(trend['date'].toString());
          month = date.month;
          occupancyRate = (trend['occupancyRate'] as num?)?.toDouble() ?? 0.0;
        } else {
          // Assume it's OccupancyTrendModel
          month = trend.date.month;
          occupancyRate = trend.occupancyRate * 100; // Convert from 0-1 to 0-100
        }
        
        if (month >= 1 && month <= 12) {
          historicalMap[month] = occupancyRate;
        }
      }
    }

    // Create occupancy data for all 12 months
    for (int month = 1; month <= 12; month++) {
      final timestamp = DateTime(currentYear, month, 1);
      final isCurrent = month == currentMonth;

      // Use historical data if available, otherwise use current occupancy
      final occupancy = historicalMap[month] ?? currentOccupancyRate;

      occupancyList.add({
        'month': month,
        'occupancy': occupancy.round(),
        'isCurrent': isCurrent,
        'pgId': pgId ?? '',
        'timestamp': timestamp,
      });
    }

    return occupancyList;
  }

  Future<void> _refreshData() async {
    await _loadDataForPg(_selectedPgProvider?.selectedPgId);
  }

  @override
  Widget build(BuildContext context) {
    final selectedPgProvider = context.watch<SelectedPgProvider>();
    final currentPgId = selectedPgProvider.selectedPgId;
    final subscriptionViewModel = context.watch<OwnerSubscriptionViewModel>();
    final loc = AppLocalizations.of(context)!;
    final tabLabels = [
      loc.analyticsTabRevenue,
      loc.analyticsTabOccupancy,
      loc.analyticsTabPerformance,
    ];

    // Check if user has premium subscription
    final hasPremiumAccess =
        subscriptionViewModel.currentTier != SubscriptionTier.free;

    // If free tier, show upgrade prompt instead of analytics
    if (!hasPremiumAccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          PremiumUpgradeDialog.show(
            context,
            featureName: 'Analytics Dashboard',
            description:
                'Get comprehensive insights into your PG business with advanced analytics. Track revenue trends, occupancy rates, and performance metrics.',
            featureBenefits: [
              'Revenue analytics and trends',
              'Occupancy rate tracking',
              'Performance metrics and KPIs',
              'Historical data comparisons',
              'Export reports for analysis',
            ],
          ).then((_) {
            // Navigate back after dialog is dismissed
            if (mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        }
      });
      // Return empty scaffold while dialog is being shown
      return Scaffold(
        appBar: AdaptiveAppBar(
          title: 'Analytics',
          showBackButton: true,
        ),
        body: Container(), // Empty body while checking subscription
      );
    }

    return Scaffold(
      appBar: AdaptiveAppBar(
        titleWidget: const PgSelectorDropdown(compact: true),
        centerTitle: true,
        leadingActions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: loc.menuTooltip,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: const Icon(Icons.trending_up),
                text: tabLabels[0],
              ),
              Tab(
                icon: const Icon(Icons.bed),
                text: tabLabels[1],
              ),
              Tab(
                icon: const Icon(Icons.analytics),
                text: tabLabels[2],
              ),
            ],
          ),
        ),
        showBackButton: false,
        showThemeToggle: false,
      ),
      drawer: const OwnerDrawer(),
      body: _buildBody(context, currentPgId),
    );
  }

  Widget _buildBody(BuildContext context, String? currentPgId) {
    if (currentPgId == null) {
      return _buildNoPgSelected(context);
    }

    if (_isLoading && _revenueData.isEmpty) {
      return _buildLoadingState(context);
    }

    if (_error != null) {
      return _buildErrorState(context);
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildRevenueTab(context),
        _buildOccupancyTab(context),
        _buildPerformanceTab(context),
      ],
    );
  }

  Widget _buildNoPgSelected(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apartment_outlined,
            size: 64,
            color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.5) ??
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          SizedBox(
              height:
                  context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),
          HeadingMedium(text: loc.analyticsNoPgTitle),
          SizedBox(
              height:
                  context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
          BodyText(
            text: loc.analyticsNoPgMessage,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AdaptiveLoader(),
          SizedBox(
              height:
                  context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),
          BodyText(text: loc.analyticsLoading),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Semantics(
      label: 'Error loading analytics data',
      hint:
          'An error occurred while loading analytics. Use the retry button to try again.',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Error icon',
              excludeSemantics: true,
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            SizedBox(
                height: context.isMobile
                    ? AppSpacing.paddingM
                    : AppSpacing.paddingL),
            Semantics(
              header: true,
              child: HeadingMedium(text: loc.analyticsErrorTitle),
            ),
            SizedBox(
                height: context.isMobile
                    ? AppSpacing.paddingS
                    : AppSpacing.paddingM),
            BodyText(
              text: _error ?? loc.analyticsUnknownError,
            ),
            SizedBox(
                height: context.isMobile
                    ? AppSpacing.paddingM
                    : AppSpacing.paddingL),
            PrimaryButton(
              onPressed: _refreshData,
              label: loc.retry,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueTab(BuildContext context) {
    final padding = context.responsivePadding;
    return SingleChildScrollView(
      padding:
          EdgeInsets.all(context.isMobile ? padding.top * 0.75 : padding.top),
      child: RevenueAnalyticsWidget(
        revenueData: _revenueData,
        selectedPgId: _lastLoadedPgId,
        onRefresh: _refreshData,
      ),
    );
  }

  Widget _buildOccupancyTab(BuildContext context) {
    final padding = context.responsivePadding;
    return SingleChildScrollView(
      padding:
          EdgeInsets.all(context.isMobile ? padding.top * 0.75 : padding.top),
      child: OccupancyAnalyticsWidget(
        occupancyData: _occupancyData,
        selectedPgId: _lastLoadedPgId,
        onRefresh: _refreshData,
      ),
    );
  }

  Widget _buildPerformanceTab(BuildContext context) {
    final padding = context.responsivePadding;
    final cardGap =
        context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL;
    return SingleChildScrollView(
      padding:
          EdgeInsets.all(context.isMobile ? padding.top * 0.75 : padding.top),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceHeader(context),
          SizedBox(height: cardGap),
          _buildPerformanceMetrics(context),
          SizedBox(height: cardGap),
          _buildPerformanceInsights(context),
        ],
      ),
    );
  }

  Widget _buildPerformanceHeader(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(
              context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          child: Icon(
            Icons.analytics,
            color: context.primaryColor,
            size: context.isMobile ? 20 : 24,
          ),
        ),
        SizedBox(
            width:
                context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(text: loc.performanceAnalyticsTitle),
              CaptionText(
                text: loc.performanceAnalyticsSubtitle,
                color: ThemeColors.getTextSecondary(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final decimalFormatter = NumberFormat('0.0', loc.localeName);
    
    // Use real performance metrics if available, otherwise show loading/placeholder
    final metrics = _performanceMetrics;
    final guestSatisfactionScore = decimalFormatter.format(
      metrics['guestSatisfactionScore'] ?? 0.0,
    );
    final responseTimeHours = decimalFormatter.format(
      metrics['avgResponseTimeHours'] ?? 0.0,
    );
    final maintenanceScore = decimalFormatter.format(
      metrics['maintenanceScore'] ?? 0.0,
    );

    final padding = context.responsivePadding;
    final cardGap =
        context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM;
    return AdaptiveCard(
      padding: EdgeInsets.all(
          context.isMobile ? padding.top * 0.75 : AppSpacing.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(text: loc.performanceKpiTitle),
          SizedBox(
              height:
                  context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  context,
                  loc.performanceKpiGuestSatisfaction,
                  loc.performanceKpiGuestSatisfactionValue(
                    guestSatisfactionScore,
                  ),
                  Icons.star,
                  AppColors.warning,
                ),
              ),
              SizedBox(width: cardGap),
              Expanded(
                child: _buildKpiCard(
                  context,
                  loc.performanceKpiResponseTime,
                  loc.performanceKpiResponseTimeValue(responseTimeHours),
                  Icons.timer,
                  AppColors.info,
                ),
              ),
              SizedBox(width: cardGap),
              Expanded(
                child: _buildKpiCard(
                  context,
                  loc.performanceKpiMaintenanceScore,
                  loc.performanceKpiMaintenanceScoreValue(maintenanceScore),
                  Icons.build,
                  AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final padding = context.responsivePadding;
    return Container(
      padding: EdgeInsets.all(
          context.isMobile ? padding.top * 0.5 : padding.top * 0.75),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: context.isMobile ? 16 : 20),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: context.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.7) ??
                        context.colors.onSurface.withValues(alpha: 0.7),
                    fontSize: context.isMobile ? 10 : 12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
              height: context.isMobile
                  ? AppSpacing.paddingXS
                  : AppSpacing.paddingS),
          Text(
            value,
            style: TextStyle(
              fontSize: context.isMobile ? 14 : 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceInsights(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final recommendations = [
      loc.performanceRecommendationMaintainSchedule,
      loc.performanceRecommendationExpandCapacity,
      loc.performanceRecommendationFeedbackSystem,
      loc.performanceRecommendationOptimizeEnergy,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: loc.performanceInsightsTitle),
            const SizedBox(height: AppSpacing.paddingM),
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: loc.performanceInsightsOverall,
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  BodyText(
                    text: loc.performanceInsightsSummary,
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  BodyText(
                    text: loc.performanceRecommendationsTitle,
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  ...recommendations.map(
                    (rec) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.paddingXS),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: context.textTheme.bodyMedium?.color ??
                                  context.colors.onSurface,
                            ),
                          ),
                          Expanded(
                            child: BodyText(
                              text: rec,
                              color: ThemeColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
