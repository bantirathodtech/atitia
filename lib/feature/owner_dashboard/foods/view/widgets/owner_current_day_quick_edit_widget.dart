// lib/feature/owner_dashboard/foods/view/widgets/owner_current_day_quick_edit_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/utils/helpers/menu_initialization_helper.dart';
import '../../viewmodel/owner_food_viewmodel.dart';
import '../screens/owner_menu_edit_screen.dart';

/// Quick edit widget for current day's menu
/// Shows today's menu with quick edit button
class OwnerCurrentDayQuickEditWidget extends StatelessWidget {
  const OwnerCurrentDayQuickEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final foodVM = context.watch<OwnerFoodViewModel>();
    final currentDayMenu = foodVM.currentDayMenu;
    final currentDay = MenuInitializationHelper.weekdayString(DateTime.now());
    
    // Theme-aware colors
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final textTertiary = isDarkMode ? AppColors.textTertiary : AppColors.textSecondary;

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.paddingS),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.today,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingSmall(
                        text: 'Today\'s Menu',
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 2),
                      BodyText(
                        text: currentDay,
                        color: textSecondary, // Theme-aware
                      ),
                    ],
                  ),
                ],
              ),
              if (currentDayMenu != null)
                IconButton(
                  onPressed: () => _editCurrentDayMenu(context, currentDayMenu, currentDay),
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  tooltip: 'Edit Today\'s Menu',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          
          if (currentDayMenu == null)
            Center(
              child: Column(
                children: [
                  BodyText(
                    text: 'No menu set for today',
                    color: textTertiary, // Theme-aware
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  PrimaryButton(
                    onPressed: () => _editCurrentDayMenu(context, null, currentDay),
                    label: 'Add Menu',
                    icon: Icons.add,
                  ),
                ],
              ),
            )
          else ...[
            _buildMealSummary(
              context,
              'Breakfast',
              currentDayMenu.breakfast.length,
              Icons.free_breakfast,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            _buildMealSummary(
              context,
              'Lunch',
              currentDayMenu.lunch.length,
              Icons.lunch_dining,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            _buildMealSummary(
              context,
              'Dinner',
              currentDayMenu.dinner.length,
              Icons.dinner_dining,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Icon(
                  Icons.photo_library,
                  size: 16,
                  color: textTertiary, // Theme-aware
                ),
                const SizedBox(width: AppSpacing.paddingXS),
                BodyText(
                  text: '${currentDayMenu.photoUrls.length} photos',
                  color: textTertiary, // Theme-aware
                ),
                const Spacer(),
                BodyText(
                  text: 'Updated: ${currentDayMenu.formattedUpdatedAt}',
                  color: textTertiary, // Theme-aware
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMealSummary(
    BuildContext context,
    String mealType,
    int itemCount,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: theme.primaryColor.withValues(alpha: 0.7),
        ),
        const SizedBox(width: AppSpacing.paddingS),
        BodyText(text: mealType, medium: true),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingS,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: itemCount > 0
                ? AppColors.success.withOpacity(isDarkMode ? 0.15 : 0.1) // Theme-aware
                : AppColors.warning.withOpacity(isDarkMode ? 0.15 : 0.1), // Theme-aware
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
          ),
          child: BodyText(
            text: '$itemCount items',
            color: itemCount > 0 ? AppColors.success : AppColors.warning, // Theme-aware
          ),
        ),
      ],
    );
  }

  void _editCurrentDayMenu(
    BuildContext context,
    dynamic menu,
    String currentDay,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OwnerMenuEditScreen(
          dayLabel: currentDay,
          existingMenu: menu,
        ),
      ),
    );
  }
}

