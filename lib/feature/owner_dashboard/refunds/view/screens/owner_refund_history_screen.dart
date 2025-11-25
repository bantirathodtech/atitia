// lib/feature/owner_dashboard/refunds/view/screens/owner_refund_history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
import '../../../../../../common/utils/constants/firestore.dart';
import '../../../../../../common/widgets/pagination/paginated_list_view.dart';
import '../../../../../../common/widgets/pagination/firestore_pagination_helper.dart';
import '../../../../../../common/widgets/pagination/pagination_controller.dart';
import '../../../../../../core/di/firebase/di/firebase_service_locator.dart';
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
  PaginationController<RefundRequestModel>? _paginationController;
  String _selectedStatusFilter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerRefundViewModel>().initialize();
      _initializePagination();
    });
  }

  @override
  void dispose() {
    _paginationController?.dispose();
    super.dispose();
  }

  /// Initialize pagination controller for refund requests
  void _initializePagination() {
    final ownerId = getIt.auth.currentUserId;
    if (ownerId == null || ownerId.isEmpty) return;

    _updatePaginationController(ownerId);
  }

  /// Update pagination controller based on selected filter
  void _updatePaginationController(String ownerId, [String? statusFilter]) {
    final filter = statusFilter ?? _selectedStatusFilter;
    _paginationController?.dispose();

    Query baseQuery = FirebaseFirestore.instance
        .collection(FirestoreConstants.refundRequests)
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('requestedAt', descending: true);

    // Apply status filter if not 'all'
    if (filter != 'all') {
      baseQuery = baseQuery.where('status', isEqualTo: filter);
    }

    _paginationController = FirestorePaginationHelper.createController<RefundRequestModel>(
      query: baseQuery,
      documentMapper: (doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Ensure refundRequestId is set from document ID
        if (data['refundRequestId'] == null || (data['refundRequestId'] as String).isEmpty) {
          data['refundRequestId'] = doc.id;
        }
        return RefundRequestModel.fromMap(data);
      },
      pageSize: 20,
    );

    // Load initial page
    _paginationController?.loadInitial();
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
            onRefresh: () async {
              await viewModel.refresh();
              await _paginationController?.refresh();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Request new refund button
                Padding(
                  padding: ResponsiveSystem.getResponsivePadding(context).copyWith(bottom: AppSpacing.paddingM),
                  child: PrimaryButton(
                    onPressed: () {
                      context.go(AppRoutes.ownerRefundRequest);
                    },
                    label: 'Request New Refund',
                  ),
                ),

                // Filters
                Padding(
                  padding: ResponsiveSystem.getResponsivePadding(context).copyWith(bottom: AppSpacing.paddingM),
                  child: _buildFilters(context, viewModel),
                ),

                // Refund requests list
                Expanded(
                  child: Padding(
                    padding: ResponsiveSystem.getResponsivePadding(context),
                    child: _buildRefundRequestsList(context, viewModel),
                  ),
                ),
              ],
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
                _buildFilterChip(context, 'all', 'All'),
                _buildFilterChip(context, 'pending', 'Pending'),
                _buildFilterChip(context, 'approved', 'Approved'),
                _buildFilterChip(context, 'rejected', 'Rejected'),
                _buildFilterChip(context, 'completed', 'Completed'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String value, String label) {
    final isSelected = _selectedStatusFilter == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatusFilter = value;
        });
        final ownerId = getIt.auth.currentUserId;
        if (ownerId != null && ownerId.isNotEmpty) {
          _updatePaginationController(ownerId, value);
        }
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildRefundRequestsList(
      BuildContext context, OwnerRefundViewModel viewModel) {
    // Use pagination controller if available
    if (_paginationController != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<PaginationController<RefundRequestModel>>(
            builder: (context, controller, child) {
              return HeadingMedium(text: 'Refund Requests (${controller.items.length})');
            },
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _paginationController!.refresh(),
              child: PaginatedListView<RefundRequestModel>(
                controller: _paginationController!,
                itemBuilder: (context, refund, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
                    child: _buildRefundRequestCard(context, refund),
                  );
                },
                emptyWidget: AdaptiveCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.paddingL),
                    child: Center(
                      child: EmptyStates.noData(
                        context: context,
                        title: 'No Refund Requests',
                        message: _selectedStatusFilter == 'all'
                            ? 'You haven\'t requested any refunds yet.'
                            : 'No refund requests match the selected filter.',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Fallback to ViewModel implementation
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

