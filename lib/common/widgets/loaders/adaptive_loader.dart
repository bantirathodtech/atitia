import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';

class AdaptiveLoader extends AdaptiveStatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final bool center;

  const AdaptiveLoader({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 3,
    this.center = true,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final loader = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
        strokeWidth: strokeWidth,
      ),
    );

    if (!center) return loader;
    return Center(child: loader);
  }
}
