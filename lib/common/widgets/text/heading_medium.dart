import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/typography.dart';

class HeadingMedium extends AdaptiveStatelessWidget {
  final String text;
  final Color? color;
  final TextAlign align;
  final int? maxLines;
  final TextOverflow? overflow;

  const HeadingMedium({
    super.key,
    required this.text,
    this.color,
    this.align = TextAlign.start,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return Text(
      text,
      style: AppTypography.headingMedium.copyWith(
        color: color ?? Theme.of(context).textTheme.displayMedium?.color,
      ),
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
