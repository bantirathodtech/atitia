// lib/feature/owner_dashboard/refunds/view/screens/owner_refund_history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/loaders/enhanced_loading_state.dart';
import '../../../../../../common/widgets/indicators/enhanced_empty_state.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/caption_text.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../../common/utils/constants/routes.dart';
import '../../../../../../core/models/refund/refund_request_model.dart';
import '../../viewmodel/owner_refund_viewmodel.dart';
import '../../../shared/widgets/owner_drawer.dart';

/// Owner Refund History Screen
/// Displays all refund requests made by the owner
class OwnerRefundHistoryScreen extends StatefulWidget {
  const OwnerRefundHistoryScreen({super.key});

  @override
  State<OwnerRefundHistoryScreen> createState() =>
      _OwnerRefundHistoryScreenState();
}

class _OwnerRefundHistoryScreenState
    extends State<OwnerRefundHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerRefundViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Refund History',
        showDrawer: true,
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.go(AppRoutes.ownerRefundRequest);
            },
            tooltip: 'Request Refund',
          ),
        ],
      ),
      drawer: const OwnerDrawer(),
      body: Consumer<OwnerRefundViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading && viewModel.refundRequests.isEmpty) {
            return const EnhancedLoadingState(type: LoadingType.centered);
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
                  // Request new refund button
                  PrimaryButton(
                    onPressed: () {
                      context.go(AppRoutes.ownerRefundRequest);
                    },
                    label: 'Request New Refund',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Filters
                  _buildFilters(context, viewModel),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Refund requests list
                  _buildRefundRequestsList(context, viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters(
      BuildContext context, OwnerRefundViewModel viewModel) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Filter by Status'),
            const SizedBox(height: AppSpacing.paddingM),
            Wrap(
              spacing: AppSpacing.paddingS,
              children: [
                _buildFilterChip(context, 'all', 'All', viewModel),
                _buildFilterChip(context, 'pending', 'Pending', viewModel),
                _buildFilterChip(context, 'approved', 'Approved', viewModel),
                _buildFilterChip(context, 'rejected', 'Rejected', viewModel),
                _buildFilterChip(context, 'completed', 'Completed', viewModel),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String value, String label,
      OwnerRefundViewModel viewModel) {
    final isSelected = viewModel.selectedStatusFilter == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        viewModel.setStatusFilter(value);
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildRefundRequestsList(
      BuildContext context, OwnerRefundViewModel viewModel) {
    final filteredRefunds = viewModel.filteredRefunds;

    if (filteredRefunds.isEmpty) {
      return AdaptiveCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Center(
            child: EmptyStates.noData(
              context: context,
              title: 'No Refund Requests',
              message: viewModel.selectedStatusFilter == 'all'
                  ? 'You haven\'t requested any refunds yet.'
                  : 'No refund requests match the selected filter.',
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
              child: _buildRefundRequestCard(context, refund),
            )),
      ],
    );
  }

  Widget _buildRefundRequestCard(
      BuildContext context, RefundRequestModel refund) {
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
                      HeadingMedium(text: refund.type.displayName),
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
            const Divider(),
            const SizedBox(height: AppSpacing.paddingM),

            // Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BodyText(text: 'Refund Amount:'),
                HeadingMedium(
                  text: currencyFormatter.format(refund.amount),
                  color: AppColors.primary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),

            // Reason
            BodyText(
              text: 'Reason: ${refund.reason}',
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withValues(alpha: 0.8),
            ),

            // Admin notes
            if (refund.adminNotes != null && refund.adminNotes!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingM),
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: BodyText(
                  text: 'Admin Notes: ${refund.adminNotes}',
                  color: AppColors.info,
                ),
              ),
            ],

            // Rejection reason
            if (refund.rejectionReason != null &&
                refund.rejectionReason!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.paddingM),
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
            ],

            // Processed date
            if (refund.processedAt != null) ...[
              const SizedBox(height: AppSpacing.paddingM),
              CaptionText(
                text: 'Processed: ${dateFormatter.format(refund.processedAt!)}',
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.7),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

