import '../../../navigation/navigation_service.dart';
import '../../../services/api/api_service.dart';
import '../di/rest_api_service_locator.dart';

/// Complete REST API-specific service initialization.
/// Only contains REST API logic - no Firebase code.
class RestApiServiceInitializer {
  /// Initializes complete REST API service stack.
  static Future<void> initialize() async {
    // Step 1: Register ONLY REST API services
    setupRestApiDependencies();

    // Step 2: Verify REST API services
    _verifyRestApiServices();
  }

  /// Verifies ALL REST API services are properly initialized.
  static void _verifyRestApiServices() {
    final services = [
      _ServiceInfo('API Service', getIt.get<ApiService>()),
      // _ServiceInfo('Auth API', getIt.get<AuthApiService>()),
      // _ServiceInfo('User API', getIt.get<UserApiService>()),
      // _ServiceInfo('Payment API', getIt.get<PaymentApiService>()),
      // _ServiceInfo('Complaint API', getIt.get<ComplaintApiService>()),
      // _ServiceInfo('Food API', getIt.get<FoodApiService>()),
      // _ServiceInfo('PG API', getIt.get<PgApiService>()),
      // _ServiceInfo('Storage', getIt.get<StorageService>()),
      _ServiceInfo('Navigation', getIt.get<NavigationService>()),
    ];

    bool allReady = true;

    for (final service in services) {
      if (service.instance != null) {
      } else {
        allReady = false;
      }
    }

    if (allReady) {
    } else {
      throw Exception('REST API service initialization failed');
    }
  }
}

class _ServiceInfo {
  final String name;
  final Object? instance;

  _ServiceInfo(this.name, this.instance);
}
