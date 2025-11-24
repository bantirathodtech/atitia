import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';

/// 🎨 **ENHANCED SHIMMER LOADER - POLISHED ANIMATION**
///
/// Beautiful shimmer effect loader with smooth animations
/// Used for skeleton screens and loading placeholders
class ShimmerLoader extends AdaptiveStatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppSpacing.borderRadiusM,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final base = baseColor ?? 
        (isDark 
            ? Colors.grey[800]!.withValues(alpha: 0.5)
            : Colors.grey[300]!.withValues(alpha: 0.5));
    final highlight = highlightColor ?? 
        (isDark 
            ? Colors.grey[700]!.withValues(alpha: 0.8)
            : Colors.grey[100]!.withValues(alpha: 0.8));

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// Shimmer skeleton for cards
class ShimmerCard extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsets? padding;

  const ShimmerCard({
    this.width,
    this.height = 120,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppSpacing.paddingM),
      child: ShimmerLoader(
        width: width ?? double.infinity,
        height: height,
        borderRadius: AppSpacing.borderRadiusL,
      ),
    );
  }
}

/// Shimmer skeleton for list items
class ShimmerListTile extends StatelessWidget {
  final bool hasAvatar;
  final bool hasSubtitle;

  const ShimmerListTile({
    this.hasAvatar = true,
    this.hasSubtitle = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      child: Row(
        children: [
          if (hasAvatar)
            ShimmerLoader(
              width: 48,
              height: 48,
              borderRadius: 24,
            ),
          if (hasAvatar) const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerLoader(
                  width: double.infinity,
                  height: 16,
                  borderRadius: AppSpacing.borderRadiusS,
                ),
                if (hasSubtitle) ...[
                  const SizedBox(height: AppSpacing.paddingS),
                  ShimmerLoader(
                    width: double.infinity * 0.7,
                    height: 12,
                    borderRadius: AppSpacing.borderRadiusS,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Circular shimmer loader
class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle({
    this.size = 48,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      width: size,
      height: size,
      borderRadius: size / 2,
    );
  }
}
