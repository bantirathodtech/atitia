import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../common/utils/constants/routes.dart';

/// Centralized navigation service for context-free navigation throughout the app.
///
/// Benefits:
/// - No BuildContext needed for navigation
/// - ViewModels can navigate directly
/// - Type-safe navigation methods
/// - Single entry point for all navigation logic
class NavigationService {
  final GoRouter _router;

  NavigationService(this._router);

  // Auth navigation methods
  void goToSplash() => _router.go(AppRoutes.splash);

  /// Navigate to Role Selection Screen
  void goToRoleSelection() => _router.go(AppRoutes.roleSelection);

  void goToPhoneAuth() => _router.go(AppRoutes.phoneAuth);
  void goToRegistration() => _router.go(AppRoutes.registration);

  // void goToSignIn() => _router.go(AppRoutes.signIn);

  // void goToSignUp() => _router.go(AppRoutes.signUp);

  // Guest navigation methods
  void goToGuestHome() => _router.go(AppRoutes.guestHome);
  void goToGuestPGs() => _router.go(AppRoutes.guestPGs);
  void goToGuestPGDetails(String pgId) {
    _router.pushNamed(
      'guestPGDetails',
      pathParameters: {'pgId': pgId},
    );
  }

  void goToGuestPGAdd() => _router.go(AppRoutes.guestPGAdd());
  void goToGuestFoods() => _router.go(AppRoutes.guestFoods);
  void goToGuestFoodDetails(String foodId) =>
      _router.go(AppRoutes.guestFoodDetails(foodId));
  void goToGuestPayments() => _router.go(AppRoutes.guestPayments);
  void goToGuestPaymentDetails(String paymentId) {
    _router.pushNamed(
      'guestPaymentDetails',
      pathParameters: {'paymentId': paymentId},
    );
  }

  void goToGuestPaymentAdd() => _router.go(AppRoutes.guestPaymentAdd());
  void goToGuestComplaints() => _router.go(AppRoutes.guestComplaints);
  void goToGuestComplaintAdd() {
    _router.pushNamed('guestComplaintsAdd');
  }

  void goToGuestComplaintDetails(String complaintId) =>
      _router.go(AppRoutes.guestComplaintDetails(complaintId));
  void goToGuestProfile() => _router.go(AppRoutes.guestProfile);
  void goToGuestNotifications() => _router.go(AppRoutes.guestNotifications);
  void goToGuestRoomBed() => _router.go(AppRoutes.guestRoomBed);
  void goToGuestSettings() => _router.go(AppRoutes.guestSettings);
  void goToGuestHelp() => _router.go(AppRoutes.guestHelp);

  // Owner navigation methods
  void goToOwnerHome() => _router.go(AppRoutes.ownerHome);
  void goToOwnerOverview() => _router.go(AppRoutes.ownerOverview);
  void goToOwnerFoods() => _router.go(AppRoutes.ownerFoods);
  void goToOwnerPGs() => _router.go(AppRoutes.ownerPGs);
  void goToOwnerGuests() => _router.go(AppRoutes.ownerGuests);
  void goToOwnerProfile() => _router.go(AppRoutes.ownerProfile);
  void goToOwnerSettings() => _router.go(AppRoutes.ownerSettings);
  void goToOwnerNotifications() => _router.go(AppRoutes.ownerNotifications);
  void goToOwnerHelp() => _router.go(AppRoutes.ownerHelp);
  void goToOwnerAnalytics() => _router.go(AppRoutes.ownerAnalytics);
  void goToOwnerReports() => _router.go(AppRoutes.ownerReports);

  // Utility navigation methods
  void goBack() => _router.pop();
  void goToRoute(String route) => _router.go(route);
  void pushRoute(String route) => _router.push(route);

  /// Check if current route matches the given route path
  bool isCurrentRoute(String route) => getCurrentLocation() == route;

  /// Get the current route location/path
  String getCurrentLocation() {
    try {
      // Try multiple ways to get current location based on GoRouter version
      return _router.routerDelegate.currentConfiguration.uri.toString();
    } catch (e) {
      return AppRoutes.splash;
    }
  }

  /// Check if user is on any auth screen
  bool get isOnAuthFlow {
    final currentLocation = getCurrentLocation();
    return currentLocation == AppRoutes.splash ||
        currentLocation == AppRoutes.phoneAuth ||
        currentLocation == AppRoutes.registration;
  }

  /// Check if user is on guest flow
  bool get isOnGuestFlow =>
      getCurrentLocation().startsWith(AppRoutes.guestHome);

  /// Check if user is on owner flow
  bool get isOnOwnerFlow =>
      getCurrentLocation().startsWith(AppRoutes.ownerHome);

  /// STRICT: Navigate to home dashboard based on user role
  /// This method should be used instead of directly calling goToGuestHome/goToOwnerHome
  /// to ensure role-based navigation is always enforced
  void goToHomeByRole(String? role) {
    final userRole = role?.toLowerCase().trim();

    // STRICT: Only navigate if role is explicitly 'guest' or 'owner'
    if (userRole == 'guest') {
      goToGuestHome();
    } else if (userRole == 'owner') {
      goToOwnerHome();
    } else {
      // Invalid or missing role - redirect to role selection
      goToRoleSelection();
    }
  }
}

/// Extension to easily access NavigationService from GetIt
extension NavigationServiceExtension on GetIt {
  NavigationService get navigation => get<NavigationService>();
}
