// lib/feature/admin_dashboard/revenue/view/screens/admin_revenue_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/caption_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/heading_small.dart';
import '../../../../../../common/widgets/indicators/enhanced_empty_state.dart';
import '../../../../../../core/models/revenue/revenue_record_model.dart';
import '../../viewmodel/admin_revenue_viewmodel.dart';

/// Admin Revenue Dashboard Screen
/// Displays app-level revenue metrics, subscription stats, and analytics
class AdminRevenueDashboardScreen extends StatefulWidget {
  const AdminRevenueDashboardScreen({super.key});

  @override
  State<AdminRevenueDashboardScreen> createState() =>
      _AdminRevenueDashboardScreenState();
}

class _AdminRevenueDashboardScreenState
    extends State<AdminRevenueDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminRevenueViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Revenue Dashboard',
        showBackButton: true,
      ),
      body: Consumer<AdminRevenueViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading && viewModel.totalRevenue == 0) {
            return const Center(child: AdaptiveLoader());
          }

          if (viewModel.error) {
            return Center(
              child: EmptyStates.error(
                context: context,
                message:
                    viewModel.errorMessage ?? 'Failed to load revenue data',
                onRetry: () => viewModel.initialize(),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.refresh(),
            child: SingleChildScrollView(
              padding: ResponsiveSystem.getResponsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Revenue Overview Cards
                  _buildRevenueOverview(context, viewModel),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Key Metrics
                  _buildKeyMetrics(context, viewModel),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Revenue Breakdown by Type
                  _buildRevenueBreakdown(context, viewModel),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Subscription Stats
                  _buildSubscriptionStats(context, viewModel),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Featured Listing Stats
                  _buildFeaturedListingStats(context, viewModel),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Conversion Metrics
                  _buildConversionMetrics(context, viewModel),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Monthly Revenue Chart
                  if (viewModel.monthlyBreakdown.isNotEmpty)
                    _buildMonthlyRevenueChart(context, viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRevenueOverview(
      BuildContext context, AdminRevenueViewModel viewModel) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: 'Revenue Overview'),
        const SizedBox(height: AppSpacing.paddingM),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                'Total Revenue',
                currencyFormatter.format(viewModel.totalRevenue),
                Icons.account_balance_wallet,
                AppColors.success,
              ),
            ),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: _buildMetricCard(
                context,
                'Monthly Revenue',
                currencyFormatter.format(viewModel.monthlyRevenue),
                Icons.trending_up,
                AppColors.info,
              ),
            ),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: _buildMetricCard(
                context,
                'Yearly Revenue',
                currencyFormatter.format(viewModel.yearlyRevenue),
                Icons.calendar_today,
                AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: AppSpacing.paddingS),
                Expanded(
                  child: CaptionText(
                    text: title,
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
            HeadingSmall(
              text: value,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyMetrics(
      BuildContext context, AdminRevenueViewModel viewModel) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Key Metrics'),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Active Subscriptions',
                    viewModel.activeSubscriptionsCount.toString(),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Active Featured Listings',
                    viewModel.activeFeaturedListingsCount.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Total Subscriptions',
                    viewModel.totalSubscriptionsCount.toString(),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Total Featured Listings',
                    viewModel.totalFeaturedListingsCount.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CaptionText(
          text: label,
          color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withValues(alpha: 0.7) ??
              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        const SizedBox(height: AppSpacing.paddingS),
        HeadingSmall(text: value),
      ],
    );
  }

  Widget _buildRevenueBreakdown(
      BuildContext context, AdminRevenueViewModel viewModel) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Revenue by Source'),
            const SizedBox(height: AppSpacing.paddingM),
            _buildBreakdownItem(
              context,
              'Subscriptions',
              currencyFormatter.format(
                  viewModel.revenueByType[RevenueType.subscription] ?? 0.0),
              AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            _buildBreakdownItem(
              context,
              'Featured Listings',
              currencyFormatter.format(
                  viewModel.revenueByType[RevenueType.featuredListing] ?? 0.0),
              AppColors.info,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            _buildBreakdownItem(
              context,
              'Success Fees',
              currencyFormatter.format(
                  viewModel.revenueByType[RevenueType.successFee] ?? 0.0),
              AppColors.warning,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownItem(
      BuildContext context, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BodyText(text: label),
        HeadingSmall(text: value, color: color),
      ],
    );
  }

  Widget _buildSubscriptionStats(
      BuildContext context, AdminRevenueViewModel viewModel) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Subscriptions by Tier'),
            const SizedBox(height: AppSpacing.paddingM),
            _buildTierStat(
              context,
              'Free',
              viewModel.subscriptionsByTier['free'] ?? 0,
              AppColors.secondary,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            _buildTierStat(
              context,
              'Premium',
              viewModel.subscriptionsByTier['premium'] ?? 0,
              AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            _buildTierStat(
              context,
              'Enterprise',
              viewModel.subscriptionsByTier['enterprise'] ?? 0,
              AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierStat(
      BuildContext context, String tier, int count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BodyText(text: tier),
        HeadingSmall(
          text: count.toString(),
          color: color,
        ),
      ],
    );
  }

  Widget _buildFeaturedListingStats(
      BuildContext context, AdminRevenueViewModel viewModel) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Featured Listings'),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Active',
                    viewModel.activeFeaturedListingsCount.toString(),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Total',
                    viewModel.totalFeaturedListingsCount.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConversionMetrics(
      BuildContext context, AdminRevenueViewModel viewModel) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Conversion Metrics'),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Conversion Rate',
                    '${viewModel.conversionRate.toStringAsFixed(1)}%',
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Avg Revenue/Owner',
                    currencyFormatter.format(viewModel.averageRevenuePerOwner),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyRevenueChart(
      BuildContext context, AdminRevenueViewModel viewModel) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    // Sort months chronologically
    final sortedMonths = viewModel.monthlyBreakdown.keys.toList()..sort();

    final maxValue = viewModel.monthlyBreakdown.values.isEmpty
        ? 1.0
        : viewModel.monthlyBreakdown.values.reduce((a, b) => a > b ? a : b);

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Monthly Revenue Trend'),
            const SizedBox(height: AppSpacing.paddingL),
            SizedBox(
              height: 300,
              child: sortedMonths.isEmpty
                  ? Center(
                      child: BodyText(
                        text: 'No revenue data available',
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7),
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: sortedMonths.map((monthYear) {
                        final value =
                            viewModel.monthlyBreakdown[monthYear] ?? 0.0;
                        final height =
                            maxValue > 0 ? (value / maxValue) * 250 : 0.0;

                        // Parse month-year (format: "2025-01")
                        final parts = monthYear.split('-');
                        final year = int.tryParse(parts[0]) ?? 2025;
                        final month = int.tryParse(parts[1]) ?? 1;
                        final monthName =
                            DateFormat.MMM().format(DateTime(year, month));

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.paddingS / 2,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Tooltip(
                                  message: currencyFormatter.format(value),
                                  child: Container(
                                    height: height,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(
                                        AppSpacing.borderRadiusS,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.paddingS),
                                RotatedBox(
                                  quarterTurns: 1,
                                  child: CaptionText(
                                    text: monthName,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color
                                        ?.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
