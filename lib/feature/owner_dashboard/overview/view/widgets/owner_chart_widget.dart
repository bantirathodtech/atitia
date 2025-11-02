// lib/features/owner_dashboard/overview/view/widgets/owner_chart_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/cards/info_card.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';

/// Widget displaying revenue chart (responsive bar chart)
/// Fully adaptive and responsive using core/common reusable components
class OwnerChartWidget extends AdaptiveStatelessWidget {
  final String title;
  final Map<String, double> data;

  const OwnerChartWidget({
    required this.title,
    required this.data,
    super.key,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final responsive = context.responsive;
    final theme = Theme.of(context);
    final padding = context.responsivePadding;

    // Calculate responsive dimensions
    final chartHeight = _getResponsiveChartHeight(responsive);
    final barMaxHeight = chartHeight * 0.7; // 70% of chart height for bars
    final horizontalSpacing = _getHorizontalSpacing(responsive);
    final fontSize = _getResponsiveFontSize(responsive);

    final maxValue =
        data.values.isEmpty ? 1.0 : data.values.reduce((a, b) => a > b ? a : b);

    final hasData = data.values.any((v) => v > 0);

    // For mobile: make chart horizontally scrollable
    final isScrollable = responsive.isMobile && data.length > 4;

    // Calculate stats: Total Revenue, Average/Month, Highest Month
    final totalRevenue = data.values.fold(0.0, (sum, value) => sum + value);
    final monthsWithData = data.values.where((v) => v > 0).length;
    final averagePerMonth = monthsWithData > 0 ? totalRevenue / monthsWithData : 0.0;
    final highestMonthEntry = data.entries.isEmpty 
        ? null 
        : data.entries.reduce((a, b) => a.value > b.value ? a : b);
    final highestMonthValue = highestMonthEntry?.value ?? 0.0;
    final highestMonthNum = highestMonthEntry != null 
        ? (int.tryParse(highestMonthEntry.key.split('_').last) ?? 1)
        : 0;
    final highestMonthName = highestMonthNum > 0 
        ? DateFormat('MMM').format(DateTime(2024, highestMonthNum))
        : 'N/A';

    return AdaptiveCard(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeadingMedium(
            text: title,
            color: theme.primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingL),

          // Stats cards: Total Revenue, Average/Month, Highest Month
          _buildStatsCards(
            context, 
            theme, 
            responsive,
            totalRevenue,
            averagePerMonth,
            highestMonthValue,
            highestMonthName,
          ),
          const SizedBox(height: AppSpacing.paddingL),

          // Chart content - scrollable on mobile if needed
          if (hasData)
            SizedBox(
              height: chartHeight,
              child: isScrollable
                  ? _buildScrollableChart(context, theme, barMaxHeight,
                      maxValue, horizontalSpacing, fontSize)
                  : _buildStaticChart(context, theme, barMaxHeight, maxValue,
                      horizontalSpacing, fontSize),
            )
          else
            SizedBox(
              height: chartHeight,
              child: _buildEmptyChartBars(context, theme, responsive, chartHeight),
            ),
        ],
      ),
    );
  }

  /// Builds scrollable chart for mobile devices
  Widget _buildScrollableChart(
    BuildContext context,
    ThemeData theme,
    double barMaxHeight,
    double maxValue,
    double horizontalSpacing,
    double fontSize,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: horizontalSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _buildBarItemsForScroll(context, theme, barMaxHeight,
            maxValue, horizontalSpacing, fontSize),
      ),
    );
  }

  /// Builds static chart for tablet/desktop
  Widget _buildStaticChart(
    BuildContext context,
    ThemeData theme,
    double barMaxHeight,
    double maxValue,
    double horizontalSpacing,
    double fontSize,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _buildBarItems(context, theme, barMaxHeight, maxValue,
            horizontalSpacing, fontSize),
      ),
    );
  }

  /// Builds list of bar items for static chart (uses Expanded)
  List<Widget> _buildBarItems(
    BuildContext context,
    ThemeData theme,
    double barMaxHeight,
    double maxValue,
    double horizontalSpacing,
    double fontSize,
  ) {
    return data.entries.map((entry) {
      return _buildBarItem(
        context,
        theme,
        barMaxHeight,
        maxValue,
        horizontalSpacing,
        fontSize,
        entry,
        useExpanded: true,
      );
    }).toList();
  }

  /// Builds list of bar items for scrollable chart (fixed width)
  List<Widget> _buildBarItemsForScroll(
    BuildContext context,
    ThemeData theme,
    double barMaxHeight,
    double maxValue,
    double horizontalSpacing,
    double fontSize,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive width: 25% of screen width, min 80px, max 120px
    final itemWidth = (screenWidth / 4).clamp(80.0, 120.0);
    return data.entries.map((entry) {
      return SizedBox(
        width: itemWidth,
        child: _buildBarItem(
          context,
          theme,
          barMaxHeight,
          maxValue,
          horizontalSpacing,
          fontSize,
          entry,
          useExpanded: false,
        ),
      );
    }).toList();
  }

  /// Builds a single bar item
  Widget _buildBarItem(
      BuildContext context,
      ThemeData theme,
      double barMaxHeight,
      double maxValue,
      double horizontalSpacing,
      double fontSize,
      MapEntry<String, double> entry,
      {required bool useExpanded}) {
    final monthNum = int.tryParse(entry.key.split('_').last) ?? 1;
    final monthName = DateFormat('MMM').format(DateTime(2024, monthNum));
    final value = entry.value;
    final heightPercent = maxValue > 0 ? (value / maxValue) : 0.0;
    final barHeight = barMaxHeight * heightPercent;

    // Minimum bar height for visibility
    final minBarHeight = 4.0;
    final finalBarHeight =
        barHeight < minBarHeight && value > 0 ? minBarHeight : barHeight;

    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalSpacing / 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Value label (only show if value > 0)
          if (value > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.paddingXS),
              child: Tooltip(
                message: '₹${NumberFormat('#,##0.00').format(value)}',
                child: Text(
                  '₹${NumberFormat.compact().format(value)}',
                  style: TextStyle(
                    fontSize: fontSize * 0.85,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),

          // Bar
          if (value > 0)
            Flexible(
              child: Container(
                height: finalBarHeight,
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primaryColor.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            )
          else
            Container(
              height: 2,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(1),
              ),
            ),

          const SizedBox(height: AppSpacing.paddingXS),

          // Month label
          CaptionText(
            text: monthName,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );

    return useExpanded ? Expanded(child: content) : content;
  }

  /// Builds placeholder chart bars (without stats, stats are shown separately now)
  Widget _buildEmptyChartBars(BuildContext context, ThemeData theme,
      ResponsiveConfig responsive, double chartHeight) {
    final horizontalSpacing = _getHorizontalSpacing(responsive);
    final fontSize = _getResponsiveFontSize(responsive);
    final barMaxHeight = chartHeight * 0.7;

    // Placeholder chart bars - show structure even with no data
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _buildPlaceholderBars(
            context, theme, barMaxHeight, horizontalSpacing, fontSize),
      ),
    );
  }

  /// Builds statistics cards with actual calculated values
  /// Displays 3 cards that expand to fill full width of screen
  Widget _buildStatsCards(
      BuildContext context,
      ThemeData theme,
      ResponsiveConfig responsive,
      double totalRevenue,
      double averagePerMonth,
      double highestMonthValue,
      String highestMonthName) {
    final stats = [
      {
        'label': 'Total Revenue',
        'value': '₹${NumberFormat('#,##0').format(totalRevenue)}',
        'icon': Icons.account_balance_wallet_outlined,
        'color': Colors.blue,
      },
      {
        'label': 'Average/Month',
        'value': '₹${NumberFormat('#,##0').format(averagePerMonth)}',
        'icon': Icons.trending_flat,
        'color': Colors.green,
      },
      {
        'label': 'Highest Month',
        'value': '₹${NumberFormat('#,##0').format(highestMonthValue)} ($highestMonthName)',
        'icon': Icons.trending_up,
        'color': Colors.orange,
      },
    ];

    // On mobile, stack vertically; on tablet/desktop, use horizontal row
    if (responsive.isMobile) {
      return Column(
        children: stats.map((stat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
            child: SizedBox(
              width: double.infinity,
              child: InfoCard(
                title: stat['value'] as String,
                description: stat['label'] as String,
                icon: stat['icon'] as IconData,
                iconColor: stat['color'] as Color,
              ),
            ),
          );
        }).toList(),
      );
    }

    // Tablet/Desktop: Use Row with Expanded to fill full width
    return Row(
      children: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index < stats.length - 1 ? AppSpacing.paddingM : 0,
            ),
            child: InfoCard(
              title: stat['value'] as String,
              description: stat['label'] as String,
              icon: stat['icon'] as IconData,
              iconColor: stat['color'] as Color,
            ),
          ),
        );
      }).toList(),
    );
  }


  /// Builds placeholder bars for all 12 months
  List<Widget> _buildPlaceholderBars(
    BuildContext context,
    ThemeData theme,
    double barMaxHeight,
    double horizontalSpacing,
    double fontSize,
  ) {
    final months = List.generate(12, (index) => index + 1);

    return months.map((monthNum) {
      final monthName = DateFormat('MMM').format(DateTime(2024, monthNum));
      // Placeholder height - very small for visual consistency
      final placeholderHeight = 8.0;

      return Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalSpacing / 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Placeholder value label (subtle)
              CaptionText(
                text: '₹0',
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 4),

              // Placeholder bar
              Container(
                height: placeholderHeight,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.paddingXS),

              // Month label
              CaptionText(
                text: monthName,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  /// Gets responsive chart height based on screen size
  double _getResponsiveChartHeight(ResponsiveConfig responsive) {
    if (responsive.isMobile) return 220.0;
    if (responsive.isTablet) return 280.0;
    if (responsive.isDesktop) return 320.0;
    return 360.0; // largeDesktop
  }

  /// Gets responsive horizontal spacing between bars
  double _getHorizontalSpacing(ResponsiveConfig responsive) {
    if (responsive.isMobile) return AppSpacing.paddingXS;
    if (responsive.isTablet) return AppSpacing.paddingS;
    return AppSpacing.paddingM; // desktop
  }

  /// Gets responsive font size
  double _getResponsiveFontSize(ResponsiveConfig responsive) {
    if (responsive.isMobile) return 10.0;
    if (responsive.isTablet) return 12.0;
    return 14.0; // desktop
  }
}
