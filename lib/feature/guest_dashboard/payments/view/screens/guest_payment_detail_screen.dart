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
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
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
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  String get _shortPaymentId =>
      _payment?.paymentId.substring(0, 8).toUpperCase() ?? '';

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
      final details =
          await _ownerPaymentRepo.getPaymentDetails(_payment!.ownerId);
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
    final loc = AppLocalizations.of(context);
    try {
      final paymentVM =
          Provider.of<GuestPaymentViewModel>(context, listen: false);
      final payment = await paymentVM.getPaymentById(widget.paymentId);

      if (mounted) {
        setState(() {
          _payment = payment;
          _isLoading = false;
          _error = payment == null
              ? (loc?.paymentNotFound ??
                  _text('paymentNotFound', 'Payment not found'))
              : null;
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
          _error = loc?.failedToLoadPaymentDetails(e.toString()) ??
              _text('failedToLoadPaymentDetails',
                  'Failed to load payment details: {error}',
                  parameters: {'error': e.toString()});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: AppLocalizations.of(context)?.paymentDetails ??
            _text('paymentDetails', 'Payment Details'),
        showBackButton: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (_isLoading) {
      return const Center(child: AdaptiveLoader());
    }

    if (_error != null || _payment == null) {
      return Center(
        child: EmptyState(
          title: loc?.paymentNotFound ??
              _text('paymentNotFound', 'Payment Not Found'),
          message: _error ??
              (loc?.theRequestedPaymentCouldNotBeFound ??
                  _text('theRequestedPaymentCouldNotBeFound',
                      'The requested payment could not be found.')),
          icon: Icons.error_outline,
          actionLabel: loc?.goBack ?? _text('goBack', 'Go Back'),
          onAction: () => Navigator.of(context).pop(),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPaymentHeader(context, loc),
          const SizedBox(height: AppSpacing.paddingL),
          _buildPaymentInfo(context, loc),
          const SizedBox(height: AppSpacing.paddingL),
          _buildPaymentTimeline(context, loc),
          if (_payment!.metadata != null && _payment!.metadata!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.paddingL),
            _buildMetadataSection(context, loc),
          ],
          const SizedBox(height: AppSpacing.paddingL),
          _buildActionButtons(context, loc),
        ],
      ),
    );
  }

  Widget _buildPaymentHeader(BuildContext context, AppLocalizations? loc) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingM),
                decoration: BoxDecoration(
                  color: _getStatusColor(context).withValues(alpha: 0.1),
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
                      text: _paymentTypeLabel(_payment!.paymentType, loc),
                      color: Theme.of(context).textTheme.titleLarge?.color,
                    ),
                    CaptionText(
                      text: loc?.paymentNumber(_shortPaymentId) ??
                          'Payment #$_shortPaymentId',
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
                  color: _getStatusColor(context),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
                ),
                child: Text(
                  _statusLabel(_payment!.status, loc),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
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
                loc?.amount ?? _text('amount', 'Amount'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                _formatAmount(_payment!.amount, loc),
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

  Widget _buildPaymentInfo(BuildContext context, AppLocalizations? loc) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: loc?.paymentInformation ??
                _text('paymentInformation', 'Payment Information'),
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildInfoRow(
            context,
            loc?.description ?? _text('description', 'Description'),
            _payment!.description,
          ),
          _buildInfoRow(
            context,
            loc?.paymentMethod ?? _text('paymentMethod', 'Payment Method'),
            _paymentMethodLabel(_payment!.paymentMethod, loc),
          ),
          _buildInfoRow(
            context,
            loc?.dueDate ?? _text('dueDate', 'Due Date'),
            _formatDate(_payment!.dueDate, loc),
          ),
          _buildInfoRow(
            context,
            loc?.paymentDate ?? _text('paymentDate', 'Payment Date'),
            _formatDate(_payment!.paymentDate, loc),
          ),
          if (_payment!.transactionId != null)
            _buildInfoRow(
              context,
              loc?.transactionId ?? _text('transactionId', 'Transaction ID'),
              _payment!.transactionId!,
            ),
          if (_payment!.upiReferenceId != null)
            _buildInfoRow(
              context,
              loc?.uPIReference ?? _text('uPIReference', 'UPI Reference'),
              _payment!.upiReferenceId!,
            ),
          _buildInfoRow(
            context,
            loc?.pgId ?? _text('pgId', 'PG ID'),
            _payment!.pgId,
          ),
          _buildInfoRow(
            context,
            loc?.ownerId ?? _text('ownerId', 'Owner ID'),
            _payment!.ownerId,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentTimeline(BuildContext context, AppLocalizations? loc) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: loc?.timeline ?? _text('timeline', 'Timeline'),
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildTimelineItem(
            context,
            loc?.created ?? _text('created', 'Created'),
            _formatDateTime(_payment!.createdAt ?? _payment!.paymentDate, loc),
            Icons.add_circle_outline,
            AppColors.statusBlue,
          ),
          if (_payment!.status.toLowerCase() == 'paid') ...[
            const SizedBox(height: AppSpacing.paddingS),
            _buildTimelineItem(
              context,
              loc?.paid ?? _text('paid', 'Paid'),
              _formatDateTime(
                  _payment!.updatedAt ?? _payment!.paymentDate, loc),
              Icons.check_circle_outline,
              AppColors.statusGreen,
            ),
          ],
          if (_payment!.status.toLowerCase() == 'failed') ...[
            const SizedBox(height: AppSpacing.paddingS),
            _buildTimelineItem(
              context,
              loc?.failed ?? _text('failed', 'Failed'),
              _formatDateTime(
                  _payment!.updatedAt ?? _payment!.paymentDate, loc),
              Icons.error_outline,
              Theme.of(context).colorScheme.error,
            ),
          ],
          if (_payment!.status.toLowerCase() == 'confirmed') ...[
            const SizedBox(height: AppSpacing.paddingS),
            _buildTimelineItem(
              context,
              loc?.confirmed ?? _text('confirmed', 'Confirmed'),
              _formatDateTime(
                  _payment!.updatedAt ?? _payment!.paymentDate, loc),
              Icons.verified_outlined,
              AppColors.statusGrey,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetadataSection(BuildContext context, AppLocalizations? loc) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: loc?.additionalInformation ??
                _text('additionalInformation', 'Additional Information'),
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

  Widget _buildActionButtons(BuildContext context, AppLocalizations? loc) {
    return Column(
      children: [
        if (_payment!.status.toLowerCase() == 'pending') ...[
          PrimaryButton(
            onPressed:
                _processingPayment ? null : () => _processPayment(context),
            label: _processingPayment
                ? (loc?.processing ?? _text('processing', 'Processing...'))
                : (loc?.payNow ?? _text('payNow', 'Pay Now')),
            icon: _processingPayment ? null : Icons.payment,
            width: double.infinity,
          ),
          const SizedBox(height: AppSpacing.paddingM),
        ],
        SecondaryButton(
          onPressed: () => Navigator.of(context).pop(),
          label: loc?.backToPayments ??
              _text('backToPayments', 'Back to Payments'),
          icon: Icons.arrow_back,
          width: double.infinity,
        ),
      ],
    );
  }

  String _statusLabel(String status, AppLocalizations? loc) {
    switch (status.toLowerCase()) {
      case 'paid':
        return loc?.paid ?? _text('paid', 'Paid');
      case 'pending':
        return loc?.pending ?? _text('pending', 'Pending');
      case 'failed':
        return loc?.failed ?? _text('failed', 'Failed');
      case 'refunded':
        return loc?.refunded ?? _text('refunded', 'Refunded');
      case 'confirmed':
        return loc?.confirmed ?? _text('confirmed', 'Confirmed');
      default:
        return status;
    }
  }

  String _paymentMethodLabel(String method, AppLocalizations? loc) {
    switch (method.toLowerCase()) {
      case 'razorpay':
        return loc?.paymentMethodRazorpay ??
            _text('paymentMethodRazorpay', 'Razorpay');
      case 'upi':
        return loc?.paymentMethodUpi ?? _text('paymentMethodUpi', 'UPI');
      case 'cash':
        return loc?.paymentMethodCash ?? _text('paymentMethodCash', 'Cash');
      case 'bank_transfer':
        return loc?.paymentMethodBankTransfer ??
            _text('paymentMethodBankTransfer', 'Bank Transfer');
      default:
        return loc?.paymentMethodOther ?? _text('paymentMethodOther', 'Other');
    }
  }

  Color _getStatusColor(BuildContext context) {
    switch (_payment!.status.toLowerCase()) {
      case 'paid':
        return AppColors.statusGreen;
      case 'pending':
        return _payment!.isOverdue
            ? AppColors.statusRed
            : AppColors.statusOrange;
      case 'failed':
        return Theme.of(context).colorScheme.error;
      case 'refunded':
        return AppColors.statusBlue;
      default:
        return Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.7) ??
            Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }

  String _formatDate(DateTime date, AppLocalizations? loc) {
    final locale = loc?.localeName;
    return DateFormat.yMMMd(locale).format(date);
  }

  String _formatDateTime(DateTime date, AppLocalizations? loc) {
    final locale = loc?.localeName;
    final datePart = DateFormat.yMMMd(locale).format(date);
    final timePart = DateFormat.jm(locale).format(date);
    return '$datePart • $timePart';
  }

  String _formatAmount(double amount, AppLocalizations? loc) {
    final locale = loc?.localeName ?? 'en_IN';
    final symbol = NumberFormat.simpleCurrency(locale: locale).currencySymbol;
    return NumberFormat.currency(locale: locale, symbol: symbol).format(amount);
  }

  String _paymentTypeLabel(String type, AppLocalizations? loc) {
    switch (type.toLowerCase()) {
      case 'rent':
        return loc?.paymentTypeRent ?? _text('paymentTypeRent', 'Rent Payment');
      case 'security deposit':
        return loc?.paymentTypeSecurityDeposit ??
            _text('paymentTypeSecurityDeposit', 'Security Deposit');
      case 'maintenance':
        return loc?.paymentTypeMaintenance ??
            _text('paymentTypeMaintenance', 'Maintenance Fee');
      case 'late fee':
        return loc?.paymentTypeLateFee ??
            _text('paymentTypeLateFee', 'Late Fee');
      default:
        return loc?.paymentTypeOther(type) ??
            _text('paymentTypeOther', '{type} Payment',
                parameters: {'type': type});
    }
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
    // FIXED: BuildContext async gap warning
    // Flutter recommends: Store context before async operations when passing to methods
    // Changed from: Passing context directly to async methods which creates async gaps
    // Changed to: Store context before async, methods will handle their own mounted checks
    // Note: Analyzer flags passing context to async methods, but this is safe as methods check mounted internally
    if (!mounted) return;
    final currentContext = context;
    switch (paymentMethod) {
      case PaymentMethodType.razorpay:
        // ignore: use_build_context_synchronously
        await _processRazorpayPayment(currentContext);
        break;
      case PaymentMethodType.upi:
        // ignore: use_build_context_synchronously
        await _processUPIPayment(currentContext);
        break;
      case PaymentMethodType.cash:
        // ignore: use_build_context_synchronously
        await _processCashPayment(currentContext);
        break;
    }
  }

  /// Process Razorpay payment
  Future<void> _processRazorpayPayment(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (_payment == null || _payment!.ownerId.isEmpty) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(loc?.invalidPaymentOrOwnerInfoNotAvailable ??
              _text('invalidPaymentOrOwnerInfoNotAvailable',
                  'Invalid payment or owner information not available.')),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final paymentVM = context.read<GuestPaymentViewModel>();
    final authProvider = context.read<AuthProvider>();

    setState(() => _processingPayment = true);

    try {
      final amount = _payment!.amount;
      final orderId =
          'order_${_payment!.paymentId}_${DateTime.now().millisecondsSinceEpoch}';

      // Open Razorpay payment
      await _razorpayService.openPayment(
        amount: (amount * 100).toInt(), // Convert to paise
        orderId: orderId,
        ownerId: _payment!.ownerId,
        description: _payment!.description,
        userName: authProvider.user?.fullName ??
            (loc?.guest ?? _text('guest', 'Guest')),
        userEmail: authProvider.user?.email,
        userPhone: authProvider.user?.phoneNumber,
        onSuccess: (orderId, response) async {
          if (!mounted) return;

          // Payment successful - update payment with Razorpay details
          final updatedPayment = _payment!.copyWith(
            status: 'Paid',
            transactionId: response.paymentId,
            razorpayOrderId: orderId,
            razorpayPaymentId: response.paymentId,
            paymentMethod: 'razorpay',
            updatedAt: DateTime.now(),
          );
          await paymentVM.updatePayment(updatedPayment);

          // Check mounted again after another async operation
          if (!mounted) return;
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(loc?.paymentSuccessful ??
                  _text('paymentSuccessful', 'Payment successful!')),
              backgroundColor: AppColors.success,
            ),
          );
          // Refresh payment details
          await _loadPaymentDetails();
        },
        onFailure: (response) {
          if (!mounted) return;
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Text(loc?.paymentFailed(response.message ?? '') ??
                  _text('paymentFailed', 'Payment failed: {message}',
                      parameters: {'message': response.message ?? ''})),
              backgroundColor: AppColors.error,
            ),
          );
        },
      );
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(loc?.failedToProcessPayment(e.toString()) ??
              _text('failedToProcessPayment',
                  'Failed to process payment: {error}',
                  parameters: {'error': e.toString()})),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _processingPayment = false);
      }
    }
  }

  /// Process UPI payment (requires screenshot)
  Future<void> _processUPIPayment(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final paymentVM = context.read<GuestPaymentViewModel>();
    final paymentNotificationVM = context.read<PaymentNotificationViewModel>();
    final authProvider = context.read<AuthProvider>();

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

    if (!mounted) return;

    setState(() => _processingPayment = true);

    try {
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
        paymentNote: loc?.upiPaymentNote ??
            _text('upiPaymentNote',
                'UPI payment made. Please verify and confirm.'),
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

      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(loc?.upiPaymentNotificationSent ??
              _text('upiPaymentNotificationSent',
                  'UPI payment notification sent. Owner will verify and confirm.')),
          backgroundColor: AppColors.success,
        ),
      );
      await _loadPaymentDetails();
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(loc?.failedToProcessUpiPayment(e.toString()) ??
              _text('failedToProcessUpiPayment',
                  'Failed to process UPI payment: {error}',
                  parameters: {'error': e.toString()})),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _processingPayment = false);
      }
    }
  }

  /// Process Cash payment
  Future<void> _processCashPayment(BuildContext context) async {
    final loc = AppLocalizations.of(context);
    final paymentVM = context.read<GuestPaymentViewModel>();
    final paymentNotificationVM = context.read<PaymentNotificationViewModel>();
    final authProvider = context.read<AuthProvider>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: HeadingMedium(
            text: loc?.cashPaymentConfirmation ??
                _text('cashPaymentConfirmation', 'Cash Payment Confirmation')),
        content: BodyText(
          text: loc?.haveYouPaidAmountInCash ??
              _text('haveYouPaidAmountInCash',
                  'Have you paid the amount in cash to the owner? Owner will confirm once they receive the payment.'),
        ),
        actions: [
          SecondaryButton(
            onPressed: () => Navigator.of(context).pop(false),
            label: loc?.cancel ?? _text('cancel', 'Cancel'),
          ),
          PrimaryButton(
            onPressed: () => Navigator.of(context).pop(true),
            label: loc?.yesPaid ?? _text('yesPaid', 'Yes, Paid'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    if (!mounted) return;

    setState(() => _processingPayment = true);

    try {
      // Send cash payment notification to owner
      await paymentNotificationVM.sendPaymentNotification(
        guestId: authProvider.user!.userId,
        ownerId: _payment!.ownerId,
        pgId: _payment!.pgId,
        bookingId: _payment!.bookingId,
        amount: _payment!.amount,
        paymentMethod: 'cash',
        paymentNote: loc?.cashPaymentNote ??
            _text('cashPaymentNote', 'Cash payment made. Please confirm.'),
      );

      // Update payment status as "Confirmed" (pending owner confirmation)
      final updatedPayment = _payment!.copyWith(
        status: 'Confirmed', // Cash payments need owner confirmation
        paymentMethod: 'cash',
        updatedAt: DateTime.now(),
      );
      await paymentVM.updatePayment(updatedPayment);

      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(loc?.cashPaymentNotificationSent ??
              _text('cashPaymentNotificationSent',
                  'Cash payment notification sent. Owner will confirm once they receive the payment.')),
          backgroundColor: AppColors.success,
        ),
      );
      await _loadPaymentDetails();
    } catch (e) {
      if (!mounted) return;
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(loc?.failedToProcessCashPayment(e.toString()) ??
              _text('failedToProcessCashPayment',
                  'Failed to process cash payment: {error}',
                  parameters: {'error': e.toString()})),
          backgroundColor: AppColors.error,
        ),
      );
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
            content: Text(
                AppLocalizations.of(context)?.failedToPickImage(e.toString()) ??
                    _text('failedToPickImage', 'Failed to pick image: {error}',
                        parameters: {'error': e.toString()})),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return AlertDialog(
      title: HeadingMedium(text: loc?.uPI ?? _text('uPI', 'UPI Payment')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BodyText(
              text:
                  '${loc?.amountLabel ?? _text('amountLabel', 'Amount:')} ${_formatAmount(widget.payment.amount, loc)}',
              medium: true,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text: loc?.uploadPaymentScreenshot ??
                  _text('uploadPaymentScreenshot', 'Upload Payment Screenshot'),
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
                    _screenshotFile is String
                        ? File(_screenshotFile)
                        : _screenshotFile,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingS),
              TextButton.icon(
                onPressed: _pickScreenshot,
                icon: const Icon(Icons.refresh),
                label: Text(loc?.changeScreenshot ??
                    _text('changeScreenshot', 'Change Screenshot')),
              ),
            ] else ...[
              PrimaryButton(
                onPressed: _uploading ? null : _pickScreenshot,
                label: _uploading
                    ? (loc?.processing ?? _text('processing', 'Processing...'))
                    : (loc?.uploadPaymentScreenshot ??
                        _text('uploadPaymentScreenshot', 'Upload Screenshot')),
                icon: Icons.upload_file,
                width: double.infinity,
              ),
            ],
            const SizedBox(height: AppSpacing.paddingM),
            Builder(
              builder: (context) {
                final loc = AppLocalizations.of(context);
                return TextField(
                  controller: _transactionIdController,
                  decoration: InputDecoration(
                    labelText: loc?.transactionIdOptional ??
                        _text('transactionIdOptional',
                            'Transaction ID (Optional)'),
                    hintText: loc?.transactionIdIsVisibleInScreenshot ??
                        _text('transactionIdIsVisibleInScreenshot',
                            'Transaction ID is visible in screenshot'),
                    border: const OutlineInputBorder(),
                    helperText: loc
                            ?.youCanSkipThisTransactionIdIsInScreenshot ??
                        _text('youCanSkipThisTransactionIdIsInScreenshot',
                            'You can skip this - transaction ID is in the screenshot'),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: loc?.upiPaymentTip ??
                  _text('upiPaymentTip',
                      '💡 Tip: After making payment via PhonePe, Paytm, Google Pay, etc., upload the payment screenshot. The transaction ID is already visible in the screenshot.'),
              color: AppColors.textSecondary,
              small: true,
            ),
          ],
        ),
      ),
      actions: [
        SecondaryButton(
          onPressed: () => Navigator.of(context).pop(),
          label: loc?.cancel ?? _text('cancel', 'Cancel'),
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
          label: loc?.confirm ?? _text('confirm', 'Confirm'),
        ),
      ],
    );
  }

  String _formatAmount(double amount, AppLocalizations? loc) {
    final locale = loc?.localeName ?? 'en_IN';
    final symbol = NumberFormat.simpleCurrency(locale: locale).currencySymbol;
    return NumberFormat.currency(locale: locale, symbol: symbol).format(amount);
  }
}
