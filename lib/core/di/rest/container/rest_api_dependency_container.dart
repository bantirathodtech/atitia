import 'package:get_it/get_it.dart';

// Auth feature
import '../../../../feature/auth/logic/auth_provider.dart';
// Guest feature viewmodels
import '../../../../feature/guest_dashboard/complaints/viewmodel/guest_complaint_viewmodel.dart';
import '../../../../feature/guest_dashboard/foods/viewmodel/guest_food_viewmodel.dart';
import '../../../../feature/guest_dashboard/payments/viewmodel/guest_payment_viewmodel.dart';
import '../../../../feature/guest_dashboard/pgs/viewmodel/guest_pg_viewmodel.dart';
import '../../../../feature/guest_dashboard/profile/viewmodel/guest_profile_viewmodel.dart';
// Owner feature viewmodels
import '../../../../feature/owner_dashboard/foods/viewmodel/owner_food_viewmodel.dart';
import '../../../../feature/owner_dashboard/myguest/viewmodel/owner_guest_viewmodel.dart';
// Core providers
import '../../../../feature/owner_dashboard/mypg/presentation/viewmodels/owner_pg_management_viewmodel.dart';
import '../../../../feature/owner_dashboard/overview/viewmodel/owner_overview_view_model.dart';
import '../../../../feature/owner_dashboard/profile/viewmodel/owner_profile_viewmodel.dart';
import '../../../app/localization/locale_provider.dart';
import '../../../app/theme/theme_provider.dart';

// Optional: expose getIt if needed for advanced factory wiring
final GetIt getIt = GetIt.instance;

/// RestApiDependencyContainer wires feature ViewModels/Providers using
/// REST API-backed services registered in the REST API Service Locator.
///
/// This is a placeholder implementation that mirrors the Firebase container structure.
/// Currently, the app uses Firebase services. When you implement REST API services,
/// this container will create ViewModels that use REST API services instead of Firebase.
///
/// To implement REST API support:
/// 1. Create REST API services in core/services/api/
/// 2. Register them in rest_api_service_locator.dart
/// 3. Update ViewModels to support REST API services
/// 4. Switch main.dart to use RestApiServiceInitializer
class RestApiDependencyContainer {
  // ==================== CORE PROVIDERS ====================

  /// Creates ThemeProvider for theme management (light/dark mode)
  static ThemeProvider createThemeProvider() => ThemeProvider();

  /// Creates LocaleProvider for localization management (language switching)
  static LocaleProvider createLocaleProvider() => LocaleProvider();

  // ==================== AUTH PROVIDER ====================

  /// Creates AuthProvider for authentication (both Guest and Owner roles)
  /// TODO: Update to use REST API auth service when implemented
  static AuthProvider createAuthProvider() => AuthProvider();

  // ==================== GUEST VIEWMODELS ====================

  /// Creates GuestProfileViewModel for user profile management
  /// TODO: Update to use REST API user service when implemented
  static GuestProfileViewModel createGuestProfileViewModel() =>
      GuestProfileViewModel();

  /// Creates GuestComplaintViewModel for complaint submission and tracking
  /// TODO: Update to use REST API complaint service when implemented
  static GuestComplaintViewModel createGuestComplaintViewModel() =>
      GuestComplaintViewModel();

  /// Creates GuestFoodViewmodel for food menu viewing and ordering
  /// TODO: Update to use REST API food service when implemented
  static GuestFoodViewmodel createGuestFoodViewModel() => GuestFoodViewmodel();

  /// Creates GuestPaymentViewModel for payment history and transactions
  /// TODO: Update to use REST API payment service when implemented
  static GuestPaymentViewModel createGuestPaymentViewModel() =>
      GuestPaymentViewModel();

  /// Creates GuestPgViewModel for PG browsing and booking
  /// TODO: Update to use REST API PG service when implemented
  static GuestPgViewModel createGuestPgViewModel() => GuestPgViewModel();

  // ==================== OWNER VIEWMODELS ====================

  /// Creates OwnerProfileViewModel for business profile management
  /// TODO: Update to use REST API user service when implemented
  static OwnerProfileViewModel createOwnerProfileViewModel() =>
      OwnerProfileViewModel();

  /// Creates OwnerFoodViewModel for menu management and special menus
  /// TODO: Update to use REST API food service when implemented
  static OwnerFoodViewModel createOwnerFoodViewModel() => OwnerFoodViewModel();

  /// Creates OwnerGuestViewModel for guest, booking, and payment management
  /// TODO: Update to use REST API guest service when implemented
  static OwnerGuestViewModel createOwnerGuestViewModel() =>
      OwnerGuestViewModel();

  /// Creates OwnerPgManagementViewModel for PG property and bed management
  /// TODO: Update to use REST API PG service when implemented
  static OwnerPgManagementViewModel createOwnerPgManagementViewModel() =>
      OwnerPgManagementViewModel();

  /// Creates OwnerOverviewViewModel for dashboard with statistics and analytics
  /// TODO: Update to use REST API analytics service when implemented
  static OwnerOverviewViewModel createOwnerOverviewViewModel() =>
      OwnerOverviewViewModel();

  // ==================== FUTURE IMPLEMENTATION GUIDE ====================

  /* 
   * When implementing REST API support, follow these steps:
   * 
   * 1. Create REST API Services:
   *    - lib/core/services/api/auth_api_service.dart
   *    - lib/core/services/api/user_api_service.dart
   *    - lib/core/services/api/food_api_service.dart
   *    - lib/core/services/api/payment_api_service.dart
   *    - lib/core/services/api/pg_api_service.dart
   *    - lib/core/services/api/complaint_api_service.dart
   * 
   * 2. Register services in rest_api_service_locator.dart:
   *    getIt.registerLazySingleton<AuthApiService>(() => AuthApiService());
   *    getIt.registerLazySingleton<UserApiService>(() => UserApiService());
   *    // ... etc
   * 
   * 3. Update ViewModels to accept REST API services:
   *    class GuestProfileViewModel {
   *      final UserApiService _userApiService;
   *      GuestProfileViewModel(this._userApiService);
   *    }
   * 
   * 4. Update factory methods here:
   *    static GuestProfileViewModel createGuestProfileViewModel() {
   *      return GuestProfileViewModel(getIt.get<UserApiService>());
   *    }
   * 
   * 5. Switch in main.dart:
   *    await RestApiServiceInitializer.initialize();
   *    // instead of FirebaseServiceInitializer.initialize()
   */
}
