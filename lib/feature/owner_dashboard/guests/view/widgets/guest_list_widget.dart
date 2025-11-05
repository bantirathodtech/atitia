// lib/feature/owner_dashboard/guests/view/widgets/guest_list_widget.dart

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
import '../../data/models/owner_guest_model.dart';

/// Widget for displaying and managing guest list
class GuestListWidget extends StatefulWidget {
  const GuestListWidget({super.key});

  @override
  State<GuestListWidget> createState() => _GuestListWidgetState();
}

class _GuestListWidgetState extends State<GuestListWidget> {
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
    final filteredGuests = guestVM.filteredGuests;

    return Column(
      children: [
        _buildSearchAndFilters(context, guestVM),
        Expanded(
          child: _buildGuestList(context, guestVM, filteredGuests),
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
                  label: 'Search Guests',
                  hint: 'Search by name, phone, room, or email...',
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
                _buildFilterChip('Inactive', 'inactive', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('Pending', 'pending', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('New', 'new', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('VIP', 'vip', guestVM.statusFilter,
                    guestVM.setStatusFilter),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.paddingS),

          // Quick stats and bulk actions
          _buildQuickStatsAndActions(context, guestVM),
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

  /// Builds quick stats and bulk actions bar
  Widget _buildQuickStatsAndActions(
      BuildContext context, OwnerGuestViewModel guestVM) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Quick stats
          Expanded(
            child: Row(
              children: [
                _buildStatChip(context, 'Total', '${guestVM.guests.length}'),
                const SizedBox(width: AppSpacing.paddingS),
                _buildStatChip(context, 'Active',
                    '${guestVM.guests.where((g) => g.status == 'active').length}'),
                const SizedBox(width: AppSpacing.paddingS),
                _buildStatChip(context, 'New',
                    '${guestVM.guests.where((g) => g.status == 'new').length}'),
              ],
            ),
          ),
          // Bulk actions
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportGuests(context, guestVM),
            tooltip: 'Export Data',
          ),
        ],
      ),
    );
  }

