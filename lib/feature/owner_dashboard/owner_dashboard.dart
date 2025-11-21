// lib/features/owner_dashboard/owner_dashboard.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../common/styles/theme_colors.dart';
import '../../common/utils/extensions/context_extensions.dart';
import '../../common/utils/logging/logging_helper.dart';
import '../../common/utils/responsive/responsive_system.dart';
import '../../l10n/app_localizations.dart';
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

  /// Builds the responsive bottom navigation bar with premium theme-aware styling
  Widget _buildResponsiveBottomNavigationBar() {
    final loc = AppLocalizations.of(context);

    return Semantics(
      label: 'Main navigation',
      hint: 'Use tabs to navigate between different sections',
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedItemColor: context.primaryColor,
        unselectedItemColor: ThemeColors.getTextTertiary(context),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 11,
        ),
        elevation: 8,
        backgroundColor: ThemeColors.getCardBackground(context),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: loc?.overview ?? "Overview",
            tooltip: loc?.overview ?? "View dashboard overview",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu),
            activeIcon: const Icon(Icons.restaurant),
            label: loc?.food ?? "Food",
            tooltip: loc?.food ?? "Manage food menu",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: loc?.pgs ?? "PGs",
            tooltip: loc?.pgs ?? "Manage paying guest properties",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline),
            activeIcon: const Icon(Icons.people),
            label: loc?.guests ?? "Guests",
            tooltip: loc?.guests ?? "Manage guests",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsiveConfig = ResponsiveSystem.getConfig(context);
    final isTabletLandscape = responsiveConfig.isTablet &&
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      // Responsive body: Navigation rail + content for tablet landscape, content only for mobile/portrait
      body: isTabletLandscape
          ? Row(
              children: [
                _buildNavigationRail()!,
                Expanded(
                  child: Stack(
                    children: [
                      // Main content
                      IndexedStack(index: _currentIndex, children: _tabs),
                      // Floating payment notifications badge
                      const OwnerPaymentNotificationsBadge(),
                    ],
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                // Main content
                IndexedStack(index: _currentIndex, children: _tabs),
                // Floating payment notifications badge
                const OwnerPaymentNotificationsBadge(),
              ],
            ),

      // Bottom navigation only for mobile/portrait
      bottomNavigationBar:
          isTabletLandscape ? null : _buildResponsiveBottomNavigationBar(),
    );
  }

  /// Builds navigation rail for tablet landscape mode
  Widget? _buildNavigationRail() {
    final loc = AppLocalizations.of(context);

    return Semantics(
      label: 'Main navigation',
      hint: 'Use navigation rail to navigate between different sections',
      child: NavigationRail(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        backgroundColor: ThemeColors.getCardBackground(context),
        selectedIconTheme: IconThemeData(
          color: context.primaryColor,
          size: 28,
        ),
        unselectedIconTheme: IconThemeData(
          color: ThemeColors.getTextTertiary(context),
          size: 24,
        ),
        selectedLabelTextStyle: TextStyle(
          color: context.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: ThemeColors.getTextTertiary(context),
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        labelType: NavigationRailLabelType.all,
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: Text(loc?.overview ?? 'Overview'),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.restaurant_menu),
            selectedIcon: const Icon(Icons.restaurant),
            label: Text(loc?.food ?? 'Food'),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: Text(loc?.pgs ?? 'PGs'),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: Text(loc?.guests ?? 'Guests'),
          ),
        ],
      ),
    );
  }
}
