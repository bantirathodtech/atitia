// lib/features/guest_dashboard/guest_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

import '../../core/di/firebase/di/firebase_service_locator.dart';
import '../../common/styles/colors.dart';
import '../../common/utils/logging/logging_helper.dart';
import '../../common/utils/responsive/responsive_system.dart';
import '../../l10n/app_localizations.dart';
// import '../auth/logic/auth_provider.dart';
import 'complaints/view/screens/guest_complaint_list_screen.dart';
import 'foods/view/screens/guest_food_list_screen.dart';
import 'payments/view/screens/guest_payment_screen.dart';
import 'pgs/view/screens/guest_pg_list_screen.dart';
import 'pgs/view/screens/guest_booking_requests_screen.dart';

/// Main dashboard screen for guest users with bottom navigation
///
/// Features:
/// - 4-tab navigation (PGs, Foods, Payments, Complaints)
/// - IndexedStack for tab state preservation
/// - Uses ViewModels already registered in AppProviders
/// - Automatic data loading handled within each screen
/// - Consistent navigation patterns throughout
/// - Profile accessible via drawer navigation
class GuestDashboardScreen extends StatefulWidget {
  const GuestDashboardScreen({super.key});

  @override
  State<GuestDashboardScreen> createState() => _GuestDashboardScreenState();
}

class _GuestDashboardScreenState extends State<GuestDashboardScreen> {
  int _currentIndex = 0;
  final _analyticsService = getIt.analytics;

  // Tab screens - No Provider wrapping needed since ViewModels are in AppProviders
  final List<Widget> _tabs = const [
    GuestPgListScreen(), // PG Listings Tab
    GuestFoodListScreen(), // Food Menu Tab
    GuestPaymentScreen(), // Payments History Tab
    GuestBookingRequestsScreen(), // Booking Requests Tab
    GuestComplaintsListScreen(), // Complaints & Requests Tab
  ];

  @override
  void initState() {
    super.initState();

    // Log screen view
    LoggingHelper.logScreenView('Guest Dashboard', feature: 'guest_dashboard');

    // Track dashboard view
    _analyticsService.logEvent(
      name: 'guest_dashboard_viewed',
      parameters: {},
    );
  }

  /// Checks if we're currently on a detail/full-screen route
  bool _isOnDetailRoute(String location) {
    if (location.contains('/complaints/add') ||
        location.contains('/profile') ||
        location.contains('/notifications') ||
        location.contains('/room-bed')) {
      return true; // These are full-screen routes
    }

    // Check path segments: /guest/pgs/:pgId = 4+ segments, /guest/pgs = 3 segments
    final pathSegments =
        location.split('/').where((s) => s.isNotEmpty).toList();

    // Detail routes have 4+ segments: /guest/pgs/:pgId or /guest/payments/:paymentId
    if (pathSegments.length >= 4) {
      if (pathSegments.length >= 3 && pathSegments[0] == 'guest') {
        // Check if it's a detail route under pgs or payments
        if ((pathSegments[1] == 'pgs' &&
                !location.endsWith('/pgs') &&
                !location.endsWith('/pgs/')) ||
            (pathSegments[1] == 'payments' &&
                !location.endsWith('/payments') &&
                !location.endsWith('/payments/'))) {
          return true; // This is a detail route
        }
      }
    }
    return false;
  }

  /// Updates the current tab index based on the current route
  void _updateTabFromRoute() {
    if (!mounted) return;

    final router = GoRouter.of(context);
    String location;
    try {
      location = router.routerDelegate.currentConfiguration.uri.toString();
    } catch (e) {
      try {
        // Try alternative way to get location
        final navService = getIt.navigation;
        location = navService.getCurrentLocation();
      } catch (e2) {
        return; // Can't determine location, skip update
      }
    }

    // Skip update if we're on a detail screen - these should not trigger tab updates
    if (_isOnDetailRoute(location)) {
      return;
    }

    // Map routes to tab indices - default to PGs tab (0)
    int newIndex = 0;
    if (location.contains('/pgs') ||
        location == '/guest' ||
        location == '/guest/' ||
        location.isEmpty) {
      newIndex = 0; // PGs tab
    } else if (location.contains('/foods')) {
      newIndex = 1; // Foods tab
    } else if (location.contains('/payments')) {
      newIndex = 2; // Payments tab
    } else if (location.contains('/requests')) {
      newIndex = 3; // Requests tab
    } else if (location.contains('/complaints')) {
      newIndex = 4; // Complaints tab
    }

    // Only update if different to avoid unnecessary rebuilds
    if (newIndex != _currentIndex && mounted) {
      _setTabIndex(newIndex, silent: true);
    }
  }