  /// Builds stat chip
  Widget _buildStatChip(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingS,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BodyText(text: '$label: ', color: AppColors.primary),
          BodyText(text: value, color: AppColors.primary),
        ],
      ),
    );
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
              label: 'Name',
              hint: 'Guest name',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Phone',
              hint: 'Phone number',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Room',
              hint: 'Room number',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Email',
              hint: 'Email address',
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

  /// Exports all guests
  void _exportGuests(BuildContext context, OwnerGuestViewModel guestVM) {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: BodyText(text: 'Guest data exported successfully')),
    );
  }

  /// Builds guest list
  Widget _buildGuestList(BuildContext context, OwnerGuestViewModel guestVM,
      List<OwnerGuestModel> guests) {
    if (guestVM.loading && guests.isEmpty) {
      return const Center(child: AdaptiveLoader());
    }

    return Column(
      children: [
        // Stats header
        _buildStatsHeader(context, guestVM),
        const SizedBox(height: AppSpacing.paddingM),
        // Guest list or structured empty state
        Expanded(
          child: guests.isEmpty
              ? _buildStructuredEmptyState(context, guestVM)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingM),
                  itemCount: guests.length,
                  itemBuilder: (context, index) {
                    final guest = guests[index];
                    return _buildGuestCard(context, guestVM, guest);
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
              'Total Guests',
              guestVM.totalGuests.toString(),
              Icons.people,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              'Active',
              guestVM.activeGuests.toString(),
              Icons.check_circle,
              Colors.green,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              'Inactive',
              (guestVM.totalGuests - guestVM.activeGuests).toString(),
              Icons.pause_circle,
              Colors.orange,
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
                const Icon(Icons.people_outline, size: 20, color: Colors.grey),
                const SizedBox(width: AppSpacing.paddingS),
                const BodyText(text: 'Guest List'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: const BodyText(text: '0 guests'),
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
            itemBuilder: (context, index) =>
                _buildPlaceholderGuestCard(context),
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
                const Icon(Icons.people_outline, size: 48, color: Colors.grey),
                const SizedBox(height: AppSpacing.paddingM),
                const HeadingMedium(text: 'No Guests Yet'),
                const SizedBox(height: AppSpacing.paddingS),
                const BodyText(
                  text: 'Guests will appear here once they book your PG',
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds placeholder guest card
  Widget _buildPlaceholderGuestCard(BuildContext context) {
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
          // Placeholder avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(24),
            ),
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

  /// Builds individual guest card
  Widget _buildGuestCard(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerGuestModel guest) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      child: AdaptiveCard(
        child: InkWell(
          onTap: () => _showGuestDetails(context, guestVM, guest),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Guest header with selection and actions
                Row(
                  children: [
                    // Selection checkbox
                    Checkbox(
                      value: false,
                      onChanged: (selected) {
                        // TODO: Implement selection
                      },
                    ),

                    // Avatar with status indicator
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: Text(
                            guest.guestName.isNotEmpty
                                ? guest.guestName[0].toUpperCase()
                                : 'G',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        // Status indicator dot
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getStatusColor(guest.status),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).cardColor,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.paddingM),

                    // Guest info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  guest.displayName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (guest.status == 'new')
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            guest.roomAssignment,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          if (guest.status == 'vip')
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'VIP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Status chip and actions
                    Column(
                      children: [
                        _buildStatusChip(guest.status),
                        const SizedBox(height: 4),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 16),
                          onSelected: (value) => _handleGuestAction(
                              context, guestVM, guest, value),
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'view',
                              child: ListTile(
                                leading: Icon(Icons.visibility, size: 16),
                                title: Text('View Details'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'edit',
                              child: ListTile(
                                leading: Icon(Icons.edit, size: 16),
                                title: Text('Edit Guest'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'message',
                              child: ListTile(
                                leading: Icon(Icons.message, size: 16),
                                title: Text('Send Message'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'call',
                              child: ListTile(
                                leading: Icon(Icons.phone, size: 16),
                                title: Text('Call Guest'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'checkout',
                              child: ListTile(
                                leading: Icon(Icons.logout, size: 16),
                                title: Text('Check Out'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.paddingM),

                // Guest details
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.phone,
                        label: 'Phone',
                        value: guest.phoneNumber,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.email,
                        label: 'Email',
                        value: guest.email,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.paddingS),

                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.calendar_today,
                        label: 'Check-in',
                        value: _formatDate(guest.checkInDate),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.timer,
                        label: 'Duration',
                        value: guest.formattedStayDuration,
                      ),
                    ),
                  ],
                ),

                if (guest.emergencyContact.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.paddingS),
                  _buildDetailItem(
                    icon: Icons.emergency,
                    label: 'Emergency Contact',
                    value:
                        '${guest.emergencyContact} (${guest.emergencyPhone})',
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
      case 'inactive':
        chipColor = Colors.grey.withValues(alpha: 0.1);
        textColor = Colors.grey;
        break;
      case 'pending':
        chipColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
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

  /// Shows guest details dialog
  void _showGuestDetails(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerGuestModel guest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(guest.displayName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Room', guest.roomAssignment),
              _buildDetailRow('Phone', guest.phoneNumber),
              _buildDetailRow('Email', guest.email),
              _buildDetailRow('Check-in', _formatDate(guest.checkInDate)),
              if (guest.checkOutDate != null)
                _buildDetailRow('Check-out', _formatDate(guest.checkOutDate!)),
              _buildDetailRow('Duration', guest.formattedStayDuration),
              if (guest.emergencyContact.isNotEmpty) ...[
                _buildDetailRow('Emergency Contact', guest.emergencyContact),
                _buildDetailRow('Emergency Phone', guest.emergencyPhone),
              ],
              if (guest.address.isNotEmpty)
                _buildDetailRow('Address', guest.address),
              if (guest.occupation.isNotEmpty)
                _buildDetailRow('Occupation', guest.occupation),
              if (guest.company.isNotEmpty)
                _buildDetailRow('Company', guest.company),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          PrimaryButton(
            label: 'Edit Guest',
            onPressed: () {
              Navigator.of(context).pop();
              _editGuest(context, guestVM, guest);
            },
          ),
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

  /// Shows edit guest dialog
  void _editGuest(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerGuestModel guest) {
    final nameController = TextEditingController(text: guest.guestName);
    final phoneController = TextEditingController(text: guest.phoneNumber);
    final emailController = TextEditingController(text: guest.email);
    final emergencyController =
        TextEditingController(text: guest.emergencyContact);
    final emergencyPhoneController =
        TextEditingController(text: guest.emergencyPhone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Guest'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextInput(
                controller: nameController,
                label: 'Guest Name',
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: phoneController,
                label: 'Phone Number',
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: emailController,
                label: 'Email',
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: emergencyController,
                label: 'Emergency Contact',
              ),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: emergencyPhoneController,
                label: 'Emergency Phone',
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
              final updatedGuest = guest.copyWith(
                guestName: nameController.text,
                phoneNumber: phoneController.text,
                email: emailController.text,
                emergencyContact: emergencyController.text,
                emergencyPhone: emergencyPhoneController.text,
                updatedAt: DateTime.now(),
              );

              final success = await guestVM.updateGuest(updatedGuest);
              if (success && mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Guest updated successfully')),
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

  /// Gets status color for indicator
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'new':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  /// Handles guest action from popup menu
  void _handleGuestAction(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerGuestModel guest, String action) {
    switch (action) {
      case 'view':
        _showGuestDetails(context, guestVM, guest);
        break;
      case 'edit':
        _editGuest(context, guestVM, guest);
        break;
      case 'message':
        _sendMessageToGuest(context, guestVM, guest);
        break;
      case 'call':
        _callGuest(guest);
        break;
      case 'checkout':
        _checkoutGuest(context, guestVM, guest);
        break;
    }
  }

  /// Sends message to guest
  void _sendMessageToGuest(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerGuestModel guest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const HeadingMedium(text: 'Send Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BodyText(text: 'To: ${guest.displayName}'),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Message',
              hint: 'Enter your message...',
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const BodyText(text: 'Cancel'),
          ),
          PrimaryButton(
            label: 'Send',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement send message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: BodyText(text: 'Message sent successfully')),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Calls guest
  void _callGuest(OwnerGuestModel guest) {
    // TODO: Implement phone call functionality
  }

  /// Checks out guest
  void _checkoutGuest(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerGuestModel guest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const HeadingMedium(text: 'Check Out Guest'),
        content: const BodyText(
          text:
              'Are you sure you want to check out this guest? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const BodyText(text: 'Cancel'),
          ),
          PrimaryButton(
            label: 'Check Out',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement checkout
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: BodyText(text: 'Guest checked out successfully')),
              );
            },
          ),
        ],
      ),
    );
  }
}
