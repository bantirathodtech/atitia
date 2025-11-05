// lib/feature/owner_dashboard/analytics/screens/owner_analytics_dashboard.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../shared/viewmodel/selected_pg_provider.dart';
import '../../shared/widgets/pg_selector_dropdown.dart';
import '../../shared/widgets/owner_drawer.dart';
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
      setState(() {
        _error = 'Failed to load analytics data: $e';
      });
    } finally {
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

    return Scaffold(
      appBar: AdaptiveAppBar(
        titleWidget: const PgSelectorDropdown(compact: true),
        centerTitle: true,
        leadingActions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Menu',
          ),
        ],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Analytics',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(
                icon: Icon(Icons.trending_up),
                text: 'Revenue',
              ),
              Tab(
                icon: Icon(Icons.bed),
                text: 'Occupancy',
              ),
              Tab(
                icon: Icon(Icons.analytics),
                text: 'Performance',
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.apartment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.paddingL),
          const HeadingMedium(text: 'Select a PG'),
          const SizedBox(height: AppSpacing.paddingM),
          const BodyText(
            text: 'Choose a PG from the dropdown above to view analytics',
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdaptiveLoader(),
          SizedBox(height: AppSpacing.paddingL),
          BodyText(text: 'Loading analytics data...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: AppSpacing.paddingL),
          const HeadingMedium(text: 'Error Loading Data'),
          const SizedBox(height: AppSpacing.paddingM),
          BodyText(
            text: _error ?? 'Unknown error occurred',
          ),
          const SizedBox(height: AppSpacing.paddingL),
          ElevatedButton(
            onPressed: _refreshData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: RevenueAnalyticsWidget(
        revenueData: _revenueData,
        selectedPgId: _lastLoadedPgId,
        onRefresh: _refreshData,
      ),
    );
  }

  Widget _buildOccupancyTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: OccupancyAnalyticsWidget(
        occupancyData: _occupancyData,
        selectedPgId: _lastLoadedPgId,
        onRefresh: _refreshData,
      ),
    );
  }

  Widget _buildPerformanceTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPerformanceHeader(context),
          const SizedBox(height: AppSpacing.paddingL),
          _buildPerformanceMetrics(context),
          const SizedBox(height: AppSpacing.paddingL),
          _buildPerformanceInsights(context),
        ],
      ),
    );
  }

  Widget _buildPerformanceHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          decoration: BoxDecoration(
            color: Colors.purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          child: const Icon(
            Icons.analytics,
            color: Colors.purple,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadingMedium(text: 'Performance Analytics'),
              CaptionText(
                text: 'Comprehensive performance insights and recommendations',
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingMedium(text: 'Key Performance Indicators'),
            const SizedBox(height: AppSpacing.paddingL),
            Row(
              children: [
                Expanded(
                  child: _buildKpiCard(
                    'Guest Satisfaction',
                    '4.8/5',
                    Icons.star,
                    Colors.amber,
                    isDark,
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: _buildKpiCard(
                    'Response Time',
                    '2.3 hrs',
                    Icons.timer,
                    Colors.blue,
                    isDark,
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: _buildKpiCard(
                    'Maintenance Score',
                    '9.2/10',
                    Icons.build,
                    Colors.green,
                    isDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
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
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceInsights(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingMedium(text: 'Performance Insights'),
            const SizedBox(height: AppSpacing.paddingM),
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[50],
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BodyText(
                    text: 'Overall Performance: Excellent',
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  const BodyText(
                    text:
                        'Your PG is performing above industry standards with high guest satisfaction and efficient operations.',
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  const BodyText(
                    text: 'Recommendations:',
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  const BodyText(
                      text: '• Continue current maintenance schedule'),
                  const BodyText(
                      text: '• Consider expanding based on high occupancy'),
                  const BodyText(text: '• Implement guest feedback system'),
                  const BodyText(
                      text: '• Optimize energy usage for cost savings'),
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
