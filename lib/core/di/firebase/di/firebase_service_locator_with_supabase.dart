import 'package:get_it/get_it.dart';

import '../../../db/flutter_secure_storage.dart';
import '../../../navigation/app_router.dart';
import '../../../navigation/navigation_service.dart';
// Firebase Services (keep all except storage)
import '../../../services/external/google/google_sign_in_service.dart';
import '../../../services/firebase/analytics/firebase_analytics_service.dart';
import '../../../services/firebase/auth/firebase_auth_service.dart';
import '../../../services/firebase/crashlytics/firebase_crashlytics_service.dart';
import '../../../services/firebase/database/firestore_database_service.dart';
import '../../../services/firebase/functions/cloud_functions_service.dart';
import '../../../services/firebase/messaging/cloud_messaging_service.dart';
import '../../../services/firebase/performance/performance_monitoring_service.dart';
import '../../../services/firebase/remote_config/remote_config_service.dart';
import '../../../services/firebase/security/app_integrity_service.dart';
// Supabase Storage (replaces Firebase Storage)
import '../../../services/supabase/storage/supabase_storage_service.dart';

final GetIt getIt = GetIt.instance;

/// Firebase Service Locator with Supabase Storage
///
/// This version uses:
/// - ✅ Firebase for: Auth, Firestore, Analytics, Crashlytics, Messaging, etc.
/// - ✅ Supabase for: Storage only (cheaper alternative)
///
/// To use this setup:
/// 1. Add supabase_flutter to pubspec.yaml
/// 2. Configure Supabase credentials in supabase_config.dart
/// 3. Replace firebase_service_locator.dart import with this file
void setupFirebaseDependenciesWithSupabaseStorage() {
  // ==================== FIREBASE SERVICES (Keep all) ====================

  getIt.registerLazySingleton<AuthenticationServiceWrapper>(
    () => AuthenticationServiceWrapper(),
  );

  getIt.registerLazySingleton<FirestoreServiceWrapper>(
    () => FirestoreServiceWrapper(),
  );

  getIt.registerLazySingleton<AppIntegrityServiceWrapper>(
    () => AppIntegrityServiceWrapper(),
  );

  getIt.registerLazySingleton<AnalyticsServiceWrapper>(
    () => AnalyticsServiceWrapper(),
  );

  getIt.registerLazySingleton<CloudMessagingServiceWrapper>(
    () => CloudMessagingServiceWrapper(),
  );

  getIt.registerLazySingleton<CrashlyticsServiceWrapper>(
    () => CrashlyticsServiceWrapper(),
  );

  getIt.registerLazySingleton<RemoteConfigServiceWrapper>(
    () => RemoteConfigServiceWrapper(),
  );

  getIt.registerLazySingleton<PerformanceMonitoringServiceWrapper>(
    () => PerformanceMonitoringServiceWrapper(),
  );

  getIt.registerLazySingleton<CloudFunctionsServiceWrapper>(
    () => CloudFunctionsServiceWrapper(),
  );

  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(),
  );

  getIt.registerLazySingleton<GoogleSignInServiceWrapper>(
    () => GoogleSignInServiceWrapper(
      authService: getIt<AuthenticationServiceWrapper>(),
    ),
  );

  // ==================== SUPABASE STORAGE (Replaces Firebase Storage) ====================

  /// 🎯 KEY CHANGE: Using Supabase Storage instead of Firebase Storage
  /// This is the ONLY line that changes!
  getIt.registerLazySingleton<SupabaseStorageServiceWrapper>(
    () => SupabaseStorageServiceWrapper(),
  );

  // Core Services
  getIt.registerLazySingleton<NavigationService>(
    () => NavigationService(AppRouter.router),
  );
}

// Extension with Supabase Storage
extension FirebaseServiceLocatorWithSupabaseStorage on GetIt {
  AuthenticationServiceWrapper get auth => get<AuthenticationServiceWrapper>();
  FirestoreServiceWrapper get firestore => get<FirestoreServiceWrapper>();

  /// 🎯 Storage now points to Supabase instead of Firebase
  SupabaseStorageServiceWrapper get storage =>
      get<SupabaseStorageServiceWrapper>();

  AppIntegrityServiceWrapper get appCheck => get<AppIntegrityServiceWrapper>();
  AnalyticsServiceWrapper get analytics => get<AnalyticsServiceWrapper>();
  CloudMessagingServiceWrapper get messaging =>
      get<CloudMessagingServiceWrapper>();
  CrashlyticsServiceWrapper get crashlytics => get<CrashlyticsServiceWrapper>();
  RemoteConfigServiceWrapper get remoteConfig =>
      get<RemoteConfigServiceWrapper>();
  PerformanceMonitoringServiceWrapper get performance =>
      get<PerformanceMonitoringServiceWrapper>();
  CloudFunctionsServiceWrapper get functions =>
      get<CloudFunctionsServiceWrapper>();
  GoogleSignInServiceWrapper get googleSignIn =>
      get<GoogleSignInServiceWrapper>();
  LocalStorageService get localStorage => get<LocalStorageService>();
  NavigationService get navigation => get<NavigationService>();
}
