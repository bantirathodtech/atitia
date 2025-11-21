// lib/feature/owner_dashboard/shared/widgets/owner_payment_notifications_badge.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../common/styles/colors.dart';
import '../../../../common/styles/spacing.dart';
import '../../../../common/styles/theme_colors.dart';
import '../../../../common/utils/extensions/context_extensions.dart';
import '../../../../common/widgets/text/body_text.dart';
import '../../../../common/widgets/text/caption_text.dart';
import '../../../../common/widgets/text/heading_small.dart';
import '../../../../common/widgets/text/heading_medium.dart';
import '../../../../common/widgets/images/adaptive_image.dart';
import '../../../../common/widgets/buttons/primary_button.dart';
import '../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../common/widgets/buttons/text_button.dart';
import '../../../../common/widgets/inputs/text_input.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/logic/auth_provider.dart';
import '../../../../core/viewmodels/payment_notification_viewmodel.dart';
import '../../../../core/models/payment_notification_model.dart';

/// Floating badge showing pending payment notifications for owner
/// Appears on owner dashboard with count and quick actions
class OwnerPaymentNotificationsBadge extends StatefulWidget {
  const OwnerPaymentNotificationsBadge({super.key});

  @override
  State<OwnerPaymentNotificationsBadge> createState() =>
      _OwnerPaymentNotificationsBadgeState();
}

