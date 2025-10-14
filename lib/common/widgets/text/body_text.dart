import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/typography.dart';

class BodyText extends AdaptiveStatelessWidget {
  final String text;
  final Color? color;
  final TextAlign align;
  final bool medium;
  final bool small;
  final int? maxLines;
  final TextOverflow? overflow;

  const BodyText({
    super.key,
    required this.text,
    this.color,
    this.align = TextAlign.start,
    this.medium = false,
    this.small = false,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final TextStyle style;
    if (small) {
      style = AppTypography.bodySmall;
    } else if (medium) {
      style = AppTypography.bodyMedium;
    } else {
      style = AppTypography.bodyLarge;
    }

    return Text(
      text,
      style: style.copyWith(
        color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
      ),
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
