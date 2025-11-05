// lib/features/guest_dashboard/foods/view/screens/guest_food_list_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../feature/owner_dashboard/foods/data/models/owner_food_menu.dart';
import '../../../shared/widgets/guest_drawer.dart';
import '../../../shared/widgets/guest_pg_appbar_display.dart';
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
  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize tab controller with today's day
    final today = DateFormat('EEEE').format(DateTime.now());
    final todayIndex = _days.indexOf(today);
    _tabController = TabController(
      length: _days.length,
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AdaptiveAppBar(
        titleWidget: const GuestPgAppBarDisplay(),
        centerTitle: true,
        showDrawer: true,
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

      backgroundColor: theme.scaffoldBackgroundColor,
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final today = DateFormat('EEEE').format(DateTime.now());

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
            color: isDarkMode ? AppColors.darkCard : AppColors.surface,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: theme.primaryColor,
              labelColor: theme.primaryColor,
              unselectedLabelColor:
                  isDarkMode ? AppColors.textTertiary : AppColors.textSecondary,
              tabs: _days.map((day) {
                final isToday = day == today;
                return Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS,
                      vertical: AppSpacing.paddingXS,
                    ),
                    decoration: isToday
                        ? BoxDecoration(
                            color: theme.primaryColor.withValues(alpha: 0.1),
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
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(day),
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
              children: _days.map((day) {
                final menu = foodViewModel.getMenuForDay(day);
                return _buildDayMenu(context, day, menu, isDarkMode);
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
                  label: const Text("Like Today's Menu"),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                OutlinedButton.icon(
                  onPressed: () => foodViewModel.submitMealFeedback(
                    meal: 'lunch',
                    like: false,
                  ),
                  icon: const Icon(Icons.thumb_down_alt_outlined),
                  label: const Text('Dislike'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🍴 Builds menu for a specific day
  Widget _buildDayMenu(
      BuildContext context, String day, OwnerFoodMenu? menu, bool isDarkMode) {
    if (menu == null) {
      return _buildNoDayMenu(context, day, isDarkMode);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Menu info card
          if (menu.description != null && menu.description!.isNotEmpty)
            _buildMenuInfoCard(context, menu, isDarkMode),

          const SizedBox(height: AppSpacing.paddingM),

          // Breakfast section
          if (menu.breakfast.isNotEmpty)
            _buildMealSection(
              context,
              'Breakfast',
              Icons.free_breakfast,
              menu.breakfast,
              AppColors.breakfast,
              isDarkMode,
            ),

          const SizedBox(height: AppSpacing.paddingM),

          // Lunch section
          if (menu.lunch.isNotEmpty)
            _buildMealSection(
              context,
              'Lunch',
              Icons.lunch_dining,
              menu.lunch,
              AppColors.lunch,
              isDarkMode,
            ),

          const SizedBox(height: AppSpacing.paddingM),

          // Dinner section
          if (menu.dinner.isNotEmpty)
            _buildMealSection(
              context,
              'Dinner',
              Icons.dinner_dining,
              menu.dinner,
              AppColors.dinner,
              isDarkMode,
            ),

          const SizedBox(height: AppSpacing.paddingM),

          // Photos section
          if (menu.photoUrls.isNotEmpty)
            _buildPhotosSection(context, menu.photoUrls, isDarkMode),
        ],
      ),
    );
  }

  /// 📋 Menu info card
  Widget _buildMenuInfoCard(
      BuildContext context, OwnerFoodMenu menu, bool isDarkMode) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
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
                  'Menu Note',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  menu.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDarkMode
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
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
    bool isDarkMode,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.05),
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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0.1),
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
                    color: color.withValues(alpha: 0.2),
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
                    color: color.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: Text(
                    '${items.length} items',
                    style: theme.textTheme.bodySmall?.copyWith(
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
                    color: isDarkMode
                        ? AppColors.darkInputFill
                        : AppColors.surfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                    border: Border.all(
                      color: color.withValues(alpha: 0.2),
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
                      const SizedBox(width: 6),
                      Text(
                        item,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                        ),
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
  Widget _buildPhotosSection(
      BuildContext context, List<String> photos, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Row(
              children: [
                Icon(Icons.photo_library,
                    color: Theme.of(context).primaryColor),
                const SizedBox(width: AppSpacing.paddingS),
                HeadingSmall(
                  text: 'Food Gallery',
                  color: Theme.of(context).textTheme.headlineSmall?.color,
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
                        color: isDarkMode
                            ? AppColors.darkInputFill
                            : AppColors.surfaceVariant,
                        child: const Center(
                          child:
                              Icon(Icons.image, size: 32, color: Colors.grey),
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
  Widget _buildNoDayMenu(BuildContext context, String day, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: EmptyState(
        title: 'No Menu for $day',
        message: 'The owner hasn\'t set a menu for this day yet.',
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: EmptyState(
        title: 'Error Loading Menu',
        message: foodViewModel.errorMessage ??
            'Unable to load menu. Please try again.',
        icon: Icons.error_outline,
        actionLabel: 'Retry',
        onAction: () => foodViewModel.loadGuestMenu(),
      ),
    );
  }

  /// 🍽️ Structured empty state with zero-state stats and placeholder rows
  Widget _buildEmptyState(
      BuildContext context, GuestFoodViewmodel foodViewModel) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Zero-state stats section
          _buildZeroStateStats(context, isDarkMode),

          // Placeholder menu structure
          _buildPlaceholderMenuStructure(context, isDarkMode),

          // Call to action
          _buildEmptyStateAction(context, foodViewModel),
        ],
      ),
    );
  }

  /// 📊 Zero-state stats section
  Widget _buildZeroStateStats(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color:
              isDarkMode ? Colors.white12 : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Food Menu Statistics',
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Stats grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Weekly Menus',
                  '0',
                  Icons.calendar_view_week,
                  Colors.blue,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Total Items',
                  '0',
                  Icons.restaurant_menu,
                  Colors.green,
                  isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Breakfast Items',
                  '0',
                  Icons.free_breakfast,
                  Colors.orange,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Lunch Items',
                  '0',
                  Icons.lunch_dining,
                  Colors.purple,
                  isDarkMode,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Dinner Items',
                  '0',
                  Icons.dinner_dining,
                  Colors.red,
                  isDarkMode,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Snack Items',
                  '0',
                  Icons.cookie,
                  Colors.brown,
                  isDarkMode,
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
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 🍽️ Placeholder menu structure
  Widget _buildPlaceholderMenuStructure(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(
            text: 'Weekly Menu Preview',
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Placeholder day tabs
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.darkCard : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white12
                    : Colors.grey.withValues(alpha: 0.2),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.paddingS),
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
                return Container(
                  margin: const EdgeInsets.all(AppSpacing.paddingS),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingM),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: Center(
                    child: Text(
                      days[index],
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppSpacing.paddingM),

          // Placeholder meal sections
          _buildPlaceholderMealSection(
            context,
            'Breakfast',
            Icons.free_breakfast,
            Colors.orange,
            isDarkMode,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildPlaceholderMealSection(
            context,
            'Lunch',
            Icons.lunch_dining,
            Colors.purple,
            isDarkMode,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildPlaceholderMealSection(
            context,
            'Dinner',
            Icons.dinner_dining,
            Colors.red,
            isDarkMode,
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
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color:
              isDarkMode ? Colors.white12 : Colors.grey.withValues(alpha: 0.2),
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
                size: 20,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Text(
                mealName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Placeholder food items
          ...List.generate(
              3, (index) => _buildPlaceholderFoodItem(context, isDarkMode)),
        ],
      ),
    );
  }

  /// 🍽️ Placeholder food item
  Widget _buildPlaceholderFoodItem(BuildContext context, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
            child: Icon(
              Icons.restaurant,
              color: Colors.grey.withValues(alpha: 0.5),
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 8,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
            child: Center(
              child: Container(
                height: 8,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔄 Empty state action section
  Widget _buildEmptyStateAction(
      BuildContext context, GuestFoodViewmodel foodViewModel) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkCard : AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color:
              isDarkMode ? Colors.white12 : Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 48,
            color: isDarkMode ? Colors.white54 : Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          HeadingMedium(
            text: 'No Menu Available',
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: AppSpacing.paddingS),
          Text(
            'Your PG owner hasn\'t set up a weekly menu yet. The menu will appear here once it\'s configured.',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => foodViewModel.loadGuestMenu(),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Menu'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.paddingM),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
