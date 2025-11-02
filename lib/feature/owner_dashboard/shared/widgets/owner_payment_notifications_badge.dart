// lib/feature/owner_dashboard/shared/widgets/owner_payment_notifications_badge.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/styles/colors.dart';
import '../../../../common/styles/spacing.dart';
import '../../../../common/widgets/text/body_text.dart';
import '../../../../common/widgets/text/caption_text.dart';
import '../../../../common/widgets/text/heading_small.dart';
import '../../../../common/widgets/buttons/primary_button.dart';
import '../../../../common/widgets/buttons/secondary_button.dart';
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
    final theme = Theme.of(context);
    // final true = theme.brightness == Brightness.dark;

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
              colors: [AppColors.warning, AppColors.warning.withValues(alpha: 0.8)],
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.payment_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BodyText(
                    text: 'Pending Payments',
                    color: Colors.white,
                    medium: true,
                  ),
                  CaptionText(
                    text: '${viewModel.pendingNotifications.length} waiting',
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
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
      backgroundColor: Colors.transparent,
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
    final theme = Theme.of(context);
    // final true = theme.brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppColors.darkCard,
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
                  child: const Icon(Icons.payment_rounded,
                      color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeadingSmall(text: 'Pending Payments'),
                      CaptionText(
                        text: '${notifications.length} notifications',
                        color: AppColors.textSecondary,
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
    final theme = Theme.of(context);
    // final true = theme.brightness == Brightness.dark;
    final authProvider = context.read<AuthProvider>();
    final viewModel = context.read<PaymentNotificationViewModel>();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: true ? AppColors.darkInputFill : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(
          color: AppColors.darkDivider,
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
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: BodyText(
                  text: notification.formattedAmount,
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
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
                ),
                child: CaptionText(
                  text: notification.paymentMethodDisplay,
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
                const SizedBox(width: 4),
                CaptionText(
                  text: 'TXN: ${notification.transactionId}',
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
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
              child: Image.network(
                notification.paymentScreenshotUrl!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: true ? AppColors.darkCard : AppColors.outline,
                    child: const Center(
                      child: Icon(Icons.error, color: AppColors.error),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.paddingM),
          ],
          // Action buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Reject',
                  icon: Icons.close,
                  onPressed: () =>
                      _rejectPayment(context, viewModel, authProvider),
                ),
              ),
              const SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: PrimaryButton(
                  label: 'Confirm',
                  icon: Icons.check,
                  onPressed: () =>
                      _confirmPayment(context, viewModel, authProvider),
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
  ) async {
    final ownerId = authProvider.user?.userId ?? '';
    final success =
        await viewModel.confirmPayment(notification.notificationId, ownerId);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment confirmed successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _rejectPayment(
    BuildContext context,
    PaymentNotificationViewModel viewModel,
    AuthProvider authProvider,
  ) async {
    final reason = await _showRejectDialog(context);
    if (reason == null || reason.isEmpty) return;

    final ownerId = authProvider.user?.userId ?? '';
    final success = await viewModel.rejectPayment(
        notification.notificationId, ownerId, reason);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment rejected'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<String?> _showRejectDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reject Payment'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Reason for rejection',
              hintText: 'e.g., Incorrect amount, wrong transaction',
            ),
            maxLines: 2,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }
}
