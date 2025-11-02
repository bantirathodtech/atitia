// lib/core/di/common/unified_service_locator.dart

import 'package:get_it/get_it.dart';

import '../../adapters/firebase/firebase_analytics_adapter.dart';
import '../../adapters/firebase/firebase_auth_adapter.dart';
import '../../adapters/firebase/firebase_database_adapter.dart';
import '../../adapters/supabase/supabase_storage_adapter.dart';
import '../../interfaces/analytics/analytics_service_interface.dart';
import '../../interfaces/auth/auth_service_interface.dart';
import '../../interfaces/database/database_service_interface.dart';
import '../../interfaces/storage/storage_service_interface.dart';
import '../../services/firebase/analytics/firebase_analytics_service.dart';
import '../../services/firebase/auth/firebase_auth_service.dart';
import '../../services/firebase/database/firestore_database_service.dart';
import '../../services/supabase/storage/supabase_storage_service.dart';
import 'di_config.dart';
import '../firebase/di/firebase_service_locator.dart' as firebase_di;
import 'service_factory.dart';

/// Unified service locator that registers implementations based on backend provider
/// This allows swapping between Firebase, Supabase, and REST API without code changes
class UnifiedServiceLocator {
  static final GetIt _getIt = GetIt.instance;
  static ServiceFactory? _serviceFactory;

  /// Initializes DI container based on current backend provider
  static Future<void> initialize() async {
    // Clear any existing registrations
    await _getIt.reset();

    switch (DIConfig.currentProvider) {
      case BackendProvider.firebase:
        await _initializeFirebase();
        break;
      case BackendProvider.supabase:
        await _initializeSupabase();
        break;
      case BackendProvider.restApi:
        await _initializeRestApi();
        break;
    }

    // Create service factory
    _serviceFactory = ServiceFactory(_getIt);
  }

  /// Initializes Firebase implementations
  static Future<void> _initializeFirebase() async {
    // Initialize Firebase service locator
    firebase_di.setupFirebaseDependencies();

    // Get concrete Firebase services using explicit GetIt access
    final firestoreService = firebase_di.getIt<FirestoreServiceWrapper>();
    final authService = firebase_di.getIt<AuthenticationServiceWrapper>();
    final analyticsService = firebase_di.getIt<AnalyticsServiceWrapper>();
    final storageService = firebase_di.getIt<SupabaseStorageServiceWrapper>();

    // Create adapters that wrap Firebase services
    final databaseAdapter = FirebaseDatabaseAdapter(firestoreService);
    final authAdapter = FirebaseAuthAdapter(authService);
    final analyticsAdapter = FirebaseAnalyticsAdapter(analyticsService);
    final storageAdapter = SupabaseStorageAdapter(storageService);

    // Register interface implementations with instance names
    _getIt.registerLazySingleton<IDatabaseService>(
      () => databaseAdapter,
      instanceName: 'firebase_database',
    );

    _getIt.registerLazySingleton<IAuthService>(
      () => authAdapter,
      instanceName: 'firebase_auth',
    );

    _getIt.registerLazySingleton<IAnalyticsService>(
      () => analyticsAdapter,
      instanceName: 'firebase_analytics',
    );

    // Register storage (uses Supabase Storage for cost savings)
    _getIt.registerLazySingleton<IStorageService>(
      () => storageAdapter,
      instanceName: 'supabase_storage',
    );
  }

  /// Initializes Supabase implementations
  static Future<void> _initializeSupabase() async {
    // TODO: Initialize Supabase service locator when implemented
    // For now, register placeholder implementations
    throw UnimplementedError(
      'Supabase implementation not yet available. Use Firebase or REST API.',
    );
  }

  /// Initializes REST API implementations
  static Future<void> _initializeRestApi() async {
    // TODO: Initialize REST API service locator when implemented
    // For now, register placeholder implementations
    throw UnimplementedError(
      'REST API implementation not yet available. Use Firebase.',
    );
  }

  /// Gets service factory for accessing services
  static ServiceFactory get serviceFactory {
    if (_serviceFactory == null) {
      throw StateError(
        'UnifiedServiceLocator not initialized. Call initialize() first.',
      );
    }
    return _serviceFactory!;
  }

  /// Convenience getter for GetIt instance
  static GetIt get getIt => _getIt;
}

/// Extension on GetIt to provide convenient access to services via interface
/// Note: These use different names to avoid conflicts with FirebaseServiceLocator extension
extension UnifiedServiceLocatorExtension on GetIt {
  /// Gets database service based on current provider
  IDatabaseService get databaseInterface =>
      UnifiedServiceLocator.serviceFactory.database;

  /// Gets storage service based on current provider
  IStorageService get storageInterface =>
      UnifiedServiceLocator.serviceFactory.storage;

  /// Gets auth service based on current provider
  IAuthService get authInterface => UnifiedServiceLocator.serviceFactory.auth;

  /// Gets analytics service based on current provider
  IAnalyticsService get analyticsInterface =>
      UnifiedServiceLocator.serviceFactory.analytics;
}