class _OwnerPaymentNotificationsBadgeState
    extends State<OwnerPaymentNotificationsBadge> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      // Defer initialization to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _initializeStream();
        }
      });
    }
  }

  void _initializeStream() {
    final authProvider = context.read<AuthProvider>();
    final viewModel = context.read<PaymentNotificationViewModel>();
    final ownerId = authProvider.user?.userId ?? '';

    if (ownerId.isNotEmpty) {
      viewModel.streamOwnerNotifications(ownerId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PaymentNotificationViewModel>();
    final loc = AppLocalizations.of(context);

    if (!viewModel.hasPendingNotifications) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 80,
      right: 16,
      child: GestureDetector(
        onTap: () =>
            _showNotificationsList(context, viewModel.pendingNotifications),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingM,
            vertical: AppSpacing.paddingS,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.warning,
                AppColors.warning.withValues(alpha: 0.8)
              ],
            ),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
            boxShadow: [
              BoxShadow(
                color: AppColors.warning.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimary
                      .withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.payment_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BodyText(
                    text: loc?.pendingPayments ?? 'Pending Payments',
                    color: Theme.of(context).colorScheme.onPrimary,
                    medium: true,
                  ),
                  CaptionText(
                    text: loc?.pendingPaymentsWaiting(
                          viewModel.pendingNotifications.length,
                        ) ??
                        '${viewModel.pendingNotifications.length} waiting',
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withValues(alpha: 0.9),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  shape: BoxShape.circle,
                ),
                child: BodyText(
                  text: '${viewModel.pendingNotifications.length}',
                  color: AppColors.warning,
                  medium: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationsList(
      BuildContext context, List<PaymentNotificationModel> notifications) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          Colors.transparent, // Modal bottom sheet - transparent is fine
      builder: (context) =>
          _PaymentNotificationsSheet(notifications: notifications),
    );
  }
}

/// Bottom sheet showing list of pending payment notifications
class _PaymentNotificationsSheet extends StatelessWidget {
  final List<PaymentNotificationModel> notifications;

  const _PaymentNotificationsSheet({required this.notifications});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color:
            ThemeColors.getCardBackground(context),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusL),
        ),
      ),
      child: Column(
        children: [
          // Handle indicator
          Container(
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.paddingS),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.darkDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingL),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.warning,
                        AppColors.warning.withValues(alpha: 0.7)
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                  ),
                  child: Icon(Icons.payment_rounded,
                      color: Theme.of(context).colorScheme.onPrimary, size: 24),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingSmall(
                          text: loc?.pendingPayments ?? 'Pending Payments'),
                      CaptionText(
                        text: loc?.notificationsCount(notifications.length) ??
                            '${notifications.length} notifications',
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
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Notifications list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.paddingL),
              itemCount: notifications.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.paddingM),
              itemBuilder: (context, index) {
                return _PaymentNotificationCard(
                    notification: notifications[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual payment notification card
class _PaymentNotificationCard extends StatelessWidget {
  final PaymentNotificationModel notification;

  const _PaymentNotificationCard({required this.notification});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final viewModel = context.read<PaymentNotificationViewModel>();
    final loc = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: context.theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: ThemeColors.getDivider(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Amount and method
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingS,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                  border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: BodyText(
                  text: _formatCurrency(notification.amount, loc),
                  color: AppColors.success,
                  medium: true,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingS,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                  border:
                      Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                ),
                child: CaptionText(
                  text: _paymentMethodLabel(notification.paymentMethod, loc),
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingS),
          // Transaction ID
          if (notification.transactionId != null) ...[
            Row(
              children: [
                const Icon(Icons.receipt,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: AppSpacing.paddingXS),
                CaptionText(
                  text: loc?.transactionIdLabel(notification.transactionId!) ??
                      'TXN: ${notification.transactionId}',
                  color: AppColors.textSecondary,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingS),
          ],
          // Payment note
          if (notification.paymentNote != null) ...[
            BodyText(
              text: notification.paymentNote!,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.paddingS),
          ],
          // Screenshot preview
          if (notification.paymentScreenshotUrl != null) ...[
            AdaptiveImage(
              imageUrl: notification.paymentScreenshotUrl!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              borderRadius: AppSpacing.borderRadiusS,
              errorWidget: Container(
                height: 150,
                color: ThemeColors.getCardBackground(context),
                child: Center(
                  child: Icon(Icons.error, color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.paddingM),
          ],
          // Action buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: loc?.reject ?? 'Reject',
                  icon: Icons.close,
                  onPressed: () =>
                      _rejectPayment(context, viewModel, authProvider, loc),
                ),
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: PrimaryButton(
                  label: loc?.confirm ?? 'Confirm',
                  icon: Icons.check,
                  onPressed: () =>
                      _confirmPayment(context, viewModel, authProvider, loc),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _confirmPayment(
    BuildContext context,
    PaymentNotificationViewModel viewModel,
    AuthProvider authProvider,
    AppLocalizations? loc,
  ) async {
    final ownerId = authProvider.user?.userId ?? '';
    final success =
        await viewModel.confirmPayment(notification.notificationId, ownerId);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc?.paymentConfirmedSuccessfully ??
              'Payment confirmed successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _rejectPayment(
    BuildContext context,
    PaymentNotificationViewModel viewModel,
    AuthProvider authProvider,
    AppLocalizations? loc,
  ) async {
    final reason = await _showRejectDialog(context, loc);
    if (reason == null || reason.isEmpty) return;

    final ownerId = authProvider.user?.userId ?? '';
    final success = await viewModel.rejectPayment(
        notification.notificationId, ownerId, reason);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc?.paymentRejected ?? 'Payment rejected'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<String?> _showRejectDialog(
      BuildContext context, AppLocalizations? loc) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
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
                HeadingMedium(
                  text: loc?.rejectPayment ?? 'Reject Payment',
                ),
                const SizedBox(height: AppSpacing.paddingM),
                TextInput(
                  controller: controller,
                  label: loc?.rejectionReason ?? 'Reason for rejection',
                  hint: loc?.rejectionReasonHint ??
                      'e.g., Incorrect amount, wrong transaction',
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.paddingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButtonWidget(
                      onPressed: () => Navigator.pop(context),
                      text: loc?.cancel ?? 'Cancel',
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    SecondaryButton(
                      onPressed: () => Navigator.pop(context, controller.text),
                      label: loc?.reject ?? 'Reject',
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

  String _formatCurrency(double amount, AppLocalizations? loc) {
    final formatter = NumberFormat.simpleCurrency(
      locale: loc?.localeName,
      name: 'INR',
    );
    return formatter.format(amount);
  }

  String _paymentMethodLabel(String method, AppLocalizations? loc) {
    switch (method.toLowerCase()) {
      case 'cash':
        return loc?.paymentMethodCash ?? 'Cash';
      case 'upi':
        return loc?.paymentMethodUpi ?? 'UPI';
      case 'razorpay':
        return loc?.paymentMethodRazorpay ?? 'Razorpay';
      case 'card':
        return loc?.paymentMethodCard ?? 'Card';
      case 'bank_transfer':
        return loc?.paymentMethodBankTransfer ?? 'Bank Transfer';
      default:
        return loc?.paymentMethodOther ?? method.toUpperCase();
    }
  }
}
