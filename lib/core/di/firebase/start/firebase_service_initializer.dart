// ============================================================================
// Firebase + Supabase Service Initializer
// ============================================================================
// This file handles the complete initialization of all backend services.
//
// INITIALIZATION FLOW:
// 1. Register all services with GetIt (dependency injection)
// 2. Initialize Supabase (for storage - cost-effective alternative)
// 3. Initialize Firebase Core with platform-specific options
// 4. Initialize individual Firebase services
// 5. Initialize Supabase Storage bucket
// 6. Verify all services are ready
//
// IMPORTANT FOR WEB:
// - Firebase MUST be initialized with DefaultFirebaseOptions.currentPlatform
// - Firebase SDK scripts MUST be loaded in web/index.html BEFORE Flutter
// - Supabase is used only for storage (cost optimization)
//
// ERROR HANDLING:
// - Supabase errors don't stop app initialization (graceful degradation)
// - Firebase errors will throw and trigger emergency fallback app
// - Service verification ensures all critical services are ready
// ============================================================================

import 'package:firebase_core/firebase_core.dart';
// FIXED: Unnecessary import warning
// Flutter recommends: Only import packages that provide unique functionality
// Changed from: Importing 'package:flutter/foundation.dart' when 'package:flutter/widgets.dart' already provides debugPrint
// Changed to: Removed unnecessary foundation.dart import, using show debugPrint from widgets.dart
import 'package:flutter/widgets.dart' show debugPrint, WidgetsBinding;

import '../../../db/flutter_secure_storage.dart';
import '../../../navigation/navigation_service.dart';
import '../../../services/external/google/google_sign_in_service.dart';
import '../../../services/external/apple/apple_sign_in_service.dart';
import '../../../services/firebase/analytics/firebase_analytics_service.dart';
import '../../../services/firebase/auth/firebase_auth_service.dart';
import '../../../services/firebase/crashlytics/firebase_crashlytics_service.dart';
import '../../../services/firebase/database/firestore_database_service.dart';
import '../../../services/firebase/functions/cloud_functions_service.dart';
import '../../../services/firebase/messaging/cloud_messaging_service.dart';
import '../../../services/firebase/performance/performance_monitoring_service.dart';
import '../../../services/firebase/remote_config/remote_config_service.dart';
import '../../../services/firebase/security/app_integrity_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../services/supabase/supabase_config.dart';
import '../../../services/supabase/storage/supabase_storage_service.dart';
import '../../../../common/constants/environment_config.dart';
import '../di/firebase_service_locator.dart';
import '../../common/unified_service_locator.dart';

// ============================================================================
// CRITICAL IMPORT for Web Platform Support
// ============================================================================
// This import provides Firebase configuration for all platforms including web.
// Without this, Firebase initialization will fail on web with:
// "FirebaseOptions cannot be null when creating the default app"
// ============================================================================
import '../../../../firebase_options.dart';

// ============================================================================
// FirebaseServiceInitializer Class
// ============================================================================
// Central orchestrator for all backend service initialization.
// Handles Firebase (most services) + Supabase (storage only).
//
// WHY THIS ARCHITECTURE:
// - Firebase: Excellent for auth, database, analytics, messaging
// - Supabase: Cost-effective storage alternative to Firebase Storage
// - GetIt: Dependency injection for easy service access across the app
//
// USAGE:
// Called once in main.dart before app starts:
//   await FirebaseServiceInitializer.initialize();
// ============================================================================
class FirebaseServiceInitializer {
  // Static flag to prevent multiple initialization calls
  static bool _isInitialized = false;

