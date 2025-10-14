import 'package:get_it/get_it.dart';

import '../../../../feature/owner_dashboard/mypg/data/repositories/owner_pg_management_repository.dart';
import '../../../db/flutter_secure_storage.dart';
import '../../../navigation/app_router.dart';
import '../../../navigation/navigation_service.dart';
// Firebase Services
import '../../../services/external/apple/apple_sign_in_service.dart';
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
// Supabase Storage (replaces Firebase Storage for cost savings)
import '../../../services/supabase/storage/supabase_storage_service.dart';
// Owner PG Management Repository

final GetIt getIt = GetIt.instance;

void setupFirebaseDependencies() {
  // ✅ ALL Firebase Services - Complete list from your existing code
  getIt.registerLazySingleton<AuthenticationServiceWrapper>(
    () => AuthenticationServiceWrapper(),
  );
  getIt.registerLazySingleton<FirestoreServiceWrapper>(
    () => FirestoreServiceWrapper(),
  );
  // Supabase Storage (replaces Firebase Storage for cost savings)
  getIt.registerLazySingleton<SupabaseStorageServiceWrapper>(
    () => SupabaseStorageServiceWrapper(),
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

  // Google Sign-In Service
  getIt.registerLazySingleton<GoogleSignInServiceWrapper>(
    () => GoogleSignInServiceWrapper(
      authService: getIt<AuthenticationServiceWrapper>(),
    ),
  );

  // Apple Sign-In Service
  getIt.registerLazySingleton<AppleSignInServiceWrapper>(
    () => AppleSignInServiceWrapper(
      authService: getIt<AuthenticationServiceWrapper>(),
    ),
  );

  // Core Services (Same for both)
  getIt.registerLazySingleton<NavigationService>(
    () => NavigationService(AppRouter.router),
  );

  // Owner PG Management Repository (for multi-PG support)
  getIt.registerLazySingleton<OwnerPgManagementRepository>(
    () => OwnerPgManagementRepository(),
  );

  // ❌ NO REST API services registered here
}

// Convenience getters for Firebase services only
extension FirebaseServiceLocator on GetIt {
  AuthenticationServiceWrapper get auth => get<AuthenticationServiceWrapper>();

  FirestoreServiceWrapper get firestore => get<FirestoreServiceWrapper>();

  // Supabase Storage (replaces Firebase Storage)
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

  AppleSignInServiceWrapper get appleSignIn => get<AppleSignInServiceWrapper>();

  LocalStorageService get localStorage => get<LocalStorageService>();

  NavigationService get navigation => get<NavigationService>();

  OwnerPgManagementRepository get ownerPgRepository =>
      get<OwnerPgManagementRepository>();
}
