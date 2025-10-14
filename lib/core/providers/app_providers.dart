// // lib/core/app_setup/providers/app_providers.dart
//
// // Auth provider
// import 'package:atitia/feature/auth/logic/auth_provider.dart';
// // Core imports
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// // Guest-related providers
// import '../../../feature/guest_dashboard/complaints/viewmodel/guest_complaint_viewmodel.dart';
// import '../../../feature/guest_dashboard/foods/viewmodel/guest_food_viewmodel.dart';
// import '../../../feature/guest_dashboard/payments/viewmodel/guest_payment_viewmodel.dart';
// import '../../../feature/guest_dashboard/pgs/viewmodel/guest_pg_viewmodel.dart';
// import '../../../feature/guest_dashboard/profile/viewmodel/guest_profile_viewmodel.dart';
// // Owner dashboard providers
// import '../../../feature/owner_dashboard/foods/viewmodel/owner_food_viewmodel.dart';
// import '../../../feature/owner_dashboard/myguest/viewmodel/owner_guest_viewmodel.dart';
// import '../../../feature/owner_dashboard/mypg/viewmodel/owner_pg_management_viewmodel.dart';
// import '../../../feature/owner_dashboard/overview/viewmodel/owner_overview_view_model.dart';
// import '../../../feature/owner_dashboard/profile/viewmodel/owner_profile_viewmodel.dart';
// // Core providers
// import '../app/localization/locale_provider.dart';
// import '../app/theme/theme_provider.dart';
//
// /// Centralized provider configuration for the entire application.
// ///
// /// This file contains all providers used across the app to keep main.dart clean
// /// and provide a single source of truth for dependency injection.
// /// ALL ViewModels use GetIt for dependencies - NO PARAMETERS in constructors.
// class AppProviders {
//   /// Returns the list of all providers used in the application
//   /// All ViewModels have parameterless constructors - dependencies via GetIt
//   static List<ChangeNotifierProvider<ChangeNotifier>> get providers => [
//         // Core providers (theme & locale)
//         ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
//         ChangeNotifierProvider<LocaleProvider>(create: (_) => LocaleProvider()),
//
//         // Auth provider
//         ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
//
//         // Guest-related providers - NO PARAMETERS
//         ChangeNotifierProvider<GuestProfileViewModel>(
//             create: (_) => GuestProfileViewModel()),
//         ChangeNotifierProvider<GuestComplaintViewModel>(
//             create: (_) => GuestComplaintViewModel()),
//         ChangeNotifierProvider<GuestPaymentViewModel>(
//             create: (_) => GuestPaymentViewModel()),
//         ChangeNotifierProvider<GuestFoodViewmodel>(
//             create: (_) => GuestFoodViewmodel()),
//         ChangeNotifierProvider<GuestPgViewmodel>(
//             create: (_) => GuestPgViewmodel()),
//
//         // Owner dashboard providers - NO PARAMETERS
//         ChangeNotifierProvider<OwnerFoodViewModel>(
//             create: (_) => OwnerFoodViewModel()),
//         ChangeNotifierProvider<OwnerOverviewViewModel>(
//             create: (_) => OwnerOverviewViewModel()),
//         ChangeNotifierProvider<OwnerPgManagementViewModel>(
//             create: (_) => OwnerPgManagementViewModel()),
//         ChangeNotifierProvider<OwnerGuestViewModel>(
//             create: (_) => OwnerGuestViewModel()),
//         ChangeNotifierProvider<OwnerProfileViewModel>(
//             create: (_) => OwnerProfileViewModel()),
//
//         // ALL providers now have parameterless constructors
//         // Dependencies are accessed via GetIt service locator
//       ];
//
//   /// Creates a MultiProvider widget with all application providers
//   static Widget buildWithProviders({required Widget child}) {
//     return MultiProvider(
//       providers: providers,
//       child: child,
//     );
//   }
// }
//
// class AppProviders {
//   static List<ChangeNotifierProvider<ChangeNotifier>> get providers => [
//         // Core providers
//         ChangeNotifierProvider<ThemeProvider>(
//             create: (_) => DependencyContainer.createThemeProvider()),
//         ChangeNotifierProvider<LocaleProvider>(
//             create: (_) => DependencyContainer.createLocaleProvider()),
//
//         // Auth provider
//         ChangeNotifierProvider<AuthProvider>(
//             create: (_) => DependencyContainer.createAuthViewModel()),
//
//         // Guest providers - CLEAN one-liners
//         ChangeNotifierProvider<GuestProfileViewModel>(
//             create: (_) => DependencyContainer.createGuestProfileViewModel()),
//         ChangeNotifierProvider<GuestComplaintViewModel>(
//             create: (_) => DependencyContainer.createGuestComplaintViewModel()),
//         ChangeNotifierProvider<GuestPaymentViewModel>(
//             create: (_) => DependencyContainer.createGuestPaymentViewModel()),
//         ChangeNotifierProvider<GuestFoodViewmodel>(
//             create: (_) => DependencyContainer.createGuestFoodViewModel()),
//         ChangeNotifierProvider<GuestPgViewmodel>(
//             create: (_) => DependencyContainer.createGuestPgViewModel()),
//
//         // Owner providers - CLEAN one-liners
//         ChangeNotifierProvider<OwnerFoodViewModel>(
//             create: (_) => DependencyContainer.createOwnerFoodViewModel()),
//         ChangeNotifierProvider<OwnerOverviewViewModel>(
//             create: (_) => DependencyContainer.createOwnerOverviewViewModel()),
//         ChangeNotifierProvider<OwnerPgManagementViewModel>(
//             create: (_) =>
//                 DependencyContainer.createOwnerPgManagementViewModel()),
//         ChangeNotifierProvider<OwnerGuestViewModel>(
//             create: (_) => DependencyContainer.createOwnerGuestViewModel()),
//         ChangeNotifierProvider<OwnerProfileViewModel>(
//             create: (_) => DependencyContainer.createOwnerProfileViewModel()),
//       ];
//
//   static Widget buildWithProviders({required Widget child}) {
//     return MultiProvider(
//       providers: providers,
//       child: child,
//     );
//   }
// }
