// lib/core/services/connectivity/connectivity_service.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../di/firebase/di/firebase_service_locator.dart';
import '../../../common/utils/date/converter/date_service_converter.dart';

/// Connectivity service for monitoring network status
/// Handles online/offline state changes and data synchronization
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  static ConnectivityService get instance => _instance;

  // Logger not available in GetIt - removed for now
  final _analyticsService = getIt.analytics;
  final _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _isOnline = true;
  ConnectivityResult _currentConnectionType = ConnectivityResult.none;
  final List<ConnectivityResult> _connectionHistory = [];

  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();
  final StreamController<ConnectivityResult> _connectionTypeController =
      StreamController<ConnectivityResult>.broadcast();

  /// Stream of connectivity status changes
  Stream<bool> get connectivityStream => _connectivityController.stream;

  /// Stream of connection type changes
  Stream<ConnectivityResult> get connectionTypeStream =>
      _connectionTypeController.stream;

  /// Current online status
  bool get isOnline => _isOnline;

  /// Current connection type
  ConnectivityResult get currentConnectionType => _currentConnectionType;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    try {
    // Logger not available: _logger call removed

      // Get initial connectivity status
      final connectivityResults = await _connectivity.checkConnectivity();
      _updateConnectivityStatus(connectivityResults);

      // Start listening to connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectivityStatus,
        onError: (error) {
    // Logger not available: _logger call removed
        },
      );

      await _analyticsService.logEvent(
        name: 'connectivity_service_initialized',
        parameters: {
          'initial_status': _isOnline ? 'online' : 'offline',
          'connection_type': _currentConnectionType.name,
        },
      );

    // Logger not available: _logger call removed
    } catch (e) {
    // Logger not available: _logger call removed
    }
  }

  /// Update connectivity status
  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    final previousConnectionType = _currentConnectionType;

    // Determine if we're online
    _isOnline = results.any((result) => result != ConnectivityResult.none);

    // Determine connection type (prioritize better connections)
    if (results.contains(ConnectivityResult.wifi)) {
      _currentConnectionType = ConnectivityResult.wifi;
    } else if (results.contains(ConnectivityResult.mobile)) {
      _currentConnectionType = ConnectivityResult.mobile;
    } else if (results.contains(ConnectivityResult.ethernet)) {
      _currentConnectionType = ConnectivityResult.ethernet;
    } else {
      _currentConnectionType = ConnectivityResult.none;
    }

    // Add to connection history
    _connectionHistory.add(_currentConnectionType);
    if (_connectionHistory.length > 10) {
      _connectionHistory.removeAt(0);
    }

    // Notify listeners
    _connectivityController.add(_isOnline);
    _connectionTypeController.add(_currentConnectionType);

    // Log connectivity changes
    if (wasOnline != _isOnline) {
      _logConnectivityChange(
          wasOnline, _isOnline, previousConnectionType, _currentConnectionType);
    }
  }

  /// Log connectivity changes
  void _logConnectivityChange(
    bool wasOnline,
    bool isOnline,
    ConnectivityResult previousType,
    ConnectivityResult currentType,
  ) {
    final status = isOnline ? 'online' : 'offline';
    final previousStatus = wasOnline ? 'online' : 'offline';

    // Logger not available: _logger call removed

    _analyticsService.logEvent(
      name: 'connectivity_status_changed',
      parameters: {
        'from_status': previousStatus,
        'to_status': status,
        'previous_type': previousType.name,
        'current_type': currentType.name,
        'timestamp': DateServiceConverter.toService(DateTime.now()),
      },
    );
  }

  /// Check if device is connected to internet
  Future<bool> isConnectedToInternet() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      return connectivityResults
          .any((result) => result != ConnectivityResult.none);
    } catch (e) {
    // Logger not available: _logger call removed
      return false;
    }
  }

  /// Check if connected via WiFi
  bool get isConnectedViaWifi =>
      _currentConnectionType == ConnectivityResult.wifi;

  /// Check if connected via mobile data
  bool get isConnectedViaMobile =>
      _currentConnectionType == ConnectivityResult.mobile;

  /// Check if connected via ethernet
  bool get isConnectedViaEthernet =>
      _currentConnectionType == ConnectivityResult.ethernet;

  /// Get connection quality score (0-100)
  int getConnectionQualityScore() {
    if (!_isOnline) return 0;

    switch (_currentConnectionType) {
      case ConnectivityResult.wifi:
        return 90; // WiFi is generally good
      case ConnectivityResult.ethernet:
        return 95; // Ethernet is usually excellent
      case ConnectivityResult.mobile:
        return 70; // Mobile data can vary
      case ConnectivityResult.none:
        return 0;
      default:
        return 50; // Unknown connection type
    }
  }

  /// Get connection stability based on history
  double getConnectionStability() {
    if (_connectionHistory.length < 2) return 1.0;

    int changes = 0;
    for (int i = 1; i < _connectionHistory.length; i++) {
      if (_connectionHistory[i] != _connectionHistory[i - 1]) {
        changes++;
      }
    }

    return 1.0 - (changes / (_connectionHistory.length - 1));
  }

  /// Wait for internet connection
  Future<bool> waitForConnection(
      {Duration timeout = const Duration(seconds: 30)}) async {
    if (_isOnline) return true;

    final completer = Completer<bool>();
    late StreamSubscription subscription;

    subscription = connectivityStream.listen((isOnline) {
      if (isOnline) {
        subscription.cancel();
        completer.complete(true);
      }
    });

    // Set timeout
    Timer(timeout, () {
      if (!completer.isCompleted) {
        subscription.cancel();
        completer.complete(false);
      }
    });

    return completer.future;
  }

  /// Get connectivity statistics
  Map<String, dynamic> getConnectivityStats() {
    return {
      'isOnline': _isOnline,
      'connectionType': _currentConnectionType.name,
      'qualityScore': getConnectionQualityScore(),
      'stability': getConnectionStability(),
      'historyLength': _connectionHistory.length,
      'connectionHistory': _connectionHistory.map((e) => e.name).toList(),
    };
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController.close();
    _connectionTypeController.close();
  }
}
