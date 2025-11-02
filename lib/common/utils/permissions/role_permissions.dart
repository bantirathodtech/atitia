// lib/common/utils/permissions/role_permissions.dart

/// Permission enum for various actions in the app
enum AppPermission {
  // Guest permissions
  viewPgList,
  bookPg,
  viewGuestBookings,
  submitComplaint,
  viewGuestComplaints,
  viewGuestPayments,
  viewOwnRoomBed,
  requestBedChange,
  viewFoodMenu,
  submitFoodFeedback,

  // Owner permissions
  viewOwnGuests,
  manageOwnGuests,
  approveBookingRequests,
  rejectBookingRequests,
  viewOwnerBookings,
  manageOwnerBookings,
  collectPayments,
  viewOwnerPayments,
  viewComplaints,
  replyToComplaints,
  manageComplaints,
  publishFoodMenus,
  viewFoodFeedback,
  assignRoomBed,
  approveBedChangeRequests,
  viewDashboard,
  managePGs,
}

/// Role-based permission checker
class RolePermissions {
  /// Checks if a role has a specific permission
  static bool hasPermission(String? role, AppPermission permission) {
    if (role == null) return false;

    switch (permission) {
      // Guest permissions
      case AppPermission.viewPgList:
      case AppPermission.bookPg:
      case AppPermission.viewGuestBookings:
      case AppPermission.submitComplaint:
      case AppPermission.viewGuestComplaints:
      case AppPermission.viewGuestPayments:
      case AppPermission.viewOwnRoomBed:
      case AppPermission.requestBedChange:
      case AppPermission.viewFoodMenu:
      case AppPermission.submitFoodFeedback:
        return role == 'guest';

      // Owner permissions
      case AppPermission.viewOwnGuests:
      case AppPermission.manageOwnGuests:
      case AppPermission.approveBookingRequests:
      case AppPermission.rejectBookingRequests:
      case AppPermission.viewOwnerBookings:
      case AppPermission.manageOwnerBookings:
      case AppPermission.collectPayments:
      case AppPermission.viewOwnerPayments:
      case AppPermission.viewComplaints:
      case AppPermission.replyToComplaints:
      case AppPermission.manageComplaints:
      case AppPermission.publishFoodMenus:
      case AppPermission.viewFoodFeedback:
      case AppPermission.assignRoomBed:
      case AppPermission.approveBedChangeRequests:
      case AppPermission.viewDashboard:
      case AppPermission.managePGs:
        return role == 'owner';
    }
  }

  /// Gets all permissions for a role
  static List<AppPermission> getPermissionsForRole(String? role) {
    if (role == null) return [];

    switch (role) {
      case 'guest':
        return [
          AppPermission.viewPgList,
          AppPermission.bookPg,
          AppPermission.viewGuestBookings,
          AppPermission.submitComplaint,
          AppPermission.viewGuestComplaints,
          AppPermission.viewGuestPayments,
          AppPermission.viewOwnRoomBed,
          AppPermission.requestBedChange,
          AppPermission.viewFoodMenu,
          AppPermission.submitFoodFeedback,
        ];
      case 'owner':
        return [
          AppPermission.viewOwnGuests,
          AppPermission.manageOwnGuests,
          AppPermission.approveBookingRequests,
          AppPermission.rejectBookingRequests,
          AppPermission.viewOwnerBookings,
          AppPermission.manageOwnerBookings,
          AppPermission.collectPayments,
          AppPermission.viewOwnerPayments,
          AppPermission.viewComplaints,
          AppPermission.replyToComplaints,
          AppPermission.manageComplaints,
          AppPermission.publishFoodMenus,
          AppPermission.viewFoodFeedback,
          AppPermission.assignRoomBed,
          AppPermission.approveBedChangeRequests,
          AppPermission.viewDashboard,
          AppPermission.managePGs,
        ];
      default:
        return [];
    }
  }
}
