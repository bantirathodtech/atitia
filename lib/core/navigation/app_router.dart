// lib/core/navigation/app_router.dart

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../feature/auth/view/screen/role_selection/role_selection_screen.dart';
import '../../../feature/auth/view/screen/signin/phone_auth_screen.dart';
import '../../../feature/auth/view/screen/signup/registration_screen.dart';
import '../../../feature/auth/view/screen/splash/splash_screen.dart';
import '../../../feature/guest_dashboard/complaints/view/screens/guest_complaint_add_screen.dart';
import '../../../feature/guest_dashboard/guest_dashboard.dart';
import '../../../feature/guest_dashboard/payments/view/screens/guest_payment_detail_screen.dart';
import '../../../feature/guest_dashboard/pgs/view/screens/guest_pg_detail_screen.dart';
import '../../../feature/guest_dashboard/pgs/view/screens/guest_room_bed_screen.dart';
import '../../../feature/guest_dashboard/profile/view/screens/guest_profile_screen.dart';
import '../../../feature/guest_dashboard/settings/view/screens/guest_settings_screen.dart';
import '../../../feature/guest_dashboard/help/view/screens/guest_help_screen.dart';
import '../../../common/widgets/notifications/notifications_screen.dart';
import '../../../feature/owner_dashboard/foods/view/screens/owner_food_management_screen.dart';
import '../../../feature/owner_dashboard/guests/view/screens/owner_guest_management_screen.dart';
import '../../../feature/owner_dashboard/mypg/presentation/screens/owner_pg_management_screen.dart';
import '../../../feature/owner_dashboard/overview/view/screens/owner_overview_screen.dart';
import '../../../feature/owner_dashboard/owner_dashboard.dart';
import '../../../feature/owner_dashboard/profile/view/screens/owner_profile_screen.dart';
import '../../../feature/owner_dashboard/settings/view/screens/owner_settings_screen.dart';
import '../../../feature/owner_dashboard/notifications/view/screens/owner_notifications_screen.dart';
import '../../../feature/owner_dashboard/help/view/screens/owner_help_screen.dart';
import '../../../feature/owner_dashboard/analytics/screens/owner_analytics_dashboard.dart';
import '../../../feature/owner_dashboard/reports/view/screens/owner_reports_screen.dart';
import '../../common/utils/constants/routes.dart';
import '../../common/utils/logging/logging_helper.dart';
import '../../../feature/auth/logic/auth_provider.dart';
import 'guards/route_guard.dart';
import 'screen/error_screen.dart';

