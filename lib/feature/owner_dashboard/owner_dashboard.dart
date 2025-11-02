// lib/features/owner_dashboard/owner_dashboard.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../common/styles/colors.dart';
import '../../common/utils/logging/logging_helper.dart';
import '../auth/logic/auth_provider.dart';
import 'shared/viewmodel/selected_pg_provider.dart';
import 'shared/widgets/owner_payment_notifications_badge.dart';

// Owner dashboard screens
import 'foods/view/screens/owner_food_management_screen.dart';
import 'guests/view/screens/owner_guest_management_screen.dart';
import 'mypg/presentation/screens/owner_pg_management_screen.dart';
import 'overview/view/screens/owner_overview_screen.dart';

/// Owner Dashboard Screen with bottom navigation
///
/// Uses Provider for ALL ViewModel access - NO PARAMETERS in tab initialization
/// All ViewModels are already registered in AppProviders and use GetIt for dependencies
///
/// Now includes PG Selector for multi-PG management
class OwnerDashboardScreen extends StatefulWidget {
  // NO constructor parameters - uses Provider for everything
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  int _currentIndex = 0;
  bool _pgInitRequested =
      false; // ensure we initialize PGs only once per session

  // Tab screens - ALL use Provider for ViewModel access, NO parameters
  final List<Widget> _tabs = const [
    OwnerOverviewScreen(), // ViewModel from Provider
    OwnerFoodManagementScreen(), // ViewModel from Provider
    OwnerPgManagementScreen(), // ViewModel from Provider
    OwnerGuestManagementScreen(), // ViewModel from Provider
    // OwnerProfileScreen(), // REMOVED - Profile tab removed from bottom nav
  ];

  @override
  void initState() {
    super.initState();

    // Log screen view
    LoggingHelper.logScreenView('Owner Dashboard', feature: 'owner_dashboard');

    // Initialize PG selector with owner's PGs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final selectedPgProvider = Provider.of<SelectedPgProvider>(
        context,
        listen: false,
      );

      void tryInitializePgs() async {
        if (_pgInitRequested) return;
        final ownerId = authProvider.user?.userId;
        final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;
        if (ownerId != null && ownerId.isNotEmpty && firebaseUser != null) {
          _pgInitRequested = true;
          // Load PGs from Firebase
          await selectedPgProvider.initializeForOwner(ownerId);

          LoggingHelper.logOwnerAction(
            'Initialize PGs',
            pgId: ownerId,
          );
        }
      }

      // Try immediately (cold starts after login), otherwise wait for auth to be ready
      tryInitializePgs();
      if (!_pgInitRequested) {
        authProvider.addListener(() {
          tryInitializePgs();
        });
      }
    });
  }

  /// Handles bottom navigation tab changes
  void _onTabTapped(int index) {
    final oldIndex = _currentIndex;
    final tabNames = ['overview', 'foods', 'pgs', 'guests'];

    setState(() {
      _currentIndex = index;
    });

    // Log tab navigation
    LoggingHelper.logNavigation(
      tabNames[oldIndex],
      tabNames[index],
      metadata: {
        'oldIndex': oldIndex,
        'newIndex': index,
        'tabName': tabNames[index],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack preserves state of all tabs
      body: Stack(
        children: [
          // Main content
          IndexedStack(index: _currentIndex, children: _tabs),
          // Floating payment notifications badge
          const OwnerPaymentNotificationsBadge(),
        ],
      ),

      // Bottom navigation bar with theme support
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: AppColors.textOnPrimary, // White when selected
        unselectedItemColor: AppColors.textOnPrimary.withValues(
          alpha: 0.7,
        ), // Semi-transparent white
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Overview",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Food",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "PGs"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Guests"),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: "Profile",
          // ), // REMOVED - Profile tab removed from bottom nav
        ],
      ),
    );
  }
}
