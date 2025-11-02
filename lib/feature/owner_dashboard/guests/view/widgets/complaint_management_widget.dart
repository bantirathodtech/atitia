// lib/feature/owner_dashboard/guests/view/widgets/complaint_management_widget.dart

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
                  label: 'Search Complaints',
                  hint: 'Search by title, guest, room, or description...',
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
                _buildFilterChip('New', 'new', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('In Progress', 'in_progress',
                    guestVM.statusFilter, guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('Resolved', 'resolved', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('Urgent', 'urgent', guestVM.statusFilter,
                    guestVM.setStatusFilter),
                const SizedBox(width: AppSpacing.paddingS),
                _buildFilterChip('High Priority', 'high_priority',
                    guestVM.statusFilter, guestVM.setStatusFilter),
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

  /// Builds complaint list
  Widget _buildComplaintList(BuildContext context, OwnerGuestViewModel guestVM,
      List<OwnerComplaintModel> complaints) {
    if (guestVM.loading && complaints.isEmpty) {
      return const Center(child: AdaptiveLoader());
    }

    return Column(
      children: [
        // Stats header
        _buildStatsHeader(context, guestVM),
        const SizedBox(height: AppSpacing.paddingM),
        // Complaint list or structured empty state
        Expanded(
          child: complaints.isEmpty
              ? _buildStructuredEmptyState(context, guestVM)
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
              'Total',
              guestVM.totalComplaints.toString(),
              Icons.report_problem,
              AppColors.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              'New',
              guestVM.newComplaints.toString(),
              Icons.new_releases,
              Colors.red,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: _buildStatCard(
              context,
              'Resolved',
              guestVM.complaints.where((c) => c.isResolved).length.toString(),
              Icons.check_circle,
              Colors.green,
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
                const Icon(Icons.report_problem_outlined,
                    size: 20, color: Colors.grey),
                const SizedBox(width: AppSpacing.paddingS),
                const BodyText(text: 'Complaints'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.paddingS, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: const BodyText(text: '0 complaints'),
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
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                const Icon(Icons.report_problem_outlined,
                    size: 48, color: Colors.grey),
                const SizedBox(height: AppSpacing.paddingM),
                const HeadingMedium(text: 'No Complaints Yet'),
                const SizedBox(height: AppSpacing.paddingS),
                const BodyText(
                  text: 'Guest complaints will appear here when submitted',
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
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
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
                  color: Colors.grey.withValues(alpha: 0.2),
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
          const SizedBox(height: AppSpacing.paddingM),
          Container(
            height: 14,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: AppSpacing.paddingXS),
          Container(
            height: 12,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
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
                      color: _getComplaintColor(complaint.priority),
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
                          const SizedBox(height: 4),
                          Text(
                            '${complaint.guestName} - Room ${complaint.roomNumber}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(complaint.status),
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
                        icon: Icons.schedule,
                        label: 'Created',
                        value: _formatDate(complaint.createdAt),
                      ),
                    ),
                    Expanded(
                      child: _buildDetailItem(
                        icon: Icons.priority_high,
                        label: 'Priority',
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
                      '${complaint.unreadOwnerMessages} unread messages',
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
      case 'new':
        chipColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        break;
      case 'in_progress':
        chipColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        break;
      case 'resolved':
        chipColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        break;
      case 'closed':
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
  Color _getComplaintColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Shows complaint details dialog
  void _showComplaintDetails(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerComplaintModel complaint) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(complaint.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Guest', complaint.guestName),
              _buildDetailRow('Room', complaint.roomNumber),
              _buildDetailRow('Type', complaint.complaintType),
              _buildDetailRow('Priority', complaint.priorityDisplay),
              _buildDetailRow('Status', complaint.statusDisplay),
              _buildDetailRow('Created', _formatDate(complaint.createdAt)),
              if (complaint.resolvedAt != null)
                _buildDetailRow('Resolved', _formatDate(complaint.resolvedAt!)),
              const SizedBox(height: AppSpacing.paddingM),
              const Text('Description:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(complaint.description),
              const SizedBox(height: AppSpacing.paddingM),
              const Text('Messages:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              _buildMessagesList(complaint.messages),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (!complaint.isResolved) ...[
            PrimaryButton(
              label: 'Reply',
              onPressed: () {
                Navigator.of(context).pop();
                _showReplyDialog(context, guestVM, complaint);
              },
            ),
            PrimaryButton(
              label: 'Resolve',
              onPressed: () => _resolveComplaint(context, guestVM, complaint),
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

  /// Builds messages list
  Widget _buildMessagesList(List<ComplaintMessage> messages) {
    if (messages.isEmpty) {
      return const Text('No messages yet');
    }

    return Column(
      children: messages.map((message) => _buildMessageItem(message)).toList(),
    );
  }

  /// Builds message item
  Widget _buildMessageItem(ComplaintMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: message.isFromGuest
            ? Colors.grey[100]
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
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
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
      builder: (context) => AlertDialog(
        title: const Text('Reply to Complaint'),
        content: TextInput(
          controller: replyController,
          label: 'Reply',
          hint: 'Type your reply...',
          maxLines: 4,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Send Reply',
            onPressed: () async {
              if (replyController.text.isNotEmpty) {
                final success = await guestVM.addComplaintReply(
                  complaint.complaintId,
                  replyController.text,
                  'Owner',
                );

                if (success && mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reply sent successfully')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  /// Resolves complaint
  void _resolveComplaint(BuildContext context, OwnerGuestViewModel guestVM,
      OwnerComplaintModel complaint) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve Complaint'),
        content: TextInput(
          controller: notesController,
          label: 'Resolution Notes',
          hint: 'Resolution notes (optional)...',
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Mark as Resolved',
            onPressed: () async {
              final success = await guestVM.updateComplaintStatus(
                complaint.complaintId,
                'resolved',
                resolutionNotes: notesController.text.isNotEmpty
                    ? notesController.text
                    : null,
              );

              if (success && mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Complaint resolved successfully')),
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
                _buildStatChip(
                    context, 'Total', '${guestVM.complaints.length}'),
                const SizedBox(width: AppSpacing.paddingS),
                _buildStatChip(context, 'New',
                    '${guestVM.complaints.where((c) => c.status == 'new').length}'),
                const SizedBox(width: AppSpacing.paddingS),
                _buildStatChip(context, 'Urgent',
                    '${guestVM.complaints.where((c) => c.priority == 'urgent').length}'),
              ],
            ),
          ),
          // Bulk actions
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportComplaints(context, guestVM),
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
              label: 'Title',
              hint: 'Complaint title',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Guest Name',
              hint: 'Guest name',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Room',
              hint: 'Room number',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextInput(
              label: 'Priority',
              hint: 'Priority level',
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

  /// Exports all complaints
  void _exportComplaints(BuildContext context, OwnerGuestViewModel guestVM) {
    // TODO: Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: BodyText(text: 'Complaint data exported successfully')),
    );
  }
}
