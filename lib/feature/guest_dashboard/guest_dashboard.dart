// lib/features/guest_dashboard/guest_dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/di/firebase/di/firebase_service_locator.dart';
import '../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../common/widgets/navigation/app_drawer.dart';
import '../../common/styles/colors.dart';
import '../auth/logic/auth_provider.dart';
import 'complaints/view/screens/guest_complaint_list_screen.dart';
import 'foods/view/screens/guest_food_list_screen.dart';
import 'payments/view/screens/guest_payment_screen.dart';
import 'pgs/view/screens/guest_pg_list_screen.dart';
import 'profile/view/screens/guest_profile_screen.dart';

/// Main dashboard screen for guest users with bottom navigation
///
/// Features:
/// - 5-tab navigation (PGs, Foods, Payments, Complaints, Profile)
/// - IndexedStack for tab state preservation
/// - Uses ViewModels already registered in AppProviders
/// - Automatic data loading handled within each screen
/// - Consistent navigation patterns throughout
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
    GuestComplaintsListScreen(), // Complaints & Requests Tab
    GuestProfileScreen(), // Profile Management Tab
  ];

  @override
  void initState() {
    super.initState();
    // Track dashboard view
    _analyticsService.logEvent(
      name: 'guest_dashboard_viewed',
      parameters: {},
    );
  }

  /// Handles bottom navigation tab selection
  /// Updates current index to switch between tab views
  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Track tab navigation
    final tabNames = ['pgs', 'foods', 'payments', 'complaints', 'profile'];
    _analyticsService.logEvent(
      name: 'guest_tab_changed',
      parameters: {
        'tab_name': tabNames[index],
        'tab_index': index,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userName = authProvider.user?.fullName ?? 'Guest';

    return Scaffold(
      // Premium App bar with drawer and theme toggle
      appBar: AdaptiveAppBar(
        title: _getAppBarTitle(),
        showBackButton: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: 'Menu',
          ),
        ),
        actions: [
          // Notification icon (placeholder for future feature)
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => _showNotifications(context),
            tooltip: 'Notifications',
          ),
        ],
        showThemeToggle: true,
      ),

      // App Drawer with profile header
      drawer: const AppDrawer(),

      // Main content area with tab preservation
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),

      // Premium bottom navigation with theme support
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Gets dynamic app bar title based on current tab
  String _getAppBarTitle() {
    final titles = [
      'PG Accommodations',
      'Food Menu',
      'Payment History',
      'Complaints & Requests',
      'My Profile'
    ];

    return titles[_currentIndex];
  }

  /// Builds the bottom navigation bar with premium theme-aware styling
  BottomNavigationBar _buildBottomNavigationBar() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTabSelected,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: isDarkMode 
          ? AppColors.textTertiary 
          : Colors.grey.shade600,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 11,
      ),
      elevation: 8,
      backgroundColor: isDarkMode 
          ? AppColors.darkCard 
          : theme.scaffoldBackgroundColor,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          activeIcon: Icon(Icons.apartment_outlined),
          label: 'PGs',
          tooltip: 'Browse PG Accommodations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant_menu),
          activeIcon: Icon(Icons.restaurant),
          label: 'Foods',
          tooltip: 'View Food Menu',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.payment),
          activeIcon: Icon(Icons.payment_outlined),
          label: 'Payments',
          tooltip: 'Payment History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.report_problem),
          activeIcon: Icon(Icons.report_problem_outlined),
          label: 'Complaints',
          tooltip: 'Complaints & Requests',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          activeIcon: Icon(Icons.person_outline),
          label: 'Profile',
          tooltip: 'My Profile',
        ),
      ],
    );
  }

  /// Shows notifications (placeholder for future feature)
  void _showNotifications(BuildContext context) {
    _analyticsService.logEvent(
      name: 'notifications_clicked',
      parameters: {},
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifications feature coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

}
