// lib/feature/owner_dashboard/featured/view/screens/owner_featured_listing_management_screen.dart

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
import '../../../../../../core/models/featured/featured_listing_model.dart';
import '../../../../../../common/utils/constants/routes.dart';
import '../../../shared/widgets/owner_drawer.dart';
import '../../../shared/viewmodel/selected_pg_provider.dart';
import '../../viewmodel/owner_featured_listing_viewmodel.dart';

/// Screen for managing featured listings
class OwnerFeaturedListingManagementScreen extends StatefulWidget {
  const OwnerFeaturedListingManagementScreen({super.key});

  @override
  State<OwnerFeaturedListingManagementScreen> createState() =>
      _OwnerFeaturedListingManagementScreenState();
}

class _OwnerFeaturedListingManagementScreenState
    extends State<OwnerFeaturedListingManagementScreen> {
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
        title: _text('featuredListings', 'Featured Listings'),
        showDrawer: true,
        showBackButton: true,
        showThemeToggle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to purchase screen
              context.go(AppRoutes.ownerFeaturedListingPurchase);
            },
            tooltip: _text('featureNewPG', 'Feature a New PG'),
          ),
        ],
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
            _text('errorLoadingFeaturedListings', 'Failed to load featured listings'),
        onRetry: () => viewModel.initialize(),
      );
    }

    final featuredListings = viewModel.featuredListings;
    final responsivePadding = ResponsiveSystem.getResponsivePadding(context);

    if (featuredListings.isEmpty) {
      return EnhancedEmptyState(
        title: _text('noFeaturedListings', 'No Featured Listings'),
        message: _text(
          'noFeaturedListingsDescription',
          'Feature your PGs to increase visibility and get more bookings',
        ),
        icon: Icons.star_border,
        primaryActionLabel: _text('featureFirstPG', 'Feature Your First PG'),
        onPrimaryAction: () {
          context.go(AppRoutes.ownerFeaturedListingPurchase);
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refresh(),
      child: ListView.builder(
        padding: responsivePadding,
        itemCount: featuredListings.length,
        itemBuilder: (context, index) {
          final listing = featuredListings[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < featuredListings.length - 1
                  ? AppSpacing.paddingM
                  : 0,
            ),
            child: _buildFeaturedListingCard(
              context,
              listing,
              viewModel,
              pgProvider,
              loc,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedListingCard(
    BuildContext context,
    FeaturedListingModel listing,
    OwnerFeaturedListingViewModel viewModel,
    SelectedPgProvider pgProvider,
    AppLocalizations loc,
  ) {
    final pgName = pgProvider.getPgName(listing.pgId) ?? 'Unknown PG';
    Color statusColor;

    switch (listing.status) {
      case FeaturedListingStatus.active:
        statusColor = Colors.green;
        break;
      case FeaturedListingStatus.expired:
        statusColor = Colors.red;
        break;
      case FeaturedListingStatus.cancelled:
        statusColor = Colors.grey;
        break;
      case FeaturedListingStatus.pending:
        statusColor = Colors.blue;
        break;
    }

    return AdaptiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: AppSpacing.paddingXS),
                        HeadingMedium(text: pgName),
                      ],
                    ),
                    SizedBox(height: AppSpacing.paddingXS),
                    CaptionText(
                      text: '${listing.formattedDuration} • ₹${listing.amountPaid.toStringAsFixed(0)}',
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
                  text: listing.status.displayName,
                  color: statusColor,
                  small: true,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.paddingM),
          Row(
            children: [
              Icon(Icons.event, size: 16, color: context.primaryColor),
              SizedBox(width: AppSpacing.paddingXS),
              Expanded(
                child: CaptionText(
                  text: '${DateFormat('MMM dd, yyyy').format(listing.startDate)} - ${DateFormat('MMM dd, yyyy').format(listing.endDate)}',
                ),
              ),
            ],
          ),
          if (listing.isActive && listing.daysUntilExpiry > 0) ...[
            SizedBox(height: AppSpacing.paddingS),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.orange),
                SizedBox(width: AppSpacing.paddingXS),
                CaptionText(
                  text: _text(
                    'expiresInDays',
                    'Expires in {days} days',
                    parameters: {'days': listing.daysUntilExpiry.toString()},
                  ),
                  color: Colors.orange,
                ),
              ],
            ),
          ],
          if (listing.status == FeaturedListingStatus.active) ...[
            SizedBox(height: AppSpacing.paddingM),
            SecondaryButton(
              onPressed: () => _showCancelDialog(context, listing, viewModel, loc),
              label: _text('cancelFeaturedListing', 'Cancel Featured Listing'),
              icon: Icons.cancel,
              width: double.infinity,
            ),
          ],
        ],
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
    FeaturedListingModel listing,
    OwnerFeaturedListingViewModel viewModel,
    AppLocalizations loc,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(_text('cancelFeaturedListing', 'Cancel Featured Listing')),
        content: Text(
          _text(
            'cancelFeaturedListingConfirmation',
            'Are you sure you want to cancel this featured listing? It will no longer appear at the top of search results.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(_text('keepFeaturedListing', 'Keep Featured Listing')),
          ),
          PrimaryButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              viewModel.cancelFeaturedListing(
                featuredListingId: listing.featuredListingId,
                onSuccess: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_text('featuredListingCancelled', 'Featured listing cancelled successfully')),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                onFailure: (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_text('featuredListingCancellationFailed', 'Failed to cancel featured listing: {error}', parameters: {'error': error})),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            },
            label: _text('cancel', 'Cancel'),
          ),
        ],
      ),
    );
  }
}

