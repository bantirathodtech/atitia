// adaptive_stateful_widget.dart
import 'package:flutter/material.dart';

import '../mixin/stateful_lifecycle_mixin.dart';

/// Base class for adaptive, lifecycle-aware stateful widgets.
abstract class AdaptiveStatefulWidget extends StatefulWidget {
  const AdaptiveStatefulWidget({super.key});

  /// Override to produce your custom state.
  @override
  AdaptiveStatefulWidgetState createState();
}

abstract class AdaptiveStatefulWidgetState<T extends AdaptiveStatefulWidget>
    extends State<T> with StatefulLifecycleMixin<T> {
  /// Use this getter for adaptivity (MediaQuery, Theme, etc.).
  BuildContext get adaptiveContext => context;

  /// Override this to build your widget with full lifecycle and adaptive support.
  Widget buildAdaptive(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildAdaptive(context);
  }
}
