// lib/features/owner_dashboard/mypg/presentation/widgets/owner_bed_map_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/indicators/empty_state.dart';
import '../../../../../common/styles/spacing.dart';
import '../../data/models/owner_pg_management_model.dart';

/// Interactive bed map widget showing room and bed occupancy
class OwnerBedMapWidget extends StatelessWidget {
  final List<OwnerBed> beds;
  final List<OwnerRoom> rooms;
  final List<OwnerFloor> floors;

  const OwnerBedMapWidget({
    required this.beds,
    required this.rooms,
    required this.floors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (beds.isEmpty) {
      return const EmptyState(
        title: 'No Beds',
        message: 'Bed map will appear here once beds are added',
        icon: Icons.bed_outlined,
      );
    }

    // Group beds by room
    final roomBeds = _groupBedsByRoom(beds);

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      itemCount: roomBeds.keys.length,
      itemBuilder: (context, index) {
        final roomId = roomBeds.keys.elementAt(index);
        final roomBedsList = roomBeds[roomId]!;
        final room = rooms.firstWhere((r) => r.id == roomId,
            orElse: () =>
                OwnerRoom(id: roomId, floorId: '', roomNumber: 'Unknown'));

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
          child: _buildRoomCard(context, room, roomBedsList),
        );
      },
    );
  }

  Map<String, List<OwnerBed>> _groupBedsByRoom(List<OwnerBed> beds) {
    final Map<String, List<OwnerBed>> grouped = {};
    for (var bed in beds) {
      if (!grouped.containsKey(bed.roomId)) {
        grouped[bed.roomId] = [];
      }
      grouped[bed.roomId]!.add(bed);
    }
    return grouped;
  }

  Widget _buildRoomCard(
      BuildContext context, OwnerRoom room, List<OwnerBed> roomBeds) {
    final occupiedCount = roomBeds.where((b) => b.isOccupied).length;

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeadingSmall(text: 'Room ${room.roomNumber}'),
                CaptionText(
                  text: '$occupiedCount/${roomBeds.length} occupied',
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Wrap(
              spacing: AppSpacing.paddingS,
              runSpacing: AppSpacing.paddingS,
              children:
                  roomBeds.map((bed) => _buildBedItem(context, bed)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBedItem(BuildContext context, OwnerBed bed) {
    return Container(
      width: 70,
      padding: const EdgeInsets.all(AppSpacing.paddingS),
      decoration: BoxDecoration(
        color: bed.statusColor.withOpacity(0.1),
        border: Border.all(color: bed.statusColor),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      ),
      child: Column(
        children: [
          Icon(bed.isOccupied ? Icons.bed : Icons.bed_outlined,
              color: bed.statusColor, size: 24),
          const SizedBox(height: 4),
          CaptionText(
            text: 'B${bed.bedNumber}',
            color: bed.statusColor,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
