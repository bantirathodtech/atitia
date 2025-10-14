// // lib/features/owner_dashboard/foods/view/screens/owner_food_management_screen.dart
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../../common/styles/spacing.dart';
// import '../../../../../common/widgets/buttons/primary_button.dart';
// import '../../../../../common/widgets/cards/adaptive_card.dart';
// import '../../../../../common/widgets/indicators/empty_state.dart';
// import '../../../../../common/widgets/loaders/adaptive_loader.dart';
// import '../../../../../common/widgets/text/body_text.dart';
// import '../../../../../common/widgets/text/heading_medium.dart';
// import '../../../../auth/logic/auth_provider.dart';
// import '../../viewmodel/owner_food_viewmodel.dart';
// import '../widgets/owner_menu_day_tab.dart';
// import 'owner_special_menu_screen.dart';
//
// /// Screen for owner to manage food menus for all days of the week
// /// Uses OwnerFoodViewModel for data management and state
// /// Provides weekly menu management with day-wise tabs and override functionality
// class OwnerFoodManagementScreen extends StatefulWidget {
//   const OwnerFoodManagementScreen({super.key});
//
//   @override
//   State<OwnerFoodManagementScreen> createState() =>
//       _OwnerFoodManagementScreenState();
// }
//
// class _OwnerFoodManagementScreenState extends State<OwnerFoodManagementScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 7, vsync: this);
//
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       final authProvider = context.read<AuthProvider>();
//       final ownerId = authProvider.user?.userId ?? '';
//
//       if (ownerId.isNotEmpty) {
//         final foodVM = context.read<OwnerFoodViewModel>();
//         if (!foodVM.loading && foodVM.weeklyMenus.isEmpty) {
//           await foodVM.loadMenus(ownerId);
//
//           // // If no menus exist, prompt to initialize default menus
//           // if (foodVM.weeklyMenus.isEmpty && mounted) {
//           //   _showInitializeMenusDialog(context, foodVM, ownerId);
//           // }
//         }
//       }
//     });
//
//     // Track tab changes
//     _tabController.addListener(() {
//       if (!_tabController.indexIsChanging) {
//         final foodVM = context.read<OwnerFoodViewModel>();
//         final weekdays = foodVM.weekdays;
//         foodVM.setSelectedDay(weekdays[_tabController.index]);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final foodVM = context.watch<OwnerFoodViewModel>();
//     final authProvider = context.watch<AuthProvider>();
//     final ownerId = authProvider.user?.userId ?? '';
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Food Menu Management'),
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//         elevation: 2,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () => foodVM.refreshMenus(ownerId),
//             tooltip: 'Refresh Menus',
//           ),
//           IconButton(
//             icon: const Icon(Icons.calendar_month),
//             onPressed: () => _showOverridesDialog(context, foodVM),
//             tooltip: 'Special Menus',
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           isScrollable: true,
//           indicatorColor: Colors.white,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white70,
//           tabs: const [
//             Tab(text: 'Monday', icon: Icon(Icons.calendar_today, size: 16)),
//             Tab(text: 'Tuesday', icon: Icon(Icons.calendar_today, size: 16)),
//             Tab(text: 'Wednesday', icon: Icon(Icons.calendar_today, size: 16)),
//             Tab(text: 'Thursday', icon: Icon(Icons.calendar_today, size: 16)),
//             Tab(text: 'Friday', icon: Icon(Icons.calendar_today, size: 16)),
//             Tab(text: 'Saturday', icon: Icon(Icons.calendar_today, size: 16)),
//             Tab(text: 'Sunday', icon: Icon(Icons.calendar_today, size: 16)),
//           ],
//         ),
//       ),
//       body: _buildBody(context, foodVM, ownerId),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () => _showAddOverrideDialog(context, foodVM, ownerId),
//         icon: const Icon(Icons.add),
//         label: const Text('Special Menu'),
//         tooltip: 'Add Special Menu for Festival/Event',
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//     );
//   }
//
//   /// Builds appropriate body content based on current state
//   Widget _buildBody(
//       BuildContext context, OwnerFoodViewModel foodVM, String ownerId) {
//     if (foodVM.loading && foodVM.weeklyMenus.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AdaptiveLoader(),
//             const SizedBox(height: AppSpacing.paddingM),
//             const BodyText(text: 'Loading menus...'),
//           ],
//         ),
//       );
//     }
//
//     if (foodVM.error) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.error_outline, size: 64, color: Colors.red),
//             const SizedBox(height: AppSpacing.paddingL),
//             const HeadingMedium(
//               text: 'Error loading menus',
//               align: TextAlign.center,
//             ),
//             const SizedBox(height: AppSpacing.paddingS),
//             BodyText(
//               text: foodVM.errorMessage ?? 'Unknown error occurred',
//               align: TextAlign.center,
//             ),
//             const SizedBox(height: AppSpacing.paddingL),
//             PrimaryButton(
//               onPressed: () {
//                 foodVM.clearError();
//                 foodVM.loadMenus(ownerId);
//               },
//               label: 'Try Again',
//               icon: Icons.refresh,
//             ),
//           ],
//         ),
//       );
//     }
//
//     return TabBarView(
//       controller: _tabController,
//       children: const [
//         OwnerMenuDayTab(dayLabel: 'Monday'),
//         OwnerMenuDayTab(dayLabel: 'Tuesday'),
//         OwnerMenuDayTab(dayLabel: 'Wednesday'),
//         OwnerMenuDayTab(dayLabel: 'Thursday'),
//         OwnerMenuDayTab(dayLabel: 'Friday'),
//         OwnerMenuDayTab(dayLabel: 'Saturday'),
//         OwnerMenuDayTab(dayLabel: 'Sunday'),
//       ],
//     );
//   }
//
//   /// Builds menu statistics card
//   Widget _buildStatsCard(BuildContext context, OwnerFoodViewModel foodVM) {
//     final stats = foodVM.menuStats;
//
//     return AdaptiveCard(
//       margin: const EdgeInsets.all(AppSpacing.paddingM),
//       padding: const EdgeInsets.all(AppSpacing.paddingM),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           HeadingMedium(
//             text: 'Menu Overview',
//             color: Theme.of(context).primaryColor,
//           ),
//           const SizedBox(height: AppSpacing.paddingM),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildStatItem(
//                 context,
//                 'Weekly Menus',
//                 '${stats['totalWeeklyMenus'] ?? 0}',
//                 Icons.restaurant_menu,
//               ),
//               _buildStatItem(
//                 context,
//                 'Special Days',
//                 '${stats['totalOverrides'] ?? 0}',
//                 Icons.event,
//               ),
//               _buildStatItem(
//                 context,
//                 'Total Items',
//                 '${(stats['totalBreakfastItems'] ?? 0) + (stats['totalLunchItems'] ?? 0) + (stats['totalDinnerItems'] ?? 0)}',
//                 Icons.food_bank,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatItem(
//     BuildContext context,
//     String title,
//     String value,
//     IconData icon,
//   ) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           color: Theme.of(context).primaryColor,
//           size: 24,
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: Theme.of(context).primaryColor,
//               ),
//         ),
//         Text(
//           title,
//           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                 color: Colors.grey.shade600,
//               ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }
//
//   /// Shows dialog with list of special menu overrides
//   void _showOverridesDialog(BuildContext context, OwnerFoodViewModel foodVM) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const HeadingMedium(text: 'Special Menus'),
//         content: SizedBox(
//           width: double.maxFinite,
//           child: foodVM.hasOverrides
//               ? ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: foodVM.upcomingOverrides.length,
//                   itemBuilder: (context, index) {
//                     final override = foodVM.upcomingOverrides[index];
//                     return ListTile(
//                       leading: Icon(
//                         override.isFestival ? Icons.celebration : Icons.event,
//                         color: Theme.of(context).primaryColor,
//                       ),
//                       title: Text(override.displayTitle),
//                       subtitle: Text(override.formattedDate),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (context) => OwnerSpecialMenuScreen(
//                                     existingOverride: override,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () async {
//                               final success = await foodVM
//                                   .deleteMenuOverride(override.overrideId);
//                               if (success && context.mounted) {
//                                 Navigator.of(context).pop();
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(
//                                       content: Text(
//                                           'Override deleted successfully')),
//                                 );
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 )
//               : const EmptyState(
//                   title: 'No Special Menus',
//                   message: 'Add special menus for festivals or events',
//                   icon: Icons.event_busy,
//                 ),
//         ),
//         actions: [
//           PrimaryButton(
//             onPressed: () => Navigator.of(context).pop(),
//             label: 'Close',
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Shows dialog to add new menu override
//   void _showAddOverrideDialog(
//     BuildContext context,
//     OwnerFoodViewModel foodVM,
//     String ownerId,
//   ) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (context) => const OwnerSpecialMenuScreen(),
//       ),
//     );
//   }
// }
// ============================================================================
// Owner Food Management Screen - Weekly Menu Management
// ============================================================================
// Premium weekly menu management with day tabs and theme toggle support.
//
// FEATURES:
// - 7-day weekly menu management (Monday-Sunday)
// - Premium SliverAppBar with collapsing header
// - Day-specific color theming
// - Stats overview (menus, items, special days)
// - Theme toggle for comfortable menu viewing
//
// THEME TOGGLE:
// - Added to SliverAppBar actions for all-day menu management
// - User can switch Light/Dark/System modes while managing menus
// - Especially useful for evening menu planning
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../../shared/widgets/pg_selector_dropdown.dart';
import '../../viewmodel/owner_food_viewmodel.dart';
import '../widgets/owner_menu_day_tab.dart';
import 'owner_special_menu_screen.dart';

