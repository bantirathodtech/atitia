import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../l10n/app_localizations.dart';

/// Widget displaying PG amenities as filter chips
/// Uses common UI components for consistent styling
class GuestAmenitiesList extends StatelessWidget {
  final List<String> amenities;
  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const GuestAmenitiesList({required this.amenities, super.key});

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations.of(context);

    if (amenities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surfaceContainerHighest
              : colorScheme.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: AppSpacing.paddingS),
            BodyText(
              text: loc?.noAmenitiesListed ??
                  _text('noAmenitiesListed', 'No amenities listed for this PG'),
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: AppSpacing.paddingS,
        runSpacing: AppSpacing.paddingS / 2,
        children: amenities
            .map((amenity) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingS / 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: BodyText(
                    text: amenity,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ))
            .toList(),
      ),
    );
  }
}
