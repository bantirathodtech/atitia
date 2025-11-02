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
// Logging Service
import '../../../services/logging/app_logger.dart';
// Performance Monitoring Service
import '../../../services/performance/performance_monitoring_service.dart';
// Offline and Optimization Services
import '../../../services/offline/offline_cache_service.dart';
import '../../../services/connectivity/connectivity_service.dart';
import '../../../services/optimization/image_optimization_service.dart';
// Phase 3 Services
import '../../../services/ui/animation_service.dart';
import '../../../services/accessibility/accessibility_service.dart';
import '../../../services/localization/internationalization_service.dart';
import '../../../services/security/security_hardening_service.dart';
import '../../../services/deployment/deployment_optimization_service.dart';
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

  // Logging Service
  getIt.registerLazySingleton<AppLogger>(
    () => AppLogger.instance,
  );

  // Performance Monitoring Service (NEW)
  getIt.registerLazySingleton<PerformanceMonitoringService>(
    () => PerformanceMonitoringService.instance,
  );

  // Offline Cache Service (NEW)
  getIt.registerLazySingleton<OfflineCacheService>(
    () => OfflineCacheService.instance,
  );

  // Connectivity Service (NEW)
  getIt.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService.instance,
  );

  // Image Optimization Service (NEW)
  getIt.registerLazySingleton<ImageOptimizationService>(
    () => ImageOptimizationService.instance,
  );

  // Phase 3 Services (NEW)
  getIt.registerLazySingleton<AnimationService>(
    () => AnimationService.instance,
  );

  getIt.registerLazySingleton<AccessibilityService>(
    () => AccessibilityService.instance,
  );

  getIt.registerLazySingleton<InternationalizationService>(
    () => InternationalizationService.instance,
  );

  getIt.registerLazySingleton<SecurityHardeningService>(
    () => SecurityHardeningService.instance,
  );

  getIt.registerLazySingleton<DeploymentOptimizationService>(
    () => DeploymentOptimizationService.instance,
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

  AppLogger get logger => get<AppLogger>();
  PerformanceMonitoringService get performanceMonitoring =>
      get<PerformanceMonitoringService>();
  OfflineCacheService get offlineCache => get<OfflineCacheService>();
  ConnectivityService get connectivity => get<ConnectivityService>();
  ImageOptimizationService get imageOptimization =>
      get<ImageOptimizationService>();
  AnimationService get animation => get<AnimationService>();
  AccessibilityService get accessibility => get<AccessibilityService>();
  InternationalizationService get i18n => get<InternationalizationService>();
  SecurityHardeningService get security => get<SecurityHardeningService>();
  DeploymentOptimizationService get deployment =>
      get<DeploymentOptimizationService>();
}
