// lib/feature/owner_dashboard/refunds/view/screens/owner_refund_request_screen.dart

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
import '../../../../../../core/models/refund/refund_request_model.dart';
import '../../../../../../core/models/revenue/revenue_record_model.dart';
import '../../viewmodel/owner_refund_viewmodel.dart';
import '../../../shared/widgets/owner_drawer.dart';

/// Owner Refund Request Screen
/// Allows owners to request refunds for subscriptions or featured listings
class OwnerRefundRequestScreen extends StatefulWidget {
  final String? revenueRecordId;
  final RefundType? refundType;
  final String? subscriptionId;
  final String? featuredListingId;

  const OwnerRefundRequestScreen({
    super.key,
    this.revenueRecordId,
    this.refundType,
    this.subscriptionId,
    this.featuredListingId,
  });

  @override
  State<OwnerRefundRequestScreen> createState() =>
      _OwnerRefundRequestScreenState();
}

class _OwnerRefundRequestScreenState
    extends State<OwnerRefundRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  String? _selectedRevenueRecordId;
  RefundType? _selectedRefundType;
  RevenueRecordModel? _selectedRevenueRecord;

  @override
  void initState() {
    super.initState();
    _selectedRevenueRecordId = widget.revenueRecordId;
    _selectedRefundType = widget.refundType;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerRefundViewModel>().initialize();
    });
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Request Refund',
        showDrawer: true,
        showBackButton: false,
      ),
      drawer: const OwnerDrawer(),
      body: Consumer<OwnerRefundViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.loading && viewModel.refundableRevenueRecords.isEmpty) {
            return const EnhancedLoadingState(type: LoadingType.centered);
          }

          if (viewModel.error) {
            return Center(
              child: EmptyStates.error(
                context: context,
                message: viewModel.errorMessage ?? 'Failed to load refund data',
                onRetry: () => viewModel.refresh(),
              ),
            );
          }

          return SingleChildScrollView(
            padding: ResponsiveSystem.getResponsivePadding(context),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instructions
                  _buildInstructions(context),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Select refund type if not pre-selected
                  if (_selectedRefundType == null)
                    _buildRefundTypeSelector(context, viewModel),

                  // Select revenue record
                  _buildRevenueRecordSelector(context, viewModel),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Refund details
                  if (_selectedRevenueRecord != null)
                    _buildRefundDetails(context, viewModel),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Reason field
                  _buildReasonField(context),
                  const SizedBox(height: AppSpacing.paddingL),

                  // Submit button
                  _buildSubmitButton(context, viewModel),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info),
                const SizedBox(width: AppSpacing.paddingS),
                HeadingMedium(text: 'Refund Request'),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text:
                  'You can request a refund for subscriptions or featured listings purchased within the last 30 days. Please provide a reason for your refund request. Admin will review and process your request.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefundTypeSelector(
      BuildContext context, OwnerRefundViewModel viewModel) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Select Refund Type'),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<RefundType>(
                    title: const Text('Subscription'),
                    value: RefundType.subscription,
                    groupValue: _selectedRefundType,
                    onChanged: (value) {
                      setState(() {
                        _selectedRefundType = value;
                        _selectedRevenueRecordId = null;
                        _selectedRevenueRecord = null;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<RefundType>(
                    title: const Text('Featured Listing'),
                    value: RefundType.featuredListing,
                    groupValue: _selectedRefundType,
                    onChanged: (value) {
                      setState(() {
                        _selectedRefundType = value;
                        _selectedRevenueRecordId = null;
                        _selectedRevenueRecord = null;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueRecordSelector(
      BuildContext context, OwnerRefundViewModel viewModel) {
    if (_selectedRefundType == null) {
      return const SizedBox.shrink();
    }

    final refundableRecords = viewModel.refundableRevenueRecords
        .where((r) {
          if (_selectedRefundType == RefundType.subscription) {
            return r.type == RevenueType.subscription &&
                r.subscriptionId != null;
          } else {
            return r.type == RevenueType.featuredListing &&
                r.featuredListingId != null;
          }
        })
        .toList();

    if (refundableRecords.isEmpty) {
      return AdaptiveCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.paddingL),
          child: Center(
            child: EmptyStates.noData(
              context: context,
              title: 'No Refundable Items',
              message:
                  'You don\'t have any ${_selectedRefundType?.displayName.toLowerCase() ?? ''} payments that are eligible for refund.',
            ),
          ),
        ),
      );
    }

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Select Payment'),
            const SizedBox(height: AppSpacing.paddingM),
            ...refundableRecords.map((record) => _buildRevenueRecordOption(
                  context,
                  record,
                  viewModel,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueRecordOption(BuildContext context,
      RevenueRecordModel record, OwnerRefundViewModel viewModel) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('MMM dd, yyyy');

    final isSelected = _selectedRevenueRecordId == record.revenueId;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRevenueRecordId = record.revenueId;
          _selectedRevenueRecord = record;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.paddingS),
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: record.type.displayName,
                  ),
                  CaptionText(
                    text: dateFormatter.format(record.paymentDate),
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
            HeadingMedium(
              text: currencyFormatter.format(record.amount),
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRefundDetails(
      BuildContext context, OwnerRefundViewModel viewModel) {
    if (_selectedRevenueRecord == null) return const SizedBox.shrink();

    final currencyFormatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Refund Details'),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BodyText(text: 'Refund Amount:'),
                HeadingMedium(
                  text: currencyFormatter.format(_selectedRevenueRecord!.amount),
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonField(BuildContext context) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(text: 'Reason for Refund *'),
            const SizedBox(height: AppSpacing.paddingM),
            TextFormField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: 'Please explain why you need a refund',
                hintText: 'Enter your reason...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please provide a reason for the refund request';
                }
                if (value.trim().length < 10) {
                  return 'Please provide a more detailed reason (at least 10 characters)';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton(
      BuildContext context, OwnerRefundViewModel viewModel) {
    final canSubmit = _selectedRevenueRecord != null &&
        _reasonController.text.trim().isNotEmpty &&
        _selectedRefundType != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingM),
      child: PrimaryButton(
        onPressed: canSubmit && !viewModel.loading
            ? () => _submitRefundRequest(context, viewModel)
            : null,
        label: viewModel.loading ? 'Submitting...' : 'Submit Refund Request',
      ),
    );
  }

  Future<void> _submitRefundRequest(
      BuildContext context, OwnerRefundViewModel viewModel) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRevenueRecord == null || _selectedRefundType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment to refund'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Check if refund request already exists
    final hasExisting =
        await viewModel.hasExistingRefundRequest(_selectedRevenueRecord!.revenueId);
    if (hasExisting) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'A refund request already exists for this payment. Please wait for admin review.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    try {
      await viewModel.createRefundRequest(
        type: _selectedRefundType!,
        revenueRecordId: _selectedRevenueRecord!.revenueId,
        amount: _selectedRevenueRecord!.amount,
        reason: _reasonController.text.trim(),
        subscriptionId: _selectedRevenueRecord!.subscriptionId,
        featuredListingId: _selectedRevenueRecord!.featuredListingId,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Refund request submitted successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit refund request: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

