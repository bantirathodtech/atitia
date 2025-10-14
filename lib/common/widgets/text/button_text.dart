import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/typography.dart';

class ButtonText extends AdaptiveStatelessWidget {
  final String text;
  final Color? color;
  final bool bold;
  final double? fontSize;

  const ButtonText({
    super.key,
    required this.text,
    this.color,
    this.bold = false,
    this.fontSize,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return Text(
      text,
      style: (bold ? AppTypography.buttonBold : AppTypography.button).copyWith(
        color: color ?? Theme.of(context).textTheme.labelLarge?.color,
        fontSize: fontSize,
      ),
    );
  }
}
