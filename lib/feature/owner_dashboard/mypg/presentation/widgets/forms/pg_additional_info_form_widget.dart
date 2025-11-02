import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';

/// Additional Information Form Widget
class PgAdditionalInfoFormWidget extends AdaptiveStatelessWidget {
  final TextEditingController parkingDetailsController;
  final TextEditingController securityMeasuresController;
  final TextEditingController paymentInstructionsController;
  final List<String> nearbyPlaces;
  final Function(List<String>) onNearbyPlacesChanged;
  final Function(String) onAddNearbyPlace;

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nearbyPlaceController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: 'Additional Information'),
        const SizedBox(height: AppSpacing.paddingL),

        // Parking Details
        TextInput(
          controller: parkingDetailsController,
          label: 'Parking Details',
          hint:
              'e.g., 2-wheeler parking available, 4-wheeler parking: ₹500/month, Capacity: 20 bikes',
          maxLines: 3,
          keyboardType: TextInputType.multiline,
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Security Measures
        TextInput(
          controller: securityMeasuresController,
          label: 'Security Measures',
          hint:
              'e.g., 24/7 Security guard, CCTV surveillance, Biometric access, Fire safety equipment',
          maxLines: 4,
          keyboardType: TextInputType.multiline,
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Nearby Places
        HeadingMedium(text: 'Nearby Places'),
        const SizedBox(height: AppSpacing.paddingS),
        BodyText(
          text: 'Add nearby landmarks, locations, or points of interest',
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
        ),
        const SizedBox(height: AppSpacing.paddingM),

        Row(
          children: [
            Expanded(
              child: TextInput(
                controller: nearbyPlaceController,
                label: 'Nearby Place',
                hint: 'e.g., Metro Station, Shopping Mall, Hospital',
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
              label: 'Add',
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
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
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
          label: 'Payment Instructions',
          hint:
              'Instructions for making payments, accepted payment methods, payment schedule, etc.',
          maxLines: 4,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
