// flutter_default_state.dart
import 'package:flutter/widgets.dart';

/// A modular helper mixin for default Flutter state management using setState.
/// Provides a concise way to update state and notify listeners.
/// Includes a simple selector pattern to rebuild only what depends on specific parts of the state.
mixin FlutterDefaultState<T extends StatefulWidget, StateData> on State<T> {
  late StateData _state;

  /// Get the current state
  StateData get state => _state;

  /// Initializes the state reference. Should be called in initState or constructor.
  void initStateData(StateData initialState) {
    _state = initialState;
  }

  /// Replaces the current state and triggers rebuild.
  void updateState(StateData newState) {
    if (mounted) {
      setState(() {
        _state = newState;
      });
    }
  }

  /// Updates part of the state via a modifier function and triggers rebuild.
  void modifyState(void Function(StateData current) modifier) {
    if (mounted) {
      setState(() {
        modifier(_state);
      });
    }
  }

  /// Selector widget to optimize rebuilds by providing selected partial state to child builder.
  Widget selector<Selected>({
    required Selected Function(StateData) selector,
    required Widget Function(BuildContext, Selected) builder,
    Key? key,
  }) {
    return _SelectorWidget<StateData, Selected>(
      key: key,
      stateProvider: () => _state,
      selector: selector,
      builder: builder,
    );
  }
}

/// Internal widget implementing selector logic to rebuild only when selected part changes.
class _SelectorWidget<StateData, Selected> extends StatefulWidget {
  final StateData Function() stateProvider;
  final Selected Function(StateData) selector;
  final Widget Function(BuildContext, Selected) builder;

  const _SelectorWidget({
    super.key,
    required this.stateProvider,
    required this.selector,
    required this.builder,
  });

  @override
  _SelectorWidgetState<StateData, Selected> createState() =>
      _SelectorWidgetState<StateData, Selected>();
}

class _SelectorWidgetState<StateData, Selected>
    extends State<_SelectorWidget<StateData, Selected>> {
  late Selected selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selector(widget.stateProvider());
  }

  @override
  void didUpdateWidget(covariant _SelectorWidget<StateData, Selected> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newSelected = widget.selector(widget.stateProvider());
    if (newSelected != selectedValue) {
      setState(() {
        selectedValue = newSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, selectedValue);
  }
}