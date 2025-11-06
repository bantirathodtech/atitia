import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../feature/auth/logic/auth_provider.dart';
import '../../../feature/guest_dashboard/complaints/viewmodel/guest_complaint_viewmodel.dart';
import '../../../feature/guest_dashboard/foods/viewmodel/guest_food_viewmodel.dart';
import '../../../feature/guest_dashboard/payments/viewmodel/guest_payment_viewmodel.dart';
import '../../../feature/guest_dashboard/pgs/viewmodel/guest_pg_viewmodel.dart';
import '../../../feature/guest_dashboard/profile/viewmodel/guest_profile_viewmodel.dart';
import '../../../feature/owner_dashboard/foods/viewmodel/owner_food_viewmodel.dart';
import '../../../feature/owner_dashboard/guests/viewmodel/owner_guest_viewmodel.dart';
import '../../../feature/owner_dashboard/mypg/presentation/viewmodels/owner_pg_management_viewmodel.dart';
import '../../../feature/owner_dashboard/overview/viewmodel/owner_overview_view_model.dart';
import '../../../feature/owner_dashboard/profile/viewmodel/owner_payment_details_viewmodel.dart';
import '../../../feature/owner_dashboard/profile/viewmodel/owner_profile_viewmodel.dart';
import '../../../feature/owner_dashboard/shared/viewmodel/selected_pg_provider.dart';
import '../../../feature/guest_dashboard/shared/viewmodel/guest_pg_selection_provider.dart';
import '../../app/localization/locale_provider.dart';
import '../../app/theme/theme_provider.dart';
import '../../di/firebase/container/firebase_dependency_container.dart';
import '../../viewmodels/payment_notification_viewmodel.dart';
import '../../viewmodels/notification_viewmodel.dart';

/// Firebase-specific provider configuration.
/// Uses FirebaseDependencyContainer to create providers with Firebase wiring.
///
/// This file registers all ViewModels for both Guest and Owner roles,
/// making them available throughout the app via Provider.
class FirebaseAppProviders {
  static List<ChangeNotifierProvider> get providers => [
        // ==================== CORE PROVIDERS ====================
        // Theme management
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => FirebaseDependencyContainer.createThemeProvider(),
        ),
        // Localization management
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => FirebaseDependencyContainer.createLocaleProvider(),
        ),

        // ==================== AUTH PROVIDER ====================
        // Authentication for both Guest and Owner roles
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => FirebaseDependencyContainer.createAuthProvider(),
        ),

        // ==================== GUEST PROVIDERS ====================
        // Guest Profile - User profile management
        ChangeNotifierProvider<GuestProfileViewModel>(
          create: (_) =>
              FirebaseDependencyContainer.createGuestProfileViewModel(),
        ),

        // Guest Complaints - Complaint submission and tracking
        ChangeNotifierProvider<GuestComplaintViewModel>(
          create: (_) =>
              FirebaseDependencyContainer.createGuestComplaintViewModel(),
        ),

        // Guest Foods - Food menu viewing and ordering
        ChangeNotifierProvider<GuestFoodViewmodel>(
          create: (_) => FirebaseDependencyContainer.createGuestFoodViewModel(),
        ),

        // Guest Payments - Payment history and transactions
        ChangeNotifierProvider<GuestPaymentViewModel>(
          create: (_) =>
              FirebaseDependencyContainer.createGuestPaymentViewModel(),
        ),

        // Guest PGs - PG browsing and booking
        ChangeNotifierProvider<GuestPgViewModel>(
          create: (_) => FirebaseDependencyContainer.createGuestPgViewModel(),
        ),

        // Guest PG Selection - Selected PG state management for guests
        ChangeNotifierProvider<GuestPgSelectionProvider>(
          create: (_) => GuestPgSelectionProvider(),
        ),

        // ==================== OWNER PROVIDERS ====================
        // Owner Selected PG - Global state for multi-PG management
        ChangeNotifierProvider<SelectedPgProvider>(
          create: (_) => SelectedPgProvider(),
        ),

        // Owner Profile - Business profile management
        ChangeNotifierProvider<OwnerProfileViewModel>(
          create: (_) =>
              FirebaseDependencyContainer.createOwnerProfileViewModel(),
        ),

        // Owner Payment Details - Bank, UPI, and QR code management
        ChangeNotifierProvider<OwnerPaymentDetailsViewModel>(
          create: (_) => OwnerPaymentDetailsViewModel(),
        ),

        // Payment Notifications - Guest sends, Owner confirms/rejects
        ChangeNotifierProvider<PaymentNotificationViewModel>(
          create: (_) => PaymentNotificationViewModel(),
        ),

        // Notifications - Real-time in-app notifications for both roles
        ChangeNotifierProvider<NotificationViewModel>(
          create: (_) => NotificationViewModel(),
        ),

        // Owner Foods - Menu management and special menus
        ChangeNotifierProvider<OwnerFoodViewModel>(
          create: (_) => FirebaseDependencyContainer.createOwnerFoodViewModel(),
        ),

        // Owner MyGuest - Guest, booking, and payment management
        ChangeNotifierProvider<OwnerGuestViewModel>(
          create: (_) =>
              FirebaseDependencyContainer.createOwnerGuestViewModel(),
        ),

        // Owner MyPG - PG property and bed management
        ChangeNotifierProvider<OwnerPgManagementViewModel>(
          create: (_) =>
              FirebaseDependencyContainer.createOwnerPgManagementViewModel(),
        ),

        // Owner Overview - Dashboard with statistics and analytics
        ChangeNotifierProvider<OwnerOverviewViewModel>(
          create: (_) =>
              FirebaseDependencyContainer.createOwnerOverviewViewModel(),
        ),
      ];

  /// Wraps the app with MultiProvider using all Firebase providers
  /// 
  /// [localeProvider] - Optional pre-initialized LocaleProvider.
  /// If provided, uses this instance instead of creating a new one.
  static Widget buildWithProviders({
    required Widget child,
    LocaleProvider? localeProvider,
  }) {
    final providersList = List<ChangeNotifierProvider>.from(providers);
    
    // Replace LocaleProvider if a pre-initialized one is provided
    if (localeProvider != null) {
      final localeProviderIndex = providersList.indexWhere(
        (provider) => provider is ChangeNotifierProvider<LocaleProvider>,
      );
      if (localeProviderIndex != -1) {
        providersList[localeProviderIndex] = ChangeNotifierProvider<LocaleProvider>.value(
          value: localeProvider,
        );
      }
    }
    
    return MultiProvider(
      providers: providersList,
      child: child,
    );
  }
}
