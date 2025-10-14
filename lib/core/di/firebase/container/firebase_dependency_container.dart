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

/// FirebaseDependencyContainer wires feature ViewModels/Providers using
/// the Firebase-backed services registered in the Firebase Service Locator.
///
/// This container creates instances of all ViewModels for both Guest and Owner roles.
/// All ViewModels internally use GetIt to access Firebase services (firestore, storage, analytics, etc.)
///
/// Keep factories minimal and delegate dependencies to GetIt inside each Provider/ViewModel.
class FirebaseDependencyContainer {
  // ==================== CORE PROVIDERS ====================

  /// Creates ThemeProvider for theme management (light/dark mode)
  static ThemeProvider createThemeProvider() => ThemeProvider();

  /// Creates LocaleProvider for localization management (language switching)
  static LocaleProvider createLocaleProvider() => LocaleProvider();

  // ==================== AUTH PROVIDER ====================

  /// Creates AuthProvider for authentication (both Guest and Owner roles)
  /// Internally uses getIt.auth, getIt.firestore, getIt.analytics
  static AuthProvider createAuthProvider() => AuthProvider();

  // ==================== GUEST VIEWMODELS ====================

  /// Creates GuestProfileViewModel for user profile management
  /// Internally uses getIt.firestore, getIt.storage, getIt.analytics
  static GuestProfileViewModel createGuestProfileViewModel() =>
      GuestProfileViewModel();

  /// Creates GuestComplaintViewModel for complaint submission and tracking
  /// Internally uses getIt.firestore, getIt.analytics
  static GuestComplaintViewModel createGuestComplaintViewModel() =>
      GuestComplaintViewModel();

  /// Creates GuestFoodViewmodel for food menu viewing and ordering
  /// Internally uses getIt.firestore, getIt.analytics
  static GuestFoodViewmodel createGuestFoodViewModel() => GuestFoodViewmodel();

  /// Creates GuestPaymentViewModel for payment history and transactions
  /// Internally uses getIt.firestore, getIt.analytics
  static GuestPaymentViewModel createGuestPaymentViewModel() =>
      GuestPaymentViewModel();

  /// Creates GuestPgViewModel for PG browsing and booking
  /// Internally uses getIt.firestore, getIt.storage, getIt.analytics
  static GuestPgViewModel createGuestPgViewModel() => GuestPgViewModel();

  // ==================== OWNER VIEWMODELS ====================

  /// Creates OwnerProfileViewModel for business profile management
  /// Internally uses getIt.firestore, getIt.storage, getIt.analytics, getIt.auth
  static OwnerProfileViewModel createOwnerProfileViewModel() =>
      OwnerProfileViewModel();

  /// Creates OwnerFoodViewModel for menu management and special menus
  /// Internally uses getIt.firestore, getIt.storage, getIt.analytics
  static OwnerFoodViewModel createOwnerFoodViewModel() => OwnerFoodViewModel();

  /// Creates OwnerGuestViewModel for guest, booking, and payment management
  /// Internally uses getIt.firestore, getIt.analytics
  static OwnerGuestViewModel createOwnerGuestViewModel() =>
      OwnerGuestViewModel();

  /// Creates OwnerPgManagementViewModel for PG property and bed management
  /// Internally uses getIt.firestore, getIt.storage, getIt.analytics
  static OwnerPgManagementViewModel createOwnerPgManagementViewModel() =>
      OwnerPgManagementViewModel();

  /// Creates OwnerOverviewViewModel for dashboard with statistics and analytics
  /// Internally uses getIt.firestore, getIt.analytics
  static OwnerOverviewViewModel createOwnerOverviewViewModel() =>
      OwnerOverviewViewModel();
}
