// lib/features/owner_dashboard/overview/view/widgets/owner_chart_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/styles/spacing.dart';

/// Widget displaying revenue chart (simplified bar chart)
class OwnerChartWidget extends StatelessWidget {
  final String title;
  final Map<String, double> data;

  const OwnerChartWidget({
    required this.title,
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = data.values.isEmpty
        ? 1.0
        : data.values.reduce((a, b) => a > b ? a : b);

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: title,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data.entries.map((entry) {
                final monthNum = int.tryParse(entry.key.split('_').last) ?? 1;
                final monthName = DateFormat('MMM').format(DateTime(2024, monthNum));
                final value = entry.value;
                final heightPercent = maxValue > 0 ? (value / maxValue) : 0.0;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (value > 0)
                          CaptionText(
                            text: '₹${NumberFormat.compact().format(value)}',
                            color: Theme.of(context).primaryColor,
                          ),
                        const SizedBox(height: 4),
                        Container(
                          height: 150 * heightPercent,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        CaptionText(
                          text: monthName,
                          color: Colors.grey.shade600,
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
    );
  }
}