/// Main application router configuration combining all feature routes.
///
/// Responsibilities:
/// - Combine all feature-specific routes
/// - Set initial application route
/// - Configure global error handling
/// - Define route redirection logic
class AppRouter {
  static final GoRouter router = GoRouter(
    // Initial route when app starts
    initialLocation: AppRoutes.splash,

    // Performance optimization: Enable route caching
    routerNeglect: true,

    // Combine all feature routes
    routes: [
      // Authentication Routes
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        name: AppRoutes.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.phoneAuth,
        name: AppRoutes.phoneAuth,
        builder: (context, state) => const PhoneAuthScreen(),
      ),
      GoRoute(
        path: AppRoutes.registration,
        name: AppRoutes.registration,
        builder: (context, state) => const RegistrationScreen(),
      ),

      // Guest Routes
      GoRoute(
        path: AppRoutes.guestHome,
        name: AppRoutes.guestHome,
        redirect: (context, state) {
          // Redirect /guest to /guest/pgs to always show PGs tab
          // But don't redirect if we're navigating to a detail route
          final matched = state.matchedLocation;
          final fullPath = state.uri.path;
          
          // Don't redirect if we're on a detail route (has :pgId, :paymentId, etc.)
          if (fullPath.contains('/pgs/') && fullPath.split('/').length > 3) {
            return null; // This is a detail route, don't redirect
          }
          if (fullPath.contains('/payments/') && fullPath.split('/').length > 3) {
            return null; // This is a detail route, don't redirect
          }
          if (fullPath.contains('/complaints/add') ||
              fullPath.contains('/profile') ||
              fullPath.contains('/notifications') ||
              fullPath.contains('/room-bed')) {
            return null; // These are full-screen routes, don't redirect
          }
          
          // Only redirect if we're exactly at /guest
          if (matched == AppRoutes.guestHome || matched == '${AppRoutes.guestHome}/') {
            return AppRoutes.guestPGs;
          }
          return null;
        },
        builder: (context, state) => const GuestDashboardScreen(),
        routes: [
          // PG Listings Route - This is the default tab
          GoRoute(
            path: 'pgs',
            name: AppRoutes.guestPGs,
            builder: (context, state) => const GuestDashboardScreen(),
            routes: [
              // PG Details Route - Nested under pgs to properly push on top
              GoRoute(
                path: ':pgId',
                name: 'guestPGDetails',
                builder: (context, state) {
                  final pgId = state.pathParameters['pgId'] ?? '';
                  return GuestPgDetailScreen(pgId: pgId);
                },
              ),
            ],
          ),
          // Food Menu Route - No builder, dashboard handles it
          GoRoute(
            path: 'foods',
            name: AppRoutes.guestFoods,
            builder: (context, state) => const GuestDashboardScreen(),
          ),
          // Payment History Routes
          GoRoute(
            path: 'payments',
            name: AppRoutes.guestPayments,
            builder: (context, state) => const GuestDashboardScreen(),
            routes: [
              // Payment Details Route - Nested under payments to properly push on top
              GoRoute(
                path: ':paymentId',
                name: 'guestPaymentDetails',
                builder: (context, state) {
                  final paymentId = state.pathParameters['paymentId'] ?? '';
                  return GuestPaymentDetailScreen(paymentId: paymentId);
                },
              ),
            ],
          ),
          // Booking Requests Route - No builder, dashboard handles it
          GoRoute(
            path: 'requests',
            name: 'guestRequests',
            builder: (context, state) => const GuestDashboardScreen(),
          ),
          // Complaints Routes
          GoRoute(
            path: 'complaints',
            name: AppRoutes.guestComplaints,
            builder: (context, state) => const GuestDashboardScreen(),
            routes: [
              // Complaint Add Screen Route - Nested under complaints to properly push on top
              GoRoute(
                path: 'add',
                name: 'guestComplaintsAdd',
                builder: (context, state) => const GuestComplaintAddScreen(),
              ),
            ],
          ),
          // Profile Management Route
          GoRoute(
            path: 'profile',
            name: AppRoutes.guestProfile,
            builder: (context, state) => const GuestProfileScreen(),
          ),
          // Notifications Route
          GoRoute(
            path: 'notifications',
            name: AppRoutes.guestNotifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
          // Room/Bed Management Route
          GoRoute(
            path: 'room-bed',
            name: AppRoutes.guestRoomBed,
            builder: (context, state) => const GuestRoomBedScreen(),
          ),
          // Settings Route
          GoRoute(
            path: 'settings',
            name: AppRoutes.guestSettings,
            builder: (context, state) => const GuestSettingsScreen(),
          ),
          // Help & Support Route
          GoRoute(
            path: 'help',
            name: AppRoutes.guestHelp,
            builder: (context, state) => const GuestHelpScreen(),
          ),
        ],
      ),

      // Owner Routes
      GoRoute(
        path: AppRoutes.ownerHome,
        name: AppRoutes.ownerHome,
        builder: (context, state) => const OwnerDashboardScreen(),
        routes: [
          // Overview tab - ViewModel accessed via Provider
          GoRoute(
            path: 'overview',
            name: AppRoutes.ownerOverview,
            builder: (context, state) => const OwnerOverviewScreen(),
          ),
          // Food management tab - ViewModel accessed via Provider
          GoRoute(
            path: 'foods',
            name: AppRoutes.ownerFoods,
            builder: (context, state) => const OwnerFoodManagementScreen(),
          ),
          // PG management tab - ViewModel accessed via Provider
          GoRoute(
            path: 'pgs',
            name: AppRoutes.ownerPGs,
            builder: (context, state) => const OwnerPgManagementScreen(),
          ),
          // Guest management tab - ViewModel accessed via Provider
          GoRoute(
            path: 'guests',
            name: AppRoutes.ownerGuests,
            builder: (context, state) => const OwnerGuestManagementScreen(),
          ),
          // Profile management tab - ViewModel accessed via Provider
          GoRoute(
            path: 'profile',
            name: AppRoutes.ownerProfile,
            builder: (context, state) => const OwnerProfileScreen(),
          ),
          // Settings screen
          GoRoute(
            path: 'settings',
            name: AppRoutes.ownerSettings,
            builder: (context, state) => const OwnerSettingsScreen(),
          ),
          // Notifications screen
          GoRoute(
            path: 'notifications',
            name: AppRoutes.ownerNotifications,
            builder: (context, state) => const OwnerNotificationsScreen(),
          ),
          // Help & Support screen
          GoRoute(
            path: 'help',
            name: AppRoutes.ownerHelp,
            builder: (context, state) => const OwnerHelpScreen(),
          ),
          // Analytics screen
          GoRoute(
            path: 'analytics',
            name: AppRoutes.ownerAnalytics,
            builder: (context, state) => const OwnerAnalyticsDashboard(),
          ),
          // Reports screen
          GoRoute(
            path: 'reports',
            name: AppRoutes.ownerReports,
            builder: (context, state) => const OwnerReportsScreen(),
          ),
        ],
      ),
    ],

    // Global error handler for undefined routes
    errorBuilder: (context, state) => const ErrorScreen(),

    // Redirect logic for authentication and role-based access
    redirect: (context, state) {
      // Log navigation events
      LoggingHelper.logNavigation(
        state.matchedLocation,
        state.uri.toString(),
        metadata: {
          'routeName': state.name,
          'pathParameters': state.pathParameters,
          'uri': state.uri.toString(),
        },
      );

      final currentRoute = state.matchedLocation;

      // Skip guard for auth routes (splash, phone auth, etc.)
      if (AppRoutes.isAuthRoute(currentRoute)) {
        return null;
      }

      // Try to access AuthProvider from context
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final user = authProvider.user;
        final userRole = user?.role;

        // Check authentication
        if (!RouteGuard.isAuthenticated() &&
            RouteGuard.requiresAuth(currentRoute)) {
          // Not authenticated and route requires auth - redirect to splash
          return AppRoutes.splash;
        }

        // Check role-based access
        final redirectPath = RouteGuard.getRedirectPath(currentRoute, userRole);
        if (redirectPath != null) {
          return redirectPath;
        }
      } catch (e) {
        // If Provider not available (during initialization), allow route
        // This happens during app startup before Provider tree is ready
        if (currentRoute == AppRoutes.splash) {
          return null; // Allow splash screen
        }
        // For other routes during init, redirect to splash
        return AppRoutes.splash;
      }

      // Allow access to route
      return null;
    },
  );
}
