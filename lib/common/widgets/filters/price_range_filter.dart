// lib/common/widgets/filters/price_range_filter.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../text/caption_text.dart';
import '../text/heading_small.dart';

/// 🎨 **PRICE RANGE FILTER - REUSABLE COMPONENT**
///
/// Theme-aware, responsive price range filter widget
/// Used for filtering PGs by rent range
class PriceRangeFilter extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final double currentMinPrice;
  final double currentMaxPrice;
  final ValueChanged<RangeValues> onRangeChanged;
  final String currency;

  const PriceRangeFilter({
    super.key,
    required this.minPrice,
    required this.maxPrice,
    required this.currentMinPrice,
    required this.currentMaxPrice,
    required this.onRangeChanged,
    this.currency = '₹',
  });

  @override
  State<PriceRangeFilter> createState() => _PriceRangeFilterState();
}

class _PriceRangeFilterState extends State<PriceRangeFilter> {
  late RangeValues _currentRange;

  @override
  void initState() {
    super.initState();
    _currentRange = RangeValues(
      widget.currentMinPrice,
      widget.currentMaxPrice,
    );
  }

  @override
  void didUpdateWidget(PriceRangeFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentMinPrice != widget.currentMinPrice ||
        oldWidget.currentMaxPrice != widget.currentMaxPrice) {
      _currentRange = RangeValues(
        widget.currentMinPrice,
        widget.currentMaxPrice,
      );
    }
  }

  String _formatPrice(double price) {
    return '${widget.currency}${price.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingSmall(
          text: 'Price Range',
          color: isDark ? AppColors.lightText : AppColors.textPrimary,
        ),
        const SizedBox(height: AppSpacing.paddingS),
        RangeSlider(
          values: _currentRange,
          min: widget.minPrice,
          max: widget.maxPrice,
          divisions: 50,
          labels: RangeLabels(
            _formatPrice(_currentRange.start),
            _formatPrice(_currentRange.end),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _currentRange = values;
            });
            widget.onRangeChanged(values);
          },
          activeColor: theme.colorScheme.primary,
          inactiveColor: theme.colorScheme.primary.withOpacity(0.2),
        ),
        const SizedBox(height: AppSpacing.paddingXS),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingS,
                vertical: AppSpacing.paddingXS,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCard
                    : AppColors.lightCard,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                border: Border.all(
                  color: theme.dividerColor.withOpacity(0.3),
                ),
              ),
              child: CaptionText(
                text: 'Min: ${_formatPrice(_currentRange.start)}',
                color: isDark
                    ? AppColors.lightText
                    : AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingS,
                vertical: AppSpacing.paddingXS,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkCard
                    : AppColors.lightCard,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                border: Border.all(
                  color: theme.dividerColor.withOpacity(0.3),
                ),
              ),
              child: CaptionText(
                text: 'Max: ${_formatPrice(_currentRange.end)}',
                color: isDark
                    ? AppColors.lightText
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

