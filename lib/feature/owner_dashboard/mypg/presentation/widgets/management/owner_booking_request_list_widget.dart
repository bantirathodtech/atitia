// lib/features/owner_dashboard/mypg/presentation/widgets/owner_booking_request_list_widget.dart

import 'package:flutter/material.dart';

import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../data/models/owner_pg_management_model.dart';

/// Widget displaying pending booking requests
class OwnerBookingRequestListWidget extends StatelessWidget {
  final List<OwnerBooking> bookings;

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const OwnerBookingRequestListWidget({
    required this.bookings,
    super.key,
  });

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
    final loc = AppLocalizations.of(context);
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(
              text: loc?.ownerBookingRequestsTitle(bookings.length) ??
                  _text('ownerBookingRequestsTitle', 'Pending Requests ({count})',
                      parameters: {'count': bookings.length}),
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            ...bookings.map((booking) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BodyText(text: booking.roomBedDisplay),
                      BodyText(
                        text: booking.formattedStartDate,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
