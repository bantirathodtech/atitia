// lib/features/owner_dashboard/mypg/presentation/widgets/owner_booking_request_list_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/styles/spacing.dart';
import '../../data/models/owner_pg_management_model.dart';

/// Widget displaying pending booking requests
class OwnerBookingRequestListWidget extends StatelessWidget {
  final List<OwnerBooking> bookings;

  const OwnerBookingRequestListWidget({
    required this.bookings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingMedium(
              text: 'Pending Requests (${bookings.length})',
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
