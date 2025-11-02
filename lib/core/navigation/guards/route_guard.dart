// lib/core/navigation/guards/route_guard.dart

import '../../../../common/utils/constants/routes.dart';
import '../../../core/di/firebase/di/firebase_service_locator.dart' as di;

/// Route guard utility for authentication and role-based access control
class RouteGuard {
  /// Checks if user is authenticated
  static bool isAuthenticated() {
    try {
      final authUser = di.getIt.auth.currentUser;
      return authUser != null;
    } catch (e) {
      return false;
    }
  }

  /// Gets current user role from AuthProvider
  /// Returns 'guest', 'owner', or null if not authenticated
  static String? getUserRole() {
    try {
      // Try to get role from cached user data
      final authUser = di.getIt.auth.currentUser;
      if (authUser == null) return null;

      // Get user data from Firestore
      // For now, we'll need to read from a state/context
      // This will be enhanced when we have access to AuthProvider context
      return null; // Placeholder - will be enhanced with AuthProvider access
    } catch (e) {
      return null;
    }
  }

  /// Checks if route requires authentication
  static bool requiresAuth(String route) {
    // Auth routes don't require authentication
    if (AppRoutes.isAuthRoute(route)) return false;

    // All other routes require authentication
    return true;
  }

  /// Checks if route requires specific role
  static bool requiresRole(String route, String requiredRole) {
    if (!requiresAuth(route)) return false;

    // Guest routes require guest role
    if (AppRoutes.isGuestRoute(route)) {
      return requiredRole == 'guest';
    }

    // Owner routes require owner role
    if (AppRoutes.isOwnerRoute(route)) {
      return requiredRole == 'owner';
    }

    return false;
  }

  /// Gets redirect path based on authentication and role
  static String? getRedirectPath(String currentRoute, String? userRole) {
    // Allow auth routes without authentication
    if (AppRoutes.isAuthRoute(currentRoute)) {
      return null; // Allow access
    }

    // Check authentication
    if (!isAuthenticated()) {
      return AppRoutes.splash;
    }

    // Check role-based access
    if (userRole == null) {
      // User authenticated but role not set - redirect to role selection
      if (currentRoute != AppRoutes.roleSelection) {
        return AppRoutes.roleSelection;
      }
      return null;
    }

    // STRICT: Prevent guest from accessing owner routes - redirect to their own dashboard
    if (AppRoutes.isOwnerRoute(currentRoute) && userRole != 'owner') {
      // If user is guest trying to access owner route, force redirect to guest dashboard
      if (userRole == 'guest') {
        return AppRoutes.guestHome;
      }
      // If role is invalid/null, redirect to role selection
      return AppRoutes.roleSelection;
    }

    // STRICT: Prevent owner from accessing guest routes - redirect to their own dashboard
    if (AppRoutes.isGuestRoute(currentRoute) && userRole != 'guest') {
      // If user is owner trying to access guest route, force redirect to owner dashboard
      if (userRole == 'owner') {
        return AppRoutes.ownerHome;
      }
      // If role is invalid/null, redirect to role selection
      return AppRoutes.roleSelection;
    }

    return null; // Allow access
  }
}
