// ============================================================================
// Premium Food Header Widget - Reusable Header for Food Management
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../viewmodel/owner_food_viewmodel.dart';

class PremiumFoodHeaderWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final int currentTabIndex;
  final TabController? tabController;

  const PremiumFoodHeaderWidget({
    super.key,
    required this.currentTabIndex,
    this.tabController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(230);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final foodVM = context.watch<OwnerFoodViewModel>();

    // Day colors for gradient effects - using AppColors for consistency
    final dayColors = [
      AppColors.getDayColor(0), // Monday - Primary Purple
      AppColors.getDayColor(1), // Tuesday - Coral Red
      AppColors.getDayColor(2), // Wednesday - Teal
      AppColors.getDayColor(3), // Thursday - Green
      AppColors.getDayColor(4), // Friday - Orange
      AppColors.getDayColor(5), // Saturday - Violet
      AppColors.getDayColor(6), // Sunday - Sky Blue
    ];

    final surfaceColor = isDarkMode ? AppColors.darkSurface : AppColors.surface;
    final textPrimary =
        isDarkMode ? AppColors.textOnPrimary : AppColors.textPrimary;
    final textSecondary =
        isDarkMode ? AppColors.textSecondary : AppColors.textSecondary;

    return Column(
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
                dayColors[currentTabIndex]
                    .withValues(alpha: isDarkMode ? 0.15 : 0.1),
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
                    ? Colors.black.withValues(alpha: 0.2)
                    : dayColors[currentTabIndex].withValues(alpha: 0.05),
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
                          dayColors[currentTabIndex],
                          dayColors[currentTabIndex].withValues(alpha: 0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              dayColors[currentTabIndex].withValues(alpha: 0.3),
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
                              dayColors[currentTabIndex].withValues(alpha: 0.8),
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
              _buildStatsRow(foodVM, dayColors[currentTabIndex]),
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
                    ? AppColors.darkCard.withValues(alpha: 0.5)
                    : AppColors.surfaceVariant.withValues(alpha: 0.3),
              ],
            ),
          ),
          child: _buildPremiumTabBar(
              isDarkMode, surfaceColor, dayColors[currentTabIndex]),
        ),
      ],
    );
  }

  Widget _buildStatsRow(OwnerFoodViewModel foodVM, Color dayColor) {
    final stats = foodVM.menuStats;
    final totalItems = (stats['totalBreakfastItems'] ?? 0) +
        (stats['totalLunchItems'] ?? 0) +
        (stats['totalDinnerItems'] ?? 0);

    return Row(
      children: [
        Expanded(
          child: _buildStatChip(
            '${stats['totalWeeklyMenus'] ?? 0}',
            'Days',
            Icons.calendar_today_rounded,
            dayColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatChip(
            '$totalItems',
            'Items',
            Icons.restaurant_rounded,
            dayColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatChip(
            '${stats['totalPhotos'] ?? 0}',
            'Photos',
            Icons.photo_library_rounded,
            dayColor,
          ),
        ),
        if ((stats['upcomingFestivals'] ?? 0) > 0) ...[
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: dayColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: dayColor.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.celebration_rounded,
                    color: dayColor,
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Flexible(
                    child: Text(
                      '${stats['upcomingFestivals']} Festival',
                      style: TextStyle(
                        color: dayColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatChip(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: color.withValues(alpha: 0.7),
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTabBar(
      bool isDarkMode, Color surfaceColor, Color dayColor) {
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayIcons = [
      Icons.monitor_heart_outlined,
      Icons.auto_awesome_outlined,
      Icons.water_drop_outlined,
      Icons.rocket_launch_outlined,
      Icons.celebration_outlined,
      Icons.weekend_outlined,
      Icons.brightness_7_outlined,
    ];
    final dayColors = [
      AppColors.getDayColor(0), // Monday - Primary Purple
      AppColors.getDayColor(1), // Tuesday - Coral Red
      AppColors.getDayColor(2), // Wednesday - Teal
      AppColors.getDayColor(3), // Thursday - Green
      AppColors.getDayColor(4), // Friday - Orange
      AppColors.getDayColor(5), // Saturday - Violet
      AppColors.getDayColor(6), // Sunday - Sky Blue
    ];

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: List.generate(dayNames.length, (index) {
          final isSelected = index == currentTabIndex;
          final tabColor = dayColors[index];

          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: GestureDetector(
                onTap: () {
                  if (tabController != null) {
                    tabController!.animateTo(index);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    // Premium gradient for selected tab
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              tabColor,
                              tabColor.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    // Subtle surface color for unselected tabs
                    color: isSelected
                        ? null
                        : (isDarkMode
                            ? AppColors.darkCard
                            : AppColors.surfaceVariant),
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? Border.all(
                            color: tabColor.withValues(alpha: 0.3),
                            width: 1.5,
                          )
                        : Border.all(
                            color: isDarkMode
                                ? AppColors.darkDivider
                                : AppColors.outline,
                          ),
                    // Premium shadow for selected tab
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: tabColor.withValues(
                                  alpha: isDarkMode ? 0.4 : 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: tabColor.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        dayIcons[index],
                        size: 16,
                        color: isSelected ? AppColors.textOnPrimary : tabColor,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          dayNames[index],
                          style: TextStyle(
                            color:
                                isSelected ? AppColors.textOnPrimary : tabColor,
                            fontSize: 14,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
