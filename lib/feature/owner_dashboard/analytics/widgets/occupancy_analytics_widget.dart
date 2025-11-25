// lib/feature/owner_dashboard/analytics/widgets/occupancy_analytics_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../l10n/app_localizations.dart';

/// Occupancy analytics widget for Owner dashboard
/// Shows occupancy rates, trends, and capacity utilization
class OccupancyAnalyticsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> occupancyData;
  final String? selectedPgId;
  final VoidCallback? onRefresh;

  const OccupancyAnalyticsWidget({
    super.key,
    required this.occupancyData,
    this.selectedPgId,
    this.onRefresh,
  });

  @override
  State<OccupancyAnalyticsWidget> createState() =>
      _OccupancyAnalyticsWidgetState();
}

class _OccupancyAnalyticsWidgetState extends State<OccupancyAnalyticsWidget> {
  String _selectedPeriod = 'monthly';
  String _selectedView = 'overview';

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, loc),
        const SizedBox(height: AppSpacing.paddingL),
        _buildOccupancyMetrics(context, loc),
        const SizedBox(height: AppSpacing.paddingL),
        _buildOccupancyChart(context, loc),
        const SizedBox(height: AppSpacing.paddingL),
        _buildCapacityAnalysis(context, loc),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations loc) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          child: Icon(
            Icons.bed,
            color: AppColors.info,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(text: loc.occupancyAnalyticsTitle),
              CaptionText(
                text: widget.selectedPgId != null
                    ? loc.occupancyAnalyticsSelectedPg
                    : loc.occupancyAnalyticsOverall,
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
            ],
          ),
        ),
        if (widget.onRefresh != null)
          IconButton(
            onPressed: widget.onRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: loc.analyticsRefreshData,
          ),
      ],
    );
  }

  Widget _buildOccupancyMetrics(BuildContext context, AppLocalizations loc) {
    final metrics = _calculateOccupancyMetrics();
    final percentFormatter = NumberFormat.decimalPattern(loc.localeName);

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            context,
            loc.occupancyMetricCurrent,
            '${percentFormatter.format(metrics['currentOccupancy'])}%',
            Icons.bed,
            _getOccupancyColor(context, metrics['currentOccupancy']),
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: _buildMetricCard(
            context,
            loc.occupancyMetricAverage,
            '${percentFormatter.format(metrics['avgOccupancy'])}%',
            Icons.trending_up,
            AppColors.statusBlue,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: _buildMetricCard(
            context,
            loc.occupancyMetricPeak,
            '${percentFormatter.format(metrics['peakOccupancy'])}%',
            Icons.flag,
            AppColors.statusOrange,
          ),
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

  Widget _buildOccupancyChart(BuildContext context, AppLocalizations loc) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                HeadingSmall(text: loc.occupancyTrendsLabel),
                const Spacer(),
                _buildPeriodSelector(context, loc),
                const SizedBox(width: AppSpacing.paddingM),
                _buildViewSelector(context, loc),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),
            SizedBox(
              height: 300,
              child: _buildSimpleOccupancyChart(context, loc),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingS),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      ),
      child: DropdownButton<String>(
        value: _selectedPeriod,
        underline: const SizedBox(),
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color ??
              Theme.of(context).colorScheme.onSurface,
          fontSize: 14,
        ),
        items: [
          DropdownMenuItem(
            value: 'weekly',
            child: Text(loc.analyticsPeriodWeekly),
          ),
          DropdownMenuItem(
            value: 'monthly',
            child: Text(loc.analyticsPeriodMonthly),
          ),
          DropdownMenuItem(
            value: 'yearly',
            child: Text(loc.analyticsPeriodYearly),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedPeriod = value!;
          });
        },
      ),
    );
  }

  Widget _buildViewSelector(BuildContext context, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingS),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      ),
      child: DropdownButton<String>(
        value: _selectedView,
        underline: const SizedBox(),
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color ??
              Theme.of(context).colorScheme.onSurface,
          fontSize: 14,
        ),
        items: [
          DropdownMenuItem(
            value: 'overview',
            child: Text(loc.occupancyViewOverview),
          ),
          DropdownMenuItem(
            value: 'by_room',
            child: Text(loc.occupancyViewByRoom),
          ),
          DropdownMenuItem(
            value: 'by_floor',
            child: Text(loc.occupancyViewByFloor),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _selectedView = value!;
          });
        },
      ),
    );
  }

  Widget _buildSimpleOccupancyChart(
      BuildContext context, AppLocalizations loc) {
    final chartData = _getOccupancyChartData();
    final months = chartData['months'] as List<int>;
    final values = chartData['data'] as List<int>;
    final percentFormatter = NumberFormat.decimalPattern(loc.localeName);
    final monthFormatter = DateFormat.MMM(loc.localeName);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
      ),
      child: Column(
        children: [
          // Simple bar chart representation
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: values.asMap().entries.map((entry) {
                final index = entry.key;
                final value = entry.value;
                final height = (value / 100) * 200;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: height,
                      decoration: BoxDecoration(
                        color: AppColors.statusBlue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.paddingS),
                    Text(
                      monthFormatter.format(DateTime(2000, months[index])),
                      style: TextStyle(
                        color: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withValues(alpha: 0.7) ??
                            Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.paddingXS),
                    Text(
                      '${percentFormatter.format(value)}%',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color ??
                            Theme.of(context).colorScheme.onSurface,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.paddingM),
          BodyText(text: loc.occupancyTrendLastMonths(6)),
        ],
      ),
    );
  }

  Widget _buildCapacityAnalysis(BuildContext context, AppLocalizations loc) {
    final analysis = _calculateCapacityAnalysis(loc);
    final numberFormatter = NumberFormat.decimalPattern(loc.localeName);

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmall(text: loc.occupancyCapacityTitle),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildCapacityCard(
                    context,
                    loc.occupancyCapacityAvailableBeds,
                    numberFormatter.format(analysis['availableBeds']),
                    Icons.bed_outlined,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: _buildCapacityCard(
                    context,
                    loc.occupancyCapacityOccupiedBeds,
                    numberFormatter.format(analysis['occupiedBeds']),
                    Icons.bed,
                    AppColors.statusBlue,
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: _buildCapacityCard(
                    context,
                    loc.occupancyCapacityTotal,
                    numberFormatter.format(analysis['totalCapacity']),
                    Icons.home,
                    Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.5) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildOccupancyInsights(context, analysis, loc),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
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
    );
  }

  Widget _buildOccupancyInsights(BuildContext context,
      Map<String, dynamic> analysis, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BodyText(text: loc.occupancyInsightsTitle),
          const SizedBox(height: AppSpacing.paddingS),
          BodyText(
            text: analysis['insights'],
            color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.7) ??
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          if (analysis['recommendations'].isNotEmpty) ...[
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(text: loc.occupancyRecommendationsTitle),
            const SizedBox(height: AppSpacing.paddingS),
            ...analysis['recommendations']
                .map<Widget>((rec) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.paddingXS),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                            child: BodyText(
                              text: rec,
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
                    ))
                .toList(),
          ],
        ],
      ),
    );
  }

  // ==========================================================================
  // DATA CALCULATION METHODS
  // ==========================================================================

  Map<String, dynamic> _calculateOccupancyMetrics() {
    if (widget.occupancyData.isEmpty) {
      return {
        'currentOccupancy': 0,
        'avgOccupancy': 0.0,
        'peakOccupancy': 0,
      };
    }

    final currentOccupancy = widget.occupancyData
        .where((data) => data['isCurrent'] == true)
        .fold<int>(
            0, (sum, data) => sum + ((data['occupancy'] as num?) ?? 0).toInt());

    final avgOccupancy = widget.occupancyData.fold<double>(
            0,
            (sum, data) =>
                sum + ((data['occupancy'] as num?) ?? 0).toDouble()) /
        widget.occupancyData.length;

    final peakOccupancy = widget.occupancyData.fold<int>(0, (max, data) {
      final occupancy = ((data['occupancy'] as num?) ?? 0).toInt();
      return occupancy > max ? occupancy : max;
    });

    return {
      'currentOccupancy': currentOccupancy,
      'avgOccupancy': avgOccupancy.round(),
      'peakOccupancy': peakOccupancy,
    };
  }

  Map<String, dynamic> _getOccupancyChartData() {
    // Sample data - replace with actual data from your repository
    final sampleData = [
      {'month': 1, 'occupancy': 85},
      {'month': 2, 'occupancy': 78},
      {'month': 3, 'occupancy': 92},
      {'month': 4, 'occupancy': 88},
      {'month': 5, 'occupancy': 95},
      {'month': 6, 'occupancy': 90},
    ];

    final months = sampleData.map((d) => d['month'] as int).toList();
    final values = sampleData.map((d) => d['occupancy'] as int).toList();

    return {
      'months': months,
      'data': values,
    };
  }

  Map<String, dynamic> _calculateCapacityAnalysis(AppLocalizations loc) {
    // Sample data - replace with actual data from your repository
    final totalCapacity = 50;
    final occupiedBeds = 45;
    final availableBeds = totalCapacity - occupiedBeds;
    final occupancyRate = (occupiedBeds / totalCapacity) * 100;

    final rateString =
        '${NumberFormat.decimalPattern(loc.localeName).format(occupancyRate)}%';
    String insights = loc.occupancyInsightsCurrentRate(rateString);
    List<String> recommendations = [];

    if (occupancyRate >= 90) {
      insights += ' ${loc.occupancyInsightsNearFull}';
      recommendations.add(loc.occupancyRecommendationAddCapacity);
      recommendations.add(loc.occupancyRecommendationReviewPricing);
    } else if (occupancyRate >= 70) {
      insights += ' ${loc.occupancyInsightsGood}';
      recommendations.add(loc.occupancyRecommendationMaintainOccupancy);
      recommendations.add(loc.occupancyRecommendationSeasonalPricing);
    } else if (occupancyRate >= 50) {
      insights += ' ${loc.occupancyInsightsModerate}';
      recommendations.add(loc.occupancyRecommendationIncreaseMarketing);
      recommendations.add(loc.occupancyRecommendationImproveAmenities);
      recommendations.add(loc.occupancyRecommendationCompetitivePricing);
    } else {
      insights += ' ${loc.occupancyInsightsLow}';
      recommendations.add(loc.occupancyRecommendationUrgentCampaign);
      recommendations.add(loc.occupancyRecommendationReducePricing);
      recommendations.add(loc.occupancyRecommendationImproveFacilities);
      recommendations.add(loc.occupancyRecommendationPartnerships);
    }

    return {
      'totalCapacity': totalCapacity,
      'occupiedBeds': occupiedBeds,
      'availableBeds': availableBeds,
      'occupancyRate': occupancyRate,
      'insights': insights,
      'recommendations': recommendations,
    };
  }

  Color _getOccupancyColor(BuildContext context, int occupancy) {
    if (occupancy >= 90) return context.decorativeRed;
    if (occupancy >= 70) return AppColors.statusOrange;
    if (occupancy >= 50) return AppColors.info;
    return AppColors.success;
  }
}
