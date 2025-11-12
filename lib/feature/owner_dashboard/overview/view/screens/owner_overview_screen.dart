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
import '../../../../../l10n/app_localizations.dart';
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
  String? _lastLoadedPgId; // Track which PG we last loaded data for

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Use post-frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOverviewData();
    });
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

  String _formatCurrency(double value, AppLocalizations loc) {
    final localeCurrency = NumberFormat.simpleCurrency(locale: loc.localeName);
    return NumberFormat.currency(
      locale: loc.localeName,
      symbol: localeCurrency.currencySymbol,
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
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
            tooltip: loc.refreshDashboard,
          ),
        ],

        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Owner Drawer
      drawer: const OwnerDrawer(),

      body: _buildBody(context, viewModel, ownerId, authProvider, loc),
    );
  }

  /// Builds appropriate body content based on current state
  Widget _buildBody(BuildContext context, OwnerOverviewViewModel viewModel,
      String ownerId, AuthProvider authProvider, AppLocalizations loc) {
    if (viewModel.loading && viewModel.overviewData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveLoader(),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(text: loc.loadingDashboard),
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
            HeadingMedium(
              text: loc.errorLoadingDashboard,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: viewModel.errorMessage ?? loc.somethingWentWrong,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: () => viewModel.refreshOverviewData(ownerId),
              label: loc.tryAgain,
              icon: Icons.refresh,
            ),
          ],
        ),
      );
    }

    if (viewModel.overviewData == null) {
      return EmptyState(
        title: loc.noData,
        message: loc.dashboardDataWillAppearHere,
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
                    _buildWelcomeHeader(context, authProvider, responsive, loc),
                    const SizedBox(height: AppSpacing.paddingL),

                    // Summary Cards
                    OwnerSummaryWidget(overview: viewModel.overviewData!),
                    const SizedBox(height: AppSpacing.paddingL),

                    // Performance Indicator
                    _buildPerformanceCard(context, viewModel, loc),
                    const SizedBox(height: AppSpacing.paddingL),

                    // Revenue Chart
                    if (viewModel.monthlyBreakdown != null)
                      OwnerChartWidget(
                        title: loc.monthlyRevenue,
                        data: viewModel.monthlyBreakdown!,
                      ),
                    if (viewModel.monthlyBreakdown != null)
                      const SizedBox(height: AppSpacing.paddingL),

                    // Property Breakdown
                    if (viewModel.propertyBreakdown != null)
                      _buildPropertyBreakdown(context, viewModel, loc),
                    if (viewModel.propertyBreakdown != null)
                      const SizedBox(height: AppSpacing.paddingL),

                    // Quick Actions
                    _buildQuickActions(context, loc),
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
      ResponsiveConfig responsive, AppLocalizations loc) {
    final userName =
        authProvider.user?.fullName ?? loc.ownerOverviewOwnerFallback;
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
                  text: '${loc.welcome}, $userName!',
                  color: theme.primaryColor,
                ),
                const SizedBox(height: AppSpacing.paddingS),
                BodyText(
                  text: loc.heresYourBusinessOverview,
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
  Widget _buildPerformanceCard(BuildContext context,
      OwnerOverviewViewModel viewModel, AppLocalizations loc) {
    final indicator = viewModel.performanceIndicator;
    final occupancy = viewModel.formattedOccupancyRate;
    final indicatorLabel = _localizedPerformanceIndicator(loc, indicator);

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: loc.performance,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(text: loc.ownerOverviewOccupancyRate),
                  const SizedBox(height: AppSpacing.paddingXS),
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
                  text: indicatorLabel,
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
      case 'needs attention':
        return Colors.red;
      default:
        return Colors.red;
    }
  }

  /// Builds property breakdown section
  Widget _buildPropertyBreakdown(BuildContext context,
      OwnerOverviewViewModel viewModel, AppLocalizations loc) {
    final breakdown = viewModel.propertyBreakdown!;
    final totalPGs = breakdown.length;
    final totalRevenue =
        breakdown.values.fold(0.0, (sum, value) => sum + value);

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: loc.propertyBreakdown,
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
                  BodyText(text: loc.ownerOverviewPgLabel(index, entry.key)),
                  BodyText(
                    text: _formatCurrency(entry.value, loc),
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
                    text: loc.totalRevenueWithPgs(totalPGs),
                    medium: true,
                  ),
                  BodyText(
                    text: _formatCurrency(totalRevenue, loc),
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
  Widget _buildQuickActions(BuildContext context, AppLocalizations loc) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: loc.quickActions,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Wrap(
            spacing: AppSpacing.paddingS,
            runSpacing: AppSpacing.paddingS,
            children: [
              _buildActionChip(context, loc.addProperty, Icons.add_home, () {}),
              _buildActionChip(context, loc.addTenant, Icons.person_add, () {}),
              _buildActionChip(
                  context, loc.viewReports, Icons.analytics, () {}),
              _buildActionChip(context, loc.settings, Icons.settings, () {}),
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
            const SizedBox(width: AppSpacing.paddingS),
            BodyText(
              text: label,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  String _localizedPerformanceIndicator(
      AppLocalizations loc, String indicator) {
    switch (indicator.toLowerCase()) {
      case 'excellent':
        return loc.ownerOverviewPerformanceExcellent;
      case 'good':
        return loc.ownerOverviewPerformanceGood;
      case 'fair':
        return loc.ownerOverviewPerformanceFair;
      case 'needs attention':
        return loc.ownerOverviewPerformanceNeedsAttention;
      default:
        return indicator;
    }
  }

  // Drawer actions centralized in OwnerDrawer
}
