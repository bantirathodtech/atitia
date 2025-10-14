// adaptive_stateless_widget.dart
import 'package:flutter/material.dart';

import '../mixin/stateless_lifecycle_mixin.dart';

/// A base stateless widget with built-in adaptive support.
abstract class AdaptiveStatelessWidget extends StatelessWidget
    with StatelessLifecycleMixin {
  const AdaptiveStatelessWidget({super.key});

  /// Override this method instead of build for access to context.
  Widget buildAdaptive(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildAdaptive(context);
  }
}
