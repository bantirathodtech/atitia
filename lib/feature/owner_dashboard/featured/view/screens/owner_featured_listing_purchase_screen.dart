// lib/feature/owner_dashboard/featured/view/screens/owner_featured_listing_purchase_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/loaders/enhanced_loading_state.dart';
import '../../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../../common/widgets/indicators/enhanced_empty_state.dart';
import '../../../../../../common/widgets/text/heading_large.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/caption_text.dart';
import '../../../../../../common/widgets/dropdowns/adaptive_dropdown.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/utils/extensions/context_extensions.dart';
import '../../../../../../common/utils/responsive/responsive_system.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../../core/models/featured/featured_listing_model.dart';
import '../../../shared/widgets/owner_drawer.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../viewmodel/owner_featured_listing_viewmodel.dart';

/// Screen for purchasing featured listings for PGs
class OwnerFeaturedListingPurchaseScreen extends StatefulWidget {
  const OwnerFeaturedListingPurchaseScreen({super.key});

  @override
  State<OwnerFeaturedListingPurchaseScreen> createState() =>
      _OwnerFeaturedListingPurchaseScreenState();
}

class _OwnerFeaturedListingPurchaseScreenState
    extends State<OwnerFeaturedListingPurchaseScreen> {
  String? _selectedPgId;
  int _selectedDurationMonths = 1;
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
      context.read<OwnerFeaturedListingViewModel>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final viewModel = context.watch<OwnerFeaturedListingViewModel>();
    final pgProvider = context.watch<SelectedPgProvider>();

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: _text('featuredListing', 'Featured Listing'),
        showDrawer: true,
        showBackButton: true,
        showThemeToggle: false,
      ),
      drawer: const OwnerDrawer(),
      body: _buildBody(context, loc, viewModel, pgProvider),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations loc,
    OwnerFeaturedListingViewModel viewModel,
    SelectedPgProvider pgProvider,
  ) {
    if (viewModel.loading && viewModel.featuredListings.isEmpty) {
      return const EnhancedLoadingState(type: LoadingType.centered);
    }

    if (viewModel.error) {
      return EmptyStates.error(
        context: context,
        message: viewModel.errorMessage ??
            _text('errorLoadingFeaturedListings',
                'Failed to load featured listings'),
        onRetry: () => viewModel.initialize(),
      );
    }

    final responsivePadding = ResponsiveSystem.getResponsivePadding(context);

    return SingleChildScrollView(
      padding: responsivePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(context, loc),
          SizedBox(
              height:
                  context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // PG Selection
          _buildPGSelection(context, pgProvider, loc),
          SizedBox(
              height:
                  context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Duration Selection
          _buildDurationSelection(context, loc),
          SizedBox(
              height:
                  context.isMobile ? AppSpacing.paddingM : AppSpacing.paddingL),

          // Pricing Summary
          if (_selectedPgId != null) _buildPricingSummary(context, loc),
          if (_selectedPgId != null)
            SizedBox(
                height: context.isMobile
                    ? AppSpacing.paddingM
                    : AppSpacing.paddingL),

          // Purchase Button
          if (_selectedPgId != null)
            _buildPurchaseButton(context, viewModel, loc),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations loc) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingLarge(text: _text('featuredYourPG', 'Feature Your PG')),
          SizedBox(height: AppSpacing.paddingS),
          BodyText(
            text: _text(
              'featuredListingDescription',
              'Make your PG stand out! Featured listings appear at the top of search results, increasing visibility and bookings.',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPGSelection(
    BuildContext context,
    SelectedPgProvider pgProvider,
    AppLocalizations loc,
  ) {
    if (pgProvider.isLoading) {
      return AdaptiveCard(
        child: Column(
          children: [
            AdaptiveLoader(),
            SizedBox(height: AppSpacing.paddingM),
            BodyText(text: _text('loadingPGs', 'Loading your PGs...')),
          ],
        ),
      );
    }

    if (!pgProvider.hasPgs) {
      return AdaptiveCard(
        child: EnhancedEmptyState(
          title: _text('noPGsFound', 'No PGs Found'),
          message: _text(
            'createPGFirst',
            'Create a PG first before purchasing a featured listing',
          ),
          icon: Icons.home_work_outlined,
        ),
      );
    }

    final items = pgProvider.pgs
        .map((pg) {
          final pgId = pg['pgId'] as String? ?? pg['id'] as String? ?? '';
          final pgName =
              pg['pgName'] as String? ?? pg['name'] as String? ?? 'Unknown PG';
          final isFeatured =
              context.read<OwnerFeaturedListingViewModel>().isPGFeatured(pgId);
          return DropdownMenuItem<String>(
            value: isFeatured ? null : pgId,
            enabled: !isFeatured,
            child: Text(
              isFeatured ? '$pgName (Already Featured)' : pgName,
              style: TextStyle(
                color: isFeatured ? Theme.of(context).disabledColor : null,
              ),
            ),
          );
        })
        .where((item) => item.value != null)
        .toList();

    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(text: _text('selectPG', 'Select PG')),
          SizedBox(height: AppSpacing.paddingM),
          AdaptiveDropdown<String>(
            label: _text('selectPG', 'Select PG'),
            value: _selectedPgId,
            items: items,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedPgId = value;
                });
              }
            },
            hint: _text('selectPGToFeature', 'Select a PG to feature'),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSelection(BuildContext context, AppLocalizations loc) {
    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(text: _text('duration', 'Duration')),
          SizedBox(height: AppSpacing.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildDurationChip(context, 1, loc),
              ),
              SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: _buildDurationChip(context, 3, loc),
              ),
              SizedBox(width: AppSpacing.paddingS),
              Expanded(
                child: _buildDurationChip(context, 6, loc),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDurationChip(
    BuildContext context,
    int months,
    AppLocalizations loc,
  ) {
    final isSelected = _selectedDurationMonths == months;
    final price = FeaturedListingModel.getPriceForDuration(months);
    final pricePerMonth = price / months;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedDurationMonths = months;
        });
      },
      borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? context.primaryColor
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          color:
              isSelected ? context.primaryColor.withValues(alpha: 0.1) : null,
        ),
        child: Column(
          children: [
            BodyText(
              text:
                  '$months ${months == 1 ? _text('month', 'Month') : _text('months', "Months")}',
              medium: true,
            ),
            SizedBox(height: AppSpacing.paddingXS),
            HeadingMedium(
              text: '₹${price.toStringAsFixed(0)}',
              color: context.primaryColor,
            ),
            if (months > 1)
              CaptionText(
                text: '₹${pricePerMonth.toStringAsFixed(0)}/mo',
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSummary(BuildContext context, AppLocalizations loc) {
    final price =
        FeaturedListingModel.getPriceForDuration(_selectedDurationMonths);
    final pricePerMonth = price / _selectedDurationMonths;

    return AdaptiveCard(
      backgroundColor: context.primaryColor.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(text: _text('pricingSummary', 'Pricing Summary')),
          SizedBox(height: AppSpacing.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyText(text: _text('duration', 'Duration')),
              BodyText(
                text:
                    '$_selectedDurationMonths ${_selectedDurationMonths == 1 ? _text('month', 'Month') : _text('months', "Months")}',
                medium: true,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.paddingS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BodyText(text: _text('pricePerMonth', 'Price per Month')),
              BodyText(
                text: '₹${pricePerMonth.toStringAsFixed(0)}/mo',
                medium: true,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.paddingS),
          Divider(),
          SizedBox(height: AppSpacing.paddingS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeadingMedium(text: _text('totalAmount', 'Total Amount')),
              HeadingLarge(
                text: '₹${price.toStringAsFixed(0)}',
                color: context.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseButton(
    BuildContext context,
    OwnerFeaturedListingViewModel viewModel,
    AppLocalizations loc,
  ) {
    return PrimaryButton(
      onPressed: () => _handlePurchase(context, viewModel, loc),
      label: _text('purchaseFeaturedListing', 'Purchase Featured Listing'),
      icon: Icons.star,
      isLoading: viewModel.isProcessingPayment,
      enabled: !viewModel.isProcessingPayment && _selectedPgId != null,
      width: double.infinity,
    );
  }

  void _handlePurchase(
    BuildContext context,
    OwnerFeaturedListingViewModel viewModel,
    AppLocalizations loc,
  ) {
    if (_selectedPgId == null) return;

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_text('confirmPurchase', 'Confirm Purchase')),
        content: Text(
          _text(
            'confirmFeaturedListingPurchase',
            'You are about to purchase a featured listing for {duration} months at ₹{amount}. Continue?',
            parameters: {
              'duration': _selectedDurationMonths.toString(),
              'amount': FeaturedListingModel.getPriceForDuration(
                      _selectedDurationMonths)
                  .toStringAsFixed(0),
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
              viewModel.purchaseFeaturedListing(
                pgId: _selectedPgId!,
                durationMonths: _selectedDurationMonths,
                onSuccess: (featuredListingId) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_text('featuredListingPurchased',
                          'Featured listing purchased successfully!')),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop();
                },
                onFailure: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_text('featuredListingPurchaseFailed',
                          'Failed to purchase featured listing: {error}',
                          parameters: {'error': error})),
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
