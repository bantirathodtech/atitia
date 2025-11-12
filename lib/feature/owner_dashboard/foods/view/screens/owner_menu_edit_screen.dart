// ============================================================================
// Owner Menu Edit Screen - Edit Daily Menu
// ============================================================================
// Form for owners to edit breakfast, lunch, dinner items with theme toggle.
// ============================================================================

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/helpers/image_picker_helper.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/dialogs/confirmation_dialog.dart';
import '../../../../auth/logic/auth_provider.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../data/models/owner_food_menu.dart';
import '../../viewmodel/owner_food_viewmodel.dart';

/// Screen for owners to edit menu for a specific day
/// Allows adding/removing meal items, uploading photos, and updating descriptions
class OwnerMenuEditScreen extends StatefulWidget {
  final String dayLabel;
  final OwnerFoodMenu? existingMenu;

  const OwnerMenuEditScreen({
    required this.dayLabel,
    this.existingMenu,
    super.key,
  });

  @override
  State<OwnerMenuEditScreen> createState() => _OwnerMenuEditScreenState();
}

class _OwnerMenuEditScreenState extends State<OwnerMenuEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  late List<String> _breakfastItems;
  late List<String> _lunchItems;
  late List<String> _dinnerItems;
  late List<String> _photoUrls;

  bool _isSaving = false;
  final bool _isUploadingPhoto = false;
  final List<dynamic> _newPhotosToUpload = []; // File on mobile, XFile on web

  @override
  void initState() {
    super.initState();

    if (widget.existingMenu != null) {
      _breakfastItems = List.from(widget.existingMenu!.breakfast);
      _lunchItems = List.from(widget.existingMenu!.lunch);
      _dinnerItems = List.from(widget.existingMenu!.dinner);
      _photoUrls = List.from(widget.existingMenu!.photoUrls);
      _descriptionController.text = widget.existingMenu!.description ?? '';
    } else {
      _breakfastItems = [];
      _lunchItems = [];
      _dinnerItems = [];
      _photoUrls = [];
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if we're editing an existing menu or creating a new one
    final isEditing = widget.existingMenu != null;
    final loc = AppLocalizations.of(context)!;
    final appBarTitle = isEditing
        ? loc.ownerMenuEditTitleEdit(widget.dayLabel)
        : loc.ownerMenuEditTitleCreate(widget.dayLabel);

    return Scaffold(
      // =======================================================================
      // App Bar with Custom Actions + Theme Toggle
      // =======================================================================
      // AdaptiveAppBar automatically adds theme toggle after custom actions
      // Title changes based on edit vs create mode
      // Custom actions: Delete menu button (if menu exists)
      // Auto action: Theme toggle (Light/Dark/System)
      // =======================================================================
      appBar: AdaptiveAppBar(
        title: appBarTitle,
        elevation: 2,
        showThemeToggle: true, // Theme toggle for comfortable editing
        actions: [
          // Delete menu button (only shown if editing existing menu)
          if (isEditing)
            IconButton(
              icon: Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: _confirmDeleteMenu,
              tooltip: loc.ownerMenuEditDeleteTooltip,
            ),
          // Theme toggle automatically added after custom actions
        ],
      ),
      body: _isSaving
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AdaptiveLoader(),
                  const SizedBox(height: AppSpacing.paddingM),
                  BodyText(text: loc.ownerMenuEditSaving),
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
                    // Header Info
                    _buildHeaderCard(loc),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Photos Section
                    _buildPhotosSection(loc),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Breakfast Section
                    _buildMealSection(
                      loc: loc,
                      title: loc.breakfast,
                      items: _breakfastItems,
                      icon: Icons.free_breakfast,
                      onAdd: () =>
                          _addMealItem(loc, loc.breakfast, _breakfastItems),
                      onRemove: (index) =>
                          _removeMealItem(_breakfastItems, index),
                    ),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Lunch Section
                    _buildMealSection(
                      loc: loc,
                      title: loc.lunch,
                      items: _lunchItems,
                      icon: Icons.lunch_dining,
                      onAdd: () => _addMealItem(loc, loc.lunch, _lunchItems),
                      onRemove: (index) => _removeMealItem(_lunchItems, index),
                    ),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Dinner Section
                    _buildMealSection(
                      loc: loc,
                      title: loc.dinner,
                      items: _dinnerItems,
                      icon: Icons.dinner_dining,
                      onAdd: () => _addMealItem(loc, loc.dinner, _dinnerItems),
                      onRemove: (index) => _removeMealItem(_dinnerItems, index),
                    ),
                    const SizedBox(height: AppSpacing.paddingM),

                    // Description Section
                    _buildDescriptionSection(loc),
                    const SizedBox(height: AppSpacing.paddingXL),

                    // Save Button - Text changes based on edit vs create mode
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        onPressed: _saveMenu,
                        label: isEditing
                            ? loc.ownerMenuEditUpdateButton
                            : loc.ownerMenuEditCreateButton,
                        icon: isEditing
                            ? Icons.update
                            : Icons.save, // Dynamic icon
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  /// ============================================================================
  /// World-Class Header Card - Premium Menu Overview
  /// ============================================================================
  /// Displays menu summary with elegant design and theme support
  ///
  /// Features:
  /// - Day-specific gradient background
  /// - Real-time item count tracking
  /// - Photo count display
  /// - Last updated timestamp
  /// - Theme-aware colors for perfect visibility
  /// - Modern stat chips with icons
  /// ============================================================================
  Widget _buildHeaderCard(AppLocalizations loc) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    // final textPrimary =
    //     theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final primaryColor = theme.colorScheme.primary;

    final totalItems =
        _breakfastItems.length + _lunchItems.length + _dinnerItems.length;
    final totalPhotos = _photoUrls.length + _newPhotosToUpload.length;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        // Gradient background with day color
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withValues(alpha: isDarkMode ? 0.15 : 0.1),
            primaryColor.withValues(alpha: isDarkMode ? 0.08 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================================
          // Day Title Row with Icon
          // ====================================================================
          Row(
            children: [
              // Day Icon with gradient background
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor,
                      primaryColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.restaurant_menu_rounded,
                  color: AppColors.textOnPrimary, // White icon
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loc.ownerMenuEditOverviewTitle(widget.dayLabel),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.paddingXS),
                    Text(
                      loc.ownerMenuEditOverviewSubtitle,
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

          const SizedBox(height: AppSpacing.paddingM),

          // ====================================================================
          // Stats Row - Modern Design with Icons
          // ====================================================================
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // Total Items Stat
              _buildStatChip(
                context: context,
                label: loc.ownerMenuEditStatItems,
                value: '$totalItems',
                icon: Icons.list_alt,
                color: AppColors.info,
                isDarkMode: isDarkMode,
              ),

              // Breakfast Count
              _buildStatChip(
                context: context,
                label: loc.breakfast,
                value: '${_breakfastItems.length}',
                icon: Icons.breakfast_dining_rounded,
                color: AppColors.breakfast,
                isDarkMode: isDarkMode,
              ),

              // Lunch Count
              _buildStatChip(
                context: context,
                label: loc.lunch,
                value: '${_lunchItems.length}',
                icon: Icons.lunch_dining_rounded,
                color: AppColors.lunch,
                isDarkMode: isDarkMode,
              ),

              // Dinner Count
              _buildStatChip(
                context: context,
                label: loc.dinner,
                value: '${_dinnerItems.length}',
                icon: Icons.dinner_dining_rounded,
                color: AppColors.dinner,
                isDarkMode: isDarkMode,
              ),

              // Photos Count
              _buildStatChip(
                context: context,
                label: loc.ownerMenuEditStatPhotos,
                value: '$totalPhotos',
                icon: Icons.photo_library_rounded,
                color: AppColors.warning,
                isDarkMode: isDarkMode,
              ),
            ],
          ),

          // ====================================================================
          // Last Updated Info (if menu exists)
          // ====================================================================
          if (widget.existingMenu != null) ...[
            const SizedBox(height: AppSpacing.paddingM),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingM,
                vertical: AppSpacing.paddingS,
              ),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.darkCard.withValues(alpha: 0.5)
                    : AppColors.textOnPrimary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.darkDivider
                      : AppColors.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.update_rounded,
                    size: 16,
                    color: textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  Text(
                    loc.ownerMenuEditLastUpdated(
                        widget.existingMenu!.formattedUpdatedAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds modern stat chip with icon and count
  Widget _buildStatChip({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDarkMode ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: AppSpacing.paddingS),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingXS),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotosSection(AppLocalizations loc) {
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
                  Icon(
                    Icons.photo_library,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  HeadingSmall(text: loc.ownerMenuEditPhotosHeading),
                ],
              ),
              SecondaryButton(
                onPressed: _isUploadingPhoto ? null : () => _pickImage(loc),
                label: loc.ownerMenuEditAddPhoto,
                icon: Icons.add_photo_alternate,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Empty Photo State - Theme-aware
          if (_photoUrls.isEmpty && _newPhotosToUpload.isEmpty)
            _buildEmptyPhotoState(context)
          else
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // Existing photos from URL
                  ..._photoUrls.asMap().entries.map((entry) {
                    final index = entry.key;
                    final url = entry.value;
                    return _buildPhotoItem(
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, color: Colors.red);
                        },
                      ),
                      onDelete: () => _deletePhoto(index, isNewPhoto: false),
                    );
                  }),

                  // New photos from file (cross-platform)
                  ..._newPhotosToUpload.asMap().entries.map((entry) {
                    final index = entry.key;
                    final file = entry.value;
                    return _buildPhotoItem(
                      child: _buildImagePreview(
                          file), // Cross-platform image display
                      onDelete: () => _deletePhoto(index, isNewPhoto: true),
                      isNew: true,
                    );
                  }),
                ],
              ),
            ),

          if (_isUploadingPhoto) ...[
            const SizedBox(height: AppSpacing.paddingS),
            const LinearProgressIndicator(),
            const SizedBox(height: AppSpacing.paddingXS),
            BodyText(text: loc.ownerMenuEditUploadingPhoto, color: Colors.grey),
          ],
        ],
      ),
    );
  }

  Widget _buildPhotoItem({
    required Widget child,
    required VoidCallback onDelete,
    bool isNew = false,
  }) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      width: 120,
      height: 120,
      margin: const EdgeInsets.only(right: AppSpacing.paddingS),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
            child: SizedBox(
              width: 120,
              height: 120,
              child: child,
            ),
          ),
          if (isNew)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success, // Theme-aware success color
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  loc.ownerMenuEditBadgeNew,
                  style: TextStyle(
                    color: AppColors.textOnPrimary, // White text on green
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.paddingXS),
                decoration: BoxDecoration(
                  color: AppColors.error, // Theme-aware error color
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.textOnPrimary, // White icon on red
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds empty state when no photos are added (theme-aware)
  Widget _buildEmptyPhotoState(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final loc = AppLocalizations.of(context)!;

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.darkCard // Dark background in dark mode
            : AppColors.surfaceVariant, // Light background in light mode
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: isDarkMode
              ? AppColors.darkDivider // Subtle border in dark mode
              : AppColors.outline, // Medium border in light mode
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_camera,
              size: 40,
              color: isDarkMode
                  ? AppColors.textTertiary // Light icon in dark mode
                  : AppColors.textSecondary, // Medium icon in light mode
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: loc.ownerMenuEditNoPhotos,
              color: textSecondary, // Theme-aware text
            ),
          ],
        ),
      ),
    );
  }

  /// Builds meal section (Breakfast/Lunch/Dinner) with theme-aware colors
  Widget _buildMealSection({
    required AppLocalizations loc,
    required String title,
    required List<String> items,
    required IconData icon,
    required VoidCallback onAdd,
    required Function(int) onRemove,
  }) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    // final textPrimary =
    //     theme.textTheme.bodyLarge?.color ?? AppColors.textPrimary;
    final textSecondary =
        theme.textTheme.bodyMedium?.color ?? AppColors.textSecondary;
    final primaryColor = theme.colorScheme.primary;

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
                  Icon(icon, color: primaryColor, size: 20),
                  const SizedBox(width: AppSpacing.paddingS),
                  HeadingSmall(text: loc.ownerMenuEditOptionalSection(title)),
                  const SizedBox(width: AppSpacing.paddingS),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusS),
                    ),
                    child: BodyText(
                      text: loc.ownerMenuEditItemsCount(items.length),
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: onAdd,
                icon: Icon(Icons.add_circle, color: primaryColor),
                tooltip: loc.ownerMenuEditAddItemTooltip(title),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),

          // Empty state with theme-aware text
          if (items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.paddingM),
                child: BodyText(
                  text: loc.ownerMenuEditNoItemsForMeal(title),
                  color: textSecondary, // Theme-aware
                ),
              ),
            )
          else
            // Item list with theme-aware backgrounds and text
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.paddingS),
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.darkInputFill // Dark background for item
                      : AppColors.surfaceVariant, // Light background for item
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.darkDivider // Subtle border in dark mode
                        : AppColors.outline, // Medium border in light mode
                  ),
                ),
                child: Row(
                  children: [
                    // Item number badge
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: BodyText(
                          text: '${index + 1}',
                          color: primaryColor,
                          medium: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    // Item name with theme-aware text
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors
                              .textPrimary, // ✅ CRITICAL: Theme-aware text for visibility!
                        ),
                      ),
                    ),
                    // Delete button with theme-aware error color
                    IconButton(
                      onPressed: () => onRemove(index),
                      icon: Icon(
                        Icons.delete_outline,
                        color: AppColors.error, // Theme-aware error color
                        size: 20,
                      ),
                      tooltip: loc.ownerMenuEditRemoveItemTooltip,
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(AppLocalizations loc) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.paddingS),
              HeadingSmall(text: loc.ownerMenuEditDescriptionHeading),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          TextInput(
            controller: _descriptionController,
            label: loc.ownerMenuEditDescriptionLabel,
            hint: loc.ownerMenuEditDescriptionHint,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  /// Shows dialog to add meal item (theme-aware)
  Future<void> _addMealItem(
      AppLocalizations loc, String mealType, List<String> items) async {
    final controller = TextEditingController();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode
            ? AppColors.darkCard // Dark background for dark mode
            : AppColors.surface, // White background for light mode
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        ),
        title: HeadingMedium(text: loc.ownerMenuEditAddMealItemTitle(mealType)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: controller,
              autofocus: true,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color ??
                    AppColors.textPrimary, // Theme-aware text color
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: loc.ownerMenuEditItemNameLabel,
                hintText: loc.ownerMenuEditItemNameHint,
                prefixIcon: Icon(
                  Icons.restaurant_rounded,
                  color: theme.colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
                filled: true,
                fillColor: isDarkMode
                    ? AppColors.darkInputFill // Dark input background
                    : AppColors.surfaceVariant, // Light input background
                // Ensure label and hint are visible
                labelStyle: TextStyle(
                  color: theme.textTheme.bodyMedium?.color ??
                      AppColors.textSecondary,
                ),
                hintStyle: TextStyle(
                  color: (theme.textTheme.bodyMedium?.color ??
                          AppColors.textSecondary)
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
        actions: [
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
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        items.add(result);
      });
    }
  }

  void _removeMealItem(List<String> items, int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  /// Picks image from gallery (cross-platform: web & mobile)
  /// Returns File on mobile, XFile on web
  Future<void> _pickImage(AppLocalizations loc) async {
    try {
      final pickedFile = await ImagePickerHelper.pickImageFromGallery(
        imageQuality: 85, // Only parameter supported
      );

      if (pickedFile != null) {
        setState(() {
          _newPhotosToUpload.add(pickedFile); // Add File or XFile
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loc.ownerMenuEditImagePickError(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Builds image preview widget (cross-platform)
  /// Handles both File (mobile) and XFile (web)
  Widget _buildImagePreview(dynamic file) {
    if (file is XFile) {
      // Web: Use Image.network with XFile
      return FutureBuilder<Uint8List>(
        future: file.readAsBytes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
            );
          }
          return Container(
            color: AppColors.surfaceVariant,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    } else if (file is File) {
      // Mobile: Use Image.file
      return Image.file(
        file,
        fit: BoxFit.cover,
      );
    } else {
      // Fallback
      return Container(
        color: AppColors.errorContainer,
        child: Icon(
          Icons.error,
          color: AppColors.error,
        ),
      );
    }
  }

  void _deletePhoto(int index, {required bool isNewPhoto}) {
    setState(() {
      if (isNewPhoto) {
        _newPhotosToUpload.removeAt(index);
      } else {
        _photoUrls.removeAt(index);
      }
    });
  }

  Future<void> _saveMenu() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final loc = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    // Validation: At least one meal item required
    if (_breakfastItems.isEmpty &&
        _lunchItems.isEmpty &&
        _dinnerItems.isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(loc.ownerMenuEditMealRequired),
          backgroundColor: AppColors.warning, // Theme-aware warning color
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;

      final ownerId = user?.userId ?? '';

      // ========================================================================
      // CRITICAL: Validate owner ID before proceeding
      // ========================================================================
      if (ownerId.isEmpty) {
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(loc.ownerMenuEditAuthError),
              backgroundColor: AppColors.error,
            ),
          );
        }
        setState(() => _isSaving = false);
        return;
      }

      final foodVM = context.read<OwnerFoodViewModel>();

      // Upload new photos first
      final uploadedPhotoUrls = <String>[];
      for (int i = 0; i < _newPhotosToUpload.length; i++) {
        final file = _newPhotosToUpload[i];
        final fileName =
            'menu_${widget.dayLabel.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

        final photoUrl = await foodVM.uploadPhoto(ownerId, fileName, file);
        if (photoUrl != null) {
          uploadedPhotoUrls.add(photoUrl);
        } else {}
      }

      // Combine old and new photo URLs
      final allPhotoUrls = [..._photoUrls, ...uploadedPhotoUrls];

      // Create updated menu
      // FIXED: BuildContext async gap warning
      // Flutter recommends: Store context-dependent values before async operations
      // Changed from: Using context.read() after async gap (uploadPhoto loop)
      // Changed to: Check mounted and store values before async operations
      if (!mounted) return;
      final selectedPgProvider = context.read<SelectedPgProvider>();
      final currentPgId = selectedPgProvider.selectedPgId;

      final menuId = widget.existingMenu?.menuId ??
          '${ownerId}_${currentPgId ?? 'legacy'}_${widget.dayLabel.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}';

      final updatedMenu = OwnerFoodMenu(
        menuId: menuId,
        ownerId: ownerId,
        pgId: currentPgId, // Link menu to selected PG
        day: widget.dayLabel,
        breakfast: _breakfastItems,
        lunch: _lunchItems,
        dinner: _dinnerItems,
        photoUrls: allPhotoUrls,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        isActive: true,
        createdAt: widget.existingMenu?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final totalItemsCount =
          _breakfastItems.length + _lunchItems.length + _dinnerItems.length;
      debugPrint(loc.ownerMenuEditLogTotalItems(totalItemsCount));

      // Save to repository
      final success = await foodVM.saveWeeklyMenu(updatedMenu);

      if (success) {
        final isEditing = widget.existingMenu != null;
        debugPrint(isEditing
            ? loc.ownerMenuEditLogUpdateSuccess
            : loc.ownerMenuEditLogCreateSuccess); // Debug log

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
              content: Text(isEditing
                  ? loc.ownerMenuEditUpdateSuccess(widget.dayLabel)
                  : loc.ownerMenuEditCreateSuccess(widget.dayLabel)),
              backgroundColor: AppColors.success, // Theme-aware success color
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
              content: Text(loc.ownerMenuEditSaveFailed(errorMessage)),
              backgroundColor: AppColors.error, // Theme-aware error color
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(loc.ownerMenuEditSaveError(e.toString())),
            backgroundColor: AppColors.error, // Theme-aware error color
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

  Future<void> _confirmDeleteMenu() async {
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: loc.ownerMenuEditClearTitle,
        message: loc.ownerMenuEditClearMessage,
        confirmText: loc.ownerMenuEditClearConfirm,
        cancelText: loc.cancel,
        isDestructive: true,
      ),
    );

    if (confirmed == true) {
      setState(() {
        _breakfastItems.clear();
        _lunchItems.clear();
        _dinnerItems.clear();
        _photoUrls.clear();
        _newPhotosToUpload.clear();
        _descriptionController.clear();
      });

      // FIXED: BuildContext async gap warning
      // Flutter recommends: Check mounted before using context after async operations
      // Changed from: Using context after async operation (setState)
      // Changed to: Check mounted before using context
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.ownerMenuEditClearSnackbar),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
