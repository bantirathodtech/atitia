// ============================================================================
// Owner Overview Screen - Dashboard Analytics
// ============================================================================
// Main dashboard with analytics, charts, and quick stats with theme toggle.
// ============================================================================

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_large.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../l10n/app_localizations.dart';
// Using centralized OwnerDrawer instead of direct AdaptiveDrawer
import '../../../shared/widgets/owner_drawer.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../../shared/widgets/pg_selector_dropdown.dart';
import '../../viewmodel/owner_overview_view_model.dart';
import '../widgets/owner_summary_widget.dart';
import '../widgets/owner_chart_widget.dart';
import '../../../../../common/widgets/dashboard/recently_updated_guests_widget.dart';
import '../../../../../common/widgets/dashboard/payment_status_breakdown_widget.dart';
import '../../../../../common/widgets/loaders/enhanced_loading_state.dart';
import '../../../../../common/widgets/indicators/enhanced_empty_state.dart';
import '../../../../../common/widgets/animations/smooth_page_transition.dart';

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
  /// Optimized: Loads critical data first, then secondary data in parallel
  Future<void> _loadOverviewData() async {
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    final selectedPgProvider = context.read<SelectedPgProvider>();
    final viewModel = context.read<OwnerOverviewViewModel>();
    final ownerId = authProvider.user?.userId ?? '';
    final pgId = selectedPgProvider.selectedPgId;

    if (ownerId.isNotEmpty) {
      _lastLoadedPgId = pgId;
      
      // Phase 1: Load critical overview data first (shows main stats quickly)
      await viewModel.loadOverviewData(ownerId, pgId: pgId);
      
      // Phase 2: Load secondary data in parallel (non-blocking for UI)
      // These will update the UI as they complete
      Future.microtask(() => _loadSecondaryData(viewModel, ownerId, pgId));
    }
  }

  /// Loads secondary/optional data in parallel without blocking UI
  Future<void> _loadSecondaryData(
    OwnerOverviewViewModel viewModel,
    String ownerId,
    String? pgId,
  ) async {
    // Load all secondary data in parallel - don't block UI
    await Future.wait([
      viewModel.loadMonthlyBreakdown(ownerId, DateTime.now().year),
      viewModel.loadPropertyBreakdown(ownerId),
      viewModel.loadPaymentStatusBreakdown(ownerId, pgId: pgId),
      viewModel.loadRecentlyUpdatedGuests(ownerId, pgId: pgId),
    ], eagerError: false); // Don't fail all if one fails
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
    // Use select to only rebuild when userId or pgId changes
    final ownerId = context.select<AuthProvider, String>((a) => a.user?.userId ?? '');
    final currentPgId = context.select<SelectedPgProvider, String?>((p) => p.selectedPgId);

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
        
        // Theme-aware background color
        backgroundColor: context.colors.surface,

        // Left: Drawer button
        showDrawer: true,

        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Owner Drawer
      drawer: const OwnerDrawer(),

      body: _buildBody(context, viewModel, ownerId, loc),
    );
  }

  /// Builds appropriate body content based on current state
  Widget _buildBody(BuildContext context, OwnerOverviewViewModel viewModel,
      String ownerId, AppLocalizations loc) {
    if (viewModel.loading && viewModel.overviewData == null) {
      return EnhancedLoadingState(
        message: loc.loadingDashboard,
        type: LoadingType.fullscreen,
      );
    }

    if (viewModel.error) {
      return EmptyStates.error(
        context: context,
        message: viewModel.errorMessage ?? loc.somethingWentWrong,
        onRetry: () => viewModel.refreshOverviewData(ownerId, pgId: null),
      );
    }

    if (viewModel.overviewData == null) {
      return EnhancedEmptyState(
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
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 100),
                      child: _buildWelcomeHeader(context, responsive, loc),
                    ),
                    SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

                    // Summary Cards
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 200),
                      child: OwnerSummaryWidget(overview: viewModel.overviewData!),
                    ),
                    SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

                    // Payment Status Breakdown
                    if (viewModel.paymentStatusBreakdown != null)
                      _buildPaymentStatusBreakdown(context, viewModel),
                    if (viewModel.paymentStatusBreakdown != null)
                      SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

                    // Recently Updated Guests
                    if (viewModel.recentlyUpdatedGuests != null && viewModel.recentlyUpdatedGuests!.isNotEmpty)
                      _buildRecentlyUpdatedGuests(context, viewModel, loc),
                    if (viewModel.recentlyUpdatedGuests != null && viewModel.recentlyUpdatedGuests!.isNotEmpty)
                      SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

                    // Performance Indicator
                    _buildPerformanceCard(context, viewModel, loc),
                    SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

                    // Revenue Chart
                    if (viewModel.monthlyBreakdown != null)
                      OwnerChartWidget(
                        title: loc.monthlyRevenue,
                        data: viewModel.monthlyBreakdown!,
                      ),
                    if (viewModel.monthlyBreakdown != null)
                      SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

                    // Property Breakdown
                    if (viewModel.propertyBreakdown != null)
                      _buildPropertyBreakdown(context, viewModel, loc),
                    if (viewModel.propertyBreakdown != null)
                      SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

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
  Widget _buildWelcomeHeader(BuildContext context,
      ResponsiveConfig responsive, AppLocalizations loc) {
    final authProvider = context.read<AuthProvider>();
    final userName =
        authProvider.user?.fullName ?? loc.ownerOverviewOwnerFallback;
    final padding = context.responsivePadding;

    return AdaptiveCard(
      padding: EdgeInsets.symmetric(
        horizontal: padding.horizontal,
        vertical: context.isMobile ? padding.vertical : padding.vertical * 1.5,
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
                  color: context.primaryColor,
                ),
                SizedBox(height: context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS),
                BodyText(
                  text: loc.heresYourBusinessOverview,
                  color: ThemeColors.getTextTertiary(context),
                  small: context.isMobile,
                ),
              ],
            ),
          ),
          // Optional: Add icon or badge on larger screens
          if (responsive.isDesktop) SizedBox(width: AppSpacing.paddingM),
          if (responsive.isDesktop)
            Icon(
              Icons.dashboard_outlined,
              size: 48,
              color: context.primaryColor.withValues(alpha: 0.3),
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
    final padding = context.responsivePadding;

    return AdaptiveCard(
      padding: EdgeInsets.all(context.isMobile ? padding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: loc.performance,
            color: context.primaryColor,
          ),
          SizedBox(height: context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      text: loc.ownerOverviewOccupancyRate,
                      small: context.isMobile,
                    ),
                    SizedBox(height: context.isMobile ? AppSpacing.paddingXS * 0.5 : AppSpacing.paddingXS),
                    HeadingMedium(
                      text: occupancy,
                      color: context.primaryColor,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.paddingS),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM,
                  vertical: context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS,
                ),
                decoration: BoxDecoration(
                  color: _getPerformanceColor(context, indicator).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
                child: BodyText(
                  text: indicatorLabel,
                  color: _getPerformanceColor(context, indicator),
                  medium: true,
                  small: context.isMobile,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPerformanceColor(BuildContext context, String indicator) {
    switch (indicator.toLowerCase()) {
      case 'excellent':
        return AppColors.success;
      case 'good':
        return AppColors.success.withValues(alpha: 0.8);
      case 'fair':
        return AppColors.warning;
      case 'needs attention':
        return context.colors.error;
      default:
        return context.colors.error;
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
              padding: EdgeInsets.symmetric(
                vertical: context.isMobile ? AppSpacing.paddingXS * 0.5 : AppSpacing.paddingXS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BodyText(
                      text: loc.ownerOverviewPgLabel(index, entry.key),
                      small: context.isMobile,
                    ),
                  ),
                  BodyText(
                    text: _formatCurrency(entry.value, loc),
                    medium: true,
                    color: context.primaryColor,
                    small: context.isMobile,
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
                  Expanded(
                    child: BodyText(
                      text: loc.totalRevenueWithPgs(totalPGs),
                      medium: true,
                      small: context.isMobile,
                    ),
                  ),
                  BodyText(
                    text: _formatCurrency(totalRevenue, loc),
                    medium: true,
                    color: context.primaryColor,
                    small: context.isMobile,
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
    final padding = context.responsivePadding;
    return AdaptiveCard(
      padding: EdgeInsets.all(context.isMobile ? padding.top * 0.75 : AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: loc.quickActions,
          ),
          SizedBox(height: context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
          Wrap(
            spacing: context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS,
            runSpacing: context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS,
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
        padding: EdgeInsets.symmetric(
          horizontal: context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM,
          vertical: context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS,
        ),
        decoration: BoxDecoration(
          color: context.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          border: Border.all(
            color: context.primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: context.isMobile ? 16 : 18,
              color: context.primaryColor,
            ),
            SizedBox(width: context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS),
            BodyText(
              text: label,
              color: context.primaryColor,
              small: context.isMobile,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds payment status breakdown widget
  Widget _buildPaymentStatusBreakdown(
      BuildContext context, OwnerOverviewViewModel viewModel) {
    final breakdown = viewModel.paymentStatusBreakdown!;
    
    return PaymentStatusBreakdownWidget(
      paidCount: breakdown['paidCount'] as int? ?? 0,
      pendingCount: breakdown['pendingCount'] as int? ?? 0,
      partialCount: breakdown['partialCount'] as int? ?? 0,
      paidAmount: breakdown['paidAmount']?.toDouble(),
      pendingAmount: breakdown['pendingAmount']?.toDouble(),
      partialAmount: breakdown['partialAmount']?.toDouble(),
      onViewDetails: () {
        // TODO: Navigate to payments/guests tab
      },
    );
  }

  /// Builds recently updated guests widget
  Widget _buildRecentlyUpdatedGuests(
    BuildContext context,
    OwnerOverviewViewModel viewModel,
    AppLocalizations loc,
  ) {
    final guestsData = viewModel.recentlyUpdatedGuests!;

    // Convert List<dynamic> to List<Map<String, dynamic>>
    final guestsList = guestsData
        .map((item) => item as Map<String, dynamic>)
        .toList();

    return RecentlyUpdatedGuestsWidget(
      guests: guestsList,
      onViewAll: () {
        // TODO: Navigate to guests tab
      },
      maxDisplayCount: 5,
      daysToLookBack: 7,
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
