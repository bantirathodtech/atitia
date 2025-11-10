// lib/feature/owner_dashboard/guests/view/widgets/guest_list_widget.dart

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
import '../../data/models/owner_guest_model.dart';

/// Widget for displaying and managing guest list
class GuestListWidget extends StatefulWidget {
  const GuestListWidget({super.key});

  @override
  State<GuestListWidget> createState() => _GuestListWidgetState();
}

class _GuestListWidgetState extends State<GuestListWidget> {
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
    final filteredGuests = guestVM.filteredGuests;
    final loc = AppLocalizations.of(context);

    return Column(
      children: [
        _buildSearchAndFilters(context, guestVM, loc),
        Expanded(
          child: _buildGuestList(context, guestVM, filteredGuests, loc),
        ),
      ],
    );
  }

  /// Builds search bar and filter controls
  Widget _buildSearchAndFilters(BuildContext context,
      OwnerGuestViewModel guestVM, AppLocalizations? loc) {
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
                  label: loc?.searchGuestsLabel ??
                      _text('searchGuestsLabel', 'Search Guests'),
                  hint: loc?.searchGuestsHint ??
                      _text('searchGuestsHint',
                          'Search by name, phone, room, or email...'),
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
                tooltip: loc?.advancedSearch ??
                    _text('advancedSearch', 'Advanced Search'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Filter chips with enhanced options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                    loc?.all ?? _text('all', 'All'),
                    'all',
                    guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(
                    loc?.active ?? _text('active', 'Active'),
                    'active',
                    guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(
                    loc?.inactive ?? _text('inactive', 'Inactive'),
                    'inactive',
                    guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(
                    loc?.pending ?? _text('pending', 'Pending'),
                    'pending',
                    guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(
                    loc?.statusNew ?? _text('statusNew', 'New'),
                    'new',
                    guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(
                    loc?.statusVip ?? _text('statusVip', 'VIP'),
                    'vip',
                    guestVM.statusFilter,
                    guestVM.setStatusFilter),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.paddingS),

          // Quick stats and bulk actions
          _buildQuickStatsAndActions(context, guestVM, loc),
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
  Widget _buildQuickStatsAndActions(BuildContext context,
      OwnerGuestViewModel guestVM, AppLocalizations? loc) {
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
                _buildStatChip(
                    context,
                    loc?.total ?? _text('total', 'Total'),
                    '${guestVM.guests.length}'),
                const SizedBox(width: AppSpacing.paddingS),
                _buildStatChip(
                    context,
                    loc?.active ?? _text('active', 'Active'),
                    '${guestVM.guests.where((g) => g.status == 'active').length}'),
                const SizedBox(width: AppSpacing.paddingS),
                _buildStatChip(
                    context,
                    loc?.statusNew ?? _text('statusNew', 'New'),
                    '${guestVM.guests.where((g) => g.status == 'new').length}'),
              ],
            ),
          ),
          // Bulk actions
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportGuests(context, guestVM, loc),
            tooltip:
                loc?.exportData ?? _text('exportData', 'Export Data'),
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
    final loc = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingMedium(
            text:
                loc?.advancedSearch ?? _text('advancedSearch', 'Advanced Search')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextInput(
              label: loc?.guestName ?? _text('guestName', 'Guest Name'),
              hint: _text('guestNameHint', 'Guest full name'),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: loc?.phoneNumber ?? _text('phoneNumber', 'Phone'),
              hint: _text('phoneNumberHint', 'Phone number'),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: _text('roomLabel', 'Room'),
              hint: _text('roomHint', 'Room number'),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: loc?.emailLabel ?? _text('emailLabel', 'Email'),
              hint: _text('emailHint', 'Email address'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
              child:
                BodyText(text: loc?.cancel ?? _text('cancel', 'Cancel')),
          ),
          PrimaryButton(
            label: loc?.search ?? _text('search', 'Search'),
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
  void _exportGuests(BuildContext context, OwnerGuestViewModel guestVM,
      AppLocalizations? loc) {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          loc?.guestDataExportedSuccessfully ??
              _text('guestDataExportedSuccessfully',
                  'Guest data exported successfully'),
        ),
      ),
    );
  }

  /// Builds guest list
  Widget _buildGuestList(BuildContext context, OwnerGuestViewModel guestVM,
      List<OwnerGuestModel> guests, AppLocalizations? loc) {
    if (guestVM.loading && guests.isEmpty) {
      return const Center(child: AdaptiveLoader());
    }

    return Column(
      children: [
        // Stats header
        _buildStatsHeader(context, guestVM, loc),
        const SizedBox(height: AppSpacing.paddingM),
        // Guest list or structured empty state
        Expanded(
          child: guests.isEmpty
              ? _buildStructuredEmptyState(context, guestVM, loc)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingM),
                  itemCount: guests.length,
                  itemBuilder: (context, index) {
                    final guest = guests[index];
                    return _buildGuestCard(context, guestVM, guest, loc);
                  },
                ),
        ),
      ],
    );
  }

  /// Builds stats header
  Widget _buildStatsHeader(BuildContext context, OwnerGuestViewModel guestVM,
      AppLocalizations? loc) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              loc?.totalGuests ?? 'Total Guests',
              guestVM.totalGuests.toString(),
              Icons.people,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              loc?.active ?? 'Active',
              guestVM.activeGuests.toString(),
              Icons.check_circle,
              Colors.green,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              loc?.inactive ?? 'Inactive',
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
  Widget _buildStructuredEmptyState(BuildContext context,
      OwnerGuestViewModel guestVM, AppLocalizations? loc) {
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
                BodyText(
                  text: loc?.guestListTitle ?? 'Guest List',
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: BodyText(
                    text: loc?.guestCount(0) ?? '0 guests',
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
            itemBuilder: (context, index) =>
                _buildPlaceholderGuestCard(context),
          ),
          // Empty state message
          Container(
            margin: const EdgeInsets.all(AppSpacing.paddingM),
            padding: const EdgeInsets.all(AppSpacing.paddingL),
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                const Icon(Icons.people_outline, size: 48, color: Colors.grey),
                const SizedBox(height: AppSpacing.paddingM),
                HeadingMedium(
                  text: loc?.noGuestsYet ?? 'No Guests Yet',
                ),
                const SizedBox(height: AppSpacing.paddingS),
                BodyText(
                  text: loc?.guestsAppearAfterBooking ??
                      'Guests will appear here once they book your PG',
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
        color: Colors.grey.withValues(alpha: 0.05),
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
      OwnerGuestModel guest, AppLocalizations? loc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      child: AdaptiveCard(
        child: InkWell(
          onTap: () => _showGuestDetails(context, guestVM, guest, loc),
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
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
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
                                  child: Text(
                                    (loc?.statusNew ?? 'New').toUpperCase(),
                                    style: const TextStyle(
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
                              child: Text(
                                (loc?.statusVip ?? 'VIP').toUpperCase(),
                                style: const TextStyle(
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
                        _buildStatusChip(context, guest.status, loc),
                        const SizedBox(height: 4),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, size: 16),
                          onSelected: (value) => _handleGuestAction(
                              context, guestVM, guest, value, loc),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'view',
                              child: ListTile(
                                leading: const Icon(Icons.visibility, size: 16),
                                title: Text(
                                    AppLocalizations.of(context)?.viewDetails ??
                                        'View Details'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            PopupMenuItem(
                              value: 'edit',
                              child: ListTile(
                                leading: const Icon(Icons.edit, size: 16),
                                title: Text(
                                    AppLocalizations.of(context)?.editGuest ??
                                        'Edit Guest'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            PopupMenuItem(
                              value: 'message',
                              child: ListTile(
                                leading: const Icon(Icons.message, size: 16),
                                title: Text(
                                    AppLocalizations.of(context)?.sendMessage ??
                                        'Send Message'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            PopupMenuItem(
                              value: 'call',
                              child: ListTile(
                                leading: const Icon(Icons.phone, size: 16),
                                title: Text(
                                    AppLocalizations.of(context)?.callGuest ??
                                        'Call Guest'),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            PopupMenuItem(
                              value: 'checkout',
                              child: ListTile(
                                leading: const Icon(Icons.logout, size: 16),
                                title: Text(
                                    AppLocalizations.of(context)?.checkOut ??
                                        'Check Out'),
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
                        label: loc?.phoneNumber ?? 'Phone',
                        value: guest.phoneNumber,
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.email,
                        label: loc?.email ?? 'Email',
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
                        label: loc?.checkIn ?? 'Check-in',
                        value: _formatDate(guest.checkInDate),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.timer,
                        label: loc?.duration ?? 'Duration',
                        value: guest.formattedStayDuration,
                      ),
                    ),
                  ],
                ),

                if (guest.emergencyContact.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.paddingS),
                  _buildDetailItem(
                    icon: Icons.emergency,
                    label: loc?.emergencyContact ?? 'Emergency Contact',
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
  Widget _buildStatusChip(
      BuildContext context, String status, AppLocalizations? loc) {
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
      case 'new':
        chipColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        break;
      case 'vip':
        chipColor = Colors.purple.withValues(alpha: 0.1);
        textColor = Colors.purple;
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
        _localizedStatusLabel(status, loc).toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _localizedStatusLabel(String status, AppLocalizations? loc) {
    switch (status.toLowerCase()) {
      case 'active':
        return loc?.active ?? 'Active';
      case 'inactive':
        return loc?.inactive ?? 'Inactive';
      case 'pending':
        return loc?.pending ?? 'Pending';
      case 'new':
        return loc?.statusNew ?? 'New';
      case 'vip':
        return loc?.statusVip ?? 'VIP';
      default:
        return status;
    }
  }

  /// Shows guest details dialog
  void _showGuestDetails(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerGuestModel guest, AppLocalizations? loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(guest.displayName),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow(loc?.room ?? 'Room', guest.roomAssignment),
              _buildDetailRow(loc?.phoneNumber ?? 'Phone', guest.phoneNumber),
              _buildDetailRow(loc?.email ?? 'Email', guest.email),
              _buildDetailRow(
                  loc?.checkIn ?? 'Check-in', _formatDate(guest.checkInDate)),
              if (guest.checkOutDate != null)
                _buildDetailRow(loc?.checkOut ?? 'Check-out',
                    _formatDate(guest.checkOutDate!)),
              _buildDetailRow(
                  loc?.duration ?? 'Duration', guest.formattedStayDuration),
              if (guest.emergencyContact.isNotEmpty) ...[
                _buildDetailRow(loc?.emergencyContact ?? 'Emergency Contact',
                    guest.emergencyContact),
                _buildDetailRow(loc?.emergencyPhone ?? 'Emergency Phone',
                    guest.emergencyPhone),
              ],
              if (guest.address.isNotEmpty)
                _buildDetailRow(loc?.address ?? 'Address', guest.address),
              if (guest.occupation.isNotEmpty)
                _buildDetailRow(
                    loc?.occupation ?? 'Occupation', guest.occupation),
              if (guest.company.isNotEmpty)
                _buildDetailRow(loc?.company ?? 'Company', guest.company),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc?.close ?? 'Close'),
          ),
          PrimaryButton(
            label: loc?.editGuest ?? 'Edit Guest',
            onPressed: () {
              Navigator.of(context).pop();
              _editGuest(context, guestVM, guest, loc);
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
      OwnerGuestModel guest, AppLocalizations? loc) {
    final nameController = TextEditingController(text: guest.guestName);
    final phoneController = TextEditingController(text: guest.phoneNumber);
    final emailController = TextEditingController(text: guest.email);
    final emergencyController =
        TextEditingController(text: guest.emergencyContact);
    final emergencyPhoneController =
        TextEditingController(text: guest.emergencyPhone);
    final messenger = ScaffoldMessenger.of(context);
    final locOuter = AppLocalizations.of(context) ?? loc;

    showDialog(
      context: context,
      builder: (dialogContext) {
        final locDialog = AppLocalizations.of(dialogContext) ?? locOuter;
        return AlertDialog(
          title: Text(locDialog?.editGuest ?? 'Edit Guest'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextInput(
                  controller: nameController,
                  label: locDialog?.guestName ?? 'Guest Name',
                ),
                const SizedBox(height: AppSpacing.paddingM),
                TextInput(
                  controller: phoneController,
                  label: locDialog?.phoneNumber ?? 'Phone Number',
                ),
                const SizedBox(height: AppSpacing.paddingM),
                TextInput(
                  controller: emailController,
                  label: locDialog?.email ?? 'Email',
                ),
                const SizedBox(height: AppSpacing.paddingM),
                TextInput(
                  controller: emergencyController,
                  label: locDialog?.emergencyContact ?? 'Emergency Contact',
                ),
                const SizedBox(height: AppSpacing.paddingM),
                TextInput(
                  controller: emergencyPhoneController,
                  label: locDialog?.emergencyPhone ?? 'Emergency Phone',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(locDialog?.cancel ?? 'Cancel'),
            ),
            PrimaryButton(
              label: locDialog?.saveChanges ?? 'Save Changes',
              onPressed: () async {
                final navigator = Navigator.of(dialogContext);
                final updatedGuest = guest.copyWith(
                  guestName: nameController.text,
                  phoneNumber: phoneController.text,
                  email: emailController.text,
                  emergencyContact: emergencyController.text,
                  emergencyPhone: emergencyPhoneController.text,
                  updatedAt: DateTime.now(),
                );

                final success = await guestVM.updateGuest(updatedGuest);
                if (!success || !mounted) return;
                navigator.pop();
                if (!mounted) return;
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      locOuter?.guestUpdatedSuccessfully ??
                          _text('guestUpdatedSuccessfully',
                              'Guest updated successfully'),
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
      OwnerGuestModel guest, String action, AppLocalizations? loc) {
    switch (action) {
      case 'view':
        _showGuestDetails(context, guestVM, guest, loc);
        break;
      case 'edit':
        _editGuest(context, guestVM, guest, loc);
        break;
      case 'message':
        _sendMessageToGuest(context, guestVM, guest, loc);
        break;
      case 'call':
        _callGuest(guest);
        break;
      case 'checkout':
        _checkoutGuest(context, guestVM, guest, loc);
        break;
    }
  }

  /// Sends message to guest
  void _sendMessageToGuest(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerGuestModel guest, AppLocalizations? loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingMedium(
            text: (AppLocalizations.of(context) ?? loc)?.sendMessage ??
                'Send Message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BodyText(
                text: (AppLocalizations.of(context) ?? loc)
                        ?.messageToGuest(guest.displayName) ??
                    'To: ${guest.displayName}'),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label:
                  (AppLocalizations.of(context) ?? loc)?.message ?? 'Message',
              hint: (AppLocalizations.of(context) ?? loc)?.enterMessageHint ??
                  'Enter your message...',
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: BodyText(
                text:
                    (AppLocalizations.of(context) ?? loc)?.cancel ?? 'Cancel'),
          ),
          PrimaryButton(
            label: (AppLocalizations.of(context) ?? loc)?.send ?? 'Send',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement send message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: BodyText(
                    text: (AppLocalizations.of(context) ?? loc)
                            ?.messageSentSuccessfully ??
                        'Message sent successfully',
                  ),
                ),
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
      OwnerGuestModel guest, AppLocalizations? loc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingMedium(
            text: (AppLocalizations.of(context) ?? loc)?.checkOutGuest ??
                'Check Out Guest'),
        content: BodyText(
          text: (AppLocalizations.of(context) ?? loc)
                  ?.checkOutGuestConfirmation ??
              'Are you sure you want to check out this guest? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: BodyText(
                text:
                    (AppLocalizations.of(context) ?? loc)?.cancel ?? 'Cancel'),
          ),
          PrimaryButton(
            label:
                (AppLocalizations.of(context) ?? loc)?.checkOut ?? 'Check Out',
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement checkout
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: BodyText(
                    text: (AppLocalizations.of(context) ?? loc)
                            ?.guestCheckedOutSuccessfully ??
                        'Guest checked out successfully',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
