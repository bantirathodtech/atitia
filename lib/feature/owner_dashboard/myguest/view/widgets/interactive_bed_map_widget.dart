// lib/features/owner_dashboard/myguest/view/widgets/interactive_bed_map_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../data/models/owner_guest_model.dart';

/// Interactive bed map widget showing room and bed occupancy
/// Displays visual representation of PG occupancy status
class InteractiveBedMapWidget extends StatelessWidget {
  final List<OwnerBookingModel> bookings;

  const InteractiveBedMapWidget({
    required this.bookings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (bookings.isEmpty) {
      return EmptyState(
        title: loc.ownerBedMapNoBookingsTitle,
        message: loc.ownerBedMapNoBookingsMessage,
        icon: Icons.bed_outlined,
      );
    }

    // Group bookings by room
    final roomBookings = _groupBookingsByRoom(bookings);

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: roomBookings.keys.length,
      itemBuilder: (context, index) {
        final roomNumber = roomBookings.keys.elementAt(index);
        final roomBookingsList = roomBookings[roomNumber]!;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
          child: _buildRoomCard(context, roomNumber, roomBookingsList, loc),
        );
      },
    );
  }

  /// Groups bookings by room number
  Map<String, List<OwnerBookingModel>> _groupBookingsByRoom(
      List<OwnerBookingModel> bookings) {
    final Map<String, List<OwnerBookingModel>> grouped = {};
    for (var booking in bookings) {
      if (!grouped.containsKey(booking.roomNumber)) {
        grouped[booking.roomNumber] = [];
      }
      grouped[booking.roomNumber]!.add(booking);
    }
    return grouped;
  }

  /// Builds room card with bed occupancy
  Widget _buildRoomCard(
    BuildContext context,
    String roomNumber,
    List<OwnerBookingModel> roomBookings,
    AppLocalizations loc,
  ) {
    final activeBookings = roomBookings.where((b) => b.isActive).length;
    final totalBeds = roomBookings.length;

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.meeting_room,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.paddingS),
                    HeadingSmall(
                      text: loc.ownerBedMapRoom(roomNumber),
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.paddingS,
                    vertical: AppSpacing.paddingXS,
                  ),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusS),
                  ),
                  child: CaptionText(
                    text: loc.ownerBedMapOccupiedCount(
                      activeBookings,
                      totalBeds,
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            // Bed Grid
            Wrap(
              spacing: AppSpacing.paddingS,
              runSpacing: AppSpacing.paddingS,
              children: roomBookings
                  .map((booking) => _buildBedItem(context, booking, loc))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds individual bed item
  Widget _buildBedItem(
    BuildContext context,
    OwnerBookingModel booking,
    AppLocalizations loc,
  ) {
    final isOccupied = booking.isActive;
    final color = isOccupied ? AppColors.success : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);

    return Container(
      width: 80,
      padding: const EdgeInsets.all(AppSpacing.paddingS),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      ),
      child: Column(
        children: [
          Icon(
            isOccupied ? Icons.bed : Icons.bed_outlined,
            color: color,
            size: 24,
          ),
          const SizedBox(height: AppSpacing.paddingXS),
          CaptionText(
            text: loc.bedLabelWithNumber(booking.bedNumber),
            color: color,
            align: TextAlign.center,
          ),
          if (isOccupied) ...[
            const SizedBox(height: 2),
            CaptionText(
              text: loc.occupiedLabel,
              color: color,
              align: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
