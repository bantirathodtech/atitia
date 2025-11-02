import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Firebase Remote Config service for dynamic app configuration.
///
/// Responsibility:
/// - Manage feature flags and A/B testing
/// - Control app behavior without deployments
/// - Serve different configurations to user segments
class RemoteConfigServiceWrapper {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  RemoteConfigServiceWrapper._privateConstructor();
  static final RemoteConfigServiceWrapper _instance =
      RemoteConfigServiceWrapper._privateConstructor();
  factory RemoteConfigServiceWrapper() => _instance;

  /// Initialize remote config with default values
  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    // Set default values
    await _remoteConfig.setDefaults(const {
      'welcome_message': 'Welcome to Atitia',
      'feature_new_ui': false,
      'maintenance_mode': false,
      'app_version': '1.0.0',
    });

    // Fetch and activate config
    await fetchAndActivate();
  }

  /// Fetch and activate the latest configuration
  Future<bool> fetchAndActivate() async {
    try {
      await _remoteConfig.fetchAndActivate();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get string value from remote config
  String getString(String key) => _remoteConfig.getString(key);

  /// Get boolean value from remote config
  bool getBool(String key) => _remoteConfig.getBool(key);

  /// Get int value from remote config
  int getInt(String key) => _remoteConfig.getInt(key);

  /// Get double value from remote config
  double getDouble(String key) => _remoteConfig.getDouble(key);

  /// Get all parameters for debugging
  Map<String, RemoteConfigValue> getAll() => _remoteConfig.getAll();
}
