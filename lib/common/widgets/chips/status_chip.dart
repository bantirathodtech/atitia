import 'package:flutter/material.dart';

import '../../styles/spacing.dart';

/// Compact status chip with colored dot and label, used for legends and tags
class StatusChip extends StatelessWidget {
  final Color color;
  final String label;
  final IconData? icon;
  final bool filled;
  final double paddingH;
  final double paddingV;
  final double iconSize;
  final double fontSize;

  const StatusChip({
    super.key,
    required this.color,
    required this.label,
    this.icon,
    this.filled = false,
    this.paddingH = 12,
    this.paddingV = 8,
    this.iconSize = 16,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final bg =
        filled ? color.withValues(alpha: 0.16) : color.withValues(alpha: 0.12);
    final border = color.withValues(alpha: 0.3);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: paddingH,
        vertical: paddingV,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null)
            Icon(icon, size: iconSize, color: color)
          else
            Container(
              width: iconSize - 6,
              height: iconSize - 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          const SizedBox(width: AppSpacing.paddingS),
          DefaultTextStyle(
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
