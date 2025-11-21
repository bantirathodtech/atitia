// ============================================================================
// Owner Special Menu Screen - Festival/Event Menu Override
// ============================================================================
// Create special menus for festivals, events, or specific dates with theme toggle.
// ============================================================================

// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/theme_colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../data/models/owner_food_menu.dart';
import '../../viewmodel/owner_food_viewmodel.dart';
import '../../../../../l10n/app_localizations.dart';

/// Screen for owners to create special menu overrides for festivals/events
class OwnerSpecialMenuScreen extends StatefulWidget {
  final OwnerMenuOverride? existingOverride;

  const OwnerSpecialMenuScreen({
    this.existingOverride,
    super.key,
  });

  @override
  State<OwnerSpecialMenuScreen> createState() => _OwnerSpecialMenuScreenState();
}

class _OwnerSpecialMenuScreenState extends State<OwnerSpecialMenuScreen> {
  final _formKey = GlobalKey<FormState>();
  final _festivalNameController = TextEditingController();
  final _specialNoteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  List<String>? _breakfastItems;
  List<String>? _lunchItems;
  List<String>? _dinnerItems;
  List<String>? _photoUrls;

  bool _isSaving = false;
  // final List<File> _newPhotosToUpload = [];

  @override
  void initState() {
    super.initState();

    if (widget.existingOverride != null) {
      _selectedDate = widget.existingOverride!.date;
      _festivalNameController.text =
          widget.existingOverride!.festivalName ?? '';
      _specialNoteController.text = widget.existingOverride!.specialNote ?? '';
      _breakfastItems = widget.existingOverride!.breakfast != null
          ? List.from(widget.existingOverride!.breakfast!)
          : null;
      _lunchItems = widget.existingOverride!.lunch != null
          ? List.from(widget.existingOverride!.lunch!)
          : null;
      _dinnerItems = widget.existingOverride!.dinner != null
          ? List.from(widget.existingOverride!.dinner!)
          : null;
      _photoUrls = widget.existingOverride!.photoUrls != null
          ? List.from(widget.existingOverride!.photoUrls!)
          : null;
    }
  }

