// lib/features/owner_dashboard/foods/view/screens/owner_food_management_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../../shared/widgets/pg_selector_dropdown.dart';
import '../../../shared/widgets/owner_drawer.dart';
import '../../viewmodel/owner_food_viewmodel.dart';
import '../widgets/owner_menu_day_tab.dart';
import '../widgets/premium_food_header_widget.dart';
import 'owner_special_menu_screen.dart';

/// Screen for owner to manage food menus for all days of the week
/// Uses OwnerFoodViewModel for data management and state
/// Provides weekly menu management with day-wise tabs and override functionality
///
/// Multi-PG Support:
/// - Shows PG selector for food management
/// - Displays PG-specific menus
/// - Allows switching between PGs for food management
class OwnerFoodManagementScreen extends StatefulWidget {
  const OwnerFoodManagementScreen({super.key});

  @override
  State<OwnerFoodManagementScreen> createState() =>
      _OwnerFoodManagementScreenState();
}

class _OwnerFoodManagementScreenState extends State<OwnerFoodManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  SelectedPgProvider? _selectedPgProvider;

  // Track last loaded PG for auto-reload optimization
  String? _lastLoadedPgId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _setupPgSelectionListener();
      await _loadInitialMenus();
    });

    // Track tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
        final foodVM = context.read<OwnerFoodViewModel>();
        final weekdays = foodVM.weekdays;
        foodVM.setSelectedDay(weekdays[_tabController.index]);
      }
    });
  }

  /// Setup PG selection listener for auto-reload
  Future<void> _setupPgSelectionListener() async {
    _selectedPgProvider = context.read<SelectedPgProvider>();
    _selectedPgProvider!.addListener(_onPgSelectionChanged);
  }

  /// Load initial menus on screen load
  Future<void> _loadInitialMenus() async {
    final authProvider = context.read<AuthProvider>();
    final selectedPgProvider = context.read<SelectedPgProvider>();
    final ownerId = authProvider.user?.userId ?? '';
    final currentPgId = selectedPgProvider.selectedPgId;

    if (ownerId.isNotEmpty && currentPgId != null) {
      _lastLoadedPgId = currentPgId;
      final foodVM = context.read<OwnerFoodViewModel>();
      await foodVM.autoReloadIfNeeded(ownerId, pgId: currentPgId);
    }
  }

  /// Handle PG selection changes
  void _onPgSelectionChanged() {
    final authProvider = context.read<AuthProvider>();
    final selectedPgProvider = context.read<SelectedPgProvider>();
    final ownerId = authProvider.user?.userId ?? '';
    final currentPgId = selectedPgProvider.selectedPgId;

    // Only reload if PG actually changed
    if (currentPgId != null && currentPgId != _lastLoadedPgId) {
      _lastLoadedPgId = currentPgId;
      final foodVM = context.read<OwnerFoodViewModel>();
      foodVM.autoReloadIfNeeded(ownerId, pgId: currentPgId);
    }
  }

  @override
  void dispose() {
    // Clean up PG selection listener
    try {
      _selectedPgProvider?.removeListener(_onPgSelectionChanged);
    } catch (e) {
    }

    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodVM = context.watch<OwnerFoodViewModel>();
    final authProvider = context.watch<AuthProvider>();
    final selectedPgProvider = context.watch<SelectedPgProvider>();
    final ownerId = authProvider.user?.userId ?? '';
    final currentPgId = selectedPgProvider.selectedPgId;

    return Scaffold(
      appBar: AdaptiveAppBar(
        // Center: PG Selector dropdown
        titleWidget: const PgSelectorDropdown(compact: true),
        centerTitle: true,

        // Left: Drawer button
        showDrawer: true,

        // Right: Create PG Menu + Special Menu + Refresh buttons
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            onPressed: () => _showInitializeMenusDialog(
                context, foodVM, ownerId, currentPgId),
            tooltip: 'Create PG Menus',
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _showSpecialMenuOptions(context, foodVM, ownerId),
            tooltip: 'Special Menus',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => foodVM.refreshMenus(ownerId, pgId: currentPgId),
            tooltip: 'Refresh Menus',
          ),
        ],

        // Bottom: Premium food header with dynamic tab support
        bottom: PremiumFoodHeaderWidget(
          currentTabIndex: _currentTabIndex,
          tabController: _tabController,
        ),

        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Owner Drawer
      drawer: const OwnerDrawer(),

      body: _buildBody(context, foodVM, ownerId, currentPgId),
    );
  }

  /// Builds appropriate body content based on current state
  Widget _buildBody(BuildContext context, OwnerFoodViewModel foodVM,
      String ownerId, String? currentPgId) {
    if (foodVM.loading && foodVM.weeklyMenus.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AdaptiveLoader(),
            const SizedBox(height: AppSpacing.paddingM),
            const BodyText(text: 'Loading menus...'),
          ],
        ),
      );
    }

    if (foodVM.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSpacing.paddingM),
            const BodyText(text: 'Failed to load menus'),
            const SizedBox(height: AppSpacing.paddingM),
            PrimaryButton(
              label: 'Retry',
              onPressed: () => foodVM.refreshMenus(ownerId, pgId: currentPgId),
            ),
          ],
        ),
      );
    }

    if (foodVM.weeklyMenus.isEmpty) {
      return _buildEmptyState(context, foodVM, ownerId, currentPgId);
    }

    return TabBarView(
      controller: _tabController,
      children: [
        OwnerMenuDayTab(dayLabel: 'Monday'),
        OwnerMenuDayTab(dayLabel: 'Tuesday'),
        OwnerMenuDayTab(dayLabel: 'Wednesday'),
        OwnerMenuDayTab(dayLabel: 'Thursday'),
        OwnerMenuDayTab(dayLabel: 'Friday'),
        OwnerMenuDayTab(dayLabel: 'Saturday'),
        OwnerMenuDayTab(dayLabel: 'Sunday'),
      ],
    );
  }

  /// Builds empty state when no menus exist
  Widget _buildEmptyState(BuildContext context, OwnerFoodViewModel foodVM,
      String ownerId, String? currentPgId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
          const SizedBox(height: AppSpacing.paddingM),
          const HeadingMedium(text: 'No PG Menus Found'),
          const SizedBox(height: AppSpacing.paddingS),
          const BodyText(
            text: 'Create weekly menus for this PG to get started',
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          const BodyText(
            text:
                'Use the "Create PG Menus" button in the app bar to get started',
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Shows dialog to initialize default menus
  void _showInitializeMenusDialog(BuildContext context,
      OwnerFoodViewModel foodVM, String ownerId, String? currentPgId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create PG Weekly Menus'),
        content: const Text(
          'This will create default menu templates for all 7 days of the week for this PG. You can edit them later.',
        ),
        actions: [
          SecondaryButton(
            label: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
          PrimaryButton(
            label: 'Initialize',
            onPressed: () async {
              Navigator.of(context).pop();
              await _initializeDefaultMenus(foodVM, ownerId, currentPgId);
            },
          ),
        ],
      ),
    );
  }

  /// Initializes default menus for all days
  Future<void> _initializeDefaultMenus(
      OwnerFoodViewModel foodVM, String ownerId, String? currentPgId) async {
    try {
      await foodVM.initializeDefaultMenus(ownerId, pgId: currentPgId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Default menus initialized successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize menus: $e')),
        );
      }
    }
  }

  /// Shows special menu options dialog
  void _showSpecialMenuOptions(
      BuildContext context, OwnerFoodViewModel foodVM, String ownerId) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HeadingMedium(text: 'Special Menu Options'),
            const SizedBox(height: AppSpacing.paddingM),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Add Festival Menu'),
              subtitle: const Text('Create special menu for festivals'),
              onTap: () {
                Navigator.pop(context);
                _navigateToSpecialMenuScreen(context, 'festival');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Add Event Menu'),
              subtitle: const Text('Create special menu for events'),
              onTap: () {
                Navigator.pop(context);
                _navigateToSpecialMenuScreen(context, 'event');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('View All Special Menus'),
              subtitle: const Text('Manage existing special menus'),
              onTap: () {
                Navigator.pop(context);
                _navigateToSpecialMenuScreen(context, 'manage');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Navigates to special menu screen
  void _navigateToSpecialMenuScreen(BuildContext context, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OwnerSpecialMenuScreen(),
      ),
    );
  }
}
