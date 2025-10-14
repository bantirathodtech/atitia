// provider_state.dart
import 'package:flutter/material.dart';

/// Abstract base state class for Provider, with ChangeNotifier.
///
/// Extend this class to create your Provider state objects.
/// Encapsulates standard notifyListeners and common error handling.
abstract class BaseProviderState extends ChangeNotifier {
  bool _loading = false;

  bool get loading => _loading;

  bool _error = false;

  bool get error => _error;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  /// Utility method to update loading state with notification.
  @protected
  @mustCallSuper
  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  /// Utility method to set error state and message.
  @protected
  @mustCallSuper
  void setError(bool value, [String? message]) {
    _error = value;
    _errorMessage = message;
    notifyListeners();
  }

  /// Clear error state
  @protected
  @mustCallSuper
  void clearError() {
    _error = false;
    _errorMessage = null;
    notifyListeners();
  }
}

/// Example mixin to add selection support to Provider states,
/// for optimized UI rebuilds based on selected sub-state.
mixin SelectableProviderMixin<T> on BaseProviderState {
  T? _selected;

  T? get selected => _selected;

  /// Update selected sub-state with notification if changed.
  void updateSelected(T? newSelected) {
    if (newSelected != _selected) {
      _selected = newSelected;
      notifyListeners();
    }
  }
}