import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/typography.dart';

class OpenSansText extends AdaptiveStatelessWidget {
  final String text;
  final bool bold;
  final bool italic;
  final bool medium;
  final Color? color;
  final double? fontSize;
  final TextAlign align;
  final int? maxLines;

  const OpenSansText({
    super.key,
    required this.text,
    this.bold = false,
    this.italic = false,
    this.medium = false,
    this.color,
    this.fontSize,
    this.align = TextAlign.start,
    this.maxLines,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final TextStyle baseStyle;

    if (bold) {
      baseStyle = AppTypography.openSansBold;
    } else if (medium) {
      baseStyle = AppTypography.openSansMedium;
    } else if (italic) {
      baseStyle = AppTypography.openSansItalic;
    } else {
      baseStyle = AppTypography.openSansRegular;
    }

    return Text(
      text,
      style: baseStyle.copyWith(
        color: color ?? Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: fontSize,
      ),
      textAlign: align,
      maxLines: maxLines,
    );
  }
}
