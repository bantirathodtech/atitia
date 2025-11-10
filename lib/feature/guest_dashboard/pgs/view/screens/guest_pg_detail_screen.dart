// lib/features/guest_dashboard/pgs/view/screens/guest_pg_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/images/adaptive_image.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/loaders/adaptive_loader.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_large.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../core/di/firebase/di/firebase_service_locator.dart';
import '../../../../../core/navigation/navigation_service.dart';
import '../../viewmodel/guest_pg_viewmodel.dart';
import '../widgets/guest_amenities_list.dart';
import '../widgets/booking_request_dialog.dart';
import '../../../../../common/widgets/sharing_summary.dart';
import '../../../../../common/widgets/containers/section_container.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../l10n/app_localizations.dart';

/// Comprehensive PG Details Screen with all information sections
/// Displays complete PG information in organized sections
class GuestPgDetailScreen extends StatefulWidget {
  final String pgId;

  const GuestPgDetailScreen({
    super.key,
    required this.pgId,
  });

  @override
  State<GuestPgDetailScreen> createState() => _GuestPgDetailScreenState();
}

class _GuestPgDetailScreenState extends State<GuestPgDetailScreen> {
  bool _isFavorite = false;
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
      final pgVM = Provider.of<GuestPgViewModel>(context, listen: false);
      if (pgVM.selectedPG == null || pgVM.selectedPG!.pgId != widget.pgId) {
        pgVM.getPGById(widget.pgId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pgVM = Provider.of<GuestPgViewModel>(context);
    final pg = pgVM.selectedPG;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: pg?.pgName ??
            (loc?.pgDetails ?? _text('pgDetails', 'PG Details')),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePG(context, pg),
          ),
        ],
      ),
      body: _buildBody(context, pgVM, pg),
      bottomNavigationBar:
          pg != null ? _buildStickyActionButtons(context, pg) : null,
    );
  }

  /// Builds appropriate body content based on current state
  Widget _buildBody(BuildContext context, GuestPgViewModel pgVM, dynamic pg) {
    final loc = AppLocalizations.of(context);
    if (pgVM.loading && pg == null) {
      return const Center(child: AdaptiveLoader());
    }

    if (pgVM.error && pg == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: AppSpacing.paddingL),
            HeadingMedium(
              text: loc?.errorLoadingPgDetails ??
                  _text('errorLoadingPgDetails', 'Error loading PG details'),
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: pgVM.errorMessage ??
                  (loc?.unknownErrorOccurred ??
                      _text('unknownErrorOccurred', 'Unknown error occurred')),
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: () => pgVM.getPGById(widget.pgId),
              label: loc?.tryAgain ?? _text('tryAgain', 'Try Again'),
              icon: Icons.refresh,
            ),
          ],
        ),
      );
    }

    if (pg == null) {
      return EmptyState(
        title: AppLocalizations.of(context)?.pgNotFound ??
            _text('pgNotFound', 'PG Not Found'),
        message: AppLocalizations.of(context)
                ?.theRequestedPgCouldNotBeFoundOrMayHaveBeenRemoved ??
            _text(
              'theRequestedPgCouldNotBeFoundOrMayHaveBeenRemoved',
              'The requested PG could not be found or may have been removed.',
            ),
        icon: Icons.apartment,
        actionLabel: AppLocalizations.of(context)?.goBack ??
            _text('goBack', 'Go Back'),
        onAction: () => getIt<NavigationService>().goBack(),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: AppSpacing.paddingM,
        right: AppSpacing.paddingM,
        top: AppSpacing.paddingM,
        bottom: AppSpacing.paddingL + 80, // Space for sticky buttons
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildPricingSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildLocationSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildAmenitiesSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildFoodSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildRulesSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildContactSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildPaymentSection(context, pg),
          const SizedBox(height: AppSpacing.paddingL),
          _buildAdditionalInfoSection(context, pg),
        ],
      ),
    );
  }

  /// Section 1: Hero section with photo gallery, PG name, address, map link
  Widget _buildHeroSection(BuildContext context, dynamic pg) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Photo Gallery Carousel
        if (pg.hasPhotos)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
            child: SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: pg.photos.length,
                itemBuilder: (context, index) {
                  return AdaptiveImage(
                    imageUrl: pg.photos[index],
                    fit: BoxFit.cover,
                    placeholder: Container(
                      color: isDark
                          ? AppColors.darkInputFill
                          : Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.image, size: 64, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        else
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkInputFill : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.apartment, size: 64, color: Colors.grey),
                  const SizedBox(height: AppSpacing.paddingS),
                  CaptionText(
                    text: loc?.noPhotosAvailable ??
                        _text('noPhotosAvailable', 'No photos available'),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: AppSpacing.paddingM),
        // PG Name
        HeadingLarge(text: pg.pgName),
        const SizedBox(height: AppSpacing.paddingS),
        // Full Address with Map Link
        GestureDetector(
          onTap: () => _openMap(context, pg),
          child: Row(
            children: [
              Icon(Icons.location_on,
                  size: 18, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: AppSpacing.paddingXS),
              Expanded(
                child: BodyText(
                  text: pg.fullAddress,
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              Icon(Icons.open_in_new,
                  size: 16, color: Theme.of(context).colorScheme.primary),
            ],
          ),
        ),
      ],
    );
  }

  /// Section 2: Pricing & Availability
  Widget _buildPricingSection(BuildContext context, dynamic pg) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final summary = getSharingSummary(pg);
    final pricing = pg.pricing ?? {};
    final loc = AppLocalizations.of(context);

    // Get rent config from pg model (primary source)
    final rentConfig = pg.rentConfig ?? {};

    // Get deposit and maintenance from pg model or pricing map
    final deposit =
        pg.depositAmount ?? pricing['securityDeposit']?.toDouble() ?? 0.0;
    final maintenanceAmount =
        pg.maintenanceAmount ?? pricing['maintenance']?.toDouble() ?? 0.0;
    final maintenanceType = pg.maintenanceType ?? 'none';
    final hasMaintenance = maintenanceAmount > 0 && maintenanceType != 'none';

    // Build sharing options from rentConfig if available
    final sharingOptions = <MapEntry<String, double>>[];
    if (rentConfig.isNotEmpty) {
      if (rentConfig['oneShare'] != null &&
          (rentConfig['oneShare'] as num) > 0) {
        sharingOptions
            .add(MapEntry('1', (rentConfig['oneShare'] as num).toDouble()));
      }
      if (rentConfig['twoShare'] != null &&
          (rentConfig['twoShare'] as num) > 0) {
        sharingOptions
            .add(MapEntry('2', (rentConfig['twoShare'] as num).toDouble()));
      }
      if (rentConfig['threeShare'] != null &&
          (rentConfig['threeShare'] as num) > 0) {
        sharingOptions
            .add(MapEntry('3', (rentConfig['threeShare'] as num).toDouble()));
      }
      if (rentConfig['fourShare'] != null &&
          (rentConfig['fourShare'] as num) > 0) {
        sharingOptions
            .add(MapEntry('4', (rentConfig['fourShare'] as num).toDouble()));
      }
      if (rentConfig['fiveShare'] != null &&
          (rentConfig['fiveShare'] as num) > 0) {
        sharingOptions
            .add(MapEntry('5', (rentConfig['fiveShare'] as num).toDouble()));
      }
    }

    return SectionContainer(
      title: loc?.pricingAvailability ??
          _text('pricingAvailability', 'Pricing & Availability'),
      icon: Icons.attach_money,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sharing Options with Prices (Primary - from rentConfig)
          if (sharingOptions.isNotEmpty) ...[
            AdaptiveCard(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingSmall(
                    text: loc?.sharingOptionsPricing ??
                        _text('sharingOptionsPricing', 'Sharing Options & Pricing'),
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  ...sharingOptions.map((entry) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.paddingS),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.bed,
                                  size: 18, color: colorScheme.primary),
                              const SizedBox(width: AppSpacing.paddingXS),
                              BodyText(
                                text: loc?.sharingLabel(
                                      int.tryParse(entry.key) ?? 0,
                                    ) ??
                                    _text(
                                      'sharingLabelDefault',
                                      '{count} Sharing',
                                      parameters: {'count': entry.key},
                                    ),
                                medium: true,
                              ),
                            ],
                          ),
                          Text(
                            loc?.monthlyRentDisplay(
                                  _formatCurrency(entry.value),
                                ) ??
                                _text(
                                  'monthlyRentDisplay',
                                  '₹{amount}/month',
                                  parameters: {
                                    'amount': _formatCurrency(entry.value),
                                  },
                                ),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.paddingM),
          ] else if (summary.isNotEmpty) ...[
            // Fallback to summary if rentConfig not available
            AdaptiveCard(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingSmall(
                    text: loc?.sharingOptionsPricing ??
                        _text('sharingOptionsPricing', 'Sharing Options & Pricing'),
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  ...summary.entries.map((entry) {
                    final sharingType = entry.key.replaceAll('-share', '');
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: AppSpacing.paddingS),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.bed,
                                  size: 18, color: colorScheme.primary),
                              const SizedBox(width: AppSpacing.paddingXS),
                              BodyText(
                                text: loc?.sharingLabel(
                                      int.tryParse(sharingType) ?? 0,
                                    ) ??
                                    _text(
                                      'sharingLabelDefault',
                                      '{count} Sharing',
                                      parameters: {'count': sharingType},
                                    ),
                                medium: true,
                              ),
                            ],
                          ),
                          Text(
                            loc?.monthlyRentDisplay(
                                  _formatCurrency(
                                      entry.value.pricePerBed.toDouble()),
                                ) ??
                                _text(
                                  'monthlyRentDisplay',
                                  '₹{amount}/month',
                                  parameters: {
                                    'amount': _formatCurrency(
                                        entry.value.pricePerBed.toDouble()),
                                  },
                                ),
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.paddingM),
          ],

          // Key Pricing Info Cards
          Wrap(
            spacing: AppSpacing.paddingM,
            runSpacing: AppSpacing.paddingM,
            children: [
              if (deposit > 0)
                _buildPricingCard(
                  context,
              loc?.securityDeposit ??
                  _text('securityDeposit', 'Security Deposit'),
              _text(
                'currencyAmount',
                '₹{amount}',
                parameters: {'amount': _formatCurrency(deposit)},
              ),
                  Icons.security,
                ),
              if (hasMaintenance)
                _buildPricingCard(
                  context,
                  loc?.maintenance ?? _text('maintenance', 'Maintenance'),
              (() {
                final perMonthLabel =
                    loc?.perMonth ?? _text('perMonth', 'Per Month');
                final oneTimeLabel =
                    loc?.oneTime ?? _text('oneTime', 'one-time');
                return loc?.maintenanceAmountWithFrequency(
                      _formatCurrency(maintenanceAmount),
                      maintenanceType == 'monthly'
                          ? perMonthLabel
                          : oneTimeLabel,
                    ) ??
                  _text(
                    'maintenanceAmountWithFrequency',
                    '₹{amount}/{frequency}',
                    parameters: {
                      'amount': _formatCurrency(maintenanceAmount),
                      'frequency': maintenanceType == 'monthly'
                          ? perMonthLabel
                          : oneTimeLabel,
                    },
                  );
              })(),
                  Icons.build,
                ),
            ],
          ),

          const SizedBox(height: AppSpacing.paddingM),

          // Total Initial Payment Breakdown
          _buildTotalPaymentBreakdown(
              pg,
              pricing,
              summary,
              deposit,
              maintenanceAmount,
              sharingOptions.isEmpty ? null : sharingOptions),

          const SizedBox(height: AppSpacing.paddingM),

          // Availability Status
          if (summary.isNotEmpty || sharingOptions.isNotEmpty)
            _buildAvailabilityStatus(summary, sharingOptions),
        ],
      ),
    );
  }

  Widget _buildPricingCard(
      BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Expanded(
      child: AdaptiveCard(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: colorScheme.primary),
                const SizedBox(width: AppSpacing.paddingXS),
                Expanded(
                  child: CaptionText(text: label),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingXS),
            BodyText(
              text: value,
              medium: true,
              color: colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingRow(String label, String value,
      {bool isProminent = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: isProminent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isProminent ? colorScheme.primary : colorScheme.onSurface,
            fontWeight: isProminent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalPaymentBreakdown(
      dynamic pg,
      Map pricing,
      SharingSummary summary,
      double deposit,
      double maintenance,
      List<MapEntry<String, double>>? sharingOptions) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    // Get minimum rent from sharing options or summary
    double firstMonthRent = 0.0;
    if (sharingOptions != null && sharingOptions.isNotEmpty) {
      firstMonthRent =
          sharingOptions.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    } else if (summary.isNotEmpty) {
      firstMonthRent = _getMonthlyRentValue(pricing, summary);
    }

    // Get maintenance type
    final maintenanceType = pg.maintenanceType ?? 'none';
    final isMaintenanceMonthly = maintenanceType == 'monthly';

    final total = firstMonthRent + deposit + maintenance;

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calculate, color: colorScheme.primary, size: 20),
              const SizedBox(width: AppSpacing.paddingXS),
              HeadingSmall(
                text: loc?.totalInitialPayment ??
                    _text('totalInitialPayment', 'Total Initial Payment'),
                color: colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          if (firstMonthRent > 0)
            _buildPricingRow(
              loc?.firstMonthRent ??
                  _text('firstMonthRent', 'First Month Rent'),
              _text('currencyAmount', '₹{amount}',
                  parameters: {'amount': _formatCurrency(firstMonthRent)}),
            ),
          if (firstMonthRent > 0 && deposit > 0)
            const SizedBox(height: AppSpacing.paddingXS),
          if (deposit > 0)
            _buildPricingRowWithNote(
              loc?.securityDeposit ??
                  _text('securityDeposit', 'Security Deposit'),
              _text('currencyAmount', '₹{amount}',
                  parameters: {'amount': _formatCurrency(deposit)}),
              loc?.refundableWhenYouLeave ??
                  _text('refundableWhenYouLeave', '(Refundable when you leave)'),
            ),
          if (deposit > 0 && maintenance > 0)
            const SizedBox(height: AppSpacing.paddingXS),
          if (maintenance > 0)
            _buildPricingRowWithNote(
              loc?.maintenance ?? _text('maintenance', 'Maintenance'),
              _text('currencyAmount', '₹{amount}',
                  parameters: {'amount': _formatCurrency(maintenance)}),
              isMaintenanceMonthly
                  ? (loc?.monthlyLabel ??
                      _text('monthlyLabel', '(Monthly)'))
                  : (loc?.oneTimeLabel ??
                      _text('oneTimeLabel', '(One-time)')),
            ),
          if (total > 0) ...[
            Divider(
                height: AppSpacing.paddingM,
                color: colorScheme.outline.withValues(alpha: 0.5)),
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingS),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeadingSmall(
                    text: loc?.totalLabel ?? _text('totalLabel', 'Total'),
                    color: colorScheme.primary,
                  ),
                  HeadingSmall(
                    text: _text('currencyAmount', '₹{amount}',
                        parameters: {'amount': _formatCurrency(total)}),
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.paddingM),
          // Note about 2nd month onwards
          Container(
            padding: const EdgeInsets.all(AppSpacing.paddingS),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: AppSpacing.paddingXS),
                Expanded(
                  child: BodyText(
                    text: isMaintenanceMonthly && maintenance > 0
                        ? loc?.secondMonthRentMaintenance(
                              _formatCurrency(firstMonthRent),
                              _formatCurrency(maintenance),
                              _formatCurrency(firstMonthRent + maintenance),
                            ) ??
                            _text(
                              'secondMonthRentMaintenance',
                              'From 2nd month onwards: Rent + Maintenance (₹{rent} + ₹{maintenance} = ₹{total})',
                              parameters: {
                                'rent': _formatCurrency(firstMonthRent),
                                'maintenance': _formatCurrency(maintenance),
                                'total': _formatCurrency(
                                    firstMonthRent + maintenance),
                              },
                            )
                        : loc?.secondMonthRentOnly(
                              _formatCurrency(firstMonthRent),
                            ) ??
                            _text(
                              'secondMonthRentOnly',
                              'From 2nd month onwards: Only Rent (₹{rent})',
                              parameters: {
                                'rent': _formatCurrency(firstMonthRent),
                              },
                            ),
                    small: true,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingRowWithNote(String label, String value, String note) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            note,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilityStatus(
      SharingSummary summary, List<MapEntry<String, double>> sharingOptions) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final availableTypes = <String>[];
    final loc = AppLocalizations.of(context);

    // Get from sharingOptions first (rentConfig)
    if (sharingOptions.isNotEmpty) {
      availableTypes.addAll(sharingOptions
          .map(
            (e) => loc?.sharingLabel(int.tryParse(e.key) ?? 0) ??
                _text(
                  'sharingLabelDefault',
                  '{count} Sharing',
                  parameters: {'count': e.key},
                ),
          )
          .toList());
    } else if (summary.isNotEmpty) {
      // Fallback to summary
      availableTypes.addAll(summary.keys
          .map(
            (k) => loc?.sharingLabel(
                  int.tryParse(k.replaceAll('-share', '')) ?? 0,
                ) ??
                _text(
                  'sharingLabelDefault',
                  '{count} Sharing',
                  parameters: {
                    'count': k.replaceAll('-share', ''),
                  },
                ),
          )
          .toList());
    }

    availableTypes.sort();

    if (availableTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    final successColor = colorScheme.tertiaryContainer != colorScheme.surface
        ? colorScheme.tertiary
        : Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF4CAF50)
            : const Color(0xFF2E7D32);

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: successColor, size: 20),
          const SizedBox(width: AppSpacing.paddingS),
          Expanded(
            child: BodyText(
              text: loc?.availableTypes(availableTypes.join(', ')) ??
                  _text(
                    'availableTypes',
                    'Available: {types}',
                    parameters: {
                      'types': availableTypes.join(', '),
                    },
                  ),
              medium: true,
              color: successColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Section 3: Location & Vicinity
  Widget _buildLocationSection(BuildContext context, dynamic pg) {
    final loc = AppLocalizations.of(context);
    return SectionContainer(
      title: loc?.locationVicinity ??
          _text('locationVicinity', 'Location & Vicinity'),
      icon: Icons.location_on,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdaptiveCard(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                      loc?.completeAddress ??
                          _text('completeAddress', 'Complete Address'),
                      pg.address),
                const SizedBox(height: AppSpacing.paddingS),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(
                        loc?.areaLabel ?? _text('areaLabel', 'Area'),
                        pg.area,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.paddingM),
                    Expanded(
                      child: _buildInfoRow(
                        loc?.cityLabel ?? _text('cityLabel', 'City'),
                        pg.city,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.paddingS),
                _buildInfoRow(
                    loc?.stateLabel ?? _text('stateLabel', 'State'), pg.state),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.paddingM),
          // Interactive Map Button
          if (pg.hasLocation || pg.googleMapLink != null)
            PrimaryButton(
              label: loc?.viewOnMap ?? _text('viewOnMap', 'View on Map'),
              icon: Icons.map,
              onPressed: () => _openMap(context, pg),
            ),
        ],
      ),
    );
  }

  /// Section 4: Facilities & Amenities
  Widget _buildAmenitiesSection(BuildContext context, dynamic pg) {
    if (!pg.hasAmenities) {
      return const SizedBox.shrink();
    }

    return SectionContainer(
      title: AppLocalizations.of(context)?.facilitiesAmenities ??
          _text('facilitiesAmenities', 'Facilities & Amenities'),
      icon: Icons.room_service,
      child: AdaptiveCard(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: GuestAmenitiesList(amenities: pg.amenities),
      ),
    );
  }

  /// Section 5: Food & Meal Information
  Widget _buildFoodSection(BuildContext context, dynamic pg) {
    if (pg.mealType == null &&
        pg.mealTimings == null &&
        pg.foodQuality == null) {
      return const SizedBox.shrink();
    }

    final loc = AppLocalizations.of(context);

    return SectionContainer(
      title: AppLocalizations.of(context)?.foodMealInformation ??
          _text('foodMealInformation', 'Food & Meal Information'),
      icon: Icons.restaurant,
      child: AdaptiveCard(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pg.mealType != null)
              _buildInfoRow(
                loc?.mealTypeFieldLabel ??
                    _text('mealTypeFieldLabel', 'Meal Type'),
                pg.mealType!,
              ),
            if (pg.mealType != null &&
                (pg.mealTimings != null || pg.foodQuality != null))
              const SizedBox(height: AppSpacing.paddingS),
            if (pg.mealTimings != null && pg.mealTimings!.isNotEmpty)
              _buildInfoRow(
                loc?.mealTimingsFieldLabel ??
                    _text('mealTimingsFieldLabel', 'Meal Timings'),
                pg.mealTimings!,
              ),
            if (pg.mealTimings != null &&
                pg.foodQuality != null &&
                pg.foodQuality!.isNotEmpty)
              const SizedBox(height: AppSpacing.paddingS),
            if (pg.foodQuality != null && pg.foodQuality!.isNotEmpty)
              _buildInfoRow(
                loc?.foodQualityFieldLabel ??
                    _text('foodQualityFieldLabel', 'Food Quality'),
                pg.foodQuality!,
              ),
          ],
        ),
      ),
    );
  }

  /// Section 6: Rules & Policies
  Widget _buildRulesSection(BuildContext context, dynamic pg) {
    if (pg.rules == null || pg.rules!.isEmpty) {
      return const SizedBox.shrink();
    }

    final loc = AppLocalizations.of(context);

    return SectionContainer(
      title: AppLocalizations.of(context)?.rulesPolicies ??
          _text('rulesPolicies', 'Rules & Policies'),
      icon: Icons.rule,
      child: AdaptiveCard(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pg.rules!['entryTimings'] != null) ...[
              _buildInfoRow(
                  loc?.entryTimings ??
                      _text('entryTimings', 'Entry Timings'),
                  pg.rules!['entryTimings'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['exitTimings'] != null) ...[
              _buildInfoRow(
                  loc?.exitTimings ?? _text('exitTimings', 'Exit Timings'),
                  pg.rules!['exitTimings'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['guestPolicy'] != null) ...[
              _buildInfoRow(
                  loc?.guestPolicy ?? _text('guestPolicy', 'Guest Policy'),
                  pg.rules!['guestPolicy'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['smokingPolicy'] != null) ...[
              _buildInfoRow(
                  loc?.smokingPolicy ??
                      _text('smokingPolicy', 'Smoking Policy'),
                  pg.rules!['smokingPolicy'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['alcoholPolicy'] != null) ...[
              _buildInfoRow(
                  loc?.alcoholPolicy ??
                      _text('alcoholPolicy', 'Alcohol Policy'),
                  pg.rules!['alcoholPolicy'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['refundPolicy'] != null) ...[
              _buildInfoRow(
                  loc?.refundPolicy ?? _text('refundPolicy', 'Refund Policy'),
                  pg.rules!['refundPolicy'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['noticePeriod'] != null)
              _buildInfoRow(
                loc?.noticePeriod ?? _text('noticePeriod', 'Notice Period'),
                pg.rules!['noticePeriod'].toString(),
              ),
          ],
        ),
      ),
    );
  }

  /// Section 7: Contact & Owner Information
  Widget _buildContactSection(BuildContext context, dynamic pg) {
    if (pg.ownerName == null && pg.contactNumber == null && pg.email == null) {
      return const SizedBox.shrink();
    }

    final loc = AppLocalizations.of(context);

    return SectionContainer(
      title: AppLocalizations.of(context)?.contactOwnerInformation ??
          _text('contactOwnerInformation', 'Contact & Owner Information'),
      icon: Icons.person,
      child: AdaptiveCard(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pg.ownerName != null) ...[
              _buildInfoRow(
                  loc?.ownerNameLabel ?? _text('ownerNameLabel', 'Owner Name'),
                  pg.ownerName!),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.contactNumber != null) ...[
              GestureDetector(
                onTap: () => _callOwner(pg.contactNumber!),
                child: _buildInfoRow(
                  loc?.contactNumberLabel ??
                      _text('contactNumberLabel', 'Contact Number'),
                  pg.contactNumber!,
                  isClickable: true,
                ),
              ),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.email != null)
              GestureDetector(
                onTap: () => _emailOwner(pg.email!),
                child: _buildInfoRow(
                  loc?.emailLabel ?? _text('emailLabel', 'Email'),
                  pg.email!,
                  isClickable: true,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Section 8: Payment Information
  Widget _buildPaymentSection(BuildContext context, dynamic pg) {
    final bankDetails = pg.bankDetails;
    if (bankDetails.isEmpty) {
      return const SizedBox.shrink();
    }
    final loc = AppLocalizations.of(context);

    return SectionContainer(
      title: AppLocalizations.of(context)?.paymentInformation ??
          _text('paymentInformation', 'Payment Information'),
      icon: Icons.account_balance,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdaptiveCard(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (bankDetails['accountHolderName'] != null) ...[
                  _buildInfoRow(
                      loc?.accountHolder ??
                          _text('accountHolder', 'Account Holder'),
                      bankDetails['accountHolderName'].toString()),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (bankDetails['accountNumber'] != null) ...[
                  _buildInfoRow(
                      loc?.accountNumber ??
                          _text('accountNumber', 'Account Number'),
                      bankDetails['accountNumber'].toString()),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (bankDetails['IFSC'] != null) ...[
                  _buildInfoRow(
                      loc?.ifscCode ?? _text('ifscCode', 'IFSC Code'),
                      bankDetails['IFSC'].toString()),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (bankDetails['UPI'] != null)
                  _buildInfoRow(
                      loc?.upiId ?? _text('upiId', 'UPI ID'),
                      bankDetails['UPI'].toString()),
              ],
            ),
          ),
          // QR Code
          if (bankDetails['QRCodeUrl'] != null) ...[
            const SizedBox(height: AppSpacing.paddingM),
            AdaptiveCard(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                children: [
                  HeadingSmall(
                    text: loc?.qrCodeForPayment ??
                        _text('qrCodeForPayment', 'QR Code for Payment'),
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  AdaptiveImage(
                    imageUrl: bankDetails['QRCodeUrl']!,
                    height: 200,
                    width: 200,
                    placeholder: const Icon(Icons.qr_code, size: 100),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Section 9: Additional Information
  Widget _buildAdditionalInfoSection(BuildContext context, dynamic pg) {
    final hasInfo = (pg.description != null && pg.description!.isNotEmpty) ||
        pg.pgType != null ||
        (pg.parkingDetails != null && pg.parkingDetails!.isNotEmpty) ||
        (pg.securityMeasures != null && pg.securityMeasures!.isNotEmpty) ||
        (pg.paymentInstructions != null &&
            pg.paymentInstructions!.isNotEmpty) ||
        (pg.nearbyPlaces != null && pg.nearbyPlaces!.isNotEmpty);

    if (!hasInfo) {
      return const SizedBox.shrink();
    }

    final loc = AppLocalizations.of(context);

    return SectionContainer(
      title: AppLocalizations.of(context)?.additionalInformation ??
          _text('additionalInformation', 'Additional Information'),
      icon: Icons.info_outline,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdaptiveCard(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pg.description != null && pg.description!.isNotEmpty) ...[
                  _buildInfoRow(
                      loc?.descriptionLabel ??
                          _text('descriptionLabel', 'Description'),
                      pg.description!),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (pg.pgType != null) ...[
                  _buildInfoRow(
                      loc?.pgTypeFieldLabel ??
                          _text('pgTypeFieldLabel', 'PG Type'),
                      pg.pgType!),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (pg.parkingDetails != null &&
                    pg.parkingDetails!.isNotEmpty) ...[
                  _buildInfoRow(
                      loc?.parkingDetails ??
                          _text('parkingDetails', 'Parking Details'),
                      pg.parkingDetails!),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (pg.securityMeasures != null &&
                    pg.securityMeasures!.isNotEmpty)
                  _buildInfoRow(
                      loc?.securityMeasures ??
                          _text('securityMeasures', 'Security Measures'),
                      pg.securityMeasures!),
              ],
            ),
          ),
          if (pg.paymentInstructions != null &&
              pg.paymentInstructions!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.paddingM),
            AdaptiveCard(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.payment,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: AppSpacing.paddingXS),
                      HeadingSmall(
                        text: loc?.paymentInstructionsLabel ??
                            _text('paymentInstructionsLabel',
                                'Payment Instructions'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.paddingS),
                  BodyText(text: pg.paymentInstructions!),
                ],
              ),
            ),
          ],
          if (pg.nearbyPlaces != null && pg.nearbyPlaces!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.paddingM),
            AdaptiveCard(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: AppSpacing.paddingXS),
                      HeadingSmall(
                          text: loc?.nearbyPlacesLabel ??
                              _text('nearbyPlacesLabel', 'Nearby Places')),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  ...pg.nearbyPlaces!.map((place) => Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.paddingS),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.place,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: AppSpacing.paddingXS),
                            Expanded(child: BodyText(text: place)),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Section 10: Sticky Action Buttons
  Widget _buildStickyActionButtons(BuildContext context, dynamic pg) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: AppLocalizations.of(context)?.callOwner ??
                    _text('callOwner', 'Call Owner'),
                icon: Icons.phone,
                onPressed: pg.contactNumber != null
                    ? () => _callOwner(pg.contactNumber!)
                    : null,
              ),
            ),
            const SizedBox(width: AppSpacing.paddingS),
            Expanded(
              child: SecondaryButton(
                label: AppLocalizations.of(context)?.sharePg ??
                    _text('sharePg', 'Share PG'),
                icon: Icons.share,
                onPressed: () => _sharePG(context, pg),
              ),
            ),
            const SizedBox(width: AppSpacing.paddingS),
            Expanded(
              flex: 2,
              child: PrimaryButton(
                label: AppLocalizations.of(context)?.requestBooking ??
                    _text('requestBooking', 'Request Booking'),
                icon: Icons.home_work,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => BookingRequestDialog(pg: pg),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper: Build info row
  Widget _buildInfoRow(String label, String value, {bool isClickable = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: BodyText(
              text: '$label:',
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color:
                    isClickable ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: isClickable ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper: Format currency
  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// Helper: Get monthly rent value
  double _getMonthlyRentValue(Map pricing, SharingSummary summary) {
    if (pricing['monthlyRent'] != null) {
      return pricing['monthlyRent'].toDouble();
    }
    if (summary.isNotEmpty) {
      return summary.values.first.pricePerBed.toDouble();
    }
    return 0.0;
  }

  /// Open map
  Future<void> _openMap(BuildContext context, dynamic pg) async {
    String url;

    if (pg.hasLocation) {
      url =
          'https://www.google.com/maps/search/?api=1&query=${pg.latitude},${pg.longitude}';
    } else if (pg.googleMapLink != null && pg.googleMapLink!.isNotEmpty) {
      url = pg.googleMapLink!;
    } else if (pg.metadata?['googleMapLink'] != null) {
      url = pg.metadata!['googleMapLink'].toString();
    } else if (pg.metadata?['mapLink'] != null) {
      url = pg.metadata!['mapLink'].toString();
    } else {
      // Fallback to address search
      final query = Uri.encodeComponent(pg.fullAddress);
      url = 'https://www.google.com/maps/search/?api=1&query=$query';
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)?.couldNotOpenMaps ??
                  _text('couldNotOpenMaps', 'Could not open maps'),
            ),
          ),
        );
    }
  }

  /// Call owner
  Future<void> _callOwner(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Email owner
  Future<void> _emailOwner(String email) async {
    final uri = Uri.parse('mailto:$email');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// Share PG details using system share
  Future<void> _sharePG(BuildContext context, dynamic pg) async {
    if (pg == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)?.pgInformationNotAvailable ??
                _text('pgInformationNotAvailable', 'PG information not available'),
          ),
        ),
      );
      return;
    }

    try {
      final loc = AppLocalizations.of(context);
      // Build shareable text with PG details
      final StringBuffer shareText = StringBuffer();
      final pgName =
          pg.pgName ?? (loc?.pgProperty ?? _text('pgProperty', 'PG Property'));
      shareText.writeln(
        loc?.sharePgHeading(pgName) ??
            _text('sharePgHeading', '🏠 {name}',
                parameters: {'name': pgName}),
      );
      shareText.writeln();
      
      if (pg.pgAddress != null && pg.pgAddress.isNotEmpty) {
        shareText.writeln(
          loc?.sharePgAddressLine(pg.pgAddress) ??
              _text('sharePgAddressLine', '📍 Address: {address}',
                  parameters: {'address': pg.pgAddress}),
        );
      }
      
      // Add pricing information if available
      final pricing = pg.pricing ?? {};
      final rentConfig = pg.rentConfig ?? {};
      
      if (rentConfig.isNotEmpty || pricing.isNotEmpty) {
        shareText.writeln();
        shareText
            .writeln(loc?.sharePgPricingHeader ?? _text('sharePgPricingHeader', '💰 Pricing:'));
        
        // Show sharing options from rentConfig
        if (rentConfig['oneShare'] != null && (rentConfig['oneShare'] as num) > 0) {
          shareText.writeln(
            loc?.sharePgPricingEntry(
                  '1',
                  _formatCurrency(
                      (rentConfig['oneShare'] as num).toDouble()),
                ) ??
                _text(
                  'sharePgPricingEntry',
                  '{count} Share: ₹{price}',
                  parameters: {
                    'count': '1',
                    'price': _formatCurrency(
                        (rentConfig['oneShare'] as num).toDouble()),
                  },
                ),
          );
        }
        if (rentConfig['twoShare'] != null && (rentConfig['twoShare'] as num) > 0) {
          shareText.writeln(
            loc?.sharePgPricingEntry(
                  '2',
                  _formatCurrency(
                      (rentConfig['twoShare'] as num).toDouble()),
                ) ??
                _text(
                  'sharePgPricingEntry',
                  '{count} Share: ₹{price}',
                  parameters: {
                    'count': '2',
                    'price': _formatCurrency(
                        (rentConfig['twoShare'] as num).toDouble()),
                  },
                ),
          );
        }
        if (rentConfig['threeShare'] != null && (rentConfig['threeShare'] as num) > 0) {
          shareText.writeln(
            loc?.sharePgPricingEntry(
                  '3',
                  _formatCurrency(
                      (rentConfig['threeShare'] as num).toDouble()),
                ) ??
                _text(
                  'sharePgPricingEntry',
                  '{count} Share: ₹{price}',
                  parameters: {
                    'count': '3',
                    'price': _formatCurrency(
                        (rentConfig['threeShare'] as num).toDouble()),
                  },
                ),
          );
        }
      }
      
      // Add amenities if available
      if (pg.amenities != null && (pg.amenities as List).isNotEmpty) {
        shareText.writeln();
        shareText.writeln(
          loc?.sharePgAmenitiesLine(
                (pg.amenities as List).join(', '),
              ) ??
              _text(
                'sharePgAmenitiesLine',
                '✨ Amenities: {amenities}',
                parameters: {
                  'amenities': (pg.amenities as List).join(", "),
                },
              ),
        );
      }
      
      shareText.writeln();
      shareText.writeln(loc?.sharePgFooter ??
          _text('sharePgFooter', 'Check out this PG on Atitia!'));
      
      // Share using share_plus
      await Share.share(
        shareText.toString(),
        subject: '$pgName - Atitia',
      );
      
      // Log analytics
      getIt.analytics.logEvent(
        name: 'pg_shared',
        parameters: {
          'pg_id': pg.pgId ?? '',
          'pg_name': pg.pgName ?? '',
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                AppLocalizations.of(context)?.failedToShare(e.toString()) ??
                    _text('failedToShare', 'Failed to share: {error}',
                        parameters: {'error': e.toString()}),
              ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
