// lib/features/owner_dashboard/foods/view/widgets/owner_menu_day_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../data/models/owner_food_menu.dart';
import '../../viewmodel/owner_food_viewmodel.dart';
import '../screens/owner_menu_edit_screen.dart';
import 'package:intl/intl.dart';

/// World-class UI for displaying day's menu with premium design
class OwnerMenuDayTab extends StatelessWidget {
  final String dayLabel;
  const OwnerMenuDayTab({required this.dayLabel, super.key});

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
  Widget build(BuildContext context) {
    final vm = Provider.of<OwnerFoodViewModel>(context);
    final OwnerFoodMenu? menu = vm.getMenuByDay(dayLabel);
    final loc = AppLocalizations.of(context);

    // Check for special menu override for today's date
    final today = DateTime.now();
    final specialOverride = vm.getMenuOverrideForDate(today);

    if (menu == null) {
      return _buildEmptyState(context);
    }

    return CustomScrollView(
      slivers: [
        // Day Header
        SliverToBoxAdapter(
          child: _buildDayHeader(context),
        ),

        // Special Menu Override Banner (if exists)
        if (specialOverride != null)
          SliverToBoxAdapter(
            child: _buildSpecialMenuBanner(context, specialOverride, loc),
          ),

        // Feedback aggregates banner for today (likes/dislikes per meal)
        if (dayLabel == DateFormat('EEEE').format(DateTime.now()))
          SliverToBoxAdapter(
            child: _buildFeedbackBanner(context, vm, loc),
          ),

        // Breakfast Section
        SliverToBoxAdapter(
          child: _buildMealSection(
            context,
            (loc?.breakfast ?? _text('breakfast', 'Breakfast')).toUpperCase(),
            loc?.breakfastTime ?? _text('breakfastTime', '7:00 AM - 10:00 AM'),
            specialOverride?.breakfast ?? menu.breakfast,
            Icons.wb_sunny_outlined,
            const Color(0xFFFF6B6B),
            isSpecialMenu: specialOverride?.breakfast != null,
          ),
        ),

        // Lunch Section
        SliverToBoxAdapter(
          child: _buildMealSection(
            context,
            (loc?.lunch ?? _text('lunch', 'Lunch')).toUpperCase(),
            loc?.lunchTime ?? _text('lunchTime', '12:00 PM - 3:00 PM'),
            specialOverride?.lunch ?? menu.lunch,
            Icons.restaurant_outlined,
            const Color(0xFF4CAF50),
            isSpecialMenu: specialOverride?.lunch != null,
          ),
        ),

        // Dinner Section
        SliverToBoxAdapter(
          child: _buildMealSection(
            context,
            (loc?.dinner ?? _text('dinner', 'Dinner')).toUpperCase(),
            loc?.dinnerTime ?? _text('dinnerTime', '7:00 PM - 10:00 PM'),
            specialOverride?.dinner ?? menu.dinner,
            Icons.nightlight_outlined,
            const Color(0xFF9C27B0),
            isSpecialMenu: specialOverride?.dinner != null,
          ),
        ),

        // Edit Button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: PrimaryButton(
              label: loc?.editMenu ?? _text('editMenu', 'Edit Menu'),
              icon: Icons.edit,
              onPressed: () => _navigateToEditScreen(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackBanner(
      BuildContext context, OwnerFoodViewModel vm, AppLocalizations? loc) {
    final agg = vm.feedbackAggregates;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: AdaptiveCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeadingMedium(
                text: loc?.guestFeedbackToday ??
                    _text('guestFeedbackToday', 'Guest Feedback (Today)'),
              ),
              const SizedBox(height: AppSpacing.paddingS),
              _buildRow(context, loc?.breakfast ?? _text('breakfast', 'Breakfast'),
                  agg['breakfast']!),
              const SizedBox(height: AppSpacing.paddingXS),
              _buildRow(context, loc?.lunch ?? _text('lunch', 'Lunch'), agg['lunch']!),
              const SizedBox(height: AppSpacing.paddingXS),
              _buildRow(context,
                  loc?.dinner ?? _text('dinner', 'Dinner'), agg['dinner']!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, Map<String, int> counts) {
    final likes = counts['likes'] ?? 0;
    final dislikes = counts['dislikes'] ?? 0;
    return Row(
      children: [
        Expanded(child: BodyText(text: label)),
        const SizedBox(width: AppSpacing.paddingS),
        Icon(Icons.thumb_up_alt_outlined, size: 16, color: AppColors.success),
        const SizedBox(width: AppSpacing.paddingXS),
        CaptionText(text: likes.toString()),
        const SizedBox(width: AppSpacing.paddingM),
        Icon(Icons.thumb_down_alt_outlined, size: 16, color: context.decorativeRed),
        const SizedBox(width: AppSpacing.paddingXS),
        CaptionText(text: dislikes.toString()),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64, color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.5) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.paddingM),
          HeadingMedium(
            text: loc?.noMenuForDay(dayLabel) ??
                _text('noMenuForDay', 'No Menu for {day}',
                    parameters: {'day': dayLabel}),
          ),
          const SizedBox(height: AppSpacing.paddingS),
          BodyText(
            text: loc?.createMenuForThisDay ??
                _text('createMenuForThisDay',
                    'Create a menu for this day to get started'),
            align: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          PrimaryButton(
            label: loc?.createMenu ?? _text('createMenu', 'Create Menu'),
            icon: Icons.add,
            onPressed: () => _navigateToEditScreen(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDayHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.onPrimary, size: 24),
          const SizedBox(width: AppSpacing.paddingS),
          HeadingMedium(
            text: dayLabel,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(
    BuildContext context,
    String title,
    String time,
    List<String> items,
    IconData icon,
    Color color, {
    bool isSpecialMenu = false,
  }) {
    return AdaptiveCard(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: AppSpacing.paddingS),
              HeadingMedium(text: title),
              if (isSpecialMenu) ...[
                const SizedBox(width: AppSpacing.paddingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: BodyText(
                    text: (AppLocalizations.of(context)?.special ??
                            _text('special', 'Special'))
                        .toUpperCase(),
                    color: Theme.of(context).colorScheme.onPrimary,
                    small: true,
                  ),
                ),
              ],
              const Spacer(),
              BodyText(
                text: time,
                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                small: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          if (items.isEmpty)
            BodyText(
              text: AppLocalizations.of(context)?.ownerFoodNoItemsAddedYet ??
                  _text('ownerFoodNoItemsAddedYet', 'No items added yet'),
              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            )
          else
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.paddingXS),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 6, color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.5) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)),
                      const SizedBox(width: AppSpacing.paddingS),
                      Expanded(child: BodyText(text: item)),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildSpecialMenuBanner(BuildContext context,
      OwnerMenuOverride specialOverride, AppLocalizations? loc) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.warning,
            AppColors.warning.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.celebration, color: Theme.of(context).colorScheme.onPrimary, size: 24),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingMedium(
                  text: specialOverride.festivalName ??
                      loc?.specialMenuLabel ??
                      _text('specialMenuLabel', 'Special Menu'),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                if (specialOverride.specialNote != null &&
                    specialOverride.specialNote!.isNotEmpty)
                  BodyText(
                    text: specialOverride.specialNote!,
                    color: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.7),
                    small: true,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context) {
    final vm = Provider.of<OwnerFoodViewModel>(context, listen: false);
    final existingMenu = vm.getMenuByDay(dayLabel);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OwnerMenuEditScreen(
          dayLabel: dayLabel,
          existingMenu: existingMenu,
        ),
      ),
    );
  }
}
