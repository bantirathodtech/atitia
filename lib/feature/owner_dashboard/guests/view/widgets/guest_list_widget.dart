// lib/feature/owner_dashboard/guests/view/widgets/guest_list_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/chips/filter_chip.dart';
import '../../../../../common/widgets/buttons/text_button.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../core/di/common/unified_service_locator.dart';
import '../../../../../core/repositories/notification_repository.dart';
import '../../../../../core/interfaces/database/database_service_interface.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
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
    final loc = AppLocalizations.of(context);

    // Use select to only rebuild when filteredGuests changes, not on every viewmodel change
    final filteredGuests =
        context.select<OwnerGuestViewModel, List<OwnerGuestModel>>(
      (vm) => vm.filteredGuests,
    );

    // Read viewmodel for methods, don't watch it
    final guestVM = context.read<OwnerGuestViewModel>();

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
    final padding =
        context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM;
    return Padding(
      padding: EdgeInsets.all(padding),
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
              SizedBox(
                  width: context.isMobile
                      ? AppSpacing.paddingXS
                      : AppSpacing.paddingS),
              // Advanced search button
              IconButton(
                icon: Icon(Icons.tune, size: context.isMobile ? 18 : 24),
                onPressed: () => _showAdvancedSearch(context, guestVM),
                tooltip: loc?.advancedSearch ??
                    _text('advancedSearch', 'Advanced Search'),
                padding: EdgeInsets.all(context.isMobile ? 8 : 12),
              ),
            ],
          ),
          SizedBox(
              height:
                  context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),

          // Filter chips with enhanced options
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(loc?.all ?? _text('all', 'All'), 'all',
                    guestVM.statusFilter, guestVM.setStatusFilter),
                _buildFilterChip(loc?.active ?? _text('active', 'Active'),
                    'active', guestVM.statusFilter, guestVM.setStatusFilter),
                _buildFilterChip(loc?.inactive ?? _text('inactive', 'Inactive'),
                    'inactive', guestVM.statusFilter, guestVM.setStatusFilter),
                _buildFilterChip(loc?.pending ?? _text('pending', 'Pending'),
                    'pending', guestVM.statusFilter, guestVM.setStatusFilter),
                _buildFilterChip(loc?.statusNew ?? _text('statusNew', 'New'),
                    'new', guestVM.statusFilter, guestVM.setStatusFilter),
                _buildFilterChip(loc?.statusVip ?? _text('statusVip', 'VIP'),
                    'vip', guestVM.statusFilter, guestVM.setStatusFilter),
              ],
            ),
          ),
          SizedBox(
              height: context.isMobile
                  ? AppSpacing.paddingXS
                  : AppSpacing.paddingS),

          // Quick stats and bulk actions
          _buildQuickStatsAndActions(context, guestVM, loc),
        ],
      ),
    );
  }

  /// Builds filter chip using reusable CustomFilterChip
  Widget _buildFilterChip(String label, String value, String currentFilter,
      Function(String) onTap) {
    final isSelected = currentFilter == value;
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.paddingS),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 150),
        child: CustomFilterChip(
          label: label,
          selected: isSelected,
          onSelected: (selected) => onTap(selected ? value : 'all'),
        ),
      ),
    );
  }

  /// Builds quick stats and bulk actions bar
  Widget _buildQuickStatsAndActions(BuildContext context,
      OwnerGuestViewModel guestVM, AppLocalizations? loc) {
    return AdaptiveCard(
      padding: EdgeInsets.symmetric(
        horizontal:
            context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM,
        vertical: context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS,
      ),
      child: Row(
        children: [
          // Quick stats
          Expanded(
            child: Row(
              children: [
                _buildStatChip(context, loc?.total ?? _text('total', 'Total'),
                    '${guestVM.totalGuests}'),
                SizedBox(
                    width: context.isMobile
                        ? AppSpacing.paddingXS
                        : AppSpacing.paddingS),
                _buildStatChip(
                    context,
                    loc?.active ?? _text('active', 'Active'),
                    '${guestVM.activeGuests}'),
                SizedBox(
                    width: context.isMobile
                        ? AppSpacing.paddingXS
                        : AppSpacing.paddingS),
                _buildStatChip(
                    context,
                    loc?.statusNew ?? _text('statusNew', 'New'),
                    '${guestVM.newGuests}'),
              ],
            ),
          ),
          // Bulk actions
          IconButton(
            icon: Icon(Icons.download, size: context.isMobile ? 18 : 24),
            onPressed: () => _exportGuests(context, guestVM, loc),
            tooltip: loc?.exportData ?? _text('exportData', 'Export Data'),
            padding: EdgeInsets.all(context.isMobile ? 8 : 12),
          ),
        ],
      ),
    );
  }

  /// Builds stat chip
  Widget _buildStatChip(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal:
            context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS,
        vertical: context.isMobile ? 3 : 4,
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
              HeadingMedium(
                  text: loc?.advancedSearch ??
                      _text('advancedSearch', 'Advanced Search')),
              const SizedBox(height: AppSpacing.paddingM),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextInput(
                        label:
                            loc?.guestName ?? _text('guestName', 'Guest Name'),
                        hint: _text('guestNameHint', 'Guest full name'),
                      ),
                      const SizedBox(height: AppSpacing.paddingM),
                      TextInput(
                        label:
                            loc?.phoneNumber ?? _text('phoneNumber', 'Phone'),
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
                ),
              ),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    text: loc?.cancel ?? _text('cancel', 'Cancel'),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  PrimaryButton(
                    label: loc?.search ?? _text('search', 'Search'),
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Implement advanced search
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
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
        SizedBox(
            height:
                context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
        // Guest list or structured empty state
        Expanded(
          child: guests.isEmpty
              ? _buildStructuredEmptyState(context, guestVM, loc)
              : ListView.builder(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.isMobile
                          ? AppSpacing.paddingS
                          : AppSpacing.paddingM),
                  itemCount: guests.length,
                  cacheExtent: 512,
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,
                  itemBuilder: (context, index) {
                    final guest = guests[index];
                    return RepaintBoundary(
                      key: ValueKey('guest_${guest.guestId}_$index'),
                      child: _buildGuestCard(context, guestVM, guest, loc),
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// Builds stats header
  Widget _buildStatsHeader(BuildContext context, OwnerGuestViewModel guestVM,
      AppLocalizations? loc) {
    final padding =
        context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM;
    final gap = context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS;
    return AdaptiveCard(
      margin: EdgeInsets.all(padding),
      padding: EdgeInsets.all(padding),
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
          SizedBox(width: gap),
          Expanded(
            child: _buildStatCard(
              context,
              loc?.active ?? 'Active',
              guestVM.activeGuests.toString(),
              Icons.check_circle,
              AppColors.success,
            ),
          ),
          SizedBox(width: gap),
          Expanded(
            child: _buildStatCard(
              context,
              loc?.inactive ?? 'Inactive',
              (guestVM.totalGuests - guestVM.activeGuests).toString(),
              Icons.pause_circle,
              AppColors.warning,
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
      mainAxisSize: MainAxisSize.min,
      children: [
        // Row 1: Icon and Number side by side
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: context.isMobile ? 18 : 24),
            SizedBox(
                width: context.isMobile
                    ? AppSpacing.paddingXS * 0.5
                    : AppSpacing.paddingXS),
            HeadingMedium(
              text: value,
              color: color,
            ),
          ],
        ),
        SizedBox(
            height: context.isMobile
                ? AppSpacing.paddingXS * 0.5
                : AppSpacing.paddingXS),
        // Row 2: Label below
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
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Icon(Icons.people_outline,
                    size: 20,
                    color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.5) ??
                        Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.5)),
                const SizedBox(width: AppSpacing.paddingS),
                BodyText(
                  text: loc?.guestListTitle ?? 'Guest List',
                ),
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
                    text: loc?.guestCount(0) ?? '0 guests',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual guest card
  Widget _buildGuestCard(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerGuestModel guest, AppLocalizations? loc) {
    final padding =
        context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM;
    final gap = context.isMobile ? AppSpacing.paddingXS : AppSpacing.paddingS;
    return Padding(
      padding: EdgeInsets.only(
          bottom: context.isMobile ? AppSpacing.paddingS : AppSpacing.paddingM),
      child: AdaptiveCard(
        padding: EdgeInsets.all(padding),
        child: InkWell(
          onTap: () => _showGuestDetails(context, guestVM, guest, loc),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              // Selection checkbox
              Checkbox(
                value: false,
                onChanged: (selected) {
                  // TODO: Implement selection
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),

              // Avatar with status indicator
              Stack(
                children: [
                  CircleAvatar(
                    radius: context.isMobile ? 18 : 24,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      guest.guestName.isNotEmpty
                          ? guest.guestName[0].toUpperCase()
                          : 'G',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: context.isMobile ? 14 : 16,
                      ),
                    ),
                  ),
                  // Status indicator dot
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: context.isMobile ? 10 : 12,
                      height: context.isMobile ? 10 : 12,
                      decoration: BoxDecoration(
                        color: _getStatusColor(context, guest.status),
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
              SizedBox(width: gap),

              // Guest info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            guest.displayName,
                            style: TextStyle(
                              fontSize: context.isMobile ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (guest.status == 'new')
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.isMobile ? 4 : 6,
                              vertical: context.isMobile ? 1 : 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              (loc?.statusNew ?? 'New').toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: context.isMobile ? 8 : 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(
                        height: context.isMobile
                            ? AppSpacing.paddingXS * 0.5
                            : AppSpacing.paddingXS),
                    Text(
                      guest.roomAssignment,
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
                        fontSize: context.isMobile ? 12 : 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (guest.status == 'vip')
                      Container(
                        margin: EdgeInsets.only(top: context.isMobile ? 2 : 4),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.isMobile ? 4 : 6,
                          vertical: context.isMobile ? 1 : 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          (loc?.statusVip ?? 'VIP').toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: context.isMobile ? 8 : 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Status chip and actions
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStatusChip(context, guest.status, loc),
                  SizedBox(
                      height: context.isMobile
                          ? AppSpacing.paddingXS * 0.5
                          : AppSpacing.paddingXS),
                  PopupMenuButton<String>(
                    icon:
                        Icon(Icons.more_vert, size: context.isMobile ? 14 : 16),
                    onSelected: (value) =>
                        _handleGuestAction(context, guestVM, guest, value, loc),
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
                          title: Text(AppLocalizations.of(context)?.editGuest ??
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
                          title: Text(AppLocalizations.of(context)?.callGuest ??
                              'Call Guest'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'checkout',
                        child: ListTile(
                          leading: const Icon(Icons.logout, size: 16),
                          title: Text(AppLocalizations.of(context)?.checkOut ??
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
        ),
      ),
    );
  }

  /// Builds status chip
  Widget _buildStatusChip(
      BuildContext context, String status, AppLocalizations? loc) {
    Color chipColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'active':
        chipColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        break;
      case 'inactive':
        chipColor = Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.1) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
        textColor = Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.7) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
        break;
      case 'pending':
        chipColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        break;
      case 'new':
        chipColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
        break;
      case 'vip':
        chipColor = AppColors.purple.withValues(alpha: 0.1);
        textColor = AppColors.purple;
        break;
      default:
        chipColor = Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.1) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
        textColor = Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.7) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
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
              HeadingMedium(text: guest.displayName),
              const SizedBox(height: AppSpacing.paddingM),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDetailRow(
                          loc?.room ?? 'Room', guest.roomAssignment),
                      _buildDetailRow(
                          loc?.phoneNumber ?? 'Phone', guest.phoneNumber),
                      _buildDetailRow(loc?.email ?? 'Email', guest.email),
                      _buildDetailRow(loc?.checkIn ?? 'Check-in',
                          _formatDate(guest.checkInDate)),
                      if (guest.checkOutDate != null)
                        _buildDetailRow(loc?.checkOut ?? 'Check-out',
                            _formatDate(guest.checkOutDate!)),
                      _buildDetailRow(loc?.duration ?? 'Duration',
                          guest.formattedStayDuration),
                      if (guest.emergencyContact.isNotEmpty) ...[
                        _buildDetailRow(
                            loc?.emergencyContact ?? 'Emergency Contact',
                            guest.emergencyContact),
                        _buildDetailRow(
                            loc?.emergencyPhone ?? 'Emergency Phone',
                            guest.emergencyPhone),
                      ],
                      if (guest.address.isNotEmpty)
                        _buildDetailRow(
                            loc?.address ?? 'Address', guest.address),
                      if (guest.occupation.isNotEmpty)
                        _buildDetailRow(
                            loc?.occupation ?? 'Occupation', guest.occupation),
                      if (guest.company.isNotEmpty)
                        _buildDetailRow(
                            loc?.company ?? 'Company', guest.company),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.of(context).pop(),
                    text: loc?.close ?? 'Close',
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  PrimaryButton(
                    label: loc?.editGuest ?? 'Edit Guest',
                    onPressed: () {
                      Navigator.of(context).pop();
                      _editGuest(context, guestVM, guest, loc);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingMedium(text: locDialog?.editGuest ?? 'Edit Guest'),
                const SizedBox(height: AppSpacing.paddingM),
                Flexible(
                  child: SingleChildScrollView(
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
                          label: locDialog?.emergencyContact ??
                              'Emergency Contact',
                        ),
                        const SizedBox(height: AppSpacing.paddingM),
                        TextInput(
                          controller: emergencyPhoneController,
                          label: locDialog?.emergencyPhone ?? 'Emergency Phone',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.paddingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButtonWidget(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      text: locDialog?.cancel ?? 'Cancel',
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Formats date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Gets status color for indicator
  Color _getStatusColor(BuildContext context, String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'inactive':
        return Theme.of(context).colorScheme.error;
      case 'pending':
        return AppColors.warning;
      case 'new':
        return AppColors.info;
      default:
        return Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.7) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
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
    final TextEditingController messageController = TextEditingController();
    final NotificationRepository notificationRepo = NotificationRepository();
    final IDatabaseService databaseService =
        UnifiedServiceLocator.serviceFactory.database;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (dialogContext) => _MessageDialog(
        messageController: messageController,
        guest: guest,
        loc: loc,
        notificationRepo: notificationRepo,
        databaseService: databaseService,
        authProvider: authProvider,
        dialogContext: dialogContext,
      ),
    );
  }

  /// Calls guest
  void _callGuest(OwnerGuestModel guest) async {
    final phoneNumber = guest.phoneNumber.trim();
    if (phoneNumber.isEmpty) {
      return;
    }

    // Format phone number for tel: scheme
    // Remove any spaces, dashes, or other characters
    final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure phone number starts with + for international format
    final formattedPhoneNumber = cleanPhoneNumber.startsWith('+')
        ? cleanPhoneNumber
        : '+91$cleanPhoneNumber'; // Default to India country code if not specified

    final phoneUri = Uri(scheme: 'tel', path: formattedPhoneNumber);

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        // If canLaunchUrl returns false, try anyway (some devices may not support canLaunchUrl check)
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Error launching phone dialer - silently fail as this is a convenience feature
      debugPrint('Failed to launch phone dialer: $e');
    }
  }

  /// Checks out guest
  void _checkoutGuest(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerGuestModel guest, AppLocalizations? loc) {
    showDialog(
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
              HeadingMedium(
                  text: (AppLocalizations.of(context) ?? loc)?.checkOutGuest ??
                      'Check Out Guest'),
              const SizedBox(height: AppSpacing.paddingM),
              BodyText(
                text: (AppLocalizations.of(context) ?? loc)
                        ?.checkOutGuestConfirmation ??
                    'Are you sure you want to check out this guest? This action cannot be undone.',
              ),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.pop(context),
                    text: (AppLocalizations.of(context) ?? loc)?.cancel ??
                        'Cancel',
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  PrimaryButton(
                    label: (AppLocalizations.of(context) ?? loc)?.checkOut ??
                        'Check Out',
                    onPressed: () async {
                      Navigator.pop(context);

                      try {
                        // Update guest status to inactive and set checkout date
                        final updatedGuest = guest.copyWith(
                          status: 'inactive',
                          checkOutDate: DateTime.now(),
                          isActive: false,
                          updatedAt: DateTime.now(),
                        );

                        final success = await guestVM.updateGuest(updatedGuest);

                        if (context.mounted) {
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: BodyText(
                                  text: (AppLocalizations.of(context) ?? loc)
                                          ?.guestCheckedOutSuccessfully ??
                                      'Guest checked out successfully',
                                ),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: BodyText(
                                  text: 'Failed to check out guest',
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: BodyText(
                                text:
                                    'Failed to check out guest: ${e.toString()}',
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stateful widget for message dialog to properly manage sending state
class _MessageDialog extends StatefulWidget {
  final TextEditingController messageController;
  final OwnerGuestModel guest;
  final AppLocalizations? loc;
  final NotificationRepository notificationRepo;
  final IDatabaseService databaseService;
  final AuthProvider authProvider;
  final BuildContext dialogContext;

  const _MessageDialog({
    required this.messageController,
    required this.guest,
    required this.loc,
    required this.notificationRepo,
    required this.databaseService,
    required this.authProvider,
    required this.dialogContext,
  });

  @override
  State<_MessageDialog> createState() => _MessageDialogState();
}

class _MessageDialogState extends State<_MessageDialog> {
  bool _isSending = false;

  Future<void> _sendMessage() async {
    final messageText = widget.messageController.text.trim();
    if (messageText.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: BodyText(
              text: (AppLocalizations.of(context) ?? widget.loc)
                      ?.enterMessageHint ??
                  'Please enter a message',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    setState(() => _isSending = true);

    try {
      final owner = widget.authProvider.user;
      final ownerId = owner?.userId ?? '';
      final ownerName = owner?.fullName ?? 'Owner';

      // Save message to Firestore
      final messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';
      final messageData = {
        'messageId': messageId,
        'senderId': ownerId,
        'senderName': ownerName,
        'senderType': 'owner',
        'receiverId': widget.guest.guestId,
        'receiverName': widget.guest.guestName,
        'receiverType': 'guest',
        'message': messageText,
        'pgId': widget.guest.pgId,
        'bookingId': widget.guest.bookingId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'read': false,
        'createdAt': DateTime.now().millisecondsSinceEpoch,
      };

      await widget.databaseService.setDocument(
        'messages',
        messageId,
        messageData,
      );

      // Send push notification to guest
      await widget.notificationRepo.sendUserNotification(
        userId: widget.guest.guestId,
        type: 'owner_message',
        title: 'Message from Owner',
        body: messageText.length > 100
            ? '${messageText.substring(0, 100)}...'
            : messageText,
        data: {
          'messageId': messageId,
          'senderId': ownerId,
          'senderName': ownerName,
          'pgId': widget.guest.pgId,
          'bookingId': widget.guest.bookingId,
        },
      );

      if (mounted) {
        final navigatorContext = context;
        Navigator.pop(widget.dialogContext);
        ScaffoldMessenger.of(navigatorContext).showSnackBar(
          SnackBar(
            content: BodyText(
              text: (AppLocalizations.of(navigatorContext) ?? widget.loc)
                      ?.messageSentSuccessfully ??
                  'Message sent successfully',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final navigatorContext = context;
        ScaffoldMessenger.of(navigatorContext).showSnackBar(
          SnackBar(
            content: BodyText(
              text: 'Failed to send message: ${e.toString()}',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(
                text:
                    (AppLocalizations.of(context) ?? widget.loc)?.sendMessage ??
                        'Send Message'),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
                text: (AppLocalizations.of(context) ?? widget.loc)
                        ?.messageToGuest(widget.guest.displayName) ??
                    'To: ${widget.guest.displayName}'),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              controller: widget.messageController,
              label: (AppLocalizations.of(context) ?? widget.loc)?.message ??
                  'Message',
              hint: (AppLocalizations.of(context) ?? widget.loc)
                      ?.enterMessageHint ??
                  'Enter your message...',
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButtonWidget(
                  onPressed: _isSending
                      ? () {}
                      : () => Navigator.pop(widget.dialogContext),
                  text: (AppLocalizations.of(context) ?? widget.loc)?.cancel ??
                      'Cancel',
                ),
                const SizedBox(width: AppSpacing.paddingS),
                PrimaryButton(
                  label: (AppLocalizations.of(context) ?? widget.loc)?.send ??
                      'Send',
                  onPressed: _isSending ? () {} : _sendMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.messageController.dispose();
    super.dispose();
  }
}
