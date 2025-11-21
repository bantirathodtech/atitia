// lib/feature/owner_dashboard/myguest/view/widgets/bed_change_request_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/buttons/text_button.dart';
import '../../../../../l10n/app_localizations.dart';
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
    final AppLocalizations loc = AppLocalizations.of(context)!;
    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bed_outlined,
                size: 64,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5)),
            const SizedBox(height: AppSpacing.paddingM),
            HeadingSmall(
              text: loc.noBedChangeRequests,
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: loc.bedChangeRequestsEmptyBody,
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
          child: _buildRequestCard(context, request, loc),
        );
      },
    );
  }

  Widget _buildRequestCard(
    BuildContext context,
    BedChangeRequestModel request,
    AppLocalizations loc,
  ) {
    final isPending = request.status == 'pending';
    final statusColor = _getStatusColor(request.status);
    final statusLabel = _statusLabel(request.status, loc);

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
                HeadingSmall(
                  text: loc.bedChangeRequestTitle,
                ),
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
                    text: statusLabel,
                    color: statusColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            // Current assignment
            _buildInfoRow(
              context,
              loc.bedChangeCurrent,
              request.currentRoomNumber != null &&
                      request.currentBedNumber != null
                  ? loc.bedChangeCurrentAssignment(
                      request.currentRoomNumber!,
                      request.currentBedNumber!,
                    )
                  : loc.notAssigned,
            ),
            // Preferred assignment
            if (request.preferredRoomNumber != null ||
                request.preferredBedNumber != null)
              _buildInfoRow(
                context,
                loc.bedChangePreferred,
                loc.bedChangePreferredAssignment(
                  request.preferredRoomNumber ?? loc.anyLabel,
                  request.preferredBedNumber ?? loc.anyLabel,
                ),
              ),
            // Reason
            const SizedBox(height: AppSpacing.paddingS),
            HeadingSmall(text: loc.reasonLabel),
            const SizedBox(height: AppSpacing.paddingXS),
            BodyText(text: request.reason),
            const SizedBox(height: AppSpacing.paddingM),
            // Actions for pending requests
            if (isPending)
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      label: loc.reject,
                      icon: Icons.close,
                      onPressed: () => _showRejectDialog(context, request, loc),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingM),
                  Expanded(
                    child: PrimaryButton(
                      label: loc.approve,
                      icon: Icons.check,
                      onPressed: () =>
                          _showApproveDialog(context, request, loc),
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
                      text: '${loc.decisionNotesLabel}:',
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
          BodyText(
              text: '$label:',
              color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.7) ??
                  Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.7)),
          BodyText(text: value, medium: true),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      case 'pending':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  String _statusLabel(String status, AppLocalizations? loc) {
    switch (status.toLowerCase()) {
      case 'approved':
        return loc?.bedChangeStatusApproved ?? 'APPROVED';
      case 'rejected':
        return loc?.bedChangeStatusRejected ?? 'REJECTED';
      case 'pending':
        return loc?.bedChangeStatusPending ?? 'PENDING';
      default:
        return status.toUpperCase();
    }
  }

  void _showApproveDialog(
    BuildContext context,
    BedChangeRequestModel request,
    AppLocalizations loc,
  ) {
    final notesController = TextEditingController();

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
              HeadingSmall(text: loc.approveBedChangeTitle),
              const SizedBox(height: AppSpacing.paddingM),
              BodyText(text: loc.approveBedChangeDescription),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: notesController,
                label: loc.notesOptional,
                hint: loc.approvalNotesHint,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.of(context).pop(),
                    text: loc.cancel,
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  PrimaryButton(
            label: loc.approve,
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
                    content: Text(
                      success
                          ? loc.bedChangeApproveSuccess
                          : loc.bedChangeApproveFailure,
                    ),
                    backgroundColor:
                        success ? AppColors.success : AppColors.error,
                  ),
                );
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

  void _showRejectDialog(
    BuildContext context,
    BedChangeRequestModel request,
    AppLocalizations loc,
  ) {
    final notesController = TextEditingController();

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
              HeadingSmall(text: loc.rejectBedChangeTitle),
              const SizedBox(height: AppSpacing.paddingM),
              BodyText(text: loc.rejectBedChangeDescription),
              const SizedBox(height: AppSpacing.paddingM),
              TextInput(
                controller: notesController,
                label: loc.rejectionReasonRequired,
                hint: loc.rejectionReasonHintDetailed,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.paddingL),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButtonWidget(
                    onPressed: () => Navigator.of(context).pop(),
                    text: loc.cancel,
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  PrimaryButton(
                    label: loc.reject,
                    onPressed: () async {
                      if (notesController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(loc.provideRejectionReason),
                            backgroundColor: AppColors.warning,
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
                            content: Text(
                              success
                                  ? loc.bedChangeRejectSuccess
                                  : loc.bedChangeRejectFailure,
                            ),
                            backgroundColor:
                                success ? AppColors.warning : AppColors.error,
                          ),
                        );
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
