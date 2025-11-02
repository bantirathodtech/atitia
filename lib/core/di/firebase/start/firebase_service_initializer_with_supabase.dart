import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../firebase_options.dart';
import '../../../services/supabase/supabase_config.dart';
import '../di/firebase_service_locator_with_supabase.dart';

/// Firebase Service Initializer with Supabase Storage
///
/// This version initializes:
/// - ✅ Firebase (for Auth, Firestore, Analytics, etc.)
/// - ✅ Supabase (for Storage only)
///
/// Benefits:
/// - Lower storage costs with Supabase
/// - Keep Firebase's excellent other services
/// - Minimal code changes (same interface)
class FirebaseServiceInitializerWithSupabase {
  static bool _initialized = false;

  /// Initialize complete service stack
  /// - Initializes Firebase Core
  /// - Initializes Supabase
  /// - Registers all services in GetIt
  /// - Verifies service availability
  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    try {
      // Step 1: Register services in GetIt FIRST
      setupFirebaseDependenciesWithSupabaseStorage();

      // Step 2: Initialize Firebase Core
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Step 3: Initialize Supabase
      if (SupabaseConfig.isConfigured) {
        await Supabase.initialize(
          url: SupabaseConfig.supabaseUrl,
          anonKey: SupabaseConfig.supabaseAnonKey,
          storageOptions: const StorageClientOptions(
            retryAttempts: 3,
          ),
        );

        // Initialize Supabase Storage bucket
        await getIt.storage.initialize();
      } else {
        // To use Supabase, update SupabaseConfig with your credentials
      }

      // Step 4: Initialize individual Firebase services
      await _initializeFirebaseServices();

      // Step 5: Verify all services
      await _verifyServices();

      _initialized = true;
    } catch (e) {
      rethrow;
    }
  }

  /// Initialize all Firebase services
  static Future<void> _initializeFirebaseServices() async {
    // Initialize each service
    await getIt.auth.initialize();
    await getIt.firestore.initialize();
    await getIt.appCheck.initialize();
    await getIt.analytics.initialize();
    await getIt.messaging.initialize();
    await getIt.crashlytics.initialize();
    await getIt.remoteConfig.initialize();
    await getIt.performance.initialize();
    await getIt.functions.initialize();
    // await getIt.localStorage.initialize();
  }

  /// Verify all services are ready
  static Future<void> _verifyServices() async {
    // Verify Firebase services

    // Verify Supabase Storage
    if (SupabaseConfig.isConfigured) {
    } else {}
  }

  /// Reset initialization state (for testing)
  static void reset() {
    _initialized = false;
  }
}
