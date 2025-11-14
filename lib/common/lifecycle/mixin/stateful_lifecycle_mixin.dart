// stateful_lifecycle_mixin.dart
import 'package:flutter/widgets.dart';

/// Mixin for full, modular lifecycle handling in StatefulWidget State.
/// Includes all main and advanced lifecycle events for clarity and extensibility.
mixin StatefulLifecycleMixin<T extends StatefulWidget> on State<T> {
  /// Called once when the state is initialized.
  @protected
  void onInit() {}

  /// Called immediately after initState, and whenever dependencies change.
  @protected
  void onDependenciesChanged() {}

  /// Called whenever this widget configuration changes.
  @protected
  void onWidgetUpdated(covariant T oldWidget) {}

  /// Called when hot reload occurs (development only).
  @protected
  void onReassemble() {}

  /// Called when the widget is removed temporarily from the tree.
  @protected
  void onDeactivate() {}

  /// Called when the state object is permanently disposed.
  @protected
  void onDispose() {}

  /// True while this state object is mounted in the widget tree.
  bool get isMounted => mounted;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    onInit();
  }

  @override
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      onDependenciesChanged();
    }
  }

  @override
  @mustCallSuper
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (mounted) {
      onWidgetUpdated(oldWidget);
    }
  }

  @override
  @mustCallSuper
  void reassemble() {
    super.reassemble();
    if (mounted) {
      onReassemble();
    }
  }

  @override
  @mustCallSuper
  void deactivate() {
    onDeactivate();
    super.deactivate();
  }

  @override
  @mustCallSuper
  void dispose() {
    onDispose();
    super.dispose();
  }
}
