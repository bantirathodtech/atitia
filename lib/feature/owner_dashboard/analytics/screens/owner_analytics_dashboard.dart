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

  // Sample data - replace with actual data from repositories
  List<Map<String, dynamic>> _revenueData = [];
  List<Map<String, dynamic>> _occupancyData = [];
  bool _isLoading = false;
  String? _error;

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
      // TODO: Replace with actual data loading from repositories
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call

      // Sample data generation
      _revenueData = _generateSampleRevenueData(pgId);
      _occupancyData = _generateSampleOccupancyData(pgId);

      _lastLoadedPgId = pgId;
    } catch (e) {
      if (!mounted) return;
      
      // Get localization before setState to avoid BuildContext across async gap
      final loc = AppLocalizations.of(context);
      final errorMessage = loc?.analyticsLoadFailed(e.toString()) ??
          _text(
            'ownerAnalyticsLoadFailed',
            'Failed to load analytics data: {error}',
            parameters: {'error': e.toString()},
          );
      
      setState(() {
        _error = errorMessage;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
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
    final guestSatisfactionScore = decimalFormatter.format(4.8);
    final responseTimeHours = decimalFormatter.format(2.3);
    final maintenanceScore = decimalFormatter.format(9.2);

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

  // ==========================================================================
  // SAMPLE DATA GENERATION (Replace with actual repository calls)
  // ==========================================================================

  List<Map<String, dynamic>> _generateSampleRevenueData(String pgId) {
    return List.generate(12, (index) {
      final month = index + 1;
      final baseAmount = 50000 + (index * 5000);
      final variation = (index % 3 == 0) ? 10000 : -5000;

      return {
        'month': month,
        'amount': baseAmount + variation,
        'guestId': 'guest_${index + 1}',
        'pgId': pgId,
        'timestamp': DateTime.now().subtract(Duration(days: 30 * (12 - index))),
      };
    });
  }

  List<Map<String, dynamic>> _generateSampleOccupancyData(String pgId) {
    return List.generate(12, (index) {
      final month = index + 1;
      final baseOccupancy = 70 + (index * 2);
      final variation = (index % 4 == 0) ? 15 : -5;

      return {
        'month': month,
        'occupancy': (baseOccupancy + variation).clamp(0, 100),
        'isCurrent': index == 11,
        'pgId': pgId,
        'timestamp': DateTime.now().subtract(Duration(days: 30 * (12 - index))),
      };
    });
  }
}
