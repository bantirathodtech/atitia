// ============================================================================
// Owner Overview Screen - Dashboard Analytics
// ============================================================================
// Main dashboard with analytics, charts, and quick stats with theme toggle.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_large.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
// Using centralized OwnerDrawer instead of direct AdaptiveDrawer
import '../../../shared/widgets/owner_drawer.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../../shared/widgets/pg_selector_dropdown.dart';
import '../../viewmodel/owner_overview_view_model.dart';
import '../widgets/owner_summary_widget.dart';
import '../widgets/owner_chart_widget.dart';

/// Owner Overview Screen - Dashboard home with comprehensive analytics
/// Displays key metrics, revenue charts, and quick actions
/// Uses OwnerOverviewViewModel for data management and real-time updates
class OwnerOverviewScreen extends StatefulWidget {
  const OwnerOverviewScreen({super.key});

  @override
  State<OwnerOverviewScreen> createState() => _OwnerOverviewScreenState();
}

class _OwnerOverviewScreenState extends State<OwnerOverviewScreen> {
  bool _initialized = false;
  String? _lastLoadedPgId; // Track which PG we last loaded data for

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      // Use post-frame callback to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadOverviewData();
      });
    }
  }

  /// Loads overview data when screen initializes
  Future<void> _loadOverviewData() async {
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    final selectedPgProvider = context.read<SelectedPgProvider>();
    final viewModel = context.read<OwnerOverviewViewModel>();
    final ownerId = authProvider.user?.userId ?? '';
    final pgId = selectedPgProvider.selectedPgId;

    if (ownerId.isNotEmpty) {
      _lastLoadedPgId = pgId;
      // Load data for selected PG only
      await viewModel.loadOverviewData(ownerId, pgId: pgId);
      await viewModel.loadMonthlyBreakdown(ownerId, DateTime.now().year);
      await viewModel.loadPropertyBreakdown(ownerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OwnerOverviewViewModel>();
    final authProvider = context.watch<AuthProvider>();
    final selectedPgProvider = context.watch<SelectedPgProvider>();
    final ownerId = authProvider.user?.userId ?? '';
    final currentPgId = selectedPgProvider.selectedPgId;

    // Auto-reload data when selected PG changes
    if (_lastLoadedPgId != currentPgId && ownerId.isNotEmpty) {
      _lastLoadedPgId = currentPgId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.refreshOverviewData(ownerId, pgId: currentPgId);
      });
    }

    // Return complete screen with individual app bar and drawer
    return Scaffold(
      appBar: AdaptiveAppBar(
        // Center: PG Selector dropdown
        titleWidget: const PgSelectorDropdown(compact: true),
        centerTitle: true,

        // Left: Drawer button
        showDrawer: true,

        // Right: Refresh button
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.refreshOverviewData(ownerId),
            tooltip: 'Refresh Dashboard',
          ),
        ],

        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Owner Drawer
      drawer: const OwnerDrawer(),

      body: _buildBody(context, viewModel, ownerId, authProvider),
    );
  }

  /// Builds appropriate body content based on current state
  Widget _buildBody(BuildContext context, OwnerOverviewViewModel viewModel,
      String ownerId, AuthProvider authProvider) {
    if (viewModel.loading && viewModel.overviewData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveLoader(),
            const SizedBox(height: AppSpacing.paddingM),
            const BodyText(text: 'Loading dashboard...'),
          ],
        ),
      );
    }

    if (viewModel.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSpacing.paddingL),
            const HeadingMedium(
              text: 'Error Loading Dashboard',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: viewModel.errorMessage ?? 'Unknown error occurred',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: () => viewModel.refreshOverviewData(ownerId),
              label: 'Try Again',
              icon: Icons.refresh,
            ),
          ],
        ),
      );
    }

    if (viewModel.overviewData == null) {
      return const EmptyState(
        title: 'No Data Available',
        message: 'Dashboard data will appear here once you add properties',
        icon: Icons.dashboard_outlined,
      );
    }

    final responsive = context.responsive;
    final responsivePadding = context.responsivePadding;

    return RefreshIndicator(
      onRefresh: () => viewModel.refreshOverviewData(ownerId),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Full width container with responsive constraints
          return Center(
            child: Container(
              constraints: responsive.isDesktop
                  ? BoxConstraints(maxWidth: responsive.maxWidth)
                  : null,
              child: SingleChildScrollView(
                padding: responsivePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Header - Full Width
                    _buildWelcomeHeader(context, authProvider, responsive),
                    const SizedBox(height: AppSpacing.paddingL),

                    // Summary Cards
                    OwnerSummaryWidget(overview: viewModel.overviewData!),
                    const SizedBox(height: AppSpacing.paddingL),

                    // Performance Indicator
                    _buildPerformanceCard(context, viewModel),
                    const SizedBox(height: AppSpacing.paddingL),

                    // Revenue Chart
                    if (viewModel.monthlyBreakdown != null)
                      OwnerChartWidget(
                        title: 'Monthly Revenue',
                        data: viewModel.monthlyBreakdown!,
                      ),
                    if (viewModel.monthlyBreakdown != null)
                      const SizedBox(height: AppSpacing.paddingL),

                    // Property Breakdown
                    if (viewModel.propertyBreakdown != null)
                      _buildPropertyBreakdown(context, viewModel),
                    if (viewModel.propertyBreakdown != null)
                      const SizedBox(height: AppSpacing.paddingL),

                    // Quick Actions
                    _buildQuickActions(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds welcome header - Full width responsive design
  Widget _buildWelcomeHeader(BuildContext context, AuthProvider authProvider,
      ResponsiveConfig responsive) {
    final userName = authProvider.user?.fullName ?? 'Owner';
    final theme = Theme.of(context);
    final padding = context.responsivePadding;

    return AdaptiveCard(
      padding: EdgeInsets.symmetric(
        horizontal: padding.horizontal,
        vertical: padding.vertical * 1.5,
      ),
      child: Row(
        children: [
          // Welcome content - takes available space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingLarge(
                  text: 'Welcome, $userName!',
                  color: theme.primaryColor,
                ),
                const SizedBox(height: AppSpacing.paddingS),
                BodyText(
                  text: 'Here\'s your business overview',
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
          // Optional: Add icon or badge on larger screens
          if (responsive.isDesktop) const SizedBox(width: AppSpacing.paddingM),
          if (responsive.isDesktop)
            Icon(
              Icons.dashboard_outlined,
              size: 48,
              color: theme.primaryColor.withValues(alpha: 0.3),
            ),
        ],
      ),
    );
  }

  /// Builds performance indicator card
  Widget _buildPerformanceCard(
      BuildContext context, OwnerOverviewViewModel viewModel) {
    final indicator = viewModel.performanceIndicator;
    final occupancy = viewModel.formattedOccupancyRate;

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Performance',
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BodyText(text: 'Occupancy Rate'),
                  const SizedBox(height: 4),
                  HeadingMedium(
                    text: occupancy,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingM,
                  vertical: AppSpacing.paddingS,
                ),
                decoration: BoxDecoration(
                  color: _getPerformanceColor(indicator).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
                child: BodyText(
                  text: indicator,
                  color: _getPerformanceColor(indicator),
                  medium: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(String indicator) {
    switch (indicator.toLowerCase()) {
      case 'excellent':
        return Colors.green;
      case 'good':
        return Colors.lightGreen;
      case 'fair':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  /// Builds property breakdown section
  Widget _buildPropertyBreakdown(
      BuildContext context, OwnerOverviewViewModel viewModel) {
    final breakdown = viewModel.propertyBreakdown!;
    final totalPGs = breakdown.length;
    final totalRevenue = breakdown.values.fold(0.0, (sum, value) => sum + value);

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Property Revenue',
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          // Display each PG with numbered prefix (1PG:, 2PG:, 3PG:, etc.)
          ...breakdown.entries.toList().asMap().entries.map((mapEntry) {
            final index = mapEntry.key + 1; // Start from 1, not 0
            final entry = mapEntry.value;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyText(text: '${index}PG: ${entry.key}'),
                  BodyText(
                    text: '₹${NumberFormat('#,##0').format(entry.value)}',
                    medium: true,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            );
          }),
          // Total Revenue with PG count suffix
          if (totalPGs > 0) ...[
            const Divider(height: AppSpacing.paddingL),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppSpacing.paddingXS),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyText(
                    text: 'Total Revenue ($totalPGs PGs)',
                    medium: true,
                  ),
                  BodyText(
                    text: '₹${NumberFormat('#,##0').format(totalRevenue)}',
                    medium: true,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds quick actions section
  Widget _buildQuickActions(BuildContext context) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadingMedium(text: 'Quick Actions'),
          const SizedBox(height: AppSpacing.paddingM),
          Wrap(
            spacing: AppSpacing.paddingS,
            runSpacing: AppSpacing.paddingS,
            children: [
              _buildActionChip(context, 'Add Property', Icons.add_home, () {}),
              _buildActionChip(context, 'Add Tenant', Icons.person_add, () {}),
              _buildActionChip(context, 'View Reports', Icons.analytics, () {}),
              _buildActionChip(context, 'Settings', Icons.settings, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(
      BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingM,
          vertical: AppSpacing.paddingS,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Theme.of(context).primaryColor),
            const SizedBox(width: 8),
            BodyText(
              text: label,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  // Drawer actions centralized in OwnerDrawer
}
