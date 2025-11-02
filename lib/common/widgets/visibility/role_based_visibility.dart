// lib/common/widgets/visibility/role_based_visibility.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../feature/auth/logic/auth_provider.dart';
import '../../utils/permissions/role_permissions.dart';

/// Widget that shows content only for specific roles
class RoleBasedVisibility extends StatelessWidget {
  final Widget child;
  final List<String> allowedRoles;
  final Widget? fallback;

  const RoleBasedVisibility({
    required this.child,
    required this.allowedRoles,
    this.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userRole = authProvider.user?.role;

    if (userRole != null && allowedRoles.contains(userRole)) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }

  /// Factory for guest-only visibility
  factory RoleBasedVisibility.guest({
    required Widget child,
    Widget? fallback,
  }) {
    return RoleBasedVisibility(
      allowedRoles: ['guest'],
      fallback: fallback,
      child: child,
    );
  }

  /// Factory for owner-only visibility
  factory RoleBasedVisibility.owner({
    required Widget child,
    Widget? fallback,
  }) {
    return RoleBasedVisibility(
      allowedRoles: ['owner'],
      fallback: fallback,
      child: child,
    );
  }
}

/// Widget that shows content only if user has specific permission
class PermissionBasedVisibility extends StatelessWidget {
  final Widget child;
  final AppPermission permission;
  final Widget? fallback;

  const PermissionBasedVisibility({
    required this.child,
    required this.permission,
    this.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userRole = authProvider.user?.role;

    if (RolePermissions.hasPermission(userRole, permission)) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}
