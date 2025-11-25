// lib/feature/owner_dashboard/subscription/view/screens/owner_subscription_management_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../../common/widgets/loaders/enhanced_loading_state.dart';
import '../../../../../../common/widgets/indicators/enhanced_empty_state.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/caption_text.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../../core/models/subscription/subscription_plan_model.dart';
import '../../../../../../core/models/subscription/owner_subscription_model.dart';
import '../../../../../../common/utils/constants/routes.dart';
import '../../../shared/widgets/owner_drawer.dart';
import '../../viewmodel/owner_subscription_viewmodel.dart';

/// Screen for managing subscription details, history, and cancellation
class OwnerSubscriptionManagementScreen extends StatefulWidget {
  const OwnerSubscriptionManagementScreen({super.key});

  @override
  State<OwnerSubscriptionManagementScreen> createState() =>
      _OwnerSubscriptionManagementScreenState();
}

class _OwnerSubscriptionManagementScreenState
    extends State<OwnerSubscriptionManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerSubscriptionViewModel>().initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final viewModel = context.watch<OwnerSubscriptionViewModel>();

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: _text('subscriptionManagement', 'Subscription Management'),
        showDrawer: true,
        showBackButton: false,
        showThemeToggle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                icon: const Icon(Icons.subscriptions),
                text: _text('current', 'Current'),
              ),
              Tab(
                icon: const Icon(Icons.history),
                text: _text('history', 'History'),
              ),
            ],
          ),
        ),
      ),
      drawer: const OwnerDrawer(),
      body: _buildBody(context, loc, viewModel),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations loc,
    OwnerSubscriptionViewModel viewModel,
  ) {
    if (viewModel.loading && viewModel.currentSubscription == null) {
      return const EnhancedLoadingState(type: LoadingType.centered);
    }

    if (viewModel.error) {
      return EmptyStates.error(
        context: context,
        message: viewModel.errorMessage ??
            _text('errorLoadingSubscription', 'Failed to load subscription'),
        onRetry: () => viewModel.initialize(),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildCurrentSubscriptionTab(context, viewModel, loc),
        _buildHistoryTab(context, viewModel, loc),
      ],
    );
  }

  Widget _buildCurrentSubscriptionTab(
    BuildContext context,
    OwnerSubscriptionViewModel viewModel,
    AppLocalizations loc,
  ) {
    final subscription = viewModel.currentSubscription;
    final responsivePadding = ResponsiveSystem.getResponsivePadding(context);

    return SingleChildScrollView(
      padding: responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (subscription == null)
            _buildNoSubscriptionView(context, viewModel, loc)
          else
            ..._buildSubscriptionDetails(context, subscription, viewModel, loc),
        ],
      ),
    );
  }

  Widget _buildNoSubscriptionView(
    BuildContext context,
    OwnerSubscriptionViewModel viewModel,
    AppLocalizations loc,
  ) {
    return EnhancedEmptyState(
      title: _text('noSubscription', 'No Active Subscription'),
      message: _text(
        'subscribeToGetStarted',
        'Subscribe to a plan to unlock premium features and manage multiple PGs',
      ),
      icon: Icons.subscriptions_outlined,
      primaryActionLabel: _text('viewPlans', 'View Plans'),
      onPrimaryAction: () {
        context.go(AppRoutes.ownerSubscriptionPlans);
      },
    );
  }

  List<Widget> _buildSubscriptionDetails(
    BuildContext context,
    OwnerSubscriptionModel subscription,
    OwnerSubscriptionViewModel viewModel,
    AppLocalizations loc,
  ) {
    final plan = SubscriptionPlanModel.getPlanByTier(subscription.tier);

    return [
      // Status Banner
      _buildStatusBanner(context, subscription, loc),
      SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

      // Subscription Details Card
      _buildSubscriptionDetailsCard(context, subscription, plan, loc),
      SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

      // Payment Details Card
      if (subscription.amountPaid > 0)
        _buildPaymentDetailsCard(context, subscription, loc),
      if (subscription.amountPaid > 0)
        SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

      // Actions Card
      if (subscription.status == SubscriptionStatus.active)
        _buildActionsCard(context, subscription, viewModel, loc),
    ];
  }

  Widget _buildStatusBanner(
    BuildContext context,
    OwnerSubscriptionModel subscription,
    AppLocalizations loc,
  ) {
    Color bannerColor;
    IconData statusIcon;
    String statusText;

    switch (subscription.status) {
      case SubscriptionStatus.active:
        if (subscription.daysUntilExpiry <= 7 && subscription.daysUntilExpiry > 0) {
          bannerColor = Colors.orange;
          statusIcon = Icons.warning;
          statusText = _text(
            'expiresInDays',
            'Expires in {days} days',
            parameters: {'days': subscription.daysUntilExpiry.toString()},
          );
        } else {
          bannerColor = Colors.green;
          statusIcon = Icons.check_circle;
          statusText = _text('active', 'Active');
        }
        break;
      case SubscriptionStatus.expired:
        bannerColor = Colors.red;
        statusIcon = Icons.error;
        statusText = _text('expired', 'Expired');
        break;
      case SubscriptionStatus.gracePeriod:
        bannerColor = Colors.orange;
        statusIcon = Icons.warning;
        statusText = _text('gracePeriod', 'Grace Period');
        break;
      case SubscriptionStatus.cancelled:
        bannerColor = Colors.grey;
        statusIcon = Icons.cancel;
        statusText = _text('cancelled', 'Cancelled');
        break;
      case SubscriptionStatus.pendingPayment:
        bannerColor = Colors.blue;
        statusIcon = Icons.payment;
        statusText = _text('pendingPayment', 'Pending Payment');
        break;
    }

    return AdaptiveCard(
      backgroundColor: bannerColor.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(statusIcon, color: bannerColor),
          SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(
                  text: _text('status', 'Status'),
                  medium: true,
                ),
                SizedBox(height: AppSpacing.paddingXS),
                HeadingMedium(
                  text: statusText,
                  color: bannerColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionDetailsCard(
    BuildContext context,
    OwnerSubscriptionModel subscription,
    SubscriptionPlanModel? plan,
    AppLocalizations loc,
  ) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(text: _text('subscriptionDetails', 'Subscription Details')),
          SizedBox(height: AppSpacing.paddingM),
          _buildDetailRow(
            context,
            _text('plan', 'Plan'),
            plan?.name ?? subscription.tier.displayName,
            Icons.category,
          ),
          SizedBox(height: AppSpacing.paddingS),
          _buildDetailRow(
            context,
            _text('billingPeriod', 'Billing Period'),
            subscription.billingPeriod.displayName,
            Icons.calendar_today,
          ),
          SizedBox(height: AppSpacing.paddingS),
          _buildDetailRow(
            context,
            _text('startDate', 'Start Date'),
            DateFormat('MMM dd, yyyy').format(subscription.startDate),
            Icons.event,
          ),
          SizedBox(height: AppSpacing.paddingS),
          _buildDetailRow(
            context,
            _text('endDate', 'End Date'),
            DateFormat('MMM dd, yyyy').format(subscription.endDate),
            Icons.event_busy,
          ),
          if (subscription.daysUntilExpiry > 0)
            SizedBox(height: AppSpacing.paddingS),
          if (subscription.daysUntilExpiry > 0)
            _buildDetailRow(
              context,
              _text('daysRemaining', 'Days Remaining'),
              '${subscription.daysUntilExpiry}',
              Icons.access_time,
            ),
          SizedBox(height: AppSpacing.paddingS),
          _buildDetailRow(
            context,
            _text('autoRenew', 'Auto Renew'),
            subscription.autoRenew ? _text('enabled', 'Enabled') : _text('disabled', 'Disabled'),
            subscription.autoRenew ? Icons.check_circle : Icons.cancel,
          ),
          if (subscription.cancelledAt != null) ...[
            SizedBox(height: AppSpacing.paddingS),
            _buildDetailRow(
              context,
              _text('cancelledAt', 'Cancelled At'),
              DateFormat('MMM dd, yyyy').format(subscription.cancelledAt!),
              Icons.cancel,
            ),
          ],
          if (subscription.cancellationReason != null &&
              subscription.cancellationReason!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.paddingS),
            _buildDetailRow(
              context,
              _text('cancellationReason', 'Cancellation Reason'),
              subscription.cancellationReason!,
              Icons.info,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: context.primaryColor),
        SizedBox(width: AppSpacing.paddingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CaptionText(text: label),
              SizedBox(height: AppSpacing.paddingXS / 2),
              BodyText(text: value, medium: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentDetailsCard(
    BuildContext context,
    OwnerSubscriptionModel subscription,
    AppLocalizations loc,
  ) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(text: _text('paymentDetails', 'Payment Details')),
          SizedBox(height: AppSpacing.paddingM),
          _buildDetailRow(
            context,
            _text('amountPaid', 'Amount Paid'),
            '₹${subscription.amountPaid.toStringAsFixed(2)}',
            Icons.payment,
          ),
          if (subscription.paymentId != null) ...[
            SizedBox(height: AppSpacing.paddingS),
            _buildDetailRow(
              context,
              _text('paymentId', 'Payment ID'),
              subscription.paymentId!,
              Icons.receipt,
            ),
          ],
          if (subscription.orderId != null) ...[
            SizedBox(height: AppSpacing.paddingS),
            _buildDetailRow(
              context,
              _text('orderId', 'Order ID'),
              subscription.orderId!,
              Icons.shopping_bag,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionsCard(
    BuildContext context,
    OwnerSubscriptionModel subscription,
    OwnerSubscriptionViewModel viewModel,
    AppLocalizations loc,
  ) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HeadingMedium(text: _text('actions', 'Actions')),
          SizedBox(height: AppSpacing.paddingM),
          PrimaryButton(
            onPressed: () {
              context.go(AppRoutes.ownerSubscriptionPlans);
            },
            label: _text('upgradeOrChange', 'Upgrade or Change Plan'),
            icon: Icons.upgrade,
            width: double.infinity,
          ),
          SizedBox(height: AppSpacing.paddingS),
          SecondaryButton(
            onPressed: () => _showCancelSubscriptionDialog(
              context,
              subscription,
              viewModel,
              loc,
            ),
            label: _text('cancelSubscription', 'Cancel Subscription'),
            icon: Icons.cancel,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(
    BuildContext context,
    OwnerSubscriptionViewModel viewModel,
    AppLocalizations loc,
  ) {
    final history = viewModel.subscriptionHistory;
    final responsivePadding = ResponsiveSystem.getResponsivePadding(context);

    if (viewModel.loading && history.isEmpty) {
      return const EnhancedLoadingState(type: LoadingType.centered);
    }

    if (history.isEmpty) {
      return EnhancedEmptyState(
        title: _text('noHistory', 'No Subscription History'),
        message: _text(
          'subscriptionHistoryWillAppearHere',
          'Your subscription history will appear here',
        ),
        icon: Icons.history_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refresh(),
      child: ListView.builder(
        padding: responsivePadding,
        itemCount: history.length,
        itemBuilder: (context, index) {
          final subscription = history[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < history.length - 1 ? AppSpacing.paddingM : 0,
            ),
            child: _buildHistoryCard(context, subscription, loc),
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    OwnerSubscriptionModel subscription,
    AppLocalizations loc,
  ) {
    final plan = SubscriptionPlanModel.getPlanByTier(subscription.tier);
    Color statusColor;

    switch (subscription.status) {
      case SubscriptionStatus.active:
        statusColor = Colors.green;
        break;
      case SubscriptionStatus.expired:
        statusColor = Colors.red;
        break;
      case SubscriptionStatus.cancelled:
        statusColor = Colors.grey;
        break;
      case SubscriptionStatus.gracePeriod:
        statusColor = Colors.orange;
        break;
      case SubscriptionStatus.pendingPayment:
        statusColor = Colors.blue;
        break;
    }

    return AdaptiveCard(
      onTap: () => _showSubscriptionDetailsDialog(context, subscription, loc),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingMedium(
                      text: plan?.name ?? subscription.tier.displayName,
                    ),
                    SizedBox(height: AppSpacing.paddingXS),
                    CaptionText(
                      text: '${subscription.billingPeriod.displayName} • ₹${subscription.amountPaid.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.paddingS,
                  vertical: AppSpacing.paddingXS,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                ),
                child: BodyText(
                  text: subscription.status.displayName,
                  color: statusColor,
                  small: true,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.paddingS),
          Row(
            children: [
              Icon(Icons.event, size: 16, color: context.primaryColor),
              SizedBox(width: AppSpacing.paddingXS),
              CaptionText(
                text: '${DateFormat('MMM dd, yyyy').format(subscription.startDate)} - ${DateFormat('MMM dd, yyyy').format(subscription.endDate)}',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCancelSubscriptionDialog(
    BuildContext context,
    OwnerSubscriptionModel subscription,
    OwnerSubscriptionViewModel viewModel,
    AppLocalizations loc,
  ) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_text('cancelSubscription', 'Cancel Subscription')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BodyText(
              text: _text(
                'cancelSubscriptionConfirmation',
                'Are you sure you want to cancel your subscription? You will lose access to premium features when the current billing period ends.',
              ),
            ),
            SizedBox(height: AppSpacing.paddingM),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: _text('reason', 'Reason (Optional)'),
                hintText: _text('enterCancellationReason', 'Enter cancellation reason'),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(_text('keepSubscription', 'Keep Subscription')),
          ),
          PrimaryButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              viewModel.cancelSubscription(
                reason: reasonController.text.isNotEmpty
                    ? reasonController.text
                    : null,
                onSuccess: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_text('subscriptionCancelled', 'Subscription cancelled successfully')),
                      backgroundColor: Colors.green,
                    ),
                  );
                  viewModel.refresh();
                },
                onFailure: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_text('cancellationFailed', 'Failed to cancel subscription: {error}', parameters: {'error': error})),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            },
            label: _text('cancel', 'Cancel Subscription'),
          ),
        ],
      ),
    );
  }

  void _showSubscriptionDetailsDialog(
    BuildContext context,
    OwnerSubscriptionModel subscription,
    AppLocalizations loc,
  ) {
    final plan = SubscriptionPlanModel.getPlanByTier(subscription.tier);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_text('subscriptionDetails', 'Subscription Details')),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                dialogContext,
                _text('plan', 'Plan'),
                plan?.name ?? subscription.tier.displayName,
                Icons.category,
              ),
              SizedBox(height: AppSpacing.paddingS),
              _buildDetailRow(
                dialogContext,
                _text('status', 'Status'),
                subscription.status.displayName,
                Icons.info,
              ),
              SizedBox(height: AppSpacing.paddingS),
              _buildDetailRow(
                dialogContext,
                _text('billingPeriod', 'Billing Period'),
                subscription.billingPeriod.displayName,
                Icons.calendar_today,
              ),
              SizedBox(height: AppSpacing.paddingS),
              _buildDetailRow(
                dialogContext,
                _text('startDate', 'Start Date'),
                DateFormat('MMM dd, yyyy').format(subscription.startDate),
                Icons.event,
              ),
              SizedBox(height: AppSpacing.paddingS),
              _buildDetailRow(
                dialogContext,
                _text('endDate', 'End Date'),
                DateFormat('MMM dd, yyyy').format(subscription.endDate),
                Icons.event_busy,
              ),
              if (subscription.amountPaid > 0) ...[
                SizedBox(height: AppSpacing.paddingS),
                _buildDetailRow(
                  dialogContext,
                  _text('amountPaid', 'Amount Paid'),
                  '₹${subscription.amountPaid.toStringAsFixed(2)}',
                  Icons.payment,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(_text('close', 'Close')),
          ),
        ],
      ),
    );
  }
}

