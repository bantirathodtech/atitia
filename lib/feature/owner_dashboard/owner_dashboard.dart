// lib/features/owner_dashboard/owner_dashboard.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/styles/colors.dart';
import '../auth/logic/auth_provider.dart';
import 'shared/viewmodel/selected_pg_provider.dart';
import 'shared/widgets/owner_payment_notifications_badge.dart';

// Owner dashboard screens
import 'foods/view/screens/owner_food_management_screen.dart';
import 'myguest/view/screens/owner_guest_screen.dart';
import 'mypg/presentation/screens/owner_pg_management_screen.dart';
import 'overview/view/screens/owner_overview_screen.dart';
import 'profile/view/screens/owner_profile_screen.dart';

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

  // Tab screens - ALL use Provider for ViewModel access, NO parameters
  final List<Widget> _tabs = const [
    OwnerOverviewScreen(), // ViewModel from Provider
    OwnerFoodManagementScreen(), // ViewModel from Provider
    OwnerPgManagementScreen(), // ViewModel from Provider
    OwnerGuestScreen(), // ViewModel from Provider
    OwnerProfileScreen(), // ViewModel from Provider
  ];

  @override
  void initState() {
    super.initState();
    // Initialize PG selector with owner's PGs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final selectedPgProvider =
          Provider.of<SelectedPgProvider>(context, listen: false);

      final ownerId = authProvider.user?.userId;
      if (ownerId != null && ownerId.isNotEmpty) {
        selectedPgProvider.initializeForOwner(ownerId);
      }
    });
  }

  /// Handles bottom navigation tab changes
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedPgProvider = Provider.of<SelectedPgProvider>(context);
    final theme = Theme.of(context);

    // Tab titles for app bar
    final tabTitles = ['Overview', 'Food Menu', 'My PGs', 'Guests', 'Profile'];

    return Scaffold(
      // No app bar here - each tab has its own app bar with PG selector
      // IndexedStack preserves state of all tabs
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: _currentIndex,
            children: _tabs,
          ),
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
        unselectedItemColor:
            AppColors.textOnPrimary.withOpacity(0.7), // Semi-transparent white
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "PGs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Guests",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
