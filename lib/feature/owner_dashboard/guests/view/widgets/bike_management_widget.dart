// lib/feature/owner_dashboard/guests/view/widgets/bike_management_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../viewmodel/owner_guest_viewmodel.dart';
import '../../data/models/owner_bike_model.dart';

/// Widget for managing guest bikes
class BikeManagementWidget extends StatefulWidget {
  const BikeManagementWidget({super.key});

  @override
  State<BikeManagementWidget> createState() => _BikeManagementWidgetState();
}

class _BikeManagementWidgetState extends State<BikeManagementWidget> {
  final TextEditingController _searchController = TextEditingController();

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  String _text(
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
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final guestVM = context.read<OwnerGuestViewModel>();
    guestVM.setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final guestVM = context.watch<OwnerGuestViewModel>();
    final filteredBikes = guestVM.filteredBikes;

    return Column(
      children: [
        _buildSearchAndFilters(context, guestVM),
        Expanded(
          child: _buildBikeList(context, guestVM, filteredBikes),
        ),
      ],
    );
  }

  /// Builds search bar and filter controls
  Widget _buildSearchAndFilters(
      BuildContext context, OwnerGuestViewModel guestVM) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        children: [
          // Search bar with advanced options
          Row(
            children: [
              Expanded(
                child: TextInput(
                  controller: _searchController,
                  label: loc.searchBikes,
                  hint: loc.searchBikesHint,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            guestVM.setSearchQuery('');
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingS),
              // Advanced search button
              IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () => _showAdvancedSearch(context, guestVM),
                tooltip: loc.advancedSearch,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Filter chips with enhanced options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(loc.all, 'all', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(loc.active, 'active', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(loc.registered, 'registered',
                    guestVM.statusFilter, guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(loc.violation, 'violation',
                    guestVM.statusFilter, guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(loc.expired, 'expired', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(loc.premium, 'premium', guestVM.statusFilter,
                    guestVM.setStatusFilter),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds filter chip
  Widget _buildFilterChip(String label, String value, String currentFilter,
      Function(String) onTap) {
    final isSelected = currentFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onTap(selected ? value : 'all'),
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  /// Builds bike list
  Widget _buildBikeList(BuildContext context, OwnerGuestViewModel guestVM,
      List<OwnerBikeModel> bikes) {
    final loc = AppLocalizations.of(context)!;

    if (guestVM.loading && bikes.isEmpty) {
      return const Center(child: AdaptiveLoader());
    }

    return Column(
      children: [
        // Stats header
        _buildStatsHeader(context, guestVM, loc),
        const SizedBox(height: AppSpacing.paddingM),
        // Bike list or structured empty state
        Expanded(
          child: bikes.isEmpty
              ? _buildStructuredEmptyState(context, guestVM, loc)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingM),
                  itemCount: bikes.length,
                  itemBuilder: (context, index) {
                    final bike = bikes[index];
                    return _buildBikeCard(context, guestVM, bike);
                  },
                ),
        ),
      ],
    );
  }

  /// Builds stats header
  Widget _buildStatsHeader(
      BuildContext context, OwnerGuestViewModel guestVM, AppLocalizations loc) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              loc.totalBikes,
              guestVM.totalBikes.toString(),
              Icons.two_wheeler,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              loc.active,
              guestVM.activeBikes.toString(),
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              loc.violations,
              guestVM.bikes.where((b) => b.hasViolation).length.toString(),
              Icons.warning,
              AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual stat card
  Widget _buildStatCard(BuildContext context, String label, String value,
      IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppSpacing.paddingXS),
        HeadingMedium(text: value, color: color),
        const SizedBox(height: AppSpacing.paddingXS),
        BodyText(text: label),
      ],
    );
  }

  /// Builds structured empty state with placeholder rows
  Widget _buildStructuredEmptyState(
      BuildContext context, OwnerGuestViewModel guestVM, AppLocalizations loc) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header row
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.two_wheeler_outlined,
                    size: 20,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5)),
                const SizedBox(width: AppSpacing.paddingS),
                BodyText(text: loc.bikeRegistry),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: BodyText(
                    text: loc.bikeCount(0),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.paddingM),
          // Placeholder rows
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.paddingM),
            itemCount: 3, // Show 3 placeholder rows
            itemBuilder: (context, index) => _buildPlaceholderBikeCard(context),
          ),
          // Empty state message
          Container(
            margin: const EdgeInsets.all(AppSpacing.paddingM),
            padding: const EdgeInsets.all(AppSpacing.paddingL),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                Icon(Icons.two_wheeler_outlined,
                    size: 48,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5)),
                const SizedBox(height: AppSpacing.paddingM),
                HeadingMedium(text: loc.noBikesRegistered),
                const SizedBox(height: AppSpacing.paddingS),
                BodyText(
                  text: loc.guestBikesWillAppearHere,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds placeholder bike card
  Widget _buildPlaceholderBikeCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // Placeholder bike icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(Icons.two_wheeler,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.4),
                size: 24),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          // Placeholder content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: 120,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: AppSpacing.paddingXS),
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: AppSpacing.paddingXS),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          // Placeholder status
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingS, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
            child: Container(
              height: 12,
              width: 60,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual bike card
  Widget _buildBikeCard(
      BuildContext context, OwnerGuestViewModel guestVM, OwnerBikeModel bike) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      child: AdaptiveCard(
        child: InkWell(
          onTap: () => _showBikeDetails(context, guestVM, bike),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bike header
                Row(
                  children: [
                    Icon(
                      Icons.two_wheeler,
                      color: bike.hasViolation
                          ? AppColors.error
                          : AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bike.fullBikeName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.paddingXS),
                          Text(
                            bike.guestInfo,
                            style: TextStyle(
                              color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withValues(alpha: 0.7) ??
                                  Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(context, bike.status),
                  ],
                ),

                const SizedBox(height: AppSpacing.paddingM),

                // Bike details
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.local_parking,
                        label: loc.parkingSpot,
                        value: bike.parkingSpot,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.palette,
                        label: loc.color,
                        value: bike.color,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.paddingS),

                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.category,
                        label: loc.bikeType,
                        value: bike.bikeTypeDisplay,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.schedule,
                        label: loc.registeredOn,
                        value: _formatDate(bike.registrationDate),
                      ),
                    ),
                  ],
                ),

