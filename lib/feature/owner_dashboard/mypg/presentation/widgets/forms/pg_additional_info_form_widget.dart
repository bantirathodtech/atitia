import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../../l10n/app_localizations.dart';

/// Additional Information Form Widget
class PgAdditionalInfoFormWidget extends AdaptiveStatelessWidget {
  final TextEditingController parkingDetailsController;
  final TextEditingController securityMeasuresController;
  final TextEditingController paymentInstructionsController;
  final List<String> nearbyPlaces;
  final Function(List<String>) onNearbyPlacesChanged;
  final Function(String) onAddNearbyPlace;

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

  const PgAdditionalInfoFormWidget({
    super.key,
    required this.parkingDetailsController,
    required this.securityMeasuresController,
    required this.paymentInstructionsController,
    required this.nearbyPlaces,
    required this.onNearbyPlacesChanged,
    required this.onAddNearbyPlace,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final title = loc?.pgAdditionalInfoTitle ??
        _text('pgAdditionalInfoTitle', 'Additional Information');
    final nearbyPlaceController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: title),
        const SizedBox(height: AppSpacing.paddingL),

        // Parking Details
        TextInput(
          controller: parkingDetailsController,
          label: loc?.pgAdditionalInfoParkingLabel ??
              _text('pgAdditionalInfoParkingLabel', 'Parking Details'),
          hint: loc?.pgAdditionalInfoParkingHint ??
              _text(
                'pgAdditionalInfoParkingHint',
                'e.g., 2-wheeler parking available, 4-wheeler parking: ₹500/month, Capacity: 20 bikes',
              ),
          maxLines: 3,
          keyboardType: TextInputType.multiline,
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Security Measures
        TextInput(
          controller: securityMeasuresController,
          label: loc?.pgAdditionalInfoSecurityLabel ??
              _text('pgAdditionalInfoSecurityLabel', 'Security Measures'),
          hint: loc?.pgAdditionalInfoSecurityHint ??
              _text(
                'pgAdditionalInfoSecurityHint',
                'e.g., 24/7 Security guard, CCTV surveillance, Biometric access, Fire safety equipment',
              ),
          maxLines: 4,
          keyboardType: TextInputType.multiline,
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Nearby Places
        HeadingMedium(
            text: loc?.pgAdditionalInfoNearbyPlacesTitle ??
                _text('pgAdditionalInfoNearbyPlacesTitle', 'Nearby Places')),
        const SizedBox(height: AppSpacing.paddingS),
        BodyText(
          text: loc?.pgAdditionalInfoNearbyPlacesDescription ??
              _text('pgAdditionalInfoNearbyPlacesDescription',
                  'Add nearby landmarks, locations, or points of interest'),
          color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(height: AppSpacing.paddingM),

        Row(
          children: [
            Expanded(
              child: TextInput(
                controller: nearbyPlaceController,
                label: loc?.pgAdditionalInfoNearbyPlaceLabel ??
                    _text('pgAdditionalInfoNearbyPlaceLabel', 'Nearby Place'),
                hint: loc?.pgAdditionalInfoNearbyPlaceHint ??
                    _text(
                      'pgAdditionalInfoNearbyPlaceHint',
                      'e.g., Metro Station, Shopping Mall, Hospital',
                    ),
              ),
            ),
            const SizedBox(width: AppSpacing.paddingM),
            SecondaryButton(
              onPressed: () {
                final place = nearbyPlaceController.text.trim();
                if (place.isNotEmpty) {
                  onAddNearbyPlace(place);
                  nearbyPlaceController.clear();
                }
              },
              label: loc?.pgAdditionalInfoAddButton ??
                  _text('pgAdditionalInfoAddButton', 'Add'),
              icon: Icons.add,
            ),
          ],
        ),

        if (nearbyPlaces.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.paddingM),
          Wrap(
            spacing: AppSpacing.paddingS,
            runSpacing: AppSpacing.paddingS,
            children: nearbyPlaces.map((place) {
              return AdaptiveCard(
                onTap: () {
                  final updated = List<String>.from(nearbyPlaces)
                    ..remove(place);
                  onNearbyPlacesChanged(updated);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingM,
                    vertical: AppSpacing.paddingS,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BodyText(text: place),
                      const SizedBox(width: AppSpacing.paddingXS),
                      Icon(
                        Icons.close,
                        size: 16,
                        color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6) ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],

        const SizedBox(height: AppSpacing.paddingL),

        // Payment Instructions
        TextInput(
          controller: paymentInstructionsController,
          label: loc?.pgAdditionalInfoPaymentInstructionsLabel ??
              _text('pgAdditionalInfoPaymentInstructionsLabel',
                  'Payment Instructions'),
          hint: loc?.pgAdditionalInfoPaymentInstructionsHint ??
              _text(
                'pgAdditionalInfoPaymentInstructionsHint',
                'Instructions for making payments, accepted payment methods, payment schedule, etc.',
              ),
          maxLines: 4,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
