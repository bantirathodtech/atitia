// lib/core/config/production_config.dart

import 'package:flutter/foundation.dart';

/// Production configuration management
/// Handles environment-specific settings and feature flags
class ProductionConfig {
  static final ProductionConfig _instance = ProductionConfig._internal();
  factory ProductionConfig() => _instance;
  ProductionConfig._internal();

  // Environment detection
  static bool get isProduction => kReleaseMode;
  static bool get isDevelopment => kDebugMode;
  static bool get isStaging => !kReleaseMode && !kDebugMode;

  // Feature flags
  static const bool enableAnalytics = true;
  static const bool enableCrashlytics = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableSecurityMonitoring = true;
  static const bool enableErrorReporting = true;
  static const bool enableUserTracking = true;
  static const bool enableDebugLogging = false;

  // API Configuration
  static const String apiBaseUrl = 'https://api.atitia.com';
  static const String apiVersion = 'v1';
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;

  // Firebase Configuration
  static const String firebaseProjectId = 'atitia-app';
  static const String firebaseAppId = 'com.charyatani.atitia';
  static const String firebaseApiKey = 'AIzaSyBxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
  static const String firebaseAuthDomain = 'atitia-app.firebaseapp.com';
  static const String firebaseStorageBucket = 'atitia-app.appspot.com';

  // Supabase Configuration
  static const String supabaseUrl = 'https://atitia.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

  // Security Configuration
  static const bool enableEncryption = true;
  static const bool enableBiometricAuth = true;
  static const bool enablePinAuth = true;
  static const int maxLoginAttempts = 5;
  static const int lockoutDurationMinutes = 15;

  // Performance Configuration
  static const int imageCacheSizeMB = 100;
  static const int maxImageCacheAgeDays = 7;
  static const int networkCacheSizeMB = 50;
  static const int maxNetworkCacheAgeHours = 24;

  // Monitoring Configuration
  // Note: These are already declared above in Feature flags section

  // Logging Configuration
  static const String logLevel = 'INFO';
  static const bool enableConsoleLogging = true;
  static const bool enableFileLogging = true;
  static const bool enableRemoteLogging = true;
  static const int maxLogFileSizeMB = 10;
  static const int maxLogFiles = 5;

  // Database Configuration
  static const int databaseVersion = 1;
  static const String databaseName = 'atitia.db';
  static const int maxDatabaseSizeMB = 100;
  static const bool enableDatabaseEncryption = true;

  // Cache Configuration
  static const int memoryCacheSizeMB = 50;
  static const int diskCacheSizeMB = 200;
  static const int maxCacheAgeHours = 24;
  static const bool enableCacheCompression = true;

  // Network Configuration
  static const int connectionTimeoutSeconds = 30;
  static const int readTimeoutSeconds = 30;
  static const int writeTimeoutSeconds = 30;
  static const bool enableNetworkLogging = true;
  static const bool enableNetworkCaching = true;

  // UI Configuration
  static const bool enableAnimations = true;
  static const bool enableHapticFeedback = true;
  static const bool enableSoundEffects = true;
  static const bool enableAccessibilityFeatures = true;
  static const bool enableDarkMode = true;

  // Testing Configuration
  static const bool enableTestMode = false;
  static const bool enableMockData = false;
  static const bool enableTestAnalytics = false;
  static const bool enableTestCrashlytics = false;

  // Environment-specific overrides
  static Map<String, dynamic> get environmentOverrides {
    if (isProduction) {
      return {
        'enableDebugLogging': false,
        'enableTestMode': false,
        'enableMockData': false,
        'apiBaseUrl': 'https://api.atitia.com',
        'logLevel': 'WARN',
      };
    } else if (isStaging) {
      return {
        'enableDebugLogging': true,
        'enableTestMode': false,
        'enableMockData': true,
        'apiBaseUrl': 'https://staging-api.atitia.com',
        'logLevel': 'INFO',
      };
    } else {
      return {
        'enableDebugLogging': true,
        'enableTestMode': true,
        'enableMockData': true,
        'apiBaseUrl': 'https://dev-api.atitia.com',
        'logLevel': 'DEBUG',
      };
    }
  }

