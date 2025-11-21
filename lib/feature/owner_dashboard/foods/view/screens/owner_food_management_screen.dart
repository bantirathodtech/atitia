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
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../l10n/app_localizations.dart';
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
      debugPrint('⚠️ Owner Food Management: Failed to remove listener: $e');
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
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AdaptiveAppBar(
        // Center: PG Selector dropdown
        titleWidget: const PgSelectorDropdown(compact: true),
        centerTitle: true,
        
        // Theme-aware background color
        backgroundColor: context.colors.surface,

        // Left: Drawer button
        showDrawer: true,

        // Right: Create PG Menu + Special Menu + Refresh buttons
        actions: [
          IconButton(
            icon: const Icon(Icons.restaurant_menu),
            onPressed: () => _showInitializeMenusDialog(
                context, foodVM, ownerId, currentPgId),
            tooltip: loc.createPgMenus,
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _showSpecialMenuOptions(context, foodVM, ownerId),
            tooltip: loc.specialMenus,
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
    final loc = AppLocalizations.of(context)!;
    if (foodVM.loading && foodVM.weeklyMenus.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AdaptiveLoader(),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(text: loc.loadingMenus),
          ],
        ),
      );
    }

    if (foodVM.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline,
                size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(text: loc.failedToLoadMenus),
            const SizedBox(height: AppSpacing.paddingM),
            PrimaryButton(
              label: loc.retry,
              onPressed: () => foodVM.refreshMenus(ownerId, pgId: currentPgId),
            ),
          ],
        ),
      );
    }

    if (foodVM.weeklyMenus.isEmpty) {
      return _buildEmptyState(context, foodVM, ownerId, currentPgId);
    }

    // TabBarView - Scaffold automatically positions body below app bar (including bottom widget)
    return TabBarView(
      controller: _tabController,
      children: [
        OwnerMenuDayTab(dayLabel: loc.monday),
        OwnerMenuDayTab(dayLabel: loc.tuesday),
        OwnerMenuDayTab(dayLabel: loc.wednesday),
        OwnerMenuDayTab(dayLabel: loc.thursday),
        OwnerMenuDayTab(dayLabel: loc.friday),
        OwnerMenuDayTab(dayLabel: loc.saturday),
        OwnerMenuDayTab(dayLabel: loc.sunday),
      ],
    );
  }

  /// Builds empty state when no menus exist
  Widget _buildEmptyState(BuildContext context, OwnerFoodViewModel foodVM,
      String ownerId, String? currentPgId) {
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu,
              size: 64,
              color: ThemeColors.getTextTertiary(context).withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.paddingM),
          HeadingMedium(text: loc.noPgMenusFound),
          const SizedBox(height: AppSpacing.paddingS),
          BodyText(
            text: loc.createWeeklyMenusForThisPg,
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          BodyText(
            text: loc.useCreatePgMenusButton,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Shows dialog to initialize default menus
  void _showInitializeMenusDialog(BuildContext context,
      OwnerFoodViewModel foodVM, String ownerId, String? currentPgId) {
    final loc = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(text: loc.createPgWeeklyMenus),
              const SizedBox(height: AppSpacing.paddingM),
              BodyText(text: loc.thisWillCreateDefaultMenuTemplates),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SecondaryButton(
                    label: loc.cancel,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  PrimaryButton(
                    label: loc.initialize,
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _initializeDefaultMenus(foodVM, ownerId, currentPgId);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Initializes default menus for all days
  Future<void> _initializeDefaultMenus(
      OwnerFoodViewModel foodVM, String ownerId, String? currentPgId) async {
    final loc = AppLocalizations.of(context)!;
    try {
      await foodVM.initializeDefaultMenus(ownerId, pgId: currentPgId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.defaultMenusInitializedSuccessfully),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loc.failedToInitializeMenusWithError(e.toString()),
            ),
          ),
        );
      }
    }
  }

  /// Shows special menu options dialog
  void _showSpecialMenuOptions(
      BuildContext context, OwnerFoodViewModel foodVM, String ownerId) {
    final loc = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeadingMedium(text: loc.specialMenuOptions),
            const SizedBox(height: AppSpacing.paddingM),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(loc.addFestivalMenu),
              subtitle: Text(loc.createSpecialMenuForFestivals),
              onTap: () {
                Navigator.pop(context);
                _navigateToSpecialMenuScreen(context, 'festival');
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: Text(loc.addEventMenu),
              subtitle: Text(loc.createSpecialMenuForEvents),
              onTap: () {
                Navigator.pop(context);
                _navigateToSpecialMenuScreen(context, 'event');
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: Text(loc.viewAllSpecialMenus),
              subtitle: Text(loc.manageExistingSpecialMenus),
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
