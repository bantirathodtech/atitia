// lib/features/guest_dashboard/payments/view/screens/guest_payment_detail_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/helpers/image_picker_helper.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../core/repositories/owner_payment_details_repository.dart';
import '../../../../../core/services/payment/razorpay_service.dart';
import '../../../../../core/viewmodels/payment_notification_viewmodel.dart';
import '../../../../../feature/auth/logic/auth_provider.dart';
import '../../data/models/guest_payment_model.dart';
import '../../viewmodel/guest_payment_viewmodel.dart';
import '../../view/widgets/payment_method_selection_dialog.dart';

/// Screen displaying detailed information for a specific payment
/// Shows comprehensive payment details, status, and actions
class GuestPaymentDetailScreen extends StatefulWidget {
  final String paymentId;

  const GuestPaymentDetailScreen({
    super.key,
    required this.paymentId,
  });

  @override
  State<GuestPaymentDetailScreen> createState() =>
      _GuestPaymentDetailScreenState();
}

class _GuestPaymentDetailScreenState extends State<GuestPaymentDetailScreen> {
  GuestPaymentModel? _payment;
  bool _isLoading = true;
  String? _error;
  bool _processingPayment = false;
  bool _razorpayEnabled = false;
  final _razorpayService = RazorpayService();
  final _ownerPaymentRepo = OwnerPaymentDetailsRepository();

  @override
  void initState() {
    super.initState();
    _loadPaymentDetails();
    _loadOwnerPaymentDetails();
    _razorpayService.initialize();
  }

  @override
  void dispose() {
    _razorpayService.dispose();
    super.dispose();
  }

  /// Load owner payment details to check if Razorpay is enabled
  Future<void> _loadOwnerPaymentDetails() async {
    if (_payment == null || _payment!.ownerId.isEmpty) {
      return;
    }

    try {
      final details = await _ownerPaymentRepo.getPaymentDetails(_payment!.ownerId);
      if (mounted) {
        setState(() {
          _razorpayEnabled = details?.razorpayEnabled ?? false;
        });
      }
    } catch (e) {
      // Silently fail - Razorpay will just be disabled
      if (mounted) {
        setState(() {
          _razorpayEnabled = false;
        });
      }
    }
  }

