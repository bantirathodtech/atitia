import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/typography.dart';

class LatoText extends AdaptiveStatelessWidget {
  final String text;
  final bool bold;
  final bool italic;
  final bool light;
  final Color? color;
  final double? fontSize;
  final TextAlign align;
  final int? maxLines;
  final TextOverflow? overflow;

  const LatoText({
    super.key,
    required this.text,
    this.bold = false,
    this.italic = false,
    this.light = false,
    this.color,
    this.fontSize,
    this.align = TextAlign.start,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final TextStyle baseStyle;

    if (bold) {
      baseStyle = AppTypography.latoBold;
    } else if (light) {
      baseStyle = AppTypography.latoLight;
    } else if (italic) {
      baseStyle = AppTypography.latoItalic;
    } else {
      baseStyle = AppTypography.latoRegular;
    }

    return Text(
      text,
      style: baseStyle.copyWith(
        color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: fontSize,
      ),
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