/// Premium Food Management Screen with world-class UI/UX
class OwnerFoodManagementScreen extends StatefulWidget {
  const OwnerFoodManagementScreen({super.key});

  @override
  State<OwnerFoodManagementScreen> createState() =>
      _OwnerFoodManagementScreenState();
}

class _OwnerFoodManagementScreenState extends State<OwnerFoodManagementScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  int _currentTabIndex = 0;
  bool _isScrolled = false;
  String? _lastLoadedPgId; // Track which PG we last loaded data for

  final List<String> _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  final List<IconData> _dayIcons = [
    Icons.monitor_heart_outlined,
    Icons.auto_awesome_outlined,
    Icons.water_drop_outlined,
    Icons.rocket_launch_outlined,
    Icons.celebration_outlined,
    Icons.weekend_outlined,
    Icons.brightness_7_outlined,
  ];

  final List<Color> _dayColors = [
    AppColors.getDayColor(0), // Monday - Primary Purple
    AppColors.getDayColor(1), // Tuesday - Coral Red
    AppColors.getDayColor(2), // Wednesday - Teal
    AppColors.getDayColor(3), // Thursday - Green
    AppColors.getDayColor(4), // Friday - Orange
    AppColors.getDayColor(5), // Saturday - Violet
    AppColors.getDayColor(6), // Sunday - Sky Blue
  ];

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    WidgetsBinding.instance.addObserver(this);

    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 50;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthProvider>();
      final selectedPgProvider = context.read<SelectedPgProvider>();
      final ownerId = authProvider.user?.userId ?? '';

      if (ownerId.isNotEmpty) {
        final foodVM = context.read<OwnerFoodViewModel>();
        final pgId = selectedPgProvider.selectedPgId; // Use selected PG
        
        if (!foodVM.loading && foodVM.weeklyMenus.isEmpty) {
          await foodVM.loadMenus(ownerId, pgId: pgId);
        }
      }
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
        final foodVM = context.read<OwnerFoodViewModel>();
        foodVM.setSelectedDay(_weekdays[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodVM = context.watch<OwnerFoodViewModel>();
    final authProvider = context.watch<AuthProvider>();
    final selectedPgProvider = context.watch<SelectedPgProvider>();
    final ownerId = authProvider.user?.userId ?? '';
    final currentPgId = selectedPgProvider.selectedPgId;

    // Auto-reload menus when selected PG changes
    if (_lastLoadedPgId != currentPgId && ownerId.isNotEmpty) {
      _lastLoadedPgId = currentPgId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        foodVM.loadMenus(ownerId, pgId: currentPgId);
      });
    }

    // ========================================================================
    // Theme-Aware Colors
    // ========================================================================
    // Get current theme mode for adaptive coloring
    // All colors adapt automatically to light/dark modes
    // ========================================================================
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final surfaceColor = theme.colorScheme.surface;
    final textPrimary =
        theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;

    return Scaffold(
      backgroundColor: scaffoldBg,
      // ========================================================================
      // World-Class App Bar with Enhanced AdaptiveAppBar
      // ========================================================================
      appBar: AdaptiveAppBar(
        // Left: Food icon
        leadingActions: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              Icons.restaurant_menu,
              color: AppColors.textOnPrimary,
              size: 24,
            ),
          ),
        ],
        // Center: PG Selector Dropdown
        titleWidget: const PgSelectorDropdown(compact: false),
        centerTitle: true,
        // Right: Theme Toggle (auto-added)
        showThemeToggle: true,
        showBackButton: false,
        // Bottom: Premium Weekly Menu Management header + Day tabs
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(230), // Increased for stats row
          child: Column(
            children: [
              // Premium Header section with gradient background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _dayColors[_currentTabIndex].withOpacity(isDarkMode ? 0.15 : 0.1),
                      surfaceColor,
                    ],
                  ),
                  border: Border(
                    top: BorderSide(
                      color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode 
                          ? Colors.black.withOpacity(0.2)
                          : _dayColors[_currentTabIndex].withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Premium gradient icon container
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _dayColors[_currentTabIndex],
                                _dayColors[_currentTabIndex].withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: _dayColors[_currentTabIndex].withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.restaurant_menu_rounded,
                            color: AppColors.textOnPrimary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Premium title with gradient shimmer effect
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [
                                    textPrimary,
                                    _dayColors[_currentTabIndex].withOpacity(0.8),
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  'Weekly Menu Management',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white, // Required for ShaderMask
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Manage breakfast, lunch & dinner for all days',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildStatsRow(foodVM),
                  ],
                ),
              ),
              // Premium Day tabs with gradient backgrounds
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      surfaceColor,
                      isDarkMode 
                          ? AppColors.darkCard.withOpacity(0.5)
                          : AppColors.surfaceVariant.withOpacity(0.3),
                    ],
                  ),
                ),
                child: _buildPremiumTabBar(isDarkMode, surfaceColor, _dayColors[_currentTabIndex]),
              ),
            ],
          ),
        ),
      ),
      body: _buildBody(context, foodVM, ownerId),
      floatingActionButton: _buildPremiumFAB(context, foodVM, ownerId),
    );
  }

  Widget _buildStatsRow(OwnerFoodViewModel foodVM) {
    final stats = foodVM.menuStats;
    final totalItems = (stats['totalBreakfastItems'] ?? 0) +
        (stats['totalLunchItems'] ?? 0) +
        (stats['totalDinnerItems'] ?? 0);

    return Row(
      children: [
        _buildStatChip(
          '${stats['totalWeeklyMenus'] ?? 0}',
          'Days',
          Icons.calendar_today_rounded,
          _dayColors[_currentTabIndex],
        ),
        const SizedBox(width: 12),
        _buildStatChip(
          '$totalItems',
          'Items',
          Icons.restaurant_rounded,
          AppColors.success,
        ),
        const SizedBox(width: 12),
        _buildStatChip(
          '${stats['totalOverrides'] ?? 0}',
          'Special',
          Icons.celebration_rounded,
          AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildStatChip(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  /// Premium tab bar for day selection with gradients and shadows
  Widget _buildPremiumTabBar(bool isDarkMode, Color surfaceColor, Color dayColor) {
    final textSecondary = Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final dividerColor = isDarkMode ? AppColors.darkDivider : AppColors.outline;

    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: Colors.transparent, // We use custom decoration
      labelColor: AppColors.textOnPrimary,
      unselectedLabelColor: textSecondary,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
      ),
      unselectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      tabs: _weekdays.asMap().entries.map((entry) {
        final index = entry.key;
        final day = entry.value;
        final isSelected = _currentTabIndex == index;
        final tabColor = _dayColors[index];

        return Tab(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              // Premium gradient for selected tab
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        tabColor,
                        tabColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              // Subtle surface color for unselected tabs
              color: isSelected
                  ? null
                  : (isDarkMode ? AppColors.darkCard : AppColors.surfaceVariant),
              borderRadius: BorderRadius.circular(20),
              border: isSelected 
                  ? Border.all(
                      color: tabColor.withOpacity(0.3),
                      width: 1.5,
                    )
                  : Border.all(color: dividerColor),
              // Premium shadow for selected tab
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: tabColor.withOpacity(isDarkMode ? 0.4 : 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: tabColor.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _dayIcons[index],
                  size: 16,
                  color: isSelected ? AppColors.textOnPrimary : tabColor,
                ),
                const SizedBox(width: 6),
                Text(day),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBody(
      BuildContext context, OwnerFoodViewModel foodVM, String ownerId) {
    if (foodVM.loading && foodVM.weeklyMenus.isEmpty) {
      return _buildLoadingState();
    }

    if (foodVM.error) {
      return _buildErrorState(foodVM, ownerId);
    }

    return TabBarView(
      controller: _tabController,
      children: _weekdays
          .asMap()
          .entries
          .map((entry) => OwnerMenuDayTab(
                dayLabel: entry.value,
                dayColor: _dayColors[entry.key],
                dayIcon: _dayIcons[entry.key],
              ))
          .toList(),
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);
    final textPrimary =
        theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _dayColors[_currentTabIndex],
                  _dayColors[_currentTabIndex].withOpacity(0.7),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.restaurant_menu_rounded,
              color: AppColors.textOnPrimary, // White icon
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          const AdaptiveLoader(),
          const SizedBox(height: 16),
          Text(
            'Loading Your Menus',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textPrimary, // Theme-aware
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Preparing your weekly food management system',
            style: TextStyle(
              fontSize: 14,
              color: textSecondary, // Theme-aware
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(OwnerFoodViewModel foodVM, String ownerId) {
    final theme = Theme.of(context);
    final textPrimary =
        theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.errorContainer, // Theme-aware error background
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 60,
                color: AppColors.error, // Theme-aware error icon
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Unable to Load Menus',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: textPrimary, // Theme-aware
              ),
            ),
            const SizedBox(height: 12),
            Text(
              foodVM.errorMessage ??
                  'Please check your connection and try again',
              style: TextStyle(
                fontSize: 15,
                color: textSecondary, // Theme-aware
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              onPressed: () {
                foodVM.clearError();
                foodVM.loadMenus(ownerId);
              },
              label: 'Try Again',
              icon: Icons.refresh_rounded,
              backgroundColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumFAB(
      BuildContext context, OwnerFoodViewModel foodVM, String ownerId) {
    return FloatingActionButton.extended(
      heroTag: 'owner_food_fab', // Unique hero tag to avoid conflicts
      onPressed: () => _showSpecialMenuOptions(context, foodVM, ownerId),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary, // White text on primary color
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.textOnPrimary
              .withOpacity(0.2), // Semi-transparent white
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add_rounded, size: 24),
      ),
      label: const Text(
        'Special Menu',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }

  void _showSpecialMenuOptions(
      BuildContext context, OwnerFoodViewModel foodVM, String ownerId) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;
    final textPrimary =
        theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final dividerColor = theme.dividerColor;

    showModalBottomSheet(
      context: context,
      backgroundColor: surfaceColor, // Theme-aware
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: dividerColor, // Theme-aware
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Create Special Menu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textPrimary, // Theme-aware
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add special menus for festivals, events or custom occasions',
              style: TextStyle(
                fontSize: 14,
                color: textSecondary, // Theme-aware
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildSpecialMenuOption(
              context,
              'Festival Menu',
              'For religious festivals and celebrations',
              Icons.celebration_rounded,
              AppColors.warning,
              () {
                Navigator.pop(context);
                _navigateToSpecialMenu(context);
              },
            ),
            const SizedBox(height: 12),
            _buildSpecialMenuOption(
              context,
              'Event Menu',
              'For special events and occasions',
              Icons.event_rounded,
              AppColors.info,
              () {
                Navigator.pop(context);
                _navigateToSpecialMenu(context);
              },
            ),
            const SizedBox(height: 12),
            _buildSpecialMenuOption(
              context,
              'Custom Day Override',
              'Override specific day with custom menu',
              Icons.edit_calendar_rounded,
              AppColors.success,
              () {
                Navigator.pop(context);
                _navigateToSpecialMenu(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialMenuOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(isDarkMode ? 0.15 : 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary, // Theme-aware
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: textSecondary, // Theme-aware
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(isDarkMode ? 0.15 : 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          color: color,
          size: 16,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode ? AppColors.darkDivider : AppColors.outline, // Theme-aware
        ),
      ),
    );
  }

  void _navigateToSpecialMenu(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OwnerSpecialMenuScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}

/// Premium Tab Bar Delegate for enhanced tab experience
class _PremiumTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<String> weekdays;
  final List<IconData> dayIcons;
  final List<Color> dayColors;
  final int currentIndex;

  _PremiumTabBarDelegate({
    required this.tabController,
    required this.weekdays,
    required this.dayIcons,
    required this.dayColors,
    required this.currentIndex,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final surfaceColor = theme.colorScheme.surface;
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final dividerColor = theme.dividerColor;

    return Container(
      color: surfaceColor, // Theme-aware background
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              dayColors[currentIndex],
              dayColors[currentIndex].withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: AppColors.textOnPrimary, // White text on selected tab
        unselectedLabelColor: textSecondary, // Theme-aware unselected text
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tabs: weekdays.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;
          final isSelected = currentIndex == index;

          return Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? null
                    : (isDarkMode
                        ? AppColors.darkCard // Dark mode unselected tab
                        : AppColors
                            .surfaceVariant), // Light mode unselected tab
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? null
                    : Border.all(color: dividerColor), // Theme-aware border
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    dayIcons[index],
                    size: 16,
                    color: isSelected
                        ? AppColors.textOnPrimary // White icon on selected
                        : dayColors[index], // Day color on unselected
                  ),
                  const SizedBox(width: 6),
                  Text(day),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
