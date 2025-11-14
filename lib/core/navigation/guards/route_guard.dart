// lib/core/navigation/guards/route_guard.dart

import 'package:flutter/foundation.dart';
import '../../../../common/utils/constants/routes.dart';
import '../../../../common/utils/constants/firestore.dart';
import '../../../core/di/firebase/di/firebase_service_locator.dart' as di;

/// Route guard utility for authentication and role-based access control
class RouteGuard {
  /// Checks if user is authenticated
  /// Validates Firebase Auth session exists and is valid
  static bool isAuthenticated() {
    try {
      final authUser = di.getIt.auth.currentUser;
      if (authUser == null) {
        debugPrint('🔒 RouteGuard: No authenticated user found');
        return false;
      }

      // Additional validation: ensure user ID is not empty
      if (authUser.uid.isEmpty) {
        debugPrint('🔒 RouteGuard: Invalid user ID (empty)');
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('🔒 RouteGuard: Authentication check failed: $e');
      return false;
    }
  }

  /// Gets current user role from Firestore
  /// Returns 'guest', 'owner', or null if not authenticated or role not found
  ///
  /// This method:
  /// 1. Checks if user is authenticated via Firebase Auth
  /// 2. Fetches user document from Firestore 'users' collection
  /// 3. Extracts and returns the 'role' field
  /// 4. Handles errors gracefully with proper logging
  static Future<String?> getUserRole() async {
    try {
      // Check authentication first
      final authUser = di.getIt.auth.currentUser;
      if (authUser == null) {
        debugPrint('🔒 RouteGuard: Cannot get role - user not authenticated');
        return null;
      }

      final userId = authUser.uid;
      if (userId.isEmpty) {
        debugPrint('🔒 RouteGuard: Cannot get role - invalid user ID');
        return null;
      }

      // Get Firestore service and fetch user document
      final firestoreService = di.getIt.firestore;
      final userDoc = await firestoreService.getDocument(
        FirestoreConstants.users,
        userId,
      );

      // Check if document exists
      if (!userDoc.exists) {
        debugPrint(
            '🔒 RouteGuard: User document not found in Firestore for userId: $userId');
        return null;
      }

      // Extract role from document data
      final userData = userDoc.data() as Map<String, dynamic>?;
      if (userData == null) {
        debugPrint(
            '🔒 RouteGuard: User document data is null for userId: $userId');
        return null;
      }

      final role = userData['role'] as String?;
      if (role == null || role.isEmpty) {
        debugPrint(
            '🔒 RouteGuard: Role field is missing or empty for userId: $userId');
        return null;
      }

      // Validate role is either 'guest' or 'owner'
      if (role != 'guest' && role != 'owner') {
        debugPrint(
            '🔒 RouteGuard: Invalid role value "$role" for userId: $userId');
        return null;
      }

      debugPrint(
          '🔒 RouteGuard: Successfully retrieved role "$role" for userId: $userId');
      return role;
    } catch (e) {
      debugPrint('🔒 RouteGuard: Error getting user role: $e');
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
