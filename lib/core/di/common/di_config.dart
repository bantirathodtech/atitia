// lib/core/di/common/di_config.dart

/// Backend provider type enumeration
/// Determines which service implementations to use
enum BackendProvider {
  firebase,
  supabase,
  restApi,
}

/// Dependency Injection configuration
/// Central configuration for backend provider selection
class DIConfig {
  /// Current backend provider
  /// Change this to swap between Firebase, Supabase, and REST API
  static BackendProvider currentProvider = BackendProvider.firebase;

  /// Gets the current provider as string
  static String get providerName {
    switch (currentProvider) {
      case BackendProvider.firebase:
        return 'firebase';
      case BackendProvider.supabase:
        return 'supabase';
      case BackendProvider.restApi:
        return 'restApi';
    }
  }

  /// Switches backend provider (for testing or migration)
  static void switchProvider(BackendProvider provider) {
    currentProvider = provider;
  }

  /// Checks if using Firebase
  static bool get isFirebase => currentProvider == BackendProvider.firebase;

  /// Checks if using Supabase
  static bool get isSupabase => currentProvider == BackendProvider.supabase;

  /// Checks if using REST API
  static bool get isRestApi => currentProvider == BackendProvider.restApi;
}
