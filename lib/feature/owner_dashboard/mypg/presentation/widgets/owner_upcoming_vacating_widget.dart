// lib/features/owner_dashboard/mypg/presentation/widgets/owner_upcoming_vacating_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../data/models/owner_pg_management_model.dart';

/// Widget displaying upcoming vacating bookings
class OwnerUpcomingVacatingWidget extends StatelessWidget {
  final List<OwnerBooking> bookings;

  const OwnerUpcomingVacatingWidget({
    required this.bookings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const SizedBox.shrink();
    }

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(
              text: 'Upcoming Vacating (${bookings.length})',
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            ...bookings.map((booking) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BodyText(text: booking.roomBedDisplay),
                      CaptionText(
                        text: booking.formattedEndDate,
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
