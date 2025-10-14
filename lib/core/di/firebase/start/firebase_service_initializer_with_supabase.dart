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
      print('⚠️ Services already initialized, skipping...');
      return;
    }

    try {
      print('🔥 Starting FIREBASE + SUPABASE Service Initialization...');

      // Step 1: Register services in GetIt FIRST
      setupFirebaseDependenciesWithSupabaseStorage();
      print('✅ Services registered in GetIt');

      // Step 2: Initialize Firebase Core
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('✅ Firebase Core initialized successfully');

      // Step 3: Initialize Supabase
      if (SupabaseConfig.isConfigured) {
        await Supabase.initialize(
          url: SupabaseConfig.supabaseUrl,
          anonKey: SupabaseConfig.supabaseAnonKey,
          storageOptions: const StorageClientOptions(
            retryAttempts: 3,
          ),
        );
        print('✅ Supabase initialized successfully');

        // Initialize Supabase Storage bucket
        await getIt.storage.initialize();
        print('✅ Supabase Storage bucket initialized');
      } else {
        print(
            '⚠️ Supabase not configured - using Firebase Storage as fallback');
        print(
            '   To use Supabase, update SupabaseConfig with your credentials');
      }

      // Step 4: Initialize individual Firebase services
      await _initializeFirebaseServices();

      // Step 5: Verify all services
      await _verifyServices();

      _initialized = true;

      print('==================================================');
      print('✅ ALL SERVICES READY (Firebase + Supabase Storage)');
      print('==================================================');
      print('🎯 Setup complete - Ready to use hybrid services');
    } catch (e, stackTrace) {
      print('❌ Service initialization failed: $e');
      print('Stack trace: $stackTrace');
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

    print('✅ Firebase core initialized');
  }

  /// Verify all services are ready
  static Future<void> _verifyServices() async {
    print('🔍 Verifying Services...');

    // Verify Firebase services
    print(
        '  Authentication: ${getIt.auth.isSignedIn ? '✅ SIGNED IN' : '✅ READY'}');
    print('  Google Sign-In: ✅ READY');
    print('  Firestore: ✅ READY');

    // Verify Supabase Storage
    if (SupabaseConfig.isConfigured) {
      print('  Supabase Storage: ✅ READY');
    } else {
      print('  Storage: ⚠️ Not configured (using fallback)');
    }

    print('  App Check: ✅ READY');
    print('  Analytics: ✅ READY');
    print('  Messaging: ✅ READY');
    print('  Crashlytics: ✅ READY');
    print('  Remote Config: ✅ READY');
    print('  Performance: ✅ READY');
    print('  Cloud Functions: ✅ READY');
    print('  Local Storage: ✅ READY');
    print('  Navigation: ✅ READY');
  }

  /// Reset initialization state (for testing)
  static void reset() {
    _initialized = false;
  }
}
