// lib/features/guest_dashboard/foods/view/screens/guest_food_list_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/widgets/responsive/responsive_container.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../feature/owner_dashboard/foods/data/models/owner_food_menu.dart';
import '../../../shared/widgets/guest_drawer.dart';
import '../../../shared/widgets/guest_pg_appbar_display.dart';
import '../../../shared/widgets/guest_pg_selector_dropdown.dart';
import '../../../shared/widgets/user_location_display.dart';
import '../../viewmodel/guest_food_viewmodel.dart';

/// 🍽️ **GUEST FOOD MENU SCREEN - PRODUCTION READY**
///
/// **Features:**
/// - Displays owner's weekly menu from booked PG
/// - Highlights today's menu
/// - Shows breakfast, lunch, dinner
/// - Photo gallery for each meal
/// - Special menu notifications
/// - Theme-aware premium UI
/// - Pull-to-refresh
///
class GuestFoodListScreen extends StatefulWidget {
  const GuestFoodListScreen({super.key});

  @override
  State<GuestFoodListScreen> createState() => _GuestFoodListScreenState();
}

class _GuestFoodListScreenState extends State<GuestFoodListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDayIndex = 0; // Track selected day for placeholder menu

  List<String> _getDays(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (loc == null) {
      return [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];
    }
    return [
      loc.monday,
      loc.tuesday,
      loc.wednesday,
      loc.thursday,
      loc.friday,
      loc.saturday,
      loc.sunday,
    ];
  }

  @override
  void initState() {
    super.initState();
    // Initialize tab controller with today's day
    final today = DateFormat('EEEE').format(DateTime.now());
    final englishDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final todayIndex = englishDays.indexOf(today);
    _tabController = TabController(
      length: 7, // Always 7 days
      vsync: this,
      initialIndex: todayIndex >= 0 ? todayIndex : 0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final foodViewModel =
          Provider.of<GuestFoodViewmodel>(context, listen: false);
      if (!foodViewModel.loading && foodViewModel.weeklyMenus.isEmpty) {
        foodViewModel.loadGuestMenu();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodViewModel = Provider.of<GuestFoodViewmodel>(context);

    return Scaffold(
      appBar: AdaptiveAppBar(
        titleWidget: const GuestPgAppBarDisplay(),
        centerTitle: true,
        showDrawer: true,
        backgroundColor: context.isDarkMode ? Colors.black : Colors.white,
        leadingActions: [
          const GuestPgSelectorDropdown(compact: true),
        ],
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => foodViewModel.loadGuestMenu(),
            tooltip: 'Refresh Menu',
          ),
        ],
        showBackButton: false,
        showThemeToggle: false,
      ),

      // Centralized Guest Drawer
      drawer: const GuestDrawer(),

      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => foodViewModel.loadGuestMenu(),
        child: _buildBody(context, foodViewModel),
      ),
    );
  }

  /// 📱 Builds appropriate body based on state
  Widget _buildBody(BuildContext context, GuestFoodViewmodel foodViewModel) {
    if (foodViewModel.loading && foodViewModel.weeklyMenus.isEmpty) {
      return _buildLoadingState(context);
    }

    if (foodViewModel.error) {
      return _buildErrorState(context, foodViewModel);
    }

    if (foodViewModel.weeklyMenus.isEmpty) {
      return _buildEmptyState(context, foodViewModel);
    }

    return _buildWeeklyMenuView(context, foodViewModel);
  }

  /// 📅 Weekly menu view with day tabs
  Widget _buildWeeklyMenuView(
      BuildContext context, GuestFoodViewmodel foodViewModel) {
    final today = DateFormat('EEEE').format(DateTime.now());
    final loc = AppLocalizations.of(context);
    final days = _getDays(context);
    final englishDays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          // User Location Display
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.paddingM,
              AppSpacing.paddingM,
              AppSpacing.paddingM,
              AppSpacing.paddingS,
            ),
            child: const UserLocationDisplay(),
          ),
          // Day tabs
          Container(
            color: ThemeColors.getCardBackground(context),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: context.primaryColor,
              labelColor: context.primaryColor,
              unselectedLabelColor: ThemeColors.getTextTertiary(context),
              tabs: days.asMap().entries.map((entry) {
                final index = entry.key;
                final day = entry.value;
                final englishDay = englishDays[index];
                final isToday = englishDay == today;
                return Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS,
                      vertical: AppSpacing.paddingXS,
                    ),
                    decoration: isToday
                        ? BoxDecoration(
                            color: context.primaryColor.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.borderRadiusS),
                          )
                        : null,
                    child: Row(
                      children: [
                        if (isToday)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: context.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(
                          day,
                          style: TextStyle(
                            color: isToday
                                ? context.primaryColor
                                : ThemeColors.getTextTertiary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Menu content for selected day
          SizedBox(
            height: MediaQuery.of(context).size.height - 350,
            child: TabBarView(
              controller: _tabController,
              children: englishDays.map((day) {
                final menu = foodViewModel.getMenuForDay(day);
                return _buildDayMenu(context, day, menu);
              }).toList(),
            ),
          ),

          // Quick feedback for today's overall menu
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => foodViewModel.submitMealFeedback(
                    meal: 'lunch',
                    like: true,
                  ),
                  icon: const Icon(Icons.thumb_up_alt_outlined),
                  label: Text(loc?.likeTodaysMenu ?? "Like Today's Menu"),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                OutlinedButton.icon(
                  onPressed: () => foodViewModel.submitMealFeedback(
                    meal: 'lunch',
                    like: false,
                  ),
                  icon: const Icon(Icons.thumb_down_alt_outlined),
                  label: Text(loc?.dislike ?? 'Dislike'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🍴 Builds menu for a specific day
  Widget _buildDayMenu(BuildContext context, String day, OwnerFoodMenu? menu) {
    if (menu == null) {
      return _buildNoDayMenu(context, day);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu info card
          if (menu.description != null && menu.description!.isNotEmpty)
            _buildMenuInfoCard(context, menu),

          const SizedBox(height: AppSpacing.paddingM),

          // Breakfast section
          if (menu.breakfast.isNotEmpty)
            _buildMealSection(
              context,
              AppLocalizations.of(context)?.breakfast ?? 'Breakfast',
              Icons.free_breakfast,
              menu.breakfast,
              AppColors.breakfast,
            ),

          const SizedBox(height: AppSpacing.paddingM),

          // Lunch section
          if (menu.lunch.isNotEmpty)
            _buildMealSection(
              context,
              AppLocalizations.of(context)?.lunch ?? 'Lunch',
              Icons.lunch_dining,
              menu.lunch,
              AppColors.lunch,
            ),

          const SizedBox(height: AppSpacing.paddingM),

          // Dinner section
          if (menu.dinner.isNotEmpty)
            _buildMealSection(
              context,
              AppLocalizations.of(context)?.dinner ?? 'Dinner',
              Icons.dinner_dining,
              menu.dinner,
              AppColors.dinner,
            ),

          const SizedBox(height: AppSpacing.paddingM),

          // Photos section
          if (menu.photoUrls.isNotEmpty)
            _buildPhotosSection(context, menu.photoUrls),
        ],
      ),
    );
  }

  /// 📋 Menu info card
  Widget _buildMenuInfoCard(BuildContext context, OwnerFoodMenu menu) {
    final loc = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: ThemeColors.getDivider(context),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingS),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
            child: Icon(Icons.info_outline, color: AppColors.info, size: 24),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc?.menuNote ?? 'Menu Note',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: AppSpacing.paddingXS),
                Text(
                  menu.description!,
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🍽️ Meal section (breakfast, lunch, dinner)
  Widget _buildMealSection(
    BuildContext context,
    String title,
    IconData icon,
    List<String> items,
    Color color,
  ) {
    final loc = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: ThemeColors.getDivider(context),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow.withValues(
              alpha: context.isDarkMode ? 0.3 : 0.05,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: context.isDarkMode ? 0.3 : 0.15),
                  color.withValues(alpha: context.isDarkMode ? 0.2 : 0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.borderRadiusL),
                topRight: Radius.circular(AppSpacing.borderRadiusL),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.paddingS),
                  decoration: BoxDecoration(
                    color:
                        color.withValues(alpha: context.isDarkMode ? 0.3 : 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                HeadingSmall(
                  text: title,
                  color: color,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color:
                        color.withValues(alpha: context.isDarkMode ? 0.3 : 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: Text(
                    '${items.length} ${loc?.items ?? 'items'}',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Wrap(
              spacing: AppSpacing.paddingS,
              runSpacing: AppSpacing.paddingS,
              children: items.map((item) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingM,
                    vertical: AppSpacing.paddingS,
                  ),
                  decoration: BoxDecoration(
                    color: context.theme.inputDecorationTheme.fillColor,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                    border: Border.all(
                      color: color.withValues(
                          alpha: context.isDarkMode ? 0.4 : 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: color,
                      ),
                      const SizedBox(width: AppSpacing.paddingS),
                      Text(
                        item,
                        style: context.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// 📸 Photos section
  Widget _buildPhotosSection(BuildContext context, List<String> photos) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: ThemeColors.getDivider(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Row(
              children: [
                Icon(Icons.photo_library, color: context.primaryColor),
                const SizedBox(width: AppSpacing.paddingS),
                HeadingSmall(
                  text: AppLocalizations.of(context)?.foodGallery ??
                      'Food Gallery',
                  color: context.textTheme.headlineSmall?.color,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(
                left: AppSpacing.paddingM,
                right: AppSpacing.paddingM,
                bottom: AppSpacing.paddingM,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: AppSpacing.paddingM),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                    child: AdaptiveImage(
                      imageUrl: photos[index],
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      placeholder: Container(
                        color: context.theme.inputDecorationTheme.fillColor,
                        child: Center(
                          child: Icon(Icons.image,
                              size: 32,
                              color: context.colors.onSurface
                                  .withValues(alpha: 0.5)),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ❌ No menu for day
  Widget _buildNoDayMenu(BuildContext context, String day) {
    final loc = AppLocalizations.of(context);
    // Map English day to localized day
    final dayMap = {
      'Monday': loc?.monday ?? 'Monday',
      'Tuesday': loc?.tuesday ?? 'Tuesday',
      'Wednesday': loc?.wednesday ?? 'Wednesday',
      'Thursday': loc?.thursday ?? 'Thursday',
      'Friday': loc?.friday ?? 'Friday',
      'Saturday': loc?.saturday ?? 'Saturday',
      'Sunday': loc?.sunday ?? 'Sunday',
    };
    final localizedDay = dayMap[day] ?? day;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: EmptyState(
        title: loc?.noMenuForDay(localizedDay) ?? 'No Menu for $localizedDay',
        message: loc?.ownerHasntSetMenuForDay ??
            'The owner hasn\'t set a menu for this day yet.',
        icon: Icons.restaurant_menu,
      ),
    );
  }

  /// ⏳ Loading state
  Widget _buildLoadingState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        children: List.generate(
          3,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
            child: ShimmerLoader(
              width: double.infinity,
              height: 200,
              borderRadius: AppSpacing.borderRadiusL,
            ),
          ),
        ),
      ),
    );
  }

  /// ❌ Error state
  Widget _buildErrorState(
      BuildContext context, GuestFoodViewmodel foodViewModel) {
    final loc = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: EmptyState(
        title: loc?.errorLoadingMenu ?? 'Error Loading Menu',
        message: foodViewModel.errorMessage ??
            (loc?.unableToLoadMenuPleaseTryAgain ??
                'Unable to load menu. Please try again.'),
        icon: Icons.error_outline,
        actionLabel: loc?.retry ?? 'Retry',
        onAction: () => foodViewModel.loadGuestMenu(),
      ),
    );
  }

  /// 🍽️ Structured empty state with zero-state stats and placeholder rows
  Widget _buildEmptyState(
      BuildContext context, GuestFoodViewmodel foodViewModel) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Placeholder menu structure (moved to top)
          _buildPlaceholderMenuStructure(context),

          // Small gap between menu preview and stats
          SizedBox(height: context.responsivePadding.top * 0.5),

          // Zero-state stats section (moved down)
          _buildZeroStateStats(context),
        ],
      ),
    );
  }

  /// 📊 Zero-state stats section
  Widget _buildZeroStateStats(BuildContext context) {
    return ResponsiveContainer(
      margin: EdgeInsets.only(
        top: 0, // Remove top margin since it's now below menu preview
        left: context.responsiveMargin.left,
        right: context.responsiveMargin.right,
        bottom: context.responsiveMargin.bottom,
      ),
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: ThemeColors.getDivider(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: AppLocalizations.of(context)?.foodMenuStatistics ??
                'Food Menu Statistics',
            color:
                context.textTheme.bodyLarge?.color ?? context.colors.onSurface,
          ),
          SizedBox(height: context.responsivePadding.top),

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  AppLocalizations.of(context)?.weeklyMenus ?? 'Weekly Menus',
                  '0',
                  Icons.calendar_view_week,
                  AppColors.info,
                ),
              ),
              SizedBox(width: context.responsivePadding.left),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Items',
                  '0',
                  Icons.restaurant_menu,
                  AppColors.success,
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsivePadding.top),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Breakfast Items',
                  '0',
                  Icons.free_breakfast,
                  AppColors.breakfast,
                ),
              ),
              SizedBox(width: context.responsivePadding.left),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Lunch Items',
                  '0',
                  Icons.lunch_dining,
                  AppColors.lunch,
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsivePadding.top),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Dinner Items',
                  '0',
                  Icons.dinner_dining,
                  AppColors.dinner,
                ),
              ),
              SizedBox(width: context.responsivePadding.left),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Snack Items',
                  '0',
                  Icons.cookie,
                  AppColors.statusGrey, // Using statusGrey for brown color
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 📊 Individual stat card
  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final padding = context.responsivePadding;
    return Container(
      padding:
          EdgeInsets.all(context.isMobile ? padding.top * 0.5 : padding.top),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row 1: Icon and number side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: context.isMobile ? 18 : 24,
              ),
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              Text(
                value,
                style: TextStyle(
                  fontSize: context.isMobile ? 16 : 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(
              height: context.isMobile
                  ? AppSpacing.paddingXS
                  : AppSpacing.paddingS),
          // Row 2: Text below
          Text(
            label,
            style: TextStyle(
              fontSize: context.isMobile ? 10 : 12,
              color: (context.textTheme.bodySmall?.color ??
                      context.colors.onSurface)
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 🍽️ Placeholder menu structure
  Widget _buildPlaceholderMenuStructure(BuildContext context) {
    return ResponsiveContainer(
      margin: EdgeInsets.only(
        top:
            context.responsiveMargin.top, // Add top margin since it's now first
        left: context.responsiveMargin.left, // Match Food Menu Statistics
        right: context.responsiveMargin.right, // Match Food Menu Statistics
        bottom: 0, // Remove bottom margin to reduce gap
      ),
      padding:
          EdgeInsets.zero, // Remove default padding from ResponsiveContainer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: 'Weekly Menu Preview',
            color:
                context.textTheme.bodyLarge?.color ?? context.colors.onSurface,
          ),
          SizedBox(height: context.responsivePadding.top),

          // Placeholder day tabs - scrollable directly without card
          SizedBox(
            height: context.isMobile ? 40 : 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                  horizontal: context.responsivePadding.left * 0.5),
              itemCount: 7,
              itemBuilder: (context, index) {
                final days = [
                  'Monday',
                  'Tuesday',
                  'Wednesday',
                  'Thursday',
                  'Friday',
                  'Saturday',
                  'Sunday'
                ];
                final padding = context.responsivePadding;
                final isSelected = index == _selectedDayIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: context.isMobile
                          ? padding.left * 0.25
                          : padding.left * 0.5,
                      vertical: context.isMobile ? 4 : 6,
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: context.isMobile
                            ? padding.left * 0.5
                            : padding.left),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? context.primaryColor.withValues(alpha: 0.1)
                          : context.theme.inputDecorationTheme.fillColor,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusS),
                      border: Border.all(
                        color: isSelected
                            ? context.primaryColor
                            : ThemeColors.getDivider(context),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        days[index],
                        style: context.textTheme.bodySmall?.copyWith(
                          fontSize: context.isMobile ? 10 : 12,
                          color: isSelected
                              ? context.primaryColor
                              : context.textTheme.bodySmall?.color,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: context.responsivePadding.top),

          // Placeholder meal sections - show based on selected day
          _buildPlaceholderMealSection(
            context,
            'Breakfast',
            Icons.free_breakfast,
            AppColors.breakfast,
          ),
          SizedBox(height: context.responsivePadding.top),
          _buildPlaceholderMealSection(
            context,
            'Lunch',
            Icons.lunch_dining,
            AppColors.lunch,
          ),
          SizedBox(height: context.responsivePadding.top),
          _buildPlaceholderMealSection(
            context,
            'Dinner',
            Icons.dinner_dining,
            AppColors.dinner,
          ),
        ],
      ),
    );
  }

  /// 🍽️ Placeholder meal section
  Widget _buildPlaceholderMealSection(
    BuildContext context,
    String mealName,
    IconData icon,
    Color color,
  ) {
    final padding = context.responsivePadding;
    return Container(
      padding:
          EdgeInsets.all(context.isMobile ? padding.top * 0.5 : padding.top),
      decoration: BoxDecoration(
        color: ThemeColors.getCardBackground(context),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: ThemeColors.getDivider(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: context.isMobile ? 16 : 20,
              ),
              SizedBox(width: context.responsivePadding.left * 0.25),
              Text(
                mealName,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: context.isMobile ? 14 : 16,
                  fontWeight: FontWeight.bold,
                  color: context.textTheme.bodyLarge?.color ??
                      context.colors.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: context.responsivePadding.top),

          // Placeholder food items
          ...List.generate(3, (index) => _buildPlaceholderFoodItem(context)),
        ],
      ),
    );
  }

  /// 🍽️ Placeholder food item
  Widget _buildPlaceholderFoodItem(BuildContext context) {
    final padding = context.responsivePadding;
    return Container(
      margin: EdgeInsets.only(
          bottom: context.isMobile ? padding.top * 0.25 : padding.top * 0.5),
      padding:
          EdgeInsets.all(context.isMobile ? padding.top * 0.5 : padding.top),
      decoration: BoxDecoration(
        color: context.theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: ThemeColors.getDivider(context),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: context.isMobile ? 32 : 40,
            height: context.isMobile ? 32 : 40,
            decoration: BoxDecoration(
              color: ThemeColors.getDivider(context),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
            child: Icon(
              Icons.restaurant,
              color: ThemeColors.getTextTertiary(context),
              size: context.isMobile ? 16 : 20,
            ),
          ),
          SizedBox(
              width:
                  context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: context.isMobile ? 10 : 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ThemeColors.getTextTertiary(context)
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                SizedBox(height: context.isMobile ? 4 : AppSpacing.paddingXS),
                Container(
                  height: context.isMobile ? 6 : 8,
                  width: context.isMobile ? 80 : 120,
                  decoration: BoxDecoration(
                    color: ThemeColors.getDivider(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: context.isMobile ? 48 : 60,
            height: context.isMobile ? 20 : 24,
            decoration: BoxDecoration(
              color: ThemeColors.getDivider(context),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
            child: Center(
              child: Container(
                height: context.isMobile ? 6 : 8,
                width: context.isMobile ? 32 : 40,
                decoration: BoxDecoration(
                  color: ThemeColors.getTextTertiary(context)
                      .withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