  /// Sets the tab index (with optional silent flag to skip logging)
  void _setTabIndex(int index, {bool silent = false}) {
    if (_currentIndex == index) return;

    final oldIndex = _currentIndex;
    setState(() {
      _currentIndex = index;
    });

    if (!silent) {
      final tabNames = ['pgs', 'foods', 'payments', 'requests', 'complaints'];

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

      // Track tab navigation
      _analyticsService.logEvent(
        name: 'guest_tab_changed',
        parameters: {
          'tab_name': tabNames[index],
          'tab_index': index,
        },
      );
    }
  }

  /// Handles bottom navigation tab selection
  /// Updates current index to switch between tab views
  void _onTabSelected(int index) {
    // Prevent switching to same tab
    if (_currentIndex == index) return;

    // Update tab index immediately to change the IndexedStack
    _setTabIndex(index);

    // Navigate to the appropriate route to maintain URL consistency
    final router = GoRouter.of(context);
    final tabRoutes = [
      '/guest/pgs',
      '/guest/foods',
      '/guest/payments',
      '/guest/requests',
      '/guest/complaints'
    ];

    if (index < tabRoutes.length) {
      final targetRoute = tabRoutes[index];
      // Always navigate to ensure URL is correct
      router.go(targetRoute);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update tab index when route changes (e.g., coming back from detail screen)
    // But only if we're not on a detail screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          final navService = getIt.navigation;
          final currentLocation = navService.getCurrentLocation();
          // Don't update if on detail screen - it will cause navigation issues
          if (!_isOnDetailRoute(currentLocation)) {
            _updateTabFromRoute();
          }
        } catch (e) {
          // If we can't check, skip update to be safe
        }
      }
    });
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
                  child: IndexedStack(
                    index: _currentIndex,
                    children: _tabs,
                  ),
                ),
              ],
            )
          : IndexedStack(
              index: _currentIndex,
              children: _tabs,
            ),

      // Bottom navigation only for mobile/portrait
      bottomNavigationBar:
          isTabletLandscape ? null : _buildResponsiveBottomNavigationBar(),
    );
  }

  /// Builds the responsive bottom navigation bar with premium theme-aware styling
  Widget _buildResponsiveBottomNavigationBar() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Semantics(
      label: 'Main navigation',
      hint: 'Use tabs to navigate between different sections',
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor:
            Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 11,
        ),
        elevation: 8,
        backgroundColor:
            isDarkMode ? AppColors.darkCard : theme.scaffoldBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.apartment),
            activeIcon: const Icon(Icons.apartment_outlined),
            label: loc?.pgs ?? 'PGs',
            tooltip: loc?.browsePgAccommodations ?? 'Browse PG Accommodations',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu),
            activeIcon: const Icon(Icons.restaurant),
            label: loc?.foods ?? 'Foods',
            tooltip: loc?.viewFoodMenu ?? 'View Food Menu',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.payment),
            activeIcon: const Icon(Icons.payment_outlined),
            label: loc?.payments ?? 'Payments',
            tooltip: loc?.paymentHistory ?? 'Payment History',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.request_page),
            activeIcon: const Icon(Icons.request_page_outlined),
            label: loc?.requests ?? 'Requests',
            tooltip: loc?.bookingRequests ?? 'Booking Requests',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.report_problem),
            activeIcon: const Icon(Icons.report_problem_outlined),
            label: loc?.complaints ?? 'Complaints',
            tooltip: loc?.complaintsAndRequests ?? 'Complaints & Requests',
          ),
        ],
      ),
    );
  }

  /// Builds navigation rail for tablet landscape mode
  Widget? _buildNavigationRail() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Semantics(
      label: 'Main navigation',
      hint: 'Use navigation rail to navigate between different sections',
      child: NavigationRail(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabSelected,
        backgroundColor:
            isDarkMode ? AppColors.darkCard : theme.scaffoldBackgroundColor,
        selectedIconTheme: IconThemeData(
          color: theme.primaryColor,
          size: 28,
        ),
        unselectedIconTheme: IconThemeData(
          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          size: 24,
        ),
        selectedLabelTextStyle: TextStyle(
          color: theme.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        labelType: NavigationRailLabelType.all,
        destinations: [
          NavigationRailDestination(
            icon: const Icon(Icons.apartment_outlined),
            selectedIcon: const Icon(Icons.apartment),
            label: Text(loc?.pgs ?? 'PGs'),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.restaurant_menu),
            selectedIcon: const Icon(Icons.restaurant),
            label: Text(loc?.foods ?? 'Foods'),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.payment_outlined),
            selectedIcon: const Icon(Icons.payment),
            label: Text(loc?.payments ?? 'Payments'),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.book_outlined),
            selectedIcon: const Icon(Icons.book),
            label: Text(loc?.requests ?? 'Requests'),
          ),
          NavigationRailDestination(
            icon: const Icon(Icons.feedback_outlined),
            selectedIcon: const Icon(Icons.feedback),
            label: Text(loc?.complaints ?? 'Complaints'),
          ),
        ],
      ),
    );
  }
}
