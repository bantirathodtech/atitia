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

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: pg?.pgName ?? 'PG Details',
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
              text: 'Error loading PG details',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: pgVM.errorMessage ?? 'Unknown error occurred',
              align: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            PrimaryButton(
              onPressed: () => pgVM.getPGById(widget.pgId),
              label: 'Try Again',
              icon: Icons.refresh,
            ),
          ],
        ),
      );
    }

    if (pg == null) {
      return EmptyState(
        title: 'PG Not Found',
        message:
            'The requested PG could not be found or may have been removed.',
        icon: Icons.apartment,
        actionLabel: 'Go Back',
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
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apartment, size: 64, color: Colors.grey),
                  SizedBox(height: AppSpacing.paddingS),
                  CaptionText(text: 'No photos available'),
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
      title: 'Pricing & Availability',
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
                  const HeadingSmall(text: 'Sharing Options & Pricing'),
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
                                  text: '${entry.key} Sharing', medium: true),
                            ],
                          ),
                          Text(
                            '₹${_formatCurrency(entry.value)}/month',
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
                  const HeadingSmall(text: 'Sharing Options & Pricing'),
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
                                  text: '$sharingType Sharing', medium: true),
                            ],
                          ),
                          Text(
                            '₹${_formatCurrency(entry.value.pricePerBed.toDouble())}/month',
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
                  'Security Deposit',
                  '₹${_formatCurrency(deposit)}',
                  Icons.security,
                ),
              if (hasMaintenance)
                _buildPricingCard(
                  context,
                  'Maintenance',
                  '₹${_formatCurrency(maintenanceAmount)}/${maintenanceType == 'monthly' ? 'month' : 'one-time'}',
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
                  text: 'Total Initial Payment', color: colorScheme.primary),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          if (firstMonthRent > 0)
            _buildPricingRow(
                'First Month Rent', '₹${_formatCurrency(firstMonthRent)}'),
          if (firstMonthRent > 0 && deposit > 0)
            const SizedBox(height: AppSpacing.paddingXS),
          if (deposit > 0)
            _buildPricingRowWithNote(
              'Security Deposit',
              '₹${_formatCurrency(deposit)}',
              '(Refundable when you leave)',
            ),
          if (deposit > 0 && maintenance > 0)
            const SizedBox(height: AppSpacing.paddingXS),
          if (maintenance > 0)
            _buildPricingRowWithNote(
              'Maintenance',
              '₹${_formatCurrency(maintenance)}',
              isMaintenanceMonthly ? '(Monthly)' : '(One-time)',
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
                  HeadingSmall(text: 'Total', color: colorScheme.primary),
                  HeadingSmall(
                    text: '₹${_formatCurrency(total)}',
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
                        ? 'From 2nd month onwards: Rent + Maintenance (₹${_formatCurrency(firstMonthRent)} + ₹${_formatCurrency(maintenance)} = ₹${_formatCurrency(firstMonthRent + maintenance)})'
                        : 'From 2nd month onwards: Only Rent (₹${_formatCurrency(firstMonthRent)})',
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

    // Get from sharingOptions first (rentConfig)
    if (sharingOptions.isNotEmpty) {
      availableTypes
          .addAll(sharingOptions.map((e) => '${e.key} sharing').toList());
    } else if (summary.isNotEmpty) {
      // Fallback to summary
      availableTypes.addAll(summary.keys
          .map((k) => '${k.replaceAll('-share', '')} sharing')
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
              text: 'Available: ${availableTypes.join(", ")}',
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
    return SectionContainer(
      title: 'Location & Vicinity',
      icon: Icons.location_on,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdaptiveCard(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Complete Address', pg.address),
                const SizedBox(height: AppSpacing.paddingS),
                Row(
                  children: [
                    Expanded(child: _buildInfoRow('Area', pg.area)),
                    const SizedBox(width: AppSpacing.paddingM),
                    Expanded(child: _buildInfoRow('City', pg.city)),
                  ],
                ),
                const SizedBox(height: AppSpacing.paddingS),
                _buildInfoRow('State', pg.state),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.paddingM),
          // Interactive Map Button
          if (pg.hasLocation || pg.googleMapLink != null)
            PrimaryButton(
              label: 'View on Map',
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
      title: 'Facilities & Amenities',
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

    return SectionContainer(
      title: 'Food & Meal Information',
      icon: Icons.restaurant,
      child: AdaptiveCard(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pg.mealType != null) _buildInfoRow('Meal Type', pg.mealType!),
            if (pg.mealType != null &&
                (pg.mealTimings != null || pg.foodQuality != null))
              const SizedBox(height: AppSpacing.paddingS),
            if (pg.mealTimings != null && pg.mealTimings!.isNotEmpty)
              _buildInfoRow('Meal Timings', pg.mealTimings!),
            if (pg.mealTimings != null &&
                pg.foodQuality != null &&
                pg.foodQuality!.isNotEmpty)
              const SizedBox(height: AppSpacing.paddingS),
            if (pg.foodQuality != null && pg.foodQuality!.isNotEmpty)
              _buildInfoRow('Food Quality', pg.foodQuality!),
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

    return SectionContainer(
      title: 'Rules & Policies',
      icon: Icons.rule,
      child: AdaptiveCard(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pg.rules!['entryTimings'] != null) ...[
              _buildInfoRow(
                  'Entry Timings', pg.rules!['entryTimings'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['exitTimings'] != null) ...[
              _buildInfoRow(
                  'Exit Timings', pg.rules!['exitTimings'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['guestPolicy'] != null) ...[
              _buildInfoRow(
                  'Guest Policy', pg.rules!['guestPolicy'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['smokingPolicy'] != null) ...[
              _buildInfoRow(
                  'Smoking Policy', pg.rules!['smokingPolicy'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['alcoholPolicy'] != null) ...[
              _buildInfoRow(
                  'Alcohol Policy', pg.rules!['alcoholPolicy'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['refundPolicy'] != null) ...[
              _buildInfoRow(
                  'Refund Policy', pg.rules!['refundPolicy'].toString()),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.rules!['noticePeriod'] != null)
              _buildInfoRow(
                  'Notice Period', pg.rules!['noticePeriod'].toString()),
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

    return SectionContainer(
      title: 'Contact & Owner Information',
      icon: Icons.person,
      child: AdaptiveCard(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (pg.ownerName != null) ...[
              _buildInfoRow('Owner Name', pg.ownerName!),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.contactNumber != null) ...[
              GestureDetector(
                onTap: () => _callOwner(pg.contactNumber!),
                child: _buildInfoRow('Contact Number', pg.contactNumber!,
                    isClickable: true),
              ),
              const SizedBox(height: AppSpacing.paddingS),
            ],
            if (pg.email != null)
              GestureDetector(
                onTap: () => _emailOwner(pg.email!),
                child: _buildInfoRow('Email', pg.email!, isClickable: true),
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

    return SectionContainer(
      title: 'Payment Information',
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
                  _buildInfoRow('Account Holder',
                      bankDetails['accountHolderName'].toString()),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (bankDetails['accountNumber'] != null) ...[
                  _buildInfoRow('Account Number',
                      bankDetails['accountNumber'].toString()),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (bankDetails['IFSC'] != null) ...[
                  _buildInfoRow('IFSC Code', bankDetails['IFSC'].toString()),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (bankDetails['UPI'] != null)
                  _buildInfoRow('UPI ID', bankDetails['UPI'].toString()),
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
                  const HeadingSmall(text: 'QR Code for Payment'),
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

    return SectionContainer(
      title: 'Additional Information',
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
                  _buildInfoRow('Description', pg.description!),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (pg.pgType != null) ...[
                  _buildInfoRow('PG Type', pg.pgType!),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (pg.parkingDetails != null &&
                    pg.parkingDetails!.isNotEmpty) ...[
                  _buildInfoRow('Parking Details', pg.parkingDetails!),
                  const SizedBox(height: AppSpacing.paddingS),
                ],
                if (pg.securityMeasures != null &&
                    pg.securityMeasures!.isNotEmpty)
                  _buildInfoRow('Security Measures', pg.securityMeasures!),
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
                      const HeadingSmall(text: 'Payment Instructions'),
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
                      const HeadingSmall(text: 'Nearby Places'),
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
                label: 'Call Owner',
                icon: Icons.phone,
                onPressed: pg.contactNumber != null
                    ? () => _callOwner(pg.contactNumber!)
                    : null,
              ),
            ),
            const SizedBox(width: AppSpacing.paddingS),
            Expanded(
              child: SecondaryButton(
                label: 'Share PG',
                icon: Icons.share,
                onPressed: () => _sharePG(context, pg),
              ),
            ),
            const SizedBox(width: AppSpacing.paddingS),
            Expanded(
              flex: 2,
              child: PrimaryButton(
                label: 'Request Booking',
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
        const SnackBar(content: Text('Could not open maps')),
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
        const SnackBar(content: Text('PG information not available')),
      );
      return;
    }

    try {
      // Build shareable text with PG details
      final StringBuffer shareText = StringBuffer();
      shareText.writeln('🏠 ${pg.pgName ?? 'PG Property'}');
      shareText.writeln();
      
      if (pg.pgAddress != null && pg.pgAddress.isNotEmpty) {
        shareText.writeln('📍 Address: ${pg.pgAddress}');
      }
      
      // Add pricing information if available
      final pricing = pg.pricing ?? {};
      final rentConfig = pg.rentConfig ?? {};
      
      if (rentConfig.isNotEmpty || pricing.isNotEmpty) {
        shareText.writeln();
        shareText.writeln('💰 Pricing:');
        
        // Show sharing options from rentConfig
        if (rentConfig['oneShare'] != null && (rentConfig['oneShare'] as num) > 0) {
          shareText.writeln('1 Share: ₹${rentConfig['oneShare']}');
        }
        if (rentConfig['twoShare'] != null && (rentConfig['twoShare'] as num) > 0) {
          shareText.writeln('2 Share: ₹${rentConfig['twoShare']}');
        }
        if (rentConfig['threeShare'] != null && (rentConfig['threeShare'] as num) > 0) {
          shareText.writeln('3 Share: ₹${rentConfig['threeShare']}');
        }
      }
      
      // Add amenities if available
      if (pg.amenities != null && (pg.amenities as List).isNotEmpty) {
        shareText.writeln();
        shareText.writeln('✨ Amenities: ${(pg.amenities as List).join(", ")}');
      }
      
      shareText.writeln();
      shareText.writeln('Check out this PG on Atitia!');
      
      // Share using share_plus
      await Share.share(
        shareText.toString(),
        subject: '${pg.pgName ?? "PG Property"} - Atitia',
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
            content: Text('Failed to share: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
