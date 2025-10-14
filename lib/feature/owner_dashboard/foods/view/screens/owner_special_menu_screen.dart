// ============================================================================
// Owner Special Menu Screen - Festival/Event Menu Override
// ============================================================================
// Create special menus for festivals, events, or specific dates with theme toggle.
// ============================================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
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
  final List<File> _newPhotosToUpload = [];

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
    return Scaffold(
      // =======================================================================
      // App Bar with Theme Toggle - Special Menu
      // =======================================================================
      appBar: AdaptiveAppBar(
        title: widget.existingOverride != null
            ? 'Edit Special Menu'
            : 'Add Special Menu',
        elevation: 2,
        showThemeToggle: true,  // Theme toggle for comfortable form filling
      ),
      body: _isSaving
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AdaptiveLoader(),
                  const SizedBox(height: AppSpacing.paddingM),
                  const BodyText(text: 'Saving special menu...'),
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
                    _buildDateSection(),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Festival Name
                    _buildFestivalSection(),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Special Note
                    _buildNoteSection(),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Info about fallback
                    _buildFallbackInfo(),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Meal Sections (Optional)
                    _buildOptionalMealSection(
                      'Breakfast',
                      _breakfastItems,
                      Icons.free_breakfast,
                      (items) => setState(() => _breakfastItems = items),
                    ),
                    const SizedBox(height: AppSpacing.paddingM),

                    _buildOptionalMealSection(
                      'Lunch',
                      _lunchItems,
                      Icons.lunch_dining,
                      (items) => setState(() => _lunchItems = items),
                    ),
                    const SizedBox(height: AppSpacing.paddingM),

                    _buildOptionalMealSection(
                      'Dinner',
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
                        label: 'Save Special Menu',
                        icon: Icons.save,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDateSection() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today,
                  color: theme.primaryColor, size: 20),
              const SizedBox(width: AppSpacing.paddingS),
              const HeadingSmall(text: 'Date'),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          InkWell(
            onTap: _selectDate,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.darkInputFill : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                border: Border.all(
                  color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyText(
                    text:
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    medium: true,
                  ),
                  Icon(Icons.edit_calendar,
                      color: theme.primaryColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFestivalSection() {
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
              const HeadingSmall(text: 'Festival/Event Name'),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextInput(
            controller: _festivalNameController,
            label: 'Name',
            hint: 'e.g., Diwali, Ugadi, Special Event',
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection() {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: AppSpacing.paddingS),
              const HeadingSmall(text: 'Special Note'),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextInput(
            controller: _specialNoteController,
            label: 'Note',
            hint: 'Any special instructions or details...',
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackInfo() {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      backgroundColor: isDarkMode 
          ? AppColors.info.withOpacity(0.15) 
          : AppColors.infoContainer,
      child: Row(
        children: [
          Icon(
            Icons.info_outline, 
            color: isDarkMode ? AppColors.info : AppColors.info.withOpacity(0.8),
          ),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: BodyText(
              text:
                  'Leave meal sections empty to use the default weekly menu for this day',
              color: isDarkMode 
                  ? theme.textTheme.bodyMedium?.color 
                  : AppColors.info.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalMealSection(
    String title,
    List<String>? items,
    IconData icon,
    Function(List<String>?) onUpdate,
  ) {
    final isEnabled = items != null;
    final mealItems = items ?? [];
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textSecondary = theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;

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
                  Icon(icon, color: theme.primaryColor, size: 20),
                  const SizedBox(width: AppSpacing.paddingS),
                  HeadingSmall(text: '$title (Optional)'),
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
                activeThumbColor: theme.primaryColor,
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
                      text: 'No items added', 
                      color: isDarkMode ? AppColors.textTertiary : AppColors.textSecondary,
                    ),
                    const SizedBox(height: AppSpacing.paddingS),
                    SecondaryButton(
                      onPressed: () => _addMealItem(title, mealItems, onUpdate),
                      label: 'Add Item',
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
                    color: isDarkMode ? AppColors.darkInputFill : AppColors.surfaceVariant,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                    border: Border.all(
                      color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: theme.primaryColor,
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
                  onPressed: () => _addMealItem(title, mealItems, onUpdate),
                  label: 'Add Item',
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
    String mealType,
    List<String> items,
    Function(List<String>?) onUpdate,
  ) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.surface,
        title: HeadingMedium(text: 'Add $mealType Item'),
        content: TextInput(
          controller: controller,
          label: 'Item Name',
          hint: 'e.g., Special Biryani',
          autoFocus: true,
        ),
        actions: [
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(),
            label: 'Cancel',
          ),
          PrimaryButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.of(context).pop(controller.text.trim());
              }
            },
            label: 'Add',
            icon: Icons.add,
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      items.add(result);
      onUpdate(items);
    }
  }

  Future<void> _saveSpecialMenu() async {
    // Validate festival name
    if (_festivalNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter festival/event name'),
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

          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Special menu saved successfully!'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Failed to save special menu: ${foodVM.errorMessage}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving special menu: $e'),
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