  @override
  void dispose() {
    _festivalNameController.dispose();
    _specialNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final appBarTitle = widget.existingOverride != null
        ? loc.ownerSpecialMenuEditTitle
        : loc.ownerSpecialMenuAddTitle;
    return Scaffold(
      // =======================================================================
      // App Bar with Theme Toggle - Special Menu
      // =======================================================================
      appBar: AdaptiveAppBar(
        title: appBarTitle,
        elevation: 2,
        showThemeToggle: true, // Theme toggle for comfortable form filling
      ),
      body: _isSaving
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AdaptiveLoader(),
                  const SizedBox(height: AppSpacing.paddingM),
                  BodyText(text: loc.ownerSpecialMenuSaving),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Selection
                    _buildDateSection(loc),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Festival Name
                    _buildFestivalSection(loc),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Special Note
                    _buildNoteSection(loc),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Info about fallback
                    _buildFallbackInfo(loc),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Meal Sections (Optional)
                    _buildOptionalMealSection(
                      loc,
                      loc.breakfast,
                      _breakfastItems,
                      Icons.free_breakfast,
                      (items) => setState(() => _breakfastItems = items),
                    ),
                    const SizedBox(height: AppSpacing.paddingM),

                    _buildOptionalMealSection(
                      loc,
                      loc.lunch,
                      _lunchItems,
                      Icons.lunch_dining,
                      (items) => setState(() => _lunchItems = items),
                    ),
                    const SizedBox(height: AppSpacing.paddingM),

                    _buildOptionalMealSection(
                      loc,
                      loc.dinner,
                      _dinnerItems,
                      Icons.dinner_dining,
                      (items) => setState(() => _dinnerItems = items),
                    ),
                    const SizedBox(height: AppSpacing.paddingXL),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        onPressed: _saveSpecialMenu,
                        label: loc.ownerSpecialMenuSaveButton,
                        icon: Icons.save,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDateSection(AppLocalizations loc) {
    final formattedDate =
        DateFormat.yMMMMd(loc.localeName).format(_selectedDate);

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: context.primaryColor, size: 20),
              const SizedBox(width: AppSpacing.paddingS),
              HeadingSmall(text: loc.date),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          InkWell(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              decoration: BoxDecoration(
                color: context.theme.inputDecorationTheme.fillColor,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                border: Border.all(
                  color: ThemeColors.getDivider(context),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyText(
                    text: formattedDate,
                    medium: true,
                  ),
                  Icon(Icons.edit_calendar, color: context.primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFestivalSection(AppLocalizations loc) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.celebration,
                  color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: AppSpacing.paddingS),
              HeadingSmall(text: loc.ownerSpecialMenuFestivalHeading),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextInput(
            controller: _festivalNameController,
            label: loc.name,
            hint: loc.ownerSpecialMenuFestivalHint,
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection(AppLocalizations loc) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: AppSpacing.paddingS),
              HeadingSmall(text: loc.ownerSpecialMenuSpecialNoteHeading),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextInput(
            controller: _specialNoteController,
            label: loc.ownerSpecialMenuSpecialNoteLabel,
            hint: loc.ownerSpecialMenuSpecialNoteHint,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackInfo(AppLocalizations loc) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      backgroundColor: context.isDarkMode
          ? AppColors.info.withValues(alpha: 0.15)
          : AppColors.infoContainer,
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.isDarkMode
                ? AppColors.info
                : AppColors.info.withValues(alpha: 0.8),
          ),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: BodyText(
              text: loc.ownerSpecialMenuFallbackInfo,
              color: context.isDarkMode
                  ? context.textTheme.bodyMedium?.color
                  : AppColors.info.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalMealSection(
    AppLocalizations loc,
    String title,
    List<String>? items,
    IconData icon,
    Function(List<String>?) onUpdate,
  ) {
    final isEnabled = items != null;
    final mealItems = items ?? [];

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: context.primaryColor, size: 20),
                  const SizedBox(width: AppSpacing.paddingS),
                  HeadingSmall(
                      text: loc.ownerSpecialMenuOptionalSection(title)),
                ],
              ),
              Switch(
                value: isEnabled,
                onChanged: (value) {
                  if (value) {
                    onUpdate([]);
                  } else {
                    onUpdate(null);
                  }
                },
                activeThumbColor: context.primaryColor,
              ),
            ],
          ),
          if (isEnabled) ...[
            const SizedBox(height: AppSpacing.paddingM),
            if (mealItems.isEmpty)
              Center(
                child: Column(
                  children: [
                    BodyText(
                      text: loc.ownerSpecialMenuNoItems,
                      color: context.isDarkMode
                          ? ThemeColors.getTextTertiary(context)
                          : ThemeColors.getTextSecondary(context),
                    ),
                    const SizedBox(height: AppSpacing.paddingS),
                    SecondaryButton(
                      onPressed: () =>
                          _addMealItem(loc, title, mealItems, onUpdate),
                      label: loc.ownerSpecialMenuAddItem,
                      icon: Icons.add,
                    ),
                  ],
                ),
              )
            else ...[
              ...mealItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.paddingS),
                  padding: const EdgeInsets.all(AppSpacing.paddingS),
                  decoration: BoxDecoration(
                    color: context.theme.inputDecorationTheme.fillColor,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                    border: Border.all(
                      color: ThemeColors.getDivider(context),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: context.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: context.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.paddingS),
                      Expanded(child: BodyText(text: item)),
                      IconButton(
                        onPressed: () {
                          mealItems.removeAt(index);
                          onUpdate(mealItems);
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: AppSpacing.paddingS),
              Align(
                alignment: Alignment.centerRight,
                child: SecondaryButton(
                  onPressed: () =>
                      _addMealItem(loc, title, mealItems, onUpdate),
                  label: loc.ownerSpecialMenuAddItem,
                  icon: Icons.add,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _addMealItem(
    AppLocalizations loc,
    String mealType,
    List<String> items,
    Function(List<String>?) onUpdate,
  ) async {
    final controller = TextEditingController();

    final result = await showDialog<String>(
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
              HeadingMedium(text: loc.ownerSpecialMenuAddMealItemTitle(mealType)),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: controller,
                label: loc.ownerSpecialMenuItemNameLabel,
                hint: loc.ownerSpecialMenuItemNameHint,
                autoFocus: true,
              ),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SecondaryButton(
                    onPressed: () => Navigator.of(context).pop(),
                    label: loc.cancel,
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  PrimaryButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        Navigator.of(context).pop(controller.text.trim());
                      }
                    },
                    label: loc.add,
                    icon: Icons.add,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      items.add(result);
      onUpdate(items);
    }
  }

  Future<void> _saveSpecialMenu() async {
    final loc = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    // Validate festival name
    if (_festivalNameController.text.trim().isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            loc.ownerSpecialMenuFestivalRequired,
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final ownerId = authProvider.user?.userId ?? '';
      final foodVM = context.read<OwnerFoodViewModel>();

      // Create override
      final selectedPgProvider = context.read<SelectedPgProvider>();
      final currentPgId = selectedPgProvider.selectedPgId;

      final overrideId = widget.existingOverride?.overrideId ??
          '${ownerId}_${currentPgId ?? 'legacy'}_override_${_selectedDate.millisecondsSinceEpoch}';

      final override = OwnerMenuOverride(
        overrideId: overrideId,
        ownerId: ownerId,
        pgId: currentPgId, // Link override to selected PG
        date: _selectedDate,
        festivalName: _festivalNameController.text.trim(),
        breakfast: _breakfastItems,
        lunch: _lunchItems,
        dinner: _dinnerItems,
        photoUrls: _photoUrls,
        specialNote: _specialNoteController.text.trim().isEmpty
            ? null
            : _specialNoteController.text.trim(),
        isActive: true,
        createdAt: widget.existingOverride?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save override
      final success = await foodVM.saveOverride(override);

      if (success) {
        if (mounted) {
          // Refresh menus for current PG
          await foodVM.loadMenus(ownerId, pgId: currentPgId);

          // FIXED: BuildContext async gap warning
          // Flutter recommends: Check mounted again after async operations and store context values
          // Changed from: Using context after async gap with unrelated mounted check
          // Changed to: Check mounted immediately before using context, store Navigator and ScaffoldMessenger
          if (!mounted) return;
          navigator.pop();
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(loc.ownerSpecialMenuSaveSuccess),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        if (mounted) {
          final errorMessage = foodVM.errorMessage?.isNotEmpty == true
              ? foodVM.errorMessage!
              : loc.unknownErrorOccurred;
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(loc.ownerSpecialMenuSaveError(errorMessage)),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(
              loc.ownerSpecialMenuSaveError(e.toString()),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
