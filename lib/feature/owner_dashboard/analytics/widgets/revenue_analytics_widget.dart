// lib/feature/owner_dashboard/analytics/widgets/revenue_analytics_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';

/// Advanced revenue analytics widget for Owner dashboard
/// Shows revenue trends, forecasting, and performance metrics
class RevenueAnalyticsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> revenueData;
  final String? selectedPgId;
  final VoidCallback? onRefresh;

  const RevenueAnalyticsWidget({
    super.key,
    required this.revenueData,
    this.selectedPgId,
    this.onRefresh,
  });

  @override
  State<RevenueAnalyticsWidget> createState() => _RevenueAnalyticsWidgetState();
}

class _RevenueAnalyticsWidgetState extends State<RevenueAnalyticsWidget> {
  String _selectedPeriod = 'monthly';
  String _selectedMetric = 'revenue';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, isDark),
        const SizedBox(height: AppSpacing.paddingL),
        _buildMetricsCards(context, isDark),
        const SizedBox(height: AppSpacing.paddingL),
        _buildChartSection(context, isDark),
        const SizedBox(height: AppSpacing.paddingL),
        _buildForecastingSection(context, isDark),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          child: const Icon(
            Icons.trending_up,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadingMedium(text: 'Revenue Analytics'),
              CaptionText(
                text: widget.selectedPgId != null
                    ? 'Performance insights for selected PG'
                    : 'Overall revenue performance',
                color: isDark ? Colors.white70 : Colors.grey[600],
              ),
            ],
          ),
        ),
        if (widget.onRefresh != null)
          IconButton(
            onPressed: widget.onRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
          ),
      ],
    );
  }

  Widget _buildMetricsCards(BuildContext context, bool isDark) {
    final metrics = _calculateMetrics();

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Total Revenue',
            '₹${metrics['totalRevenue']}',
            Icons.account_balance_wallet,
            Colors.green,
            isDark,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: _buildMetricCard(
            'Monthly Growth',
            '${metrics['monthlyGrowth']}%',
            Icons.trending_up,
            metrics['monthlyGrowth'] >= 0 ? Colors.green : Colors.red,
            isDark,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: _buildMetricCard(
            'Avg. per Guest',
            '₹${metrics['avgPerGuest']}',
            Icons.person,
            Colors.blue,
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
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
                    color: isDark ? Colors.white70 : Colors.grey[600],
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

  Widget _buildChartSection(BuildContext context, bool isDark) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const HeadingSmall(text: 'Revenue Trends'),
                const Spacer(),
                _buildPeriodSelector(isDark),
                const SizedBox(width: AppSpacing.paddingM),
                _buildMetricSelector(isDark),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),
            SizedBox(
              height: 300,
              child: _buildSimpleChart(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingS),
      decoration: BoxDecoration(
        border:
            Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      ),
      child: DropdownButton<String>(
        value: _selectedPeriod,
        underline: const SizedBox(),
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 14,
        ),
        items: const [
          DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
          DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
          DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedPeriod = value!;
          });
        },
      ),
    );
  }

  Widget _buildMetricSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingS),
      decoration: BoxDecoration(
        border:
            Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      ),
      child: DropdownButton<String>(
        value: _selectedMetric,
        underline: const SizedBox(),
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 14,
        ),
        items: const [
          DropdownMenuItem(value: 'revenue', child: Text('Revenue')),
          DropdownMenuItem(value: 'occupancy', child: Text('Occupancy')),
          DropdownMenuItem(value: 'guests', child: Text('Guests')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedMetric = value!;
          });
        },
      ),
    );
  }

  Widget _buildSimpleChart(bool isDark) {
    final chartData = _getChartData();
    final labels = chartData['labels'] as List<String>;
    final values = chartData['data'] as List<int>;
    final maxValue = chartData['maxValue'] as int;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[50],
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
                final height = (value / maxValue) * 200;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: height,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      labels[index],
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${(value / 1000).toStringAsFixed(0)}k',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
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
          const BodyText(
            text: 'Revenue Trend (Last 6 Months)',
          ),
        ],
      ),
    );
  }

  Widget _buildForecastingSection(BuildContext context, bool isDark) {
    final forecast = _calculateForecast();

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingSmall(text: 'Revenue Forecast'),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildForecastCard(
                    'Next Month',
                    '₹${forecast['nextMonth']}',
                    forecast['nextMonthGrowth'],
                    Colors.blue,
                    isDark,
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: _buildForecastCard(
                    'Next Quarter',
                    '₹${forecast['nextQuarter']}',
                    forecast['nextQuarterGrowth'],
                    Colors.green,
                    isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            _buildForecastInsights(forecast, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastCard(
    String title,
    String value,
    double growth,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CaptionText(
            text: title,
            color: isDark ? Colors.white70 : Colors.grey[600],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          HeadingSmall(
            text: value,
            color: color,
          ),
          const SizedBox(height: AppSpacing.paddingXS),
          Row(
            children: [
              Icon(
                growth >= 0 ? Icons.trending_up : Icons.trending_down,
                color: growth >= 0 ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 4),
              CaptionText(
                text: '${growth >= 0 ? '+' : ''}${growth.toStringAsFixed(1)}%',
                color: growth >= 0 ? Colors.green : Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForecastInsights(Map<String, dynamic> forecast, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.grey[50],
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BodyText(
            text: 'Forecast Insights',
          ),
          const SizedBox(height: AppSpacing.paddingS),
          BodyText(
            text: forecast['insights'],
            color: isDark ? Colors.white70 : Colors.grey[600],
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // DATA CALCULATION METHODS
  // ==========================================================================

  Map<String, dynamic> _calculateMetrics() {
    if (widget.revenueData.isEmpty) {
      return {
        'totalRevenue': 0,
        'monthlyGrowth': 0.0,
        'avgPerGuest': 0,
      };
    }

    final totalRevenue = widget.revenueData.fold<int>(
        0, (sum, data) => sum + ((data['amount'] as num?) ?? 0).toInt());

    final currentMonth = DateTime.now().month;
    final lastMonth = currentMonth == 1 ? 12 : currentMonth - 1;

    final currentMonthRevenue = widget.revenueData
        .where((data) => (data['month'] ?? 0) == currentMonth)
        .fold<int>(
            0, (sum, data) => sum + ((data['amount'] as num?) ?? 0).toInt());

    final lastMonthRevenue = widget.revenueData
        .where((data) => (data['month'] ?? 0) == lastMonth)
        .fold<int>(
            0, (sum, data) => sum + ((data['amount'] as num?) ?? 0).toInt());

    final monthlyGrowth = lastMonthRevenue > 0
        ? ((currentMonthRevenue - lastMonthRevenue) / lastMonthRevenue) * 100
        : 0.0;

    final guestCount =
        widget.revenueData.map((data) => data['guestId'] ?? '').toSet().length;

    final avgPerGuest =
        guestCount > 0 ? (totalRevenue / guestCount).round() : 0;

    return {
      'totalRevenue': totalRevenue,
      'monthlyGrowth': monthlyGrowth,
      'avgPerGuest': avgPerGuest,
    };
  }

  Map<String, dynamic> _getChartData() {
    // Sample data - replace with actual data from your repository
    final sampleData = [
      {'month': 'Jan', 'revenue': 50000},
      {'month': 'Feb', 'revenue': 55000},
      {'month': 'Mar', 'revenue': 60000},
      {'month': 'Apr', 'revenue': 58000},
      {'month': 'May', 'revenue': 65000},
      {'month': 'Jun', 'revenue': 70000},
    ];

    final labels = sampleData.map((d) => d['month'] as String).toList();
    final values = sampleData.map((d) => d['revenue'] as int).toList();
    final maxValue =
        values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 0;

    return {
      'labels': labels,
      'data': values,
      'maxValue': maxValue,
    };
  }

  Map<String, dynamic> _calculateForecast() {
    // Simple forecasting based on recent trends
    final recentData = _getChartData()['data'] as List<int>;
    if (recentData.length < 3) {
      return {
        'nextMonth': 0,
        'nextQuarter': 0,
        'nextMonthGrowth': 0.0,
        'nextQuarterGrowth': 0.0,
        'insights': 'Insufficient data for forecasting',
      };
    }

    final lastMonth = recentData.last;
    final secondLastMonth = recentData[recentData.length - 2];
    final growthRate = (lastMonth - secondLastMonth) / secondLastMonth;

    final nextMonth = (lastMonth * (1 + growthRate)).round();
    final nextQuarter = (lastMonth * (1 + growthRate * 3)).round();

    final nextMonthGrowth = growthRate * 100;
    final nextQuarterGrowth = growthRate * 300;

    String insights = 'Based on recent trends, ';
    if (growthRate > 0) {
      insights +=
          'revenue is showing positive growth. Consider expanding capacity.';
    } else if (growthRate < -0.1) {
      insights +=
          'revenue is declining. Review pricing and marketing strategies.';
    } else {
      insights +=
          'revenue is stable. Focus on maintaining current performance.';
    }

    return {
      'nextMonth': nextMonth,
      'nextQuarter': nextQuarter,
      'nextMonthGrowth': nextMonthGrowth,
      'nextQuarterGrowth': nextQuarterGrowth,
      'insights': insights,
    };
  }
}
