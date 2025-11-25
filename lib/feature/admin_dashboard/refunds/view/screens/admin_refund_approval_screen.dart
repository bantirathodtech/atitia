// lib/feature/admin_dashboard/refunds/view/screens/admin_refund_approval_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/caption_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/heading_small.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../../common/widgets/indicators/enhanced_empty_state.dart';
import '../../../../../../core/models/refund/refund_request_model.dart';
import '../../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../viewmodel/admin_refund_viewmodel.dart';

/// Admin Refund Approval Screen
/// Allows admins to view, approve, reject, and process refund requests
class AdminRefundApprovalScreen extends StatefulWidget {
  const AdminRefundApprovalScreen({super.key});

  @override
  State<AdminRefundApprovalScreen> createState() =>
      _AdminRefundApprovalScreenState();
}

class _AdminRefundApprovalScreenState
    extends State<AdminRefundApprovalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminRefundViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Refund Management',
        showBackButton: true,
      ),
      body: Consumer<AdminRefundViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading && viewModel.allRefundRequests.isEmpty) {
            return const Center(child: AdaptiveLoader());
          }

          if (viewModel.error) {
            return Center(
              child: EmptyStates.error(
                context: context,
                message: viewModel.errorMessage ?? 'Failed to load refund requests',
                onRetry: () => viewModel.refresh(),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.refresh(),
            child: SingleChildScrollView(
              padding: ResponsiveSystem.getResponsivePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Statistics Cards
                  _buildStatistics(context, viewModel),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Filters
                  _buildFilters(context, viewModel),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Refund Requests List
                  _buildRefundRequestsList(context, viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatistics(
      BuildContext context, AdminRefundViewModel viewModel) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            'Pending',
            viewModel.totalPendingCount.toString(),
            AppColors.warning,
            Icons.pending_actions,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: _buildStatCard(
            context,
            'Approved',
            viewModel.totalApprovedCount.toString(),
            AppColors.info,
            Icons.check_circle_outline,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: _buildStatCard(
            context,
            'Rejected',
            viewModel.totalRejectedCount.toString(),
            AppColors.error,
            Icons.cancel_outlined,
          ),
        ),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: _buildStatCard(
            context,
            'Completed',
            viewModel.totalCompletedCount.toString(),
            AppColors.success,
            Icons.done_all,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      BuildContext context, String label, String value, Color color, IconData icon) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppSpacing.paddingS),
            HeadingSmall(text: value, color: color),
            CaptionText(
              text: label,
              color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters(
      BuildContext context, AdminRefundViewModel viewModel) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Filters'),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildStatusFilter(context, viewModel),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: _buildTypeFilter(context, viewModel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter(
      BuildContext context, AdminRefundViewModel viewModel) {
    return DropdownButtonFormField<String>(
      value: viewModel.selectedStatusFilter,
      decoration: InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'all', child: Text('All')),
        DropdownMenuItem(value: 'pending', child: Text('Pending')),
        DropdownMenuItem(value: 'approved', child: Text('Approved')),
        DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
        DropdownMenuItem(value: 'completed', child: Text('Completed')),
      ],
      onChanged: (value) {
        if (value != null) {
          viewModel.setStatusFilter(value);
        }
      },
    );
  }

  Widget _buildTypeFilter(
      BuildContext context, AdminRefundViewModel viewModel) {
    return DropdownButtonFormField<String>(
      value: viewModel.selectedTypeFilter,
      decoration: InputDecoration(
        labelText: 'Type',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
      ),
      items: const [
        DropdownMenuItem(value: 'all', child: Text('All')),
        DropdownMenuItem(value: 'subscription', child: Text('Subscription')),
        DropdownMenuItem(
            value: 'featuredListing', child: Text('Featured Listing')),
      ],
      onChanged: (value) {
        if (value != null) {
          viewModel.setTypeFilter(value);
        }
      },
    );
  }

  Widget _buildRefundRequestsList(
      BuildContext context, AdminRefundViewModel viewModel) {
    final filteredRefunds = viewModel.filteredRefunds;

    if (filteredRefunds.isEmpty) {
      return AdaptiveCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Center(
            child: EmptyStates.noData(
              context: context,
              title: 'No Refund Requests',
              message: 'There are no refund requests matching the current filters.',
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: 'Refund Requests (${filteredRefunds.length})'),
        const SizedBox(height: AppSpacing.paddingM),
        ...filteredRefunds.map((refund) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
              child: _buildRefundRequestCard(context, refund, viewModel),
            )),
      ],
    );
  }

  Widget _buildRefundRequestCard(BuildContext context,
      RefundRequestModel refund, AdminRefundViewModel viewModel) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('MMM dd, yyyy');

    Color statusColor;
    IconData statusIcon;
    switch (refund.status) {
      case RefundStatus.pending:
        statusColor = AppColors.warning;
        statusIcon = Icons.pending_actions;
        break;
      case RefundStatus.approved:
        statusColor = AppColors.info;
        statusIcon = Icons.check_circle;
        break;
      case RefundStatus.rejected:
        statusColor = AppColors.error;
        statusIcon = Icons.cancel;
        break;
      case RefundStatus.completed:
        statusColor = AppColors.success;
        statusIcon = Icons.done_all;
        break;
      default:
        statusColor = AppColors.secondary;
        statusIcon = Icons.info;
    }

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingSmall(text: refund.type.displayName),
                      CaptionText(
                        text: 'Requested: ${dateFormatter.format(refund.requestedAt)}',
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.color
                            ?.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                    border: Border.all(color: statusColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        refund.status.displayName,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),

            // Amount
            Row(
              children: [
                Icon(Icons.currency_rupee, size: 20, color: AppColors.primary),
                const SizedBox(width: AppSpacing.paddingS),
                HeadingMedium(
                  text: currencyFormatter.format(refund.amount),
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),

            // Reason
            if (refund.reason.isNotEmpty) ...[
              BodyText(text: 'Reason: ${refund.reason}'),
              const SizedBox(height: AppSpacing.paddingM),
            ],

            // Admin notes
            if (refund.adminNotes != null && refund.adminNotes!.isNotEmpty) ...[
              BodyText(
                text: 'Admin Notes: ${refund.adminNotes}',
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.8),
              ),
              const SizedBox(height: AppSpacing.paddingM),
            ],

            // Rejection reason
            if (refund.rejectionReason != null &&
                refund.rejectionReason!.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: BodyText(
                  text: 'Rejection Reason: ${refund.rejectionReason}',
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),
            ],

            // Actions for pending refunds
            if (refund.status == RefundStatus.pending) ...[
              const Divider(),
              const SizedBox(height: AppSpacing.paddingM),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      onPressed: () => _showRejectDialog(context, refund, viewModel),
                      label: 'Reject',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingM),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () => _approveRefund(context, refund, viewModel),
                      label: 'Approve',
                    ),
                  ),
                ],
              ),
            ],

            // Process button for approved refunds
            if (refund.status == RefundStatus.approved) ...[
              const Divider(),
              const SizedBox(height: AppSpacing.paddingM),
              PrimaryButton(
                onPressed: () => _processRefund(context, refund, viewModel),
                label: 'Process Refund',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _approveRefund(BuildContext context,
      RefundRequestModel refund, AdminRefundViewModel viewModel) async {
    final authService = getIt.auth;
    final adminUserId = authService.currentUserId ?? '';

    try {
      await viewModel.approveRefundRequest(
        refundRequestId: refund.refundRequestId,
        adminUserId: adminUserId,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Refund request approved successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to approve refund: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _processRefund(BuildContext context,
      RefundRequestModel refund, AdminRefundViewModel viewModel) async {
    final authService = getIt.auth;
    final adminUserId = authService.currentUserId ?? '';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Process Refund'),
        content: const Text(
            'This will process the refund and transfer the amount back to the owner. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Process'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await viewModel.processRefund(
        refundRequestId: refund.refundRequestId,
        adminUserId: adminUserId,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Refund processed successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process refund: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _showRejectDialog(BuildContext context,
      RefundRequestModel refund, AdminRefundViewModel viewModel) async {
    final rejectionReasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Refund Request'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please provide a reason for rejection:'),
            const SizedBox(height: AppSpacing.paddingM),
            TextField(
              controller: rejectionReasonController,
              decoration: const InputDecoration(
                labelText: 'Rejection Reason',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (rejectionReasonController.text.trim().isNotEmpty) {
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final authService = getIt.auth;
    final adminUserId = authService.currentUserId ?? '';

    try {
      await viewModel.rejectRefundRequest(
        refundRequestId: refund.refundRequestId,
        adminUserId: adminUserId,
        rejectionReason: rejectionReasonController.text.trim(),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Refund request rejected'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reject refund: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