  Future<void> _loadPaymentDetails() async {
    try {
      final paymentVM =
          Provider.of<GuestPaymentViewModel>(context, listen: false);
      final payment = await paymentVM.getPaymentById(widget.paymentId);

      if (mounted) {
        setState(() {
          _payment = payment;
          _isLoading = false;
          _error = payment == null ? 'Payment not found' : null;
        });
        // Load owner payment details after payment is loaded
        if (payment != null) {
          _loadOwnerPaymentDetails();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load payment details: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Payment Details',
        showBackButton: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return Center(child: AdaptiveLoader());
    }

    if (_error != null || _payment == null) {
      return Center(
        child: EmptyState(
          title: 'Payment Not Found',
          message: _error ?? 'The requested payment could not be found.',
          icon: Icons.error_outline,
          actionLabel: 'Go Back',
          onAction: () => Navigator.of(context).pop(),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPaymentHeader(context),
          const SizedBox(height: AppSpacing.paddingL),
          _buildPaymentInfo(context),
          const SizedBox(height: AppSpacing.paddingL),
          _buildPaymentTimeline(context),
          if (_payment!.metadata != null && _payment!.metadata!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.paddingL),
            _buildMetadataSection(context),
          ],
          const SizedBox(height: AppSpacing.paddingL),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildPaymentHeader(BuildContext context) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingM),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
                child: Text(
                  _payment!.paymentTypeIcon,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingMedium(
                      text: _payment!.paymentType,
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                    CaptionText(
                      text: 'Payment #${_payment!.paymentId.substring(0, 8)}',
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingM,
                  vertical: AppSpacing.paddingS,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
                child: Text(
                  _payment!.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                _payment!.formattedAmount,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentInfo(BuildContext context) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: 'Payment Information',
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildInfoRow(context, 'Description', _payment!.description),
          _buildInfoRow(context, 'Payment Method', _payment!.paymentMethod),
          _buildInfoRow(context, 'Due Date', _formatDate(_payment!.dueDate)),
          _buildInfoRow(
              context, 'Payment Date', _formatDate(_payment!.paymentDate)),
          if (_payment!.transactionId != null)
            _buildInfoRow(context, 'Transaction ID', _payment!.transactionId!),
          if (_payment!.upiReferenceId != null)
            _buildInfoRow(context, 'UPI Reference', _payment!.upiReferenceId!),
          _buildInfoRow(context, 'PG ID', _payment!.pgId),
          _buildInfoRow(context, 'Owner ID', _payment!.ownerId),
        ],
      ),
    );
  }

  Widget _buildPaymentTimeline(BuildContext context) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: 'Timeline',
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildTimelineItem(
            context,
            'Created',
            _formatDateTime(_payment!.createdAt ?? _payment!.paymentDate),
            Icons.add_circle_outline,
            Colors.blue,
          ),
          if (_payment!.status == 'Paid') ...[
            const SizedBox(height: AppSpacing.paddingS),
            _buildTimelineItem(
              context,
              'Paid',
              _formatDateTime(_payment!.updatedAt ?? _payment!.paymentDate),
              Icons.check_circle_outline,
              Colors.green,
            ),
          ],
          if (_payment!.status == 'Failed') ...[
            const SizedBox(height: AppSpacing.paddingS),
            _buildTimelineItem(
              context,
              'Failed',
              _formatDateTime(_payment!.updatedAt ?? _payment!.paymentDate),
              Icons.error_outline,
              Colors.red,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetadataSection(BuildContext context) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: 'Additional Information',
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          ..._payment!.metadata!.entries.map((entry) =>
              _buildInfoRow(context, entry.key, entry.value.toString())),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: BodyText(
              text: label,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: BodyText(
              text: value,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String title, String date,
      IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSpacing.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText(
                text: title,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              CaptionText(
                text: date,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (_payment!.status == 'Pending') ...[
          PrimaryButton(
            onPressed: _processingPayment ? null : () => _processPayment(context),
            label: _processingPayment ? 'Processing...' : 'Pay Now',
            icon: _processingPayment ? null : Icons.payment,
            width: double.infinity,
          ),
          const SizedBox(height: AppSpacing.paddingM),
        ],
        SecondaryButton(
          onPressed: () => Navigator.of(context).pop(),
          label: 'Back to Payments',
          icon: Icons.arrow_back,
          width: double.infinity,
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (_payment!.status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return _payment!.isOverdue ? Colors.red : Colors.orange;
      case 'failed':
        return Colors.red;
      case 'refunded':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy • hh:mm a').format(date);
  }

  void _processPayment(BuildContext context) async {
    // Show payment method selection dialog
    final paymentMethod = await PaymentMethodSelectionDialog.show(
      context,
      razorpayEnabled: _razorpayEnabled,
    );

    if (paymentMethod == null) {
      return;
    }

    // Process payment based on selected method
    switch (paymentMethod) {
      case PaymentMethodType.razorpay:
        await _processRazorpayPayment(context);
        break;
      case PaymentMethodType.upi:
        await _processUPIPayment(context);
        break;
      case PaymentMethodType.cash:
        await _processCashPayment(context);
        break;
    }
  }

  /// Process Razorpay payment
  Future<void> _processRazorpayPayment(BuildContext context) async {
    if (_payment == null || _payment!.ownerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid payment or owner information not available.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _processingPayment = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final amount = _payment!.amount;
      final orderId = 'order_${_payment!.paymentId}_${DateTime.now().millisecondsSinceEpoch}';

      // Open Razorpay payment
      await _razorpayService.openPayment(
        amount: (amount * 100).toInt(), // Convert to paise
        orderId: orderId,
        ownerId: _payment!.ownerId,
        description: _payment!.description,
        userName: authProvider.user?.fullName ?? 'Guest',
        userEmail: authProvider.user?.email,
        userPhone: authProvider.user?.phoneNumber,
        onSuccess: (orderId, response) async {
      // Payment successful - update payment with Razorpay details
      final paymentVM = context.read<GuestPaymentViewModel>();
      final updatedPayment = _payment!.copyWith(
        status: 'Paid',
        transactionId: response.paymentId,
        razorpayOrderId: orderId,
        razorpayPaymentId: response.paymentId,
        paymentMethod: 'razorpay',
        updatedAt: DateTime.now(),
      );
      await paymentVM.updatePayment(updatedPayment);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment successful!'),
                backgroundColor: AppColors.success,
              ),
            );
            // Refresh payment details
            await _loadPaymentDetails();
          }
        },
        onFailure: (response) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Payment failed: ${response.message}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process payment: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _processingPayment = false);
      }
    }
  }

  /// Process UPI payment (requires screenshot)
  Future<void> _processUPIPayment(BuildContext context) async {
    // Show dialog to upload screenshot and optionally enter transaction ID
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => _UPIPaymentDialog(
        payment: _payment!,
        onConfirm: (screenshot, transactionId) {
          Navigator.of(context).pop({
            'screenshot': screenshot,
            'transactionId': transactionId,
          });
        },
      ),
    );

    if (result == null) {
      return;
    }

    setState(() => _processingPayment = true);

    try {
      final paymentVM = context.read<GuestPaymentViewModel>();
      final paymentNotificationVM = context.read<PaymentNotificationViewModel>();
      final authProvider = context.read<AuthProvider>();
      final screenshot = result['screenshot'];
      final transactionId = result['transactionId'] as String?;

      // Send payment notification to owner (handles screenshot upload internally)
      await paymentNotificationVM.sendPaymentNotification(
        guestId: authProvider.user!.userId,
        ownerId: _payment!.ownerId,
        pgId: _payment!.pgId,
        bookingId: _payment!.bookingId,
        amount: _payment!.amount,
        paymentMethod: 'upi',
        transactionId: transactionId,
        paymentScreenshot: screenshot,
        paymentNote: 'UPI payment made. Please verify and confirm.',
      );

      // Update payment status as "Confirmed" (pending owner verification)
      // Screenshot URL will be updated by the notification system
      final updatedPayment = _payment!.copyWith(
        status: 'Confirmed', // UPI payments need owner confirmation
        transactionId: transactionId,
        paymentMethod: 'upi',
        updatedAt: DateTime.now(),
      );
      await paymentVM.updatePayment(updatedPayment);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('UPI payment notification sent. Owner will verify and confirm.'),
            backgroundColor: AppColors.success,
          ),
        );
        await _loadPaymentDetails();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process UPI payment: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _processingPayment = false);
      }
    }
  }

  /// Process Cash payment
  Future<void> _processCashPayment(BuildContext context) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const HeadingMedium(text: 'Cash Payment Confirmation'),
        content: const BodyText(
          text: 'Have you paid the amount in cash to the owner? Owner will confirm once they receive the payment.',
        ),
        actions: [
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(false),
            label: 'Cancel',
          ),
          PrimaryButton(
            onPressed: () => Navigator.of(context).pop(true),
            label: 'Yes, Paid',
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    setState(() => _processingPayment = true);

    try {
      final paymentVM = context.read<GuestPaymentViewModel>();
      final paymentNotificationVM = context.read<PaymentNotificationViewModel>();
      final authProvider = context.read<AuthProvider>();

      // Send cash payment notification to owner
      await paymentNotificationVM.sendPaymentNotification(
        guestId: authProvider.user!.userId,
        ownerId: _payment!.ownerId,
        pgId: _payment!.pgId,
        bookingId: _payment!.bookingId,
        amount: _payment!.amount,
        paymentMethod: 'cash',
        paymentNote: 'Cash payment made. Please confirm.',
      );

      // Update payment status as "Confirmed" (pending owner confirmation)
      final updatedPayment = _payment!.copyWith(
        status: 'Confirmed', // Cash payments need owner confirmation
        paymentMethod: 'cash',
        updatedAt: DateTime.now(),
      );
      await paymentVM.updatePayment(updatedPayment);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cash payment notification sent. Owner will confirm once they receive the payment.'),
            backgroundColor: AppColors.success,
          ),
        );
        await _loadPaymentDetails();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process cash payment: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _processingPayment = false);
      }
    }
  }
}