                if (bike.hasViolation && bike.violationReason != null) ...[
                  const SizedBox(height: AppSpacing.paddingS),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.paddingS),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning, color: AppColors.error, size: 16),
                        const SizedBox(width: AppSpacing.paddingS),
                        Expanded(
                          child: Text(
                            loc.violationWithReason(bike.violationReason!),
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                if (bike.lastParkedDate != null) ...[
                  const SizedBox(height: AppSpacing.paddingS),
                  _buildDetailItem(
                    icon: Icons.timer,
                    label: loc.lastParked,
                    value: bike.lastParkedDisplay,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds detail item
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon,
            size: 16,
            color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.7) ??
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
        const SizedBox(width: AppSpacing.paddingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.color
                          ?.withValues(alpha: 0.7) ??
                      Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds status chip
  Widget _buildStatusChip(BuildContext context, String status) {
    final loc = AppLocalizations.of(context)!;

    Color chipColor;
    Color textColor;
    String statusLabel;

    switch (status.toLowerCase()) {
      case 'active':
        chipColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        statusLabel = loc.active;
        break;
      case 'registered':
        chipColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
        statusLabel = loc.registered;
        break;
      case 'violation':
        chipColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        statusLabel = loc.violation;
        break;
      case 'expired':
        chipColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        statusLabel = loc.expired;
        break;
      case 'premium':
        chipColor = AppColors.secondary.withValues(alpha: 0.1);
        textColor = AppColors.secondary;
        statusLabel = loc.premium;
        break;
      case 'removed':
        chipColor =
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
        textColor =
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
        statusLabel = loc.removed;
        break;
      default:
        chipColor =
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
        textColor =
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
        statusLabel = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        statusLabel,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Shows bike details dialog
  void _showBikeDetails(
      BuildContext context, OwnerGuestViewModel guestVM, OwnerBikeModel bike) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final loc = AppLocalizations.of(dialogContext)!;

        return AlertDialog(
          title: Text(bike.fullBikeName),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow(loc.guest, bike.guestInfo),
                _buildDetailRow(loc.bikeNumber, bike.bikeNumber),
                _buildDetailRow(loc.bikeName, bike.bikeName),
                _buildDetailRow(loc.bikeType, bike.bikeTypeDisplay),
                _buildDetailRow(loc.color, bike.color),
                _buildDetailRow(loc.parkingSpot, bike.parkingSpot),
                _buildDetailRow(loc.status, bike.statusDisplay),
                _buildDetailRow(
                    loc.registeredOn, _formatDate(bike.registrationDate)),
                if (bike.lastParkedDate != null)
                  _buildDetailRow(
                      loc.lastParked, _formatDate(bike.lastParkedDate!)),
                if (bike.removalDate != null)
                  _buildDetailRow(loc.removed, _formatDate(bike.removalDate!)),
                if (bike.violationReason != null)
                  _buildDetailRow(loc.violationLabel, bike.violationReason!),
                if (bike.notes != null) _buildDetailRow(loc.notes, bike.notes!),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(loc.close),
            ),
            PrimaryButton(
              label: loc.editBike,
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _editBike(context, guestVM, bike);
              },
            ),
            if (bike.isActive) ...[
              PrimaryButton(
                label: loc.moveBike,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _moveBike(context, guestVM, bike);
                },
              ),
              PrimaryButton(
                label: loc.removeBike,
                onPressed: () => _removeBike(context, guestVM, bike),
              ),
            ],
          ],
        );
      },
    );
  }

  /// Builds detail row for dialog
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// Shows edit bike dialog
  void _editBike(
      BuildContext context, OwnerGuestViewModel guestVM, OwnerBikeModel bike) {
    final parkingController = TextEditingController(text: bike.parkingSpot);
    final notesController = TextEditingController(text: bike.notes ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        final loc = AppLocalizations.of(dialogContext)!;

        return AlertDialog(
          title: Text(loc.editBike),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInput(
                  controller: parkingController,
                  label: loc.parkingSpot,
                ),
                const SizedBox(height: AppSpacing.paddingM),
                TextInput(
                  controller: notesController,
                  label: loc.notes,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(loc.cancel),
            ),
            PrimaryButton(
              label: loc.saveChanges,
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final locOuter = AppLocalizations.of(context);
                final updatedBike = bike.copyWith(
                  parkingSpot: parkingController.text,
                  notes: notesController.text.isNotEmpty
                      ? notesController.text
                      : null,
                  updatedAt: DateTime.now(),
                );

                final success = await guestVM.updateBike(updatedBike);
                // FIXED: BuildContext async gap warning
                // Flutter recommends: Check mounted immediately before using context after async operations
                // Changed from: Using context with mounted check in compound condition after async gap
                // Changed to: Check mounted immediately before each context usage
                // Note: Navigator and ScaffoldMessenger are safe to use after async when mounted check is performed, analyzer flags as false positive
                if (!success || !mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.of(dialogContext).pop();
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      locOuter?.bikeUpdatedSuccessfully ??
                          _text('bikeUpdatedSuccessfully',
                              'Bike updated successfully'),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows move bike dialog
  void _moveBike(
      BuildContext context, OwnerGuestViewModel guestVM, OwnerBikeModel bike) {
    final newSpotController = TextEditingController();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final loc = AppLocalizations.of(dialogContext)!;

        return AlertDialog(
          title: Text(loc.moveBike),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(loc.currentSpot(bike.parkingSpot)),
                const SizedBox(height: AppSpacing.paddingM),
                TextInput(
                  controller: newSpotController,
                  label: loc.newParkingSpot,
                ),
                const SizedBox(height: AppSpacing.paddingM),
                TextInput(
                  controller: reasonController,
                  label: loc.reasonForMove,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(loc.cancel),
            ),
            PrimaryButton(
              label: loc.moveBike,
              onPressed: () async {
                if (newSpotController.text.isNotEmpty) {
                  final navigator = Navigator.of(dialogContext);
                  final messenger = ScaffoldMessenger.of(context);
                  final locOuter = AppLocalizations.of(context);
                  final request = BikeMovementRequest(
                    requestId: DateTime.now().millisecondsSinceEpoch.toString(),
                    bikeId: bike.bikeId,
                    guestId: bike.guestId,
                    guestName: bike.guestName,
                    pgId: bike.pgId,
                    ownerId: bike.ownerId,
                    requestType: 'move',
                    currentSpot: bike.parkingSpot,
                    newSpot: newSpotController.text,
                    reason: reasonController.text.isNotEmpty
                        ? reasonController.text
                        : loc.ownerRequestedMove,
                    status: 'pending',
                    requestedAt: DateTime.now(),
                    isActive: true,
                  );

                  final success =
                      await guestVM.createBikeMovementRequest(request);
                  // FIXED: BuildContext async gap warning
                  if (!success || !mounted) return;
                  navigator.pop();
                  if (!mounted) return;
                  // ignore: use_build_context_synchronously
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(
                        locOuter?.bikeMovementRequestCreated ??
                            _text('bikeMovementRequestCreated',
                                'Bike movement request created'),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows remove bike dialog
  void _removeBike(
      BuildContext context, OwnerGuestViewModel guestVM, OwnerBikeModel bike) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final loc = AppLocalizations.of(dialogContext)!;

        return AlertDialog(
          title: Text(loc.removeBike),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(loc.areYouSureYouWantToRemoveBike(bike.fullBikeName)),
                const SizedBox(height: AppSpacing.paddingM),
                TextInput(
                  controller: reasonController,
                  label: loc.reasonForRemoval,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(loc.cancel),
            ),
            PrimaryButton(
              label: loc.removeBike,
              onPressed: () async {
                final navigator = Navigator.of(dialogContext);
                final messenger = ScaffoldMessenger.of(context);
                final locOuter = AppLocalizations.of(context);
                final request = BikeMovementRequest(
                  requestId: DateTime.now().millisecondsSinceEpoch.toString(),
                  bikeId: bike.bikeId,
                  guestId: bike.guestId,
                  guestName: bike.guestName,
                  pgId: bike.pgId,
                  ownerId: bike.ownerId,
                  requestType: 'remove',
                  currentSpot: bike.parkingSpot,
                  reason: reasonController.text.isNotEmpty
                      ? reasonController.text
                      : loc.ownerRequestedRemoval,
                  status: 'pending',
                  requestedAt: DateTime.now(),
                  isActive: true,
                );

                final success =
                    await guestVM.createBikeMovementRequest(request);
                // FIXED: BuildContext async gap warning
                if (!success || !mounted) return;
                navigator.pop();
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      locOuter?.bikeRemovalRequestCreated ??
                          _text('bikeRemovalRequestCreated',
                              'Bike removal request created'),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Formats date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Shows advanced search dialog
  void _showAdvancedSearch(BuildContext context, OwnerGuestViewModel guestVM) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final loc = AppLocalizations.of(dialogContext)!;

        return AlertDialog(
          title: HeadingMedium(text: loc.advancedSearch),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextInput(
                label: loc.bikeNumber,
                hint: loc.bikeNumber,
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                label: loc.guestName,
                hint: loc.guestName,
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                label: loc.bikeModel,
                hint: loc.bikeModel,
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                label: loc.bikeColor,
                hint: loc.bikeColor,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(loc.cancel),
            ),
            PrimaryButton(
              label: loc.search,
              onPressed: () {
                Navigator.pop(dialogContext);
                // TODO: Implement advanced search
              },
            ),
          ],
        );
      },
    );
  }
}