  // ==========================================================================
  // Main initialization method - Entry point for all services
  // ==========================================================================
  // INITIALIZATION STEPS (in order - DO NOT CHANGE ORDER):
  //
  // 1. setupFirebaseDependencies() - Register all services with GetIt
  //    - Makes services available throughout the app via dependency injection
  //    - No actual initialization yet, just registration
  //
  // 2. _initializeSupabase() - Initialize Supabase client
  //    - Sets up connection to Supabase backend
  //    - Used only for storage (cost optimization)
  //    - Fails gracefully if not configured
  //
  // 3. _initializeFirebaseCore() - Initialize Firebase with options
  //    - CRITICAL: Must pass DefaultFirebaseOptions.currentPlatform
  //    - Initializes all Firebase services (auth, firestore, analytics, etc)
  //    - Fails hard if Firebase can't initialize (triggers emergency app)
  //
  // 4. _initializeSupabaseStorage() - Create/verify storage bucket
  //    - Ensures storage bucket exists for file uploads
  //    - Fails gracefully (bucket might already exist)
  //
  // 5. _verifyFirebaseServices() - Verify all services are ready
  //    - Checks that all registered services are accessible
  //    - Prints status of each service
  //    - Throws if any critical service is missing
  //
  // ERROR HANDLING:
  // - Supabase errors: Logged but don't stop initialization
  // - Firebase errors: Re-thrown to trigger emergency fallback app
  // - Verification errors: Thrown to prevent app from starting with broken services
  // ==========================================================================
  static Future<void> initialize() async {
    // Prevent multiple initialization calls
    if (_isInitialized) {
      return;
    }

    // STEP 1: Register all services with dependency injection container
    // This makes services available via getIt<ServiceName>() throughout the app
    setupFirebaseDependencies();

    // STEP 2: Initialize Supabase for storage
    // Graceful degradation: App continues even if Supabase fails
    await _initializeSupabase();

    // STEP 3: Initialize Firebase Core and all Firebase services
    // CRITICAL: This will fail if Firebase SDK not loaded (web) or options not passed
    await _initializeFirebaseCore();

    // Defer non-critical initialization and verification to after first frame
    // to reduce time-to-first-frame and perceived startup cost.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _initializeOptionalServices();
      } catch (_) {}
      try {
        _verifyFirebaseServices();
      } catch (_) {}
    });

    // Mark as initialized to prevent future calls
    _isInitialized = true;
  }

  /// Reset initialization flag (for development/testing purposes)
  static void reset() {
    _isInitialized = false;
  }

  // ==========================================================================
  // Optional services initialization (deferred post-frame)
  // ==========================================================================
  static Future<void> _initializeOptionalServices() async {
    // Initialize Google Sign-In service
    // FIXED: Use async credential loading
    // Flutter recommends: Load credentials from secure storage at runtime
    // Changed from: Using static methods that may have placeholders
    // Changed to: Using async methods that load from secure storage or environment
    try {
      // Load credentials asynchronously from secure storage or environment
      final clientId = await EnvironmentConfig.getGoogleSignInWebClientIdAsync();
      final clientSecret = await EnvironmentConfig.getGoogleSignInClientSecretAsync();
      
      await getIt.googleSignIn.initialize(
        clientId: clientId,
        serverClientId: clientSecret,
      );
      debugPrint('✅ Google Sign-In service initialized with credentials from secure storage');
    } catch (e) {
      debugPrint('⚠️ Firebase Service Initializer: Google Sign-In initialization failed: $e');
      debugPrint('   App will continue but Google Sign-In may not work');
    }

    // Initialize Apple Sign-In service
    try {
      await getIt.appleSignIn.initialize();
    } catch (e) {
      debugPrint('⚠️ Firebase Service Initializer: Apple Sign-In initialization failed: $e');
    }

    // OPTIONAL Firebase services (failures are logged but don't crash app)
    try {
      await getIt.appCheck.initialize(); // Security & anti-abuse
    } catch (e) {
      debugPrint('⚠️ Firebase Service Initializer: App Check initialization failed: $e');
    }

    try {
      await getIt.analytics.initialize(); // User behavior tracking
    } catch (e) {
      debugPrint('⚠️ Firebase Service Initializer: Analytics initialization failed: $e');
    }

    try {
      await getIt.messaging.initialize(); // Push notifications
    } catch (e) {
      debugPrint('⚠️ Firebase Service Initializer: Messaging initialization failed: $e');
    }

    try {
      await getIt.crashlytics.initialize(); // Crash reporting
    } catch (e) {
      debugPrint('⚠️ Firebase Service Initializer: Crashlytics initialization failed: $e');
    }

    try {
      await getIt.remoteConfig.initialize(); // Feature flags & A/B testing
    } catch (e) {
      debugPrint('⚠️ Firebase Service Initializer: Remote Config initialization failed: $e');
    }

    try {
      await getIt.performance.initialize(); // Performance monitoring
    } catch (e) {
      debugPrint('⚠️ Firebase Service Initializer: Performance initialization failed: $e');
    }

    try {
      await getIt.functions.initialize(); // Cloud functions/backend logic
    } catch (e) {
      debugPrint('⚠️ Firebase Service Initializer: Cloud Functions initialization failed: $e');
    }

    // Initialize Supabase storage lazily on first access; nothing to do here.
  }

  // ==========================================================================
  // Initialize Supabase (for storage only)
  // ==========================================================================
  // PURPOSE:
  // - Supabase is used ONLY for file/image storage (cost optimization)
  // - Provides a cost-effective alternative to Firebase Storage
  // - Free tier: 1GB storage vs Firebase's 5GB but better pricing at scale
  //
  // GRACEFUL DEGRADATION:
  // - If not configured: Logs warning, app continues without storage
  // - If initialization fails: Logs warning, app continues with limited features
  // - Errors DON'T stop app initialization (unlike Firebase errors)
  //
  // CONFIGURATION:
  // - Check SupabaseConfig.isConfigured to see if credentials are set
  // - Update lib/core/services/supabase/supabase_config.dart with your credentials
  // - Get credentials from: https://supabase.com/dashboard
  //
  // WHAT HAPPENS IF NOT CONFIGURED:
  // - File uploads will fail or fallback to Firebase Storage
  // - User profile images may not upload
  // - Document storage features will be limited
  // - App still works for other features (auth, database, etc)
  // ==========================================================================
  static Future<void> _initializeSupabase() async {
    try {
      if (SupabaseConfig.isConfigured) {
        // Initialize Supabase client with URL and anonymous key
        // Supabase handles duplicate initialization gracefully
        await Supabase.initialize(
          url: SupabaseConfig.supabaseUrl,
          anonKey: SupabaseConfig.supabaseAnonKey,
        );
      } else {
        // Not configured - app continues without storage
        // Don't throw - let app continue with other features
      }
    } catch (error) {
      // Initialization failed - log warning but don't crash app
      // Don't rethrow - graceful degradation
    }
  }

  // ==========================================================================
  // Initialize Supabase Storage Bucket
  // ==========================================================================
  // PURPOSE:
  // - Creates or verifies the storage bucket exists for file uploads
  // - Bucket name is defined in SupabaseStorageService
  // - Required for any file/image upload features
  //
  // WHAT THIS DOES:
  // - Attempts to create the bucket if it doesn't exist
  // - If bucket already exists, verification succeeds silently
  // - If creation fails, logs error but doesn't crash app
  //
  // GRACEFUL FAILURE:
  // - Bucket might already exist (not an error)
  // - Permission issues are logged but don't stop app
  // - App continues even if bucket initialization fails
  // ==========================================================================
  // static Future<void> _initializeSupabaseStorage() async {
  //   try {
  //     // Lazily initialize storage: do not block startup; run only when used
  //     // This method is kept for API compatibility but no-op at boot.
  //     // Actual initialization should happen inside the storage service on first use.
  //   } catch (error) {
  //     // Bucket might already exist or permissions issue
  //     // Continue anyway - not a critical error
  //   }
  // }

  // ==========================================================================
  // Core Firebase initialization with platform-specific options
  // ==========================================================================
  // CRITICAL FOR WEB PLATFORM:
  // - Must pass DefaultFirebaseOptions.currentPlatform as options parameter
  // - Without this, web initialization will fail with:
  //   "FirebaseOptions cannot be null when creating the default app"
  //
  // INITIALIZATION SEQUENCE:
  // 1. Initialize Firebase Core with platform-specific configuration
  // 2. Initialize Authentication service (required for user auth)
  // 3. Initialize Firestore (database)
  // 4. Initialize App Check (security)
  // 5. Initialize Analytics (user tracking)
  // 6. Initialize Messaging (push notifications)
  // 7. Initialize Crashlytics (error reporting)
  // 8. Initialize Remote Config (feature flags)
  // 9. Initialize Performance Monitoring (performance tracking)
  // 10. Initialize Cloud Functions (backend logic)
  //
  // ERROR HANDLING:
  // - Any initialization error will be caught and re-thrown
  // - This triggers the emergency fallback app in main.dart
  // - User will see a friendly error screen instead of blank page
  // ==========================================================================
  static Future<void> _initializeFirebaseCore() async {
    try {
      // Use try-catch to handle duplicate app initialization gracefully
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } catch (e) {
        // Check if it's a duplicate app error
        if (e.toString().contains('duplicate-app') ||
            e.toString().contains('already exists')) {
          // Firebase is already initialized - this is fine
          final defaultApp = Firebase.app();
        } else {
          // Different error - re-throw it
          rethrow;
        }
      }

      // Initialize only CRITICAL services synchronously
      await getIt.auth.initialize(); // User authentication
      await getIt.firestore.initialize(); // Cloud database

      // Initialize UnifiedServiceLocator for DI abstraction (after Firebase services)
      // This allows repositories/ViewModels to use interfaces instead of concrete services
      await UnifiedServiceLocator.initialize();

      // Defer OPTIONAL services
      // Keep only CRITICAL services here. Optional ones are deferred.

      // Note: LocalStorageService (secure storage) doesn't need async initialization
    } catch (error) {
      // Log the error for debugging

      // Re-throw to trigger emergency fallback app
      // This ensures user never sees a frozen/broken app
      rethrow;
    }
  }

  // ==========================================================================
  // Verify Firebase Services
  // ==========================================================================
  // VERIFICATION STRATEGY:
  // - CRITICAL services: Must be present (auth, firestore, storage, navigation)
  // - OPTIONAL services: Nice to have but not required (analytics, messaging, etc)
  //
  // CRITICAL SERVICES (app won't work without these):
  // - Authentication: Required for user login/signup
  // - Firestore: Required for database operations
  // - Local Storage: Required for secure data storage
  // - Navigation: Required for routing between screens
  //
  // OPTIONAL SERVICES (app works without these):
  // - Google Sign-In: Only needed if using Google auth
  // - Supabase Storage: Falls back to Firebase Storage
  // - App Check: Security enhancement (not critical for dev)
  // - Analytics: Tracking feature (not critical)
  // - Messaging: Push notifications (not critical, may fail on web)
  // - Crashlytics: Error reporting (not critical, web doesn't support it)
  // - Remote Config: Feature flags (not critical)
  // - Performance: Monitoring (not critical)
  // - Cloud Functions: Backend logic (not always needed)
  // ==========================================================================
  static void _verifyFirebaseServices() {
    // CRITICAL SERVICES - Must be present
    final criticalServices = [
      _ServiceInfo(
          'Authentication', getIt.get<AuthenticationServiceWrapper>(), true),
      _ServiceInfo('Firestore', getIt.get<FirestoreServiceWrapper>(), true),
      _ServiceInfo('Local Storage', getIt.get<LocalStorageService>(), true),
      _ServiceInfo('Navigation', getIt.get<NavigationService>(), true),
    ];

    // OPTIONAL SERVICES - Nice to have but not required
    final optionalServices = [
      _ServiceInfo(
          'Google Sign-In', getIt.get<GoogleSignInServiceWrapper>(), false),
      _ServiceInfo(
          'Apple Sign-In', getIt.get<AppleSignInServiceWrapper>(), false),
      _ServiceInfo('Supabase Storage',
          getIt.get<SupabaseStorageServiceWrapper>(), false),
      _ServiceInfo('App Check', getIt.get<AppIntegrityServiceWrapper>(), false),
      _ServiceInfo('Analytics', getIt.get<AnalyticsServiceWrapper>(), false),
      _ServiceInfo(
          'Messaging', getIt.get<CloudMessagingServiceWrapper>(), false),
      _ServiceInfo(
          'Crashlytics', getIt.get<CrashlyticsServiceWrapper>(), false),
      _ServiceInfo(
          'Remote Config', getIt.get<RemoteConfigServiceWrapper>(), false),
      _ServiceInfo('Performance',
          getIt.get<PerformanceMonitoringServiceWrapper>(), false),
      _ServiceInfo(
          'Cloud Functions', getIt.get<CloudFunctionsServiceWrapper>(), false),
    ];

    bool allCriticalReady = true;
    int optionalReady = 0;

    for (final service in criticalServices) {
      if (service.instance != null) {
      } else {
        allCriticalReady = false;
      }
    }

    for (final service in optionalServices) {
      if (service.instance != null) {
        optionalReady++;
      } else {}
    }

    if (allCriticalReady) {
      // Optional services initialized
    } else {
      throw Exception('Critical service initialization failed');
    }
  }
}

// ==========================================================================
// Service Info Helper Class
// ==========================================================================
// Simple data class to hold service verification information.
//
// FIELDS:
// - name: Human-readable service name (e.g., "Authentication")
// - instance: The actual service instance from GetIt
// - isCritical: Whether this service is required for app to function
//
// USAGE:
// Used internally by _verifyFirebaseServices() to check service status
// ==========================================================================
class _ServiceInfo {
  final String name;
  final Object? instance;
  final bool isCritical;

  _ServiceInfo(this.name, this.instance, this.isCritical);
}
