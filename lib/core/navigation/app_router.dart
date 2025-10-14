// lib/core/navigation/app_router.dart

import 'package:go_router/go_router.dart';

import '../../../feature/auth/view/screen/role_selection/role_selection_screen.dart';
import '../../../feature/auth/view/screen/signin/phone_auth_screen.dart';
import '../../../feature/auth/view/screen/signup/registration_screen.dart';
import '../../../feature/auth/view/screen/splash/splash_screen.dart';
import '../../../feature/guest_dashboard/complaints/view/screens/guest_complaint_add_screen.dart';
import '../../../feature/guest_dashboard/complaints/view/screens/guest_complaint_list_screen.dart';
import '../../../feature/guest_dashboard/foods/view/screens/guest_food_list_screen.dart';
import '../../../feature/guest_dashboard/guest_dashboard.dart';
import '../../../feature/guest_dashboard/payments/view/screens/guest_payment_screen.dart';
import '../../../feature/guest_dashboard/payments/view/screens/guest_payment_detail_screen.dart';
import '../../../feature/guest_dashboard/pgs/view/screens/guest_pg_detail_screen.dart';
import '../../../feature/guest_dashboard/pgs/view/screens/guest_pg_list_screen.dart';
import '../../../feature/guest_dashboard/profile/view/screens/guest_profile_screen.dart';
import '../../../feature/owner_dashboard/foods/view/screens/owner_food_management_screen.dart';
import '../../../feature/owner_dashboard/myguest/view/screens/owner_guest_screen.dart';
import '../../../feature/owner_dashboard/mypg/presentation/screens/owner_pg_management_screen.dart';
import '../../../feature/owner_dashboard/overview/view/screens/owner_overview_screen.dart';
import '../../../feature/owner_dashboard/owner_dashboard.dart';
import '../../../feature/owner_dashboard/profile/view/screens/owner_profile_screen.dart';
import '../../common/utils/constants/routes.dart';
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
        builder: (context, state) => const GuestDashboardScreen(),
        routes: [
          // PG Listings Route
          GoRoute(
            path: 'pgs',
            name: AppRoutes.guestPGs,
            builder: (context, state) => const GuestPgListScreen(),
            routes: [
              // PG Details Route
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
          // Food Menu Route
          GoRoute(
            path: 'foods',
            name: AppRoutes.guestFoods,
            builder: (context, state) => const GuestFoodListScreen(),
          ),
          // Payment History Routes (nested for details functionality)
          GoRoute(
            path: 'payments',
            name: AppRoutes.guestPayments,
            builder: (context, state) => const GuestPaymentScreen(),
            routes: [
              // Payment Details Route
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
          // Complaints Routes (nested for add functionality)
          GoRoute(
            path: 'complaints',
            name: AppRoutes.guestComplaints,
            builder: (context, state) => const GuestComplaintsListScreen(),
            routes: [
              // Complaint Add Screen Route
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
            builder: (context, state) => const OwnerGuestScreen(),
          ),
          // Profile management tab - ViewModel accessed via Provider
          GoRoute(
            path: 'profile',
            name: AppRoutes.ownerProfile,
            builder: (context, state) => const OwnerProfileScreen(),
          ),
        ],
      ),
    ],

    // Global error handler for undefined routes
    errorBuilder: (context, state) => const ErrorScreen(),

    // Optional: Add redirect logic for authentication
    redirect: (context, state) {
      // Add authentication-based redirection logic here
      // Example: Redirect to login if not authenticated
      return null; // Return null to proceed with current route
    },
  );
}
