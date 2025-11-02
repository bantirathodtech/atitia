// lib/feature/owner_dashboard/guests/view/widgets/bike_management_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
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
                  label: 'Search Bikes',
                  hint: 'Search by number, name, guest, or model...',
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
                tooltip: 'Advanced Search',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Filter chips with enhanced options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('Active', 'active', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('Registered', 'registered',
                    guestVM.statusFilter, guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('Violation', 'violation', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('Expired', 'expired', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('Premium', 'premium', guestVM.statusFilter,
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
    if (guestVM.loading && bikes.isEmpty) {
      return const Center(child: AdaptiveLoader());
    }

    return Column(
      children: [
        // Stats header
        _buildStatsHeader(context, guestVM),
        const SizedBox(height: AppSpacing.paddingM),
        // Bike list or structured empty state
        Expanded(
          child: bikes.isEmpty
              ? _buildStructuredEmptyState(context, guestVM)
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
  Widget _buildStatsHeader(BuildContext context, OwnerGuestViewModel guestVM) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              'Total Bikes',
              guestVM.totalBikes.toString(),
              Icons.two_wheeler,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              'Active',
              guestVM.activeBikes.toString(),
              Icons.check_circle,
              Colors.green,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              'Violations',
              guestVM.bikes.where((b) => b.hasViolation).length.toString(),
              Icons.warning,
              Colors.red,
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
      BuildContext context, OwnerGuestViewModel guestVM) {
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
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.two_wheeler_outlined,
                    size: 20, color: Colors.grey),
                const SizedBox(width: AppSpacing.paddingS),
                const BodyText(text: 'Bike Registry'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: const BodyText(text: '0 bikes'),
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
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                const Icon(Icons.two_wheeler_outlined,
                    size: 48, color: Colors.grey),
                const SizedBox(height: AppSpacing.paddingM),
                const HeadingMedium(text: 'No Bikes Registered'),
                const SizedBox(height: AppSpacing.paddingS),
                const BodyText(
                  text: 'Guest bikes will appear here when registered',
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
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          // Placeholder bike icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(Icons.two_wheeler,
                color: Colors.grey.withValues(alpha: 0.4), size: 24),
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
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: AppSpacing.paddingXS),
                Container(
                  height: 12,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: AppSpacing.paddingXS),
                Container(
                  height: 12,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
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
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
            ),
            child: Container(
              height: 12,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.3),
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
                      color: bike.hasViolation ? Colors.red : AppColors.primary,
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
                          const SizedBox(height: 4),
                          Text(
                            bike.guestInfo,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(bike.status),
                  ],
                ),

                const SizedBox(height: AppSpacing.paddingM),

                // Bike details
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.local_parking,
                        label: 'Parking Spot',
                        value: bike.parkingSpot,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.palette,
                        label: 'Color',
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
                        label: 'Type',
                        value: bike.bikeTypeDisplay,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.schedule,
                        label: 'Registered',
                        value: _formatDate(bike.registrationDate),
                      ),
                    ),
                  ],
                ),

                if (bike.hasViolation && bike.violationReason != null) ...[
                  const SizedBox(height: AppSpacing.paddingS),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Violation: ${bike.violationReason}',
                            style: const TextStyle(
                              color: Colors.red,
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
                    label: 'Last Parked',
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
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
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
  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        chipColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        break;
      case 'registered':
        chipColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        break;
      case 'violation':
        chipColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        break;
      case 'removed':
        chipColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        break;
      default:
        chipColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.toUpperCase(),
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
      builder: (context) => AlertDialog(
        title: Text(bike.fullBikeName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Guest', bike.guestInfo),
              _buildDetailRow('Bike Number', bike.bikeNumber),
              _buildDetailRow('Bike Name', bike.bikeName),
              _buildDetailRow('Type', bike.bikeTypeDisplay),
              _buildDetailRow('Color', bike.color),
              _buildDetailRow('Parking Spot', bike.parkingSpot),
              _buildDetailRow('Status', bike.statusDisplay),
              _buildDetailRow('Registered', _formatDate(bike.registrationDate)),
              if (bike.lastParkedDate != null)
                _buildDetailRow(
                    'Last Parked', _formatDate(bike.lastParkedDate!)),
              if (bike.removalDate != null)
                _buildDetailRow('Removed', _formatDate(bike.removalDate!)),
              if (bike.violationReason != null)
                _buildDetailRow('Violation', bike.violationReason!),
              if (bike.notes != null) _buildDetailRow('Notes', bike.notes!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          PrimaryButton(
            label: 'Edit Bike',
            onPressed: () {
              Navigator.of(context).pop();
              _editBike(context, guestVM, bike);
            },
          ),
          if (bike.isActive) ...[
            PrimaryButton(
              label: 'Move Bike',
              onPressed: () {
                Navigator.of(context).pop();
                _moveBike(context, guestVM, bike);
              },
            ),
            PrimaryButton(
              label: 'Remove Bike',
              onPressed: () => _removeBike(context, guestVM, bike),
            ),
          ],
        ],
      ),
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
      builder: (context) => AlertDialog(
        title: const Text('Edit Bike'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextInput(
                controller: parkingController,
                label: 'Parking Spot',
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: notesController,
                label: 'Notes',
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Save Changes',
            onPressed: () async {
              final updatedBike = bike.copyWith(
                parkingSpot: parkingController.text,
                notes: notesController.text.isNotEmpty
                    ? notesController.text
                    : null,
                updatedAt: DateTime.now(),
              );

              final success = await guestVM.updateBike(updatedBike);
              if (success && mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bike updated successfully')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// Shows move bike dialog
  void _moveBike(
      BuildContext context, OwnerGuestViewModel guestVM, OwnerBikeModel bike) {
    final newSpotController = TextEditingController();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move Bike'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Current spot: ${bike.parkingSpot}'),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: newSpotController,
                label: 'New Parking Spot',
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: reasonController,
                label: 'Reason for move',
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Move Bike',
            onPressed: () async {
              if (newSpotController.text.isNotEmpty) {
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
                      : 'Owner requested move',
                  status: 'pending',
                  requestedAt: DateTime.now(),
                  isActive: true,
                );

                final success =
                    await guestVM.createBikeMovementRequest(request);
                if (success && mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Bike movement request created')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  /// Shows remove bike dialog
  void _removeBike(
      BuildContext context, OwnerGuestViewModel guestVM, OwnerBikeModel bike) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Bike'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to remove ${bike.fullBikeName}?'),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: reasonController,
                label: 'Reason for removal',
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Remove Bike',
            onPressed: () async {
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
                    : 'Owner requested removal',
                status: 'pending',
                requestedAt: DateTime.now(),
                isActive: true,
              );

              final success = await guestVM.createBikeMovementRequest(request);
              if (success && mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bike removal request created')),
                );
              }
            },
          ),
        ],
      ),
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
      builder: (context) => AlertDialog(
        title: const HeadingMedium(text: 'Advanced Search'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextInput(
              label: 'Bike Number',
              hint: 'Bike number',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Guest Name',
              hint: 'Guest name',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Model',
              hint: 'Bike model',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Color',
              hint: 'Bike color',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const BodyText(text: 'Cancel'),
          ),
          PrimaryButton(
            label: 'Search',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement advanced search
            },
          ),
        ],
      ),
    );
  }
}
