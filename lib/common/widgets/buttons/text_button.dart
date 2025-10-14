import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/typography.dart';

class TextButtonWidget extends AdaptiveStatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final bool bold;
  final double? fontSize;

  const TextButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.bold = false,
    this.fontSize,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: AppTypography.button.copyWith(
          color: color ?? Theme.of(context).primaryColor,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
