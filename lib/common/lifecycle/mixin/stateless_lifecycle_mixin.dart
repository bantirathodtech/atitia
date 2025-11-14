// stateless_lifecycle_mixin.dart
import 'package:flutter/widgets.dart';

/// Mixin providing lifecycle-like hooks for StatelessWidgets.
/// Because StatelessWidgets lack built-in lifecycle beyond build and constructor,
/// this helps modularize "start" and "dispose" hooks via wrappers or builders.
mixin StatelessLifecycleMixin on StatelessWidget {
  /// Called when widget is constructed.
  ///
  /// This cannot be automatically triggered because constructor is not overrideable,
  /// so this should be called manually in constructors or via factory methods.
  @protected
  void onStart() {}

  /// Called when widget is removed or no longer used.
  ///
  /// StatelessWidgets don't have native dispose event,
  /// so this needs external mechanism to call or simulate.
  @protected
  void onDispose() {}
}
