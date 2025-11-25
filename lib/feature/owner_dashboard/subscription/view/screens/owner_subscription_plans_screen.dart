// lib/feature/owner_dashboard/subscription/view/screens/owner_subscription_plans_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/loaders/enhanced_loading_state.dart';
import '../../../../../../common/widgets/indicators/enhanced_empty_state.dart';
import '../../../../../../common/widgets/text/heading_large.dart';
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
import '../../../shared/widgets/owner_drawer.dart';
import '../../viewmodel/owner_subscription_viewmodel.dart';

/// Screen for selecting and purchasing subscription plans
class OwnerSubscriptionPlansScreen extends StatefulWidget {
  const OwnerSubscriptionPlansScreen({super.key});

  @override
  State<OwnerSubscriptionPlansScreen> createState() =>
      _OwnerSubscriptionPlansScreenState();
}

class _OwnerSubscriptionPlansScreenState
    extends State<OwnerSubscriptionPlansScreen> {
  BillingPeriod _selectedBillingPeriod = BillingPeriod.monthly;
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OwnerSubscriptionViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final viewModel = context.watch<OwnerSubscriptionViewModel>();

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: _text('subscriptionPlans', 'Subscription Plans'),
        showDrawer: true,
        showBackButton: false,
        showThemeToggle: false,
      ),
      drawer: const OwnerDrawer(),
      body: _buildBody(context, loc ?? AppLocalizations.of(context)!, viewModel),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations loc,
    OwnerSubscriptionViewModel viewModel,
  ) {
    if (viewModel.loading) {
      return const EnhancedLoadingState(type: LoadingType.centered);
    }

    if (viewModel.error) {
      return EmptyStates.error(
        context: context,
        message: viewModel.errorMessage ?? _text('errorLoadingPlans', 'Failed to load subscription plans'),
        onRetry: () => viewModel.initialize(),
      );
    }

    final responsivePadding = ResponsiveSystem.getResponsivePadding(context);

    return SingleChildScrollView(
      padding: responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Current Subscription Banner
          if (viewModel.hasActiveSubscription)
            _buildCurrentSubscriptionBanner(context, viewModel, loc),
          if (viewModel.hasActiveSubscription)
            SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Billing Period Toggle
          _buildBillingPeriodToggle(context, loc),
          SizedBox(height: context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Subscription Plans
          _buildPlansGrid(context, viewModel, loc),
        ],
      ),
    );
  }

  Widget _buildCurrentSubscriptionBanner(
    BuildContext context,
    OwnerSubscriptionViewModel viewModel,
    AppLocalizations loc,
  ) {
    final subscription = viewModel.currentSubscription!;
    final plan = SubscriptionPlanModel.getPlanByTier(subscription.tier);

    return AdaptiveCard(
      backgroundColor: context.primaryColor.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: context.primaryColor),
          SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(
                  text: _text('currentPlan', 'Current Plan'),
                  medium: true,
                ),
                SizedBox(height: AppSpacing.paddingXS),
                HeadingMedium(
                  text: plan?.name ?? subscription.tier.displayName,
                ),
                if (subscription.endDate.isAfter(DateTime.now()))
                  CaptionText(
                    text: _text(
                      'expiresOn',
                      'Expires on {date}',
                      parameters: {
                        'date': DateFormat('MMM dd, yyyy').format(subscription.endDate),
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingPeriodToggle(
    BuildContext context,
    AppLocalizations loc,
  ) {
    return AdaptiveCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBillingPeriodChip(
            context,
            BillingPeriod.monthly,
            _text('monthly', 'Monthly'),
            _selectedBillingPeriod == BillingPeriod.monthly,
          ),
          SizedBox(width: AppSpacing.paddingS),
          _buildBillingPeriodChip(
            context,
            BillingPeriod.yearly,
            _text('yearly', 'Yearly'),
            _selectedBillingPeriod == BillingPeriod.yearly,
          ),
        ],
      ),
    );
  }

  Widget _buildBillingPeriodChip(
    BuildContext context,
    BillingPeriod period,
    String label,
    bool isSelected,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedBillingPeriod = period;
          });
        }
      },
    );
  }

  Widget _buildPlansGrid(
    BuildContext context,
    OwnerSubscriptionViewModel viewModel,
    AppLocalizations loc,
  ) {
    final plans = viewModel.availablePlans;
    final currentTier = viewModel.currentTier;

    final responsive = ResponsiveSystem.getConfig(context);
    if (responsive.isDesktop || responsive.isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: plans.map((plan) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: plan != plans.last ? AppSpacing.paddingM : 0,
              ),
              child:               _buildPlanCard(
                context,
                plan,
                viewModel,
                loc,
                currentTier == plan.tier,
              ),
            ),
          );
        }).toList(),
      );
    }

    return Column(
      children: plans.map((plan) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: plan != plans.last ? AppSpacing.paddingM : 0,
          ),
          child: _buildPlanCard(
            context,
            plan,
            viewModel,
            loc,
            currentTier == plan.tier,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPlanCard(
    BuildContext context,
    SubscriptionPlanModel plan,
    OwnerSubscriptionViewModel viewModel,
    AppLocalizations loc,
    bool isCurrentPlan,
  ) {
    final price = _selectedBillingPeriod == BillingPeriod.monthly
        ? plan.monthlyPrice
        : plan.yearlyPrice;
    final formattedPrice = price == 0
        ? _text('free', 'Free')
        : _selectedBillingPeriod == BillingPeriod.monthly
            ? '₹${price.toStringAsFixed(0)}/mo'
            : '₹${price.toStringAsFixed(0)}/yr';

    final isPopular = plan.tier == SubscriptionTier.premium;
    final canUpgrade = !isCurrentPlan &&
        viewModel.currentTier.index < plan.tier.index;
    final isDowngrade = !isCurrentPlan &&
        viewModel.currentTier.index > plan.tier.index;

    return AdaptiveCard(
      backgroundColor: isPopular
          ? context.primaryColor.withValues(alpha: 0.05)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plan Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeadingMedium(text: plan.name),
                    if (plan.description.isNotEmpty)
                      CaptionText(text: plan.description),
                  ],
                ),
              ),
              if (isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color: context.primaryColor,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: CaptionText(
                    text: _text('popular', 'Popular'),
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.paddingM),

          // Price
          HeadingLarge(
            text: formattedPrice,
            color: context.primaryColor,
          ),
          if (_selectedBillingPeriod == BillingPeriod.yearly &&
              plan.yearlySavingsPercentage > 0)
            CaptionText(
              text: _text(
                'savePercent',
                'Save {percent}%',
                parameters: {
                  'percent': plan.yearlySavingsPercentage.toStringAsFixed(0),
                },
              ),
              color: Colors.green,
            ),
          SizedBox(height: AppSpacing.paddingM),

          // Features
          ...plan.features.map((feature) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 20,
                    color: context.primaryColor,
                  ),
                  SizedBox(width: AppSpacing.paddingS),
                  Expanded(
                    child: BodyText(text: feature),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: AppSpacing.paddingL),

          // Action Button
          PrimaryButton(
            onPressed: isCurrentPlan
                ? null
                : () => _handlePurchase(context, plan, viewModel),
            label: isCurrentPlan
                ? _text('currentPlan', 'Current Plan')
                : canUpgrade
                    ? _text('upgrade', 'Upgrade')
                    : isDowngrade
                        ? _text('downgrade', 'Downgrade')
                        : _text('subscribe', 'Subscribe'),
            icon: isCurrentPlan ? Icons.check : Icons.arrow_forward,
            isLoading: viewModel.isProcessingPayment,
            enabled: !isCurrentPlan && !viewModel.isProcessingPayment,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  void _handlePurchase(
    BuildContext context,
    SubscriptionPlanModel plan,
    OwnerSubscriptionViewModel viewModel,
  ) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_text('confirmSubscription', 'Confirm Subscription')),
        content: Text(
          _text(
            'confirmPurchase',
            'You are about to subscribe to {planName} for {price}. Continue?',
            parameters: {
              'planName': plan.name,
              'price': _selectedBillingPeriod == BillingPeriod.monthly
                  ? '₹${plan.monthlyPrice.toStringAsFixed(0)}/month'
                  : '₹${plan.yearlyPrice.toStringAsFixed(0)}/year',
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(_text('cancel', 'Cancel')),
          ),
          PrimaryButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              viewModel.purchaseSubscription(
                plan: plan,
                billingPeriod: _selectedBillingPeriod,
                onSuccess: (subscriptionId) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_text('subscriptionSuccess', 'Subscription purchased successfully!')),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                onFailure: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_text('subscriptionFailed', 'Failed to purchase subscription: {error}', parameters: {'error': error})),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            },
            label: _text('confirm', 'Confirm'),
          ),
        ],
      ),
    );
  }
}