  // Get configuration value with environment override
  static T getConfigValue<T>(String key, T defaultValue) {
    final overrides = environmentOverrides;
    if (overrides.containsKey(key)) {
      return overrides[key] as T;
    }
    return defaultValue;
  }

  // Validate configuration
  static bool validateConfig() {
    try {
      // Validate required configurations
      if (apiBaseUrl.isEmpty) {
        throw Exception('API base URL is required');
      }

      if (firebaseProjectId.isEmpty) {
        throw Exception('Firebase project ID is required');
      }

      if (supabaseUrl.isEmpty) {
        throw Exception('Supabase URL is required');
      }

      // Validate numeric configurations
      if (apiTimeoutSeconds <= 0) {
        throw Exception('API timeout must be positive');
      }

      if (maxRetryAttempts <= 0) {
        throw Exception('Max retry attempts must be positive');
      }

      if (maxLoginAttempts <= 0) {
        throw Exception('Max login attempts must be positive');
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get all configuration values
  static Map<String, dynamic> getAllConfig() {
    return {
      'environment':
          isProduction ? 'production' : (isStaging ? 'staging' : 'development'),
      'apiBaseUrl': apiBaseUrl,
      'apiVersion': apiVersion,
      'apiTimeoutSeconds': apiTimeoutSeconds,
      'maxRetryAttempts': maxRetryAttempts,
      'firebaseProjectId': firebaseProjectId,
      'firebaseAppId': firebaseAppId,
      'supabaseUrl': supabaseUrl,
      'enableAnalytics': enableAnalytics,
      'enableCrashlytics': enableCrashlytics,
      'enablePerformanceMonitoring': enablePerformanceMonitoring,
      'enableSecurityMonitoring': enableSecurityMonitoring,
      'enableErrorReporting': enableErrorReporting,
      'enableUserTracking': enableUserTracking,
      'enableDebugLogging': enableDebugLogging,
      'enableEncryption': enableEncryption,
      'enableBiometricAuth': enableBiometricAuth,
      'enablePinAuth': enablePinAuth,
      'maxLoginAttempts': maxLoginAttempts,
      'lockoutDurationMinutes': lockoutDurationMinutes,
      'imageCacheSizeMB': imageCacheSizeMB,
      'maxImageCacheAgeDays': maxImageCacheAgeDays,
      'networkCacheSizeMB': networkCacheSizeMB,
      'maxNetworkCacheAgeHours': maxNetworkCacheAgeHours,
      'logLevel': logLevel,
      'enableConsoleLogging': enableConsoleLogging,
      'enableFileLogging': enableFileLogging,
      'enableRemoteLogging': enableRemoteLogging,
      'maxLogFileSizeMB': maxLogFileSizeMB,
      'maxLogFiles': maxLogFiles,
      'databaseVersion': databaseVersion,
      'databaseName': databaseName,
      'maxDatabaseSizeMB': maxDatabaseSizeMB,
      'enableDatabaseEncryption': enableDatabaseEncryption,
      'memoryCacheSizeMB': memoryCacheSizeMB,
      'diskCacheSizeMB': diskCacheSizeMB,
      'maxCacheAgeHours': maxCacheAgeHours,
      'enableCacheCompression': enableCacheCompression,
      'connectionTimeoutSeconds': connectionTimeoutSeconds,
      'readTimeoutSeconds': readTimeoutSeconds,
      'writeTimeoutSeconds': writeTimeoutSeconds,
      'enableNetworkLogging': enableNetworkLogging,
      'enableNetworkCaching': enableNetworkCaching,
      'enableAnimations': enableAnimations,
      'enableHapticFeedback': enableHapticFeedback,
      'enableSoundEffects': enableSoundEffects,
      'enableAccessibilityFeatures': enableAccessibilityFeatures,
      'enableDarkMode': enableDarkMode,
      'enableTestMode': enableTestMode,
      'enableMockData': enableMockData,
      'enableTestAnalytics': enableTestAnalytics,
      'enableTestCrashlytics': enableTestCrashlytics,
    };
  }

  // Print configuration summary
  static void printConfigSummary() {
    if (isDevelopment) {
      // Environment configuration summary
    }
  }
}
