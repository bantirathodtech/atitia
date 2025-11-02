/// Application route paths and navigation constants.
///
/// ## Purpose:
/// - Type-safe route names and paths
/// - Centralized route management
/// - Easy route refactoring
///
/// ## Usage:
/// ```dart
/// context.go(AppRoutes.splash);
/// context.go(AppRoutes.pgDetails('abc123'));
/// ```
class AppRoutes {
  // MARK: - Authentication Routes
  // ==========================================

  /// Initial app loading screen: '/splash'
  static const String splash = '/splash';

  /// Phone number authentication screen: '/phone-auth'
  static const String phoneAuth = '/phone-auth';

  /// static const String signIn = '/signIn';

  /// static const String signUp = '/signUp';

  /// OTP verification screen: '/verify-otp'
  static const String verification = '/verify-otp';

  /// User role selection screen: '/role-selection'
  static const String roleSelection = '/role-selection';

  /// User registration completion: '/registration'
  static const String registration = '/registration';

  // MARK: - Guest Feature Routes
  // ==========================================

  /// Guest dashboard home: '/guest'
  static const String guestHome = '/guest';

  /// Guest PG listings: '/guest/pgs'
  static const String guestPGs = '$guestHome/pgs';

  /// Guest food menu: '/guest/foods'
  static const String guestFoods = '$guestHome/foods';

  /// Guest payment history: '/guest/payments'
  static const String guestPayments = '$guestHome/payments';

  /// Guest complaints list: '/guest/complaints'
  static const String guestComplaints = '$guestHome/complaints';

  /// Guest notifications: '/guest/notifications'
  static const String guestNotifications = '$guestHome/notifications';

  /// Guest profile management: '/guest/profile'
  static const String guestProfile = '$guestHome/profile';

  /// Guest room/bed view: '/guest/room-bed'
  static const String guestRoomBed = '$guestHome/room-bed';

  /// Guest settings: '/guest/settings'
  static const String guestSettings = '$guestHome/settings';

  /// Guest help & support: '/guest/help'
  static const String guestHelp = '$guestHome/help';

  // MARK: - Owner Feature Routes
  // ==========================================

  /// Owner dashboard home: '/owner'
  static const String ownerHome = '/owner';

  /// Owner business overview: '/owner/overview'
  static const String ownerOverview = '$ownerHome/overview';

  /// Owner food management: '/owner/foods'
  static const String ownerFoods = '$ownerHome/foods';

  /// Owner PG management: '/owner/pgs'
  static const String ownerPGs = '$ownerHome/pgs';

  /// Owner guest management: '/owner/guests'
  static const String ownerGuests = '$ownerHome/guests';

  /// Owner profile management: '/owner/profile'
  static const String ownerProfile = '$ownerHome/profile';

  /// Owner settings: '/owner/settings'
  static const String ownerSettings = '$ownerHome/settings';

  /// Owner notifications: '/owner/notifications'
  static const String ownerNotifications = '$ownerHome/notifications';

  /// Owner help & support: '/owner/help'
  static const String ownerHelp = '$ownerHome/help';

  /// Owner analytics: '/owner/analytics'
  static const String ownerAnalytics = '$ownerHome/analytics';

  /// Owner reports: '/owner/reports'
  static const String ownerReports = '$ownerHome/reports';

  // MARK: - Route Builder Methods
  // ==========================================

  /// Build route for adding a new complaint
  static String guestComplaintAdd() => '$guestComplaints/add';

  /// Build route for guest complaint details with dynamic complaint ID
  static String guestComplaintDetails(String complaintId) =>
      '$guestComplaints/$complaintId';

  /// Build route for PG details with dynamic ID
  static String pgDetails(String pgId) => '$guestPGs/$pgId';

  /// Build route for guest PG details with dynamic PG ID
  static String guestPGDetails(String pgId) => '$guestPGs/$pgId';

  /// Build route for adding a new PG (for owners)
  static String guestPGAdd() => '$guestPGs/add';

  /// Build route for Food details with dynamic ID
  static String guestFoodDetails(String foodId) => '$guestFoods/$foodId';

  /// Build route for guest details with dynamic ID
  static String guestDetails(String guestId) => '$ownerGuests/$guestId';

  /// Build route for editing PG with dynamic ID
  static String editPG(String pgId) => '$ownerPGs/edit/$pgId';

  /// Build route for payment details with dynamic payment ID
  static String guestPaymentDetails(String paymentId) =>
      '$guestPayments/$paymentId';

  /// Build route for adding a new payment
  static String guestPaymentAdd() => '$guestPayments/add';

  // MARK: - Utility Methods
  // ==========================================

  /// Check if current route is an authentication flow
  static bool isAuthRoute(String route) {
    return route == splash ||
        route == phoneAuth ||
        route == verification ||
        route == roleSelection ||
        route == registration;
  }

  /// Check if current route is a guest flow
  static bool isGuestRoute(String route) {
    return route.startsWith(guestHome);
  }

  /// Check if current route is an owner flow
  static bool isOwnerRoute(String route) {
    return route.startsWith(ownerHome);
  }
}
