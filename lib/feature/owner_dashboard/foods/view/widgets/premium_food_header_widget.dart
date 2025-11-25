// ============================================================================
// Premium Food Header Widget - Reusable Header for Food Management
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
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

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  static String _text(
    String key,
    String fallback, {
    Map<String, dynamic>? parameters,
  }) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    final foodVM = context.watch<OwnerFoodViewModel>();
    final loc = AppLocalizations.of(context);

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

    final surfaceColor = ThemeColors.getCardBackground(context);
    final isDarkMode = context.isDarkMode;

    // Constrain the widget to preferredSize to prevent overflow
    return SizedBox(
      height: preferredSize.height,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Premium Header section with gradient background
          Flexible(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.isMobile
                  ? AppSpacing.paddingXS
                  : AppSpacing.paddingS),
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
                    color: ThemeColors.getDivider(context),
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.isDarkMode
                        ? context.colors.shadow.withValues(alpha: 0.2)
                        : dayColors[currentTabIndex].withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(
                      context, foodVM, dayColors[currentTabIndex], loc),
                ],
              ),
            ),
          ),
          // Premium Day tabs with gradient backgrounds
          Container(
            height: 48, // Fixed height for tab bar
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
                context, surfaceColor, dayColors[currentTabIndex], loc),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, OwnerFoodViewModel foodVM,
      Color dayColor, AppLocalizations? loc) {
    final stats = foodVM.menuStats;
    final totalItems = (stats['totalBreakfastItems'] ?? 0) +
        (stats['totalLunchItems'] ?? 0) +
        (stats['totalDinnerItems'] ?? 0);

    return Row(
      children: [
        Expanded(
          child: _buildStatChip(
            context,
            '${stats['totalWeeklyMenus'] ?? 0}',
            loc?.days ?? _text('days', 'Days'),
            Icons.calendar_today_rounded,
            dayColor,
          ),
        ),
        SizedBox(
            width:
                context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS),
        Expanded(
          child: _buildStatChip(
            context,
            '$totalItems',
            loc?.items ?? _text('items', 'Items'),
            Icons.restaurant_rounded,
            dayColor,
          ),
        ),
        SizedBox(
            width:
                context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS),
        Expanded(
          child: _buildStatChip(
            context,
            '${stats['totalPhotos'] ?? 0}',
            loc?.photos ?? _text('photos', 'Photos'),
            Icons.photo_library_rounded,
            dayColor,
          ),
        ),
        if ((stats['upcomingFestivals'] ?? 0) > 0) ...[
          SizedBox(
              width: context.isMobile
                  ? AppSpacing.paddingXS
                  : AppSpacing.paddingS),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.isMobile ? 6 : 8,
                vertical: context.isMobile ? 4 : 6,
              ),
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
                    size: context.isMobile ? 12 : 14,
                  ),
                  SizedBox(width: context.isMobile ? 1 : 2),
                  Flexible(
                    child: Text(
                      '${stats['upcomingFestivals']} ${loc?.festival ?? _text('festival', 'Festival')}',
                      style: TextStyle(
                        color: dayColor,
                        fontSize: context.isMobile ? 9 : 10,
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

  Widget _buildStatChip(BuildContext context, String value, String label,
      IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.isMobile ? 6 : 8,
        vertical: context.isMobile ? 4 : 6,
      ),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: context.isMobile ? 12 : 14,
          ),
          SizedBox(
              width: context.isMobile
                  ? AppSpacing.paddingXS * 0.5
                  : AppSpacing.paddingXS),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: context.isMobile ? 10 : 12,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: color.withValues(alpha: 0.7),
                    fontSize: context.isMobile ? 8 : 9,
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

  Widget _buildPremiumTabBar(BuildContext context, Color surfaceColor,
      Color dayColor, AppLocalizations? loc) {
    final isDarkMode = context.isDarkMode;
    final dayNames = [
      loc?.dayShortMon ?? _text('dayShortMon', 'Mon'),
      loc?.dayShortTue ?? _text('dayShortTue', 'Tue'),
      loc?.dayShortWed ?? _text('dayShortWed', 'Wed'),
      loc?.dayShortThu ?? _text('dayShortThu', 'Thu'),
      loc?.dayShortFri ?? _text('dayShortFri', 'Fri'),
      loc?.dayShortSat ?? _text('dayShortSat', 'Sat'),
      loc?.dayShortSun ?? _text('dayShortSun', 'Sun'),
    ];
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
            color: ThemeColors.getDivider(context),
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
                            color: ThemeColors.getDivider(context),
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
                      const SizedBox(width: AppSpacing.paddingS),
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
