// lib/feature/owner_dashboard/myguest/view/widgets/bed_change_request_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../core/models/bed_change_request_model.dart';
import '../../viewmodel/owner_guest_viewmodel.dart';

/// Widget displaying bed change requests with approve/reject actions
class BedChangeRequestWidget extends StatelessWidget {
  final List<BedChangeRequestModel> requests;
  final OwnerGuestViewModel viewModel;

  const BedChangeRequestWidget({
    required this.requests,
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bed_outlined, size: 64, color: Colors.grey),
            SizedBox(height: AppSpacing.paddingM),
            HeadingSmall(
              text: 'No Bed Change Requests',
              align: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: 'Bed change requests from guests will appear here',
              align: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
          child: _buildRequestCard(context, request),
        );
      },
    );
  }

  Widget _buildRequestCard(
      BuildContext context, BedChangeRequestModel request) {
    final isPending = request.status == 'pending';
    final statusColor = _getStatusColor(request.status);

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const HeadingSmall(text: 'Bed Change Request'),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: CaptionText(
                    text: request.status.toUpperCase(),
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            // Current assignment
            _buildInfoRow(
              context,
              'Current',
              request.currentRoomNumber != null &&
                      request.currentBedNumber != null
                  ? 'Room ${request.currentRoomNumber}, Bed ${request.currentBedNumber}'
                  : 'Not assigned',
            ),
            // Preferred assignment
            if (request.preferredRoomNumber != null ||
                request.preferredBedNumber != null)
              _buildInfoRow(
                context,
                'Preferred',
                'Room ${request.preferredRoomNumber ?? 'Any'}, Bed ${request.preferredBedNumber ?? 'Any'}',
              ),
            // Reason
            const SizedBox(height: AppSpacing.paddingS),
            const HeadingSmall(text: 'Reason'),
            const SizedBox(height: AppSpacing.paddingXS),
            BodyText(text: request.reason),
            const SizedBox(height: AppSpacing.paddingM),
            // Actions for pending requests
            if (isPending)
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: 'Reject',
                      icon: Icons.close,
                      onPressed: () => _showRejectDialog(context, request),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingM),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Approve',
                      icon: Icons.check,
                      onPressed: () => _showApproveDialog(context, request),
                    ),
                  ),
                ],
              ),
            // Decision notes if resolved
            if (!isPending && request.decisionNotes != null) ...[
              const SizedBox(height: AppSpacing.paddingS),
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CaptionText(
                      text: 'Decision Notes:',
                      color: statusColor,
                    ),
                    const SizedBox(height: AppSpacing.paddingXS),
                    BodyText(text: request.decisionNotes!),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BodyText(text: '$label:', color: Colors.grey[600]),
          BodyText(text: value, medium: true),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showApproveDialog(BuildContext context, BedChangeRequestModel request) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const HeadingSmall(text: 'Approve Bed Change Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BodyText(
              text: 'The guest will be moved to their preferred room/bed.',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add approval notes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Approve',
            onPressed: () async {
              final success = await viewModel.approveBedChangeRequest(
                request.requestId,
                decisionNotes: notesController.text.trim().isEmpty
                    ? null
                    : notesController.text.trim(),
              );
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Bed change approved successfully'
                        : 'Failed to approve bed change'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context, BedChangeRequestModel request) {
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const HeadingSmall(text: 'Reject Bed Change Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BodyText(
              text: 'Please provide a reason for rejection.',
            ),
            const SizedBox(height: AppSpacing.paddingM),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Rejection Reason *',
                hintText: 'Explain why the request is being rejected...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          PrimaryButton(
            label: 'Reject',
            onPressed: () async {
              if (notesController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a rejection reason'),
                    backgroundColor: Colors.orange,
                  ),
                );
                return;
              }
              final success = await viewModel.rejectBedChangeRequest(
                request.requestId,
                decisionNotes: notesController.text.trim(),
              );
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success
                        ? 'Bed change rejected'
                        : 'Failed to reject bed change'),
                    backgroundColor: success ? Colors.orange : Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