/// UPI Payment Dialog Widget
class _UPIPaymentDialog extends StatefulWidget {
  final GuestPaymentModel payment;
  final Function(dynamic screenshot, String? transactionId) onConfirm;

  const _UPIPaymentDialog({
    required this.payment,
    required this.onConfirm,
  });

  @override
  State<_UPIPaymentDialog> createState() => _UPIPaymentDialogState();
}

class _UPIPaymentDialogState extends State<_UPIPaymentDialog> {
  dynamic _screenshotFile;
  final _transactionIdController = TextEditingController();
  bool _uploading = false;

  @override
  void dispose() {
    _transactionIdController.dispose();
    super.dispose();
  }

  Future<void> _pickScreenshot() async {
    try {
      setState(() => _uploading = true);
      final file = await ImagePickerHelper.pickImageFromGallery();
      if (file != null && mounted) {
        setState(() {
          _screenshotFile = file;
          _uploading = false;
        });
      } else {
        if (mounted) {
          setState(() => _uploading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _uploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const HeadingMedium(text: 'UPI Payment'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BodyText(
              text: 'Amount: ${widget.payment.formattedAmount}',
              medium: true,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text: 'Upload Payment Screenshot',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            if (_screenshotFile != null) ...[
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.outline),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                  child: Image.file(
                    _screenshotFile is String ? File(_screenshotFile) : _screenshotFile,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingS),
              TextButton.icon(
                onPressed: _pickScreenshot,
                icon: const Icon(Icons.refresh),
                label: const Text('Change Screenshot'),
              ),
            ] else ...[
              PrimaryButton(
                onPressed: _uploading ? null : _pickScreenshot,
                label: _uploading ? 'Uploading...' : 'Upload Screenshot',
                icon: Icons.upload_file,
                width: double.infinity,
              ),
            ],
            const SizedBox(height: AppSpacing.paddingM),
            TextField(
              controller: _transactionIdController,
              decoration: const InputDecoration(
                labelText: 'Transaction ID (Optional)',
                hintText: 'Transaction ID is visible in screenshot',
                border: OutlineInputBorder(),
                helperText: 'You can skip this - transaction ID is in the screenshot',
              ),
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: '💡 Tip: After making payment via PhonePe, Paytm, Google Pay, etc., upload the payment screenshot. The transaction ID is already visible in the screenshot.',
              color: AppColors.textSecondary,
              small: true,
            ),
          ],
        ),
      ),
      actions: [
        SecondaryButton(
          onPressed: () => Navigator.of(context).pop(),
          label: 'Cancel',
        ),
        PrimaryButton(
          onPressed: _screenshotFile == null
              ? null
              : () {
                  widget.onConfirm(
                    _screenshotFile,
                    _transactionIdController.text.isEmpty
                        ? null
                        : _transactionIdController.text,
                  );
                },
          label: 'Confirm',
        ),
      ],
    );
  }
}
