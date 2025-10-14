import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';

class ShimmerLoader extends AdaptiveStatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppSpacing.borderRadiusM,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
