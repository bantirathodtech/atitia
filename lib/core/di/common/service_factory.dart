// lib/core/di/common/service_factory.dart

import 'package:get_it/get_it.dart';

import '../../interfaces/analytics/analytics_service_interface.dart';
import '../../interfaces/auth/auth_service_interface.dart';
import '../../interfaces/database/database_service_interface.dart';
import '../../interfaces/storage/storage_service_interface.dart';
import 'di_config.dart';

/// Factory for creating service implementations based on backend provider
/// This factory pattern allows swapping implementations without changing code
class ServiceFactory {
  final GetIt _getIt;

  ServiceFactory(this._getIt);

  /// Gets database service implementation based on current provider
  IDatabaseService get database {
    switch (DIConfig.currentProvider) {
      case BackendProvider.firebase:
        return _getIt<IDatabaseService>(instanceName: 'firebase_database');
      case BackendProvider.supabase:
        return _getIt<IDatabaseService>(instanceName: 'supabase_database');
      case BackendProvider.restApi:
        return _getIt<IDatabaseService>(instanceName: 'rest_database');
    }
  }

  /// Gets storage service implementation based on current provider
  IStorageService get storage {
    switch (DIConfig.currentProvider) {
      case BackendProvider.firebase:
        // Firebase uses Supabase Storage (cost optimization)
        return _getIt<IStorageService>(instanceName: 'supabase_storage');
      case BackendProvider.supabase:
        return _getIt<IStorageService>(instanceName: 'supabase_storage');
      case BackendProvider.restApi:
        return _getIt<IStorageService>(instanceName: 'rest_storage');
    }
  }

  /// Gets auth service implementation based on current provider
  IAuthService get auth {
    switch (DIConfig.currentProvider) {
      case BackendProvider.firebase:
        return _getIt<IAuthService>(instanceName: 'firebase_auth');
      case BackendProvider.supabase:
        return _getIt<IAuthService>(instanceName: 'supabase_auth');
      case BackendProvider.restApi:
        return _getIt<IAuthService>(instanceName: 'rest_auth');
    }
  }

  /// Gets analytics service implementation based on current provider
  IAnalyticsService get analytics {
    switch (DIConfig.currentProvider) {
      case BackendProvider.firebase:
        return _getIt<IAnalyticsService>(instanceName: 'firebase_analytics');
      case BackendProvider.supabase:
        return _getIt<IAnalyticsService>(instanceName: 'supabase_analytics');
      case BackendProvider.restApi:
        return _getIt<IAnalyticsService>(instanceName: 'rest_analytics');
    }
  }

  /// Lists all registered implementations for a service type
  List<String> getRegisteredImplementations<T>() {
    final instances = <String>[];
    // This would iterate through GetIt registrations
    // Implementation depends on GetIt capabilities
    return instances;
  }
}
