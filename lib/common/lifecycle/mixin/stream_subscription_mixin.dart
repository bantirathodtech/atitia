// stream_subscription_mixin.dart
import 'dart:async';
import 'package:flutter/material.dart';

import '../state/provider_state.dart';

/// Mixin for managing StreamSubscriptions in ViewModels that extend BaseProviderState.
///
/// Provides automatic cleanup of all stream subscriptions when ViewModel is disposed.
/// Usage:
/// ```dart
/// class MyViewModel extends BaseProviderState with StreamSubscriptionMixin {
///   void initialize() {
///     addSubscription(_repository.streamData().listen(...));
///   }
/// }
/// ```
mixin StreamSubscriptionMixin on BaseProviderState {
  final List<StreamSubscription> _subscriptions = [];
  final List<Timer> _timers = [];

  /// Adds a stream subscription to be automatically disposed
  @protected
  void addSubscription(StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  /// Adds a timer to be automatically cancelled
  @protected
  void addTimer(Timer timer) {
    _timers.add(timer);
  }

  /// Cancels all subscriptions and clears the list
  void cancelAllSubscriptions() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
  }

  /// Cancels all timers and clears the list
  void cancelAllTimers() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }

  /// Disposes all subscriptions and timers
  /// Call this in dispose() method
  void disposeAll() {
    cancelAllSubscriptions();
    cancelAllTimers();
  }
}
