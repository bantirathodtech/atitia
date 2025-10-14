import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';

class AdaptiveLoader extends AdaptiveStatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const AdaptiveLoader({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 3,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
        strokeWidth: strokeWidth,
      ),
    );
  }
}
