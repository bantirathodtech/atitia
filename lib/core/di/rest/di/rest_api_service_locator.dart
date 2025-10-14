import 'package:get_it/get_it.dart';

// Local Storage (Same for both)
import '../../../db/flutter_secure_storage.dart';
import '../../../navigation/app_router.dart';
import '../../../navigation/navigation_service.dart';
// Core Services (Same for both)
import '../../../services/api/api_service.dart';
// REST API Services
// import '../../second/di/services/restapi/api_service.dart';
// import '../../second/di/services/restapi/auth_api_service.dart';
// import '../../second/di/services/restapi/complaint_api_service.dart';
// import '../../second/di/services/restapi/payment_api_service.dart';
// import '../../second/di/services/restapi/user_api_service.dart';

final GetIt getIt = GetIt.instance;

void setupRestApiDependencies() {
  // ✅ ALL REST API Services
  getIt.registerLazySingleton<ApiService>(
    () => ApiService(),
  );
  // getIt.registerLazySingleton<AuthApiService>(
  //   () => AuthApiService(),
  // );
  // getIt.registerLazySingleton<UserApiService>(
  //   () => UserApiService(),
  // );
  // getIt.registerLazySingleton<PaymentApiService>(
  //   () => PaymentApiService(),
  // );
  // getIt.registerLazySingleton<ComplaintApiService>(
  //   () => ComplaintApiService(),
  // );

  // Core Services (Same for both)
  getIt.registerLazySingleton<NavigationService>(
    () => NavigationService(AppRouter.router),
  );

  // Local Storage (Same implementation)
  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(),
  );

  // ❌ NO Firebase services registered here
}

// Convenience getters for REST API services only
extension RestApiServiceLocator on GetIt {
  ApiService get apiService => get<ApiService>();
  // AuthApiService get authApi => get<AuthApiService>();
  // UserApiService get userApi => get<UserApiService>();
  // PaymentApiService get paymentApi => get<PaymentApiService>();
  // ComplaintApiService get complaintApi => get<ComplaintApiService>();
  LocalStorageService get storage => get<LocalStorageService>();
  NavigationService get navigation => get<NavigationService>();
}
