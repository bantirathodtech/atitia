// lib/features/guest_dashboard/foods/view/screens/guest_food_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/loaders/shimmer_loader.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../viewmodel/guest_food_viewmodel.dart';
import '../../../../../feature/owner_dashboard/foods/data/models/owner_food_menu.dart';

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
      final foodViewModel = Provider.of<GuestFoodViewmodel>(context, listen: false);
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
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => foodViewModel.loadGuestMenu(),
        child: CustomScrollView(
          slivers: [
            _buildPremiumSliverAppBar(context, isDarkMode, foodViewModel),
            SliverToBoxAdapter(
              child: _buildBody(context, foodViewModel),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 Premium Sliver App Bar with gradient
  Widget _buildPremiumSliverAppBar(
      BuildContext context, bool isDarkMode, GuestFoodViewmodel foodViewModel) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final today = DateFormat('EEEE').format(DateTime.now());

    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      stretch: true,
      backgroundColor: isDarkMode ? AppColors.darkCard : primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
        title: HeadingMedium(
          text: 'Weekly Menu',
          color: AppColors.textOnPrimary,
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [AppColors.darkCard, AppColors.darkCard.withOpacity(0.9)]
                  : [primaryColor, primaryColor.withOpacity(0.8)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.restaurant_menu,
                size: 48,
                color: AppColors.textOnPrimary.withOpacity(0.9),
              ),
              const SizedBox(height: 8),
              Text(
                "Today's Menu",
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textOnPrimary.withOpacity(0.9),
                ),
              ),
              Text(
                today,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: AppColors.textOnPrimary),
          onPressed: () => foodViewModel.loadGuestMenu(),
          tooltip: 'Refresh Menu',
        ),
      ],
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

    return Column(
      children: [
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
                          color: theme.primaryColor.withOpacity(0.1),
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
      ],
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
              color: AppColors.info.withOpacity(0.1),
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
          color: color.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.05),
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
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
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
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
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
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
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
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                    border: Border.all(
                      color: color.withOpacity(0.2),
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
                Icon(Icons.photo_library, color: Theme.of(context).primaryColor),
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
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
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
                          child: Icon(Icons.image, size: 32, color: Colors.grey),
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
        message: foodViewModel.errorMessage ?? 'Unable to load menu. Please try again.',
        icon: Icons.error_outline,
        actionLabel: 'Retry',
        onAction: () => foodViewModel.loadGuestMenu(),
      ),
    );
  }

  /// 📭 Empty state
  Widget _buildEmptyState(
      BuildContext context, GuestFoodViewmodel foodViewModel) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: EmptyState(
        title: 'No Menu Available',
        message:
            'Your PG owner hasn\'t set up a weekly menu yet. Please check back later.',
        icon: Icons.restaurant,
        actionLabel: 'Refresh',
        onAction: () => foodViewModel.loadGuestMenu(),
      ),
    );
  }
}
