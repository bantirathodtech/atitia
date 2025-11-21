// lib/feature/owner_dashboard/guests/view/widgets/complaint_management_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/text_button.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../viewmodel/owner_guest_viewmodel.dart';
import '../../data/models/owner_complaint_model.dart';

/// Widget for managing guest complaints
class ComplaintManagementWidget extends StatefulWidget {
  const ComplaintManagementWidget({super.key});

  @override
  State<ComplaintManagementWidget> createState() =>
      _ComplaintManagementWidgetState();
}

class _ComplaintManagementWidgetState extends State<ComplaintManagementWidget> {
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
    final filteredComplaints = guestVM.filteredComplaints;

    return Column(
      children: [
        _buildSearchAndFilters(context, guestVM),
        Expanded(
          child: _buildComplaintList(context, guestVM, filteredComplaints),
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
                  label: loc.searchComplaints,
                  hint: loc.searchComplaintsHint,
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
                _buildFilterChip(loc.statusNew, 'new', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(loc.statusInProgress, 'in_progress',
                    guestVM.statusFilter, guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(loc.statusResolved, 'resolved',
                    guestVM.statusFilter, guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(loc.urgent, 'urgent', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip(loc.highPriority, 'high_priority',
                    guestVM.statusFilter, guestVM.setStatusFilter),
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

  /// Builds complaint list
  Widget _buildComplaintList(BuildContext context, OwnerGuestViewModel guestVM,
      List<OwnerComplaintModel> complaints) {
    final loc = AppLocalizations.of(context)!;

    if (guestVM.loading && complaints.isEmpty) {
      return const Center(child: AdaptiveLoader());
    }

    return Column(
      children: [
        // Stats header
        _buildStatsHeader(context, guestVM, loc),
        const SizedBox(height: AppSpacing.paddingM),
        // Complaint list or structured empty state
        Expanded(
          child: complaints.isEmpty
              ? _buildStructuredEmptyState(context, guestVM, loc)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingM),
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];
                    return _buildComplaintCard(context, guestVM, complaint);
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
              loc.total,
              guestVM.totalComplaints.toString(),
              Icons.report_problem,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              loc.statusNew,
              guestVM.newComplaints.toString(),
              Icons.new_releases,
              AppColors.statusBlue,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              loc.statusResolved,
              guestVM.complaints.where((c) => c.isResolved).length.toString(),
              Icons.check_circle,
              AppColors.success,
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
                Icon(Icons.report_problem_outlined,
                    size: 20,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5)),
                const SizedBox(width: AppSpacing.paddingS),
                BodyText(text: loc.complaints),
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
                  child: BodyText(text: loc.complaintCount(0)),
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
                _buildPlaceholderComplaintCard(context),
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
                Icon(Icons.report_problem_outlined,
                    size: 48,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5)),
                const SizedBox(height: AppSpacing.paddingM),
                HeadingMedium(text: loc.noComplaintsYet),
                const SizedBox(height: AppSpacing.paddingS),
                BodyText(
                  text: loc.complaintsFromGuestsWillAppearHere,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds placeholder complaint card
  Widget _buildPlaceholderComplaintCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 16,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.paddingXS),
                    Container(
                      height: 12,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
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
          const SizedBox(height: AppSpacing.paddingM),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppSpacing.paddingXS),
          Container(
            height: 12,
            width: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds individual complaint card
  Widget _buildComplaintCard(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerComplaintModel complaint) {
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
      child: AdaptiveCard(
        child: InkWell(
          onTap: () => _showComplaintDetails(context, guestVM, complaint),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Complaint header
                Row(
                  children: [
                    Icon(
                      _getComplaintIcon(complaint.complaintType),
                      color: _getComplaintColor(context, complaint.priority),
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            complaint.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.paddingXS),
                          Text(
                            '${complaint.guestName} - ${loc.room} ${complaint.roomNumber}',
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
                    _buildStatusChip(context, complaint.status),
                  ],
                ),

                const SizedBox(height: AppSpacing.paddingM),

                // Complaint description
                Text(
                  complaint.description,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: AppSpacing.paddingM),

                // Complaint details
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.event,
                        label: loc.created,
                        value: _formatDate(complaint.createdAt),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.priority_high,
                        label: loc.priority,
                        value: complaint.priorityDisplay,
                      ),
                    ),
                  ],
                ),

                if (complaint.unreadOwnerMessages > 0) ...[
                  const SizedBox(height: AppSpacing.paddingS),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      loc.unreadMessagesCount(complaint.unreadOwnerMessages),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
    String label;

    switch (status.toLowerCase()) {
      case 'new':
        chipColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
        label = loc.statusNew;
        break;
      case 'in_progress':
        chipColor = AppColors.statusOrange.withValues(alpha: 0.1);
        textColor = AppColors.statusOrange;
        label = loc.statusInProgress;
        break;
      case 'resolved':
        chipColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        label = loc.statusResolved;
        break;
      case 'closed':
        chipColor =
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
        textColor =
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
        label = loc.statusClosed;
        break;
      default:
        chipColor =
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
        textColor =
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Gets complaint icon based on type
  IconData _getComplaintIcon(String type) {
    switch (type.toLowerCase()) {
      case 'maintenance':
        return Icons.build;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'noise':
        return Icons.volume_off;
      case 'security':
        return Icons.security;
      case 'food':
        return Icons.restaurant;
      default:
        return Icons.report_problem;
    }
  }

  /// Gets complaint color based on priority
  Color _getComplaintColor(BuildContext context, String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return AppColors.statusRed;
      case 'high':
        return AppColors.statusOrange;
      case 'medium':
        return AppColors.info;
      case 'low':
        return AppColors.success;
      default:
        return Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.7) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }

  /// Shows complaint details dialog
  void _showComplaintDetails(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerComplaintModel complaint) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final loc = AppLocalizations.of(dialogContext)!;

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
                HeadingMedium(text: complaint.title),
                const SizedBox(height: AppSpacing.paddingM),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildDetailRow(loc.guest, complaint.guestName),
                        _buildDetailRow(loc.room, complaint.roomNumber),
                        _buildDetailRow(loc.complaintTitle, complaint.title),
                        _buildDetailRow(loc.priority, complaint.priorityDisplay),
                        _buildDetailRow(loc.status, complaint.statusDisplay),
                        _buildDetailRow(loc.created, _formatDate(complaint.createdAt)),
                        if (complaint.resolvedAt != null)
                          _buildDetailRow(
                              loc.statusResolved, _formatDate(complaint.resolvedAt!)),
                        const SizedBox(height: AppSpacing.paddingM),
                        HeadingSmall(text: loc.description),
                        const SizedBox(height: AppSpacing.paddingXS),
                        BodyText(text: complaint.description),
                        const SizedBox(height: AppSpacing.paddingM),
                        HeadingSmall(text: loc.messages),
                        const SizedBox(height: AppSpacing.paddingXS),
                        _buildMessagesList(complaint.messages),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.paddingM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButtonWidget(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      text: loc.close,
                    ),
                    if (!complaint.isResolved) ...[
                      const SizedBox(width: AppSpacing.paddingS),
                      PrimaryButton(
                        label: loc.reply,
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                          _showReplyDialog(context, guestVM, complaint);
                        },
                      ),
                      const SizedBox(width: AppSpacing.paddingS),
                      PrimaryButton(
                        label: loc.resolve,
                        onPressed: () => _resolveComplaint(context, guestVM, complaint),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
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

  /// Builds messages list
  Widget _buildMessagesList(List<ComplaintMessage> messages) {
    if (messages.isEmpty) {
      return Text(AppLocalizations.of(context)!.noMessagesYet);
    }

    return Column(
      children: messages.map((message) => _buildMessageItem(message)).toList(),
    );
  }

  /// Builds message item
  Widget _buildMessageItem(ComplaintMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppSpacing.paddingS),
      decoration: BoxDecoration(
        color: message.isFromGuest
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                message.senderName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                message.formattedTimestamp,
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
            ],
          ),
          const SizedBox(height: AppSpacing.paddingXS),
          Text(message.message),
        ],
      ),
    );
  }

  /// Shows reply dialog
  void _showReplyDialog(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerComplaintModel complaint) {
    final replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final loc = AppLocalizations.of(dialogContext)!;

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
                HeadingMedium(text: loc.replyToComplaint),
                const SizedBox(height: AppSpacing.paddingM),
                TextInput(
                  controller: replyController,
                  label: loc.replyLabel,
                  hint: loc.typeYourReply,
                  maxLines: 4,
                ),
                const SizedBox(height: AppSpacing.paddingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButtonWidget(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      text: loc.cancel,
                    ),
            PrimaryButton(
              label: loc.sendReply,
              onPressed: () async {
                if (replyController.text.isNotEmpty) {
                  final navigator = Navigator.of(dialogContext);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final locOuter = AppLocalizations.of(context)!;
                  final success = await guestVM.addComplaintReply(
                    complaint.complaintId,
                    replyController.text,
                    locOuter.owner,
                  );

                  if (!success || !mounted) return;
                  navigator.pop();
                  if (!mounted) return;
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text(locOuter.replySentSuccessfully)),
                  );
                }
              },
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Resolves complaint
  void _resolveComplaint(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerComplaintModel complaint) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        final loc = AppLocalizations.of(dialogContext)!;

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
                HeadingMedium(text: loc.resolveComplaint),
                const SizedBox(height: AppSpacing.paddingM),
                TextInput(
                  controller: notesController,
                  label: loc.resolutionNotes,
                  hint: loc.resolutionNotesOptional,
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.paddingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButtonWidget(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      text: loc.cancel,
                    ),
            PrimaryButton(
              label: loc.markAsResolved,
              onPressed: () async {
                final navigator = Navigator.of(dialogContext);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final locOuter = AppLocalizations.of(context)!;
                final success = await guestVM.updateComplaintStatus(
                  complaint.complaintId,
                  'resolved',
                  resolutionNotes: notesController.text.isNotEmpty
                      ? notesController.text
                      : null,
                );

                if (!success || !mounted) return;
                navigator.pop();
                if (!mounted) return;
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                      content: Text(locOuter.complaintResolvedSuccessfully)),
                );
              },
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
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

  /// Builds quick stats and bulk actions bar
  Widget _buildQuickStatsAndActions(
      BuildContext context, OwnerGuestViewModel guestVM, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          // Quick stats
          Expanded(
            child: Row(
              children: [
                _buildStatChip(
                    context, loc.total, '${guestVM.complaints.length}'),
                const SizedBox(width: AppSpacing.paddingS),
                _buildStatChip(context, loc.statusNew,
                    '${guestVM.complaints.where((c) => c.status == 'new').length}'),
                const SizedBox(width: AppSpacing.paddingS),
                _buildStatChip(context, loc.urgent,
                    '${guestVM.complaints.where((c) => c.priority == 'urgent').length}'),
              ],
            ),
          ),
          // Bulk actions
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportComplaints(context, guestVM),
            tooltip: loc.exportData,
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
      builder: (dialogContext) {
        final loc = AppLocalizations.of(dialogContext)!;

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
                HeadingMedium(text: loc.advancedSearch),
                const SizedBox(height: AppSpacing.paddingM),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextInput(
                          label: loc.complaintTitle,
                          hint: loc.complaintTitle,
                        ),
                        const SizedBox(height: AppSpacing.paddingM),
                        TextInput(
                          label: loc.guestName,
                          hint: loc.guestName,
                        ),
                        const SizedBox(height: AppSpacing.paddingM),
                        TextInput(
                          label: loc.room,
                          hint: loc.roomNumber,
                        ),
                        const SizedBox(height: AppSpacing.paddingM),
                        TextInput(
                          label: loc.priorityLevel,
                          hint: loc.priorityLevel,
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
                      onPressed: () => Navigator.pop(dialogContext),
                      text: AppLocalizations.of(context)!.cancel,
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    PrimaryButton(
                      label: AppLocalizations.of(context)!.search,
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        // TODO: Implement advanced search
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

  /// Exports all complaints
  void _exportComplaints(BuildContext context, OwnerGuestViewModel guestVM) {
    // TODO: Implement export functionality
    final loc = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          loc?.complaintDataExportedSuccessfully ??
              _text('complaintDataExportedSuccessfully',
                  'Complaint data exported successfully'),
        ),
      ),
    );
  }
}
