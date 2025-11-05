// lib/feature/owner_dashboard/analytics/widgets/occupancy_analytics_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, isDark),
        const SizedBox(height: AppSpacing.paddingL),
        _buildOccupancyMetrics(context, isDark),
        const SizedBox(height: AppSpacing.paddingL),
        _buildOccupancyChart(context, isDark),
        const SizedBox(height: AppSpacing.paddingL),
        _buildCapacityAnalysis(context, isDark),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          ),
          child: const Icon(
            Icons.bed,
            color: Colors.blue,
            size: 24,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadingMedium(text: 'Occupancy Analytics'),
              CaptionText(
                text: widget.selectedPgId != null
                    ? 'Occupancy insights for selected PG'
                    : 'Overall occupancy performance',
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

  Widget _buildOccupancyMetrics(BuildContext context, bool isDark) {
    final metrics = _calculateOccupancyMetrics();

    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Current Occupancy',
            '${metrics['currentOccupancy']}%',
            Icons.bed,
            _getOccupancyColor(metrics['currentOccupancy']),
            isDark,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: _buildMetricCard(
            'Avg. Occupancy',
            '${metrics['avgOccupancy']}%',
            Icons.trending_up,
            Colors.blue,
            isDark,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: _buildMetricCard(
            'Peak Occupancy',
            '${metrics['peakOccupancy']}%',
            Icons.flag,
            Colors.orange,
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

  Widget _buildOccupancyChart(BuildContext context, bool isDark) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const HeadingSmall(text: 'Occupancy Trends'),
                const Spacer(),
                _buildPeriodSelector(isDark),
                const SizedBox(width: AppSpacing.paddingM),
                _buildViewSelector(isDark),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),
            SizedBox(
              height: 300,
              child: _buildSimpleOccupancyChart(isDark),
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

  Widget _buildViewSelector(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingS),
      decoration: BoxDecoration(
        border:
            Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      ),
      child: DropdownButton<String>(
        value: _selectedView,
        underline: const SizedBox(),
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontSize: 14,
        ),
        items: const [
          DropdownMenuItem(value: 'overview', child: Text('Overview')),
          DropdownMenuItem(value: 'by_room', child: Text('By Room')),
          DropdownMenuItem(value: 'by_floor', child: Text('By Floor')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedView = value!;
          });
        },
      ),
    );
  }

  Widget _buildSimpleOccupancyChart(bool isDark) {
    final chartData = _getOccupancyChartData();
    final labels = chartData['labels'] as List<String>;
    final values = chartData['data'] as List<int>;

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
                final height = (value / 100) * 200;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.blue,
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
                      '$value%',
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
            text: 'Occupancy Trend (Last 6 Months)',
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityAnalysis(BuildContext context, bool isDark) {
    final analysis = _calculateCapacityAnalysis();

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeadingSmall(text: 'Capacity Analysis'),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildCapacityCard(
                    'Available Beds',
                    '${analysis['availableBeds']}',
                    Icons.bed_outlined,
                    Colors.green,
                    isDark,
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: _buildCapacityCard(
                    'Occupied Beds',
                    '${analysis['occupiedBeds']}',
                    Icons.bed,
                    Colors.blue,
                    isDark,
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: _buildCapacityCard(
                    'Total Capacity',
                    '${analysis['totalCapacity']}',
                    Icons.home,
                    Colors.grey,
                    isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildOccupancyInsights(analysis, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildCapacityCard(
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
    );
  }

  Widget _buildOccupancyInsights(Map<String, dynamic> analysis, bool isDark) {
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
            text: 'Occupancy Insights',
          ),
          const SizedBox(height: AppSpacing.paddingS),
          BodyText(
            text: analysis['insights'],
            color: isDark ? Colors.white70 : Colors.grey[600],
          ),
          if (analysis['recommendations'].isNotEmpty) ...[
            const SizedBox(height: AppSpacing.paddingM),
            const BodyText(
              text: 'Recommendations:',
            ),
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
                              color: isDark ? Colors.white70 : Colors.grey[600],
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
      {'month': 'Jan', 'occupancy': 85},
      {'month': 'Feb', 'occupancy': 78},
      {'month': 'Mar', 'occupancy': 92},
      {'month': 'Apr', 'occupancy': 88},
      {'month': 'May', 'occupancy': 95},
      {'month': 'Jun', 'occupancy': 90},
    ];

    final labels = sampleData.map((d) => d['month'] as String).toList();
    final values = sampleData.map((d) => d['occupancy'] as int).toList();

    return {
      'labels': labels,
      'data': values,
    };
  }

  Map<String, dynamic> _calculateCapacityAnalysis() {
    // Sample data - replace with actual data from your repository
    final totalCapacity = 50;
    final occupiedBeds = 45;
    final availableBeds = totalCapacity - occupiedBeds;
    final occupancyRate = (occupiedBeds / totalCapacity) * 100;

    String insights =
        'Current occupancy is at ${occupancyRate.toStringAsFixed(1)}%. ';
    List<String> recommendations = [];

    if (occupancyRate >= 90) {
      insights +=
          'Your PG is nearly at full capacity. Consider expanding or opening new rooms.';
      recommendations.add('Consider adding more beds or rooms');
      recommendations.add('Review pricing strategy for high demand');
    } else if (occupancyRate >= 70) {
      insights +=
          'Good occupancy rate. Monitor trends and consider marketing strategies.';
      recommendations.add('Focus on maintaining current occupancy');
      recommendations.add('Consider seasonal pricing adjustments');
    } else if (occupancyRate >= 50) {
      insights +=
          'Moderate occupancy. There\'s room for improvement through better marketing.';
      recommendations.add('Increase marketing efforts');
      recommendations.add('Review and improve amenities');
      recommendations.add('Consider competitive pricing');
    } else {
      insights +=
          'Low occupancy rate. Immediate action needed to improve bookings.';
      recommendations.add('Urgent marketing campaign needed');
      recommendations.add('Review and reduce pricing');
      recommendations.add('Improve facilities and amenities');
      recommendations.add('Consider partnerships with local businesses');
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

  Color _getOccupancyColor(int occupancy) {
    if (occupancy >= 90) return Colors.red;
    if (occupancy >= 70) return Colors.orange;
    if (occupancy >= 50) return Colors.blue;
    return Colors.green;
  }
}
