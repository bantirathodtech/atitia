// lib/features/owner_dashboard/mypg/presentation/widgets/owner_bed_map_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/grids/responsive_grid.dart';
import '../../../../../../common/widgets/text/caption_text.dart';
import '../../../../../../common/widgets/text/heading_small.dart';
import '../../../../../../common/widgets/chips/status_chip.dart';
import '../../../data/models/owner_pg_management_model.dart';

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
    final hasData = beds.isNotEmpty;
    final totalBeds = hasData ? beds.length : 0;
    final occupied = hasData ? beds.where((b) => b.isOccupied).length : 0;
    final vacant = hasData ? beds.where((b) => b.isVacant).length : 0;
    final pending = hasData ? beds.where((b) => b.isPending).length : 0;
    final maintenance =
        hasData ? beds.where((b) => b.isUnderMaintenance).length : 0;

    if (!hasData) {
      return ListView(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        children: [
          _buildOverviewCard(context,
              totalBeds: totalBeds,
              occupied: occupied,
              vacant: vacant,
              pending: pending,
              maintenance: maintenance),
          const SizedBox(height: AppSpacing.paddingM),
          ..._buildRoomPlaceholders(context),
        ],
      );
    }

    // Group beds by room
    final roomBeds = _groupBedsByRoom(beds);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      children: [
        _buildOverviewCard(context,
            totalBeds: totalBeds,
            occupied: occupied,
            vacant: vacant,
            pending: pending,
            maintenance: maintenance),
        const SizedBox(height: AppSpacing.paddingM),
        ...roomBeds.keys.map((roomId) {
          final roomBedsList = roomBeds[roomId]!;
          final room = rooms.firstWhere((r) => r.id == roomId,
              orElse: () =>
                  OwnerRoom(id: roomId, floorId: '', roomNumber: 'Unknown'));

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
            child: _buildRoomCard(context, room, roomBedsList),
          );
        }),
      ],
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
    final theme = Theme.of(context);
    final occupiedCount = roomBeds.where((b) => b.isOccupied).length;
    final vacantCount = roomBeds.where((b) => b.isVacant).length;
    final pendingCount = roomBeds.where((b) => b.isPending).length;
    final maintenanceCount = roomBeds.where((b) => b.isUnderMaintenance).length;
    final total = roomBeds.isEmpty ? 1 : roomBeds.length; // avoid /0
    final occupancy = occupiedCount / total;

    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.meeting_room,
                      size: 18, color: theme.primaryColor),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingSmall(text: room.roomNumber),
                      const SizedBox(height: 2),
                      CaptionText(
                        text:
                            '$occupiedCount/${roomBeds.length} occupied • Capacity ${room.capacity}',
                        color: theme.textTheme.bodySmall?.color ?? Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.paddingS,
                vertical: AppSpacing.paddingXS,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: occupancy.clamp(0, 1).toDouble(),
                        minHeight: 8,
                        backgroundColor:
                            theme.dividerColor.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  CaptionText(
                    text: '${(occupancy * 100).toStringAsFixed(0)}%',
                    color: theme.primaryColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.paddingS),
            ResponsiveGrid(
              targetTileWidth: 220,
              horizontalGap: AppSpacing.paddingS,
              verticalGap: AppSpacing.paddingXS,
              childAspectRatio: 5.0,
              children: [
                StatusChip(
                  color: const Color(0xFF4CAF50),
                  label: 'Occupied $occupiedCount',
                  icon: Icons.person,
                  paddingH: 16,
                  paddingV: 10,
                  iconSize: 18,
                  fontSize: 13,
                ),
                StatusChip(
                  color: const Color(0xFF9E9E9E),
                  label: 'Vacant $vacantCount',
                  icon: Icons.bed_outlined,
                  paddingH: 16,
                  paddingV: 10,
                  iconSize: 18,
                  fontSize: 13,
                ),
                StatusChip(
                  color: const Color(0xFFFFA726),
                  label: 'Pending $pendingCount',
                  icon: Icons.schedule,
                  paddingH: 16,
                  paddingV: 10,
                  iconSize: 18,
                  fontSize: 13,
                ),
                StatusChip(
                  color: const Color(0xFFEF5350),
                  label: 'Maint. $maintenanceCount',
                  icon: Icons.build,
                  paddingH: 16,
                  paddingV: 10,
                  iconSize: 18,
                  fontSize: 13,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            ResponsiveGrid(
              targetTileWidth: 120,
              horizontalGap: AppSpacing.paddingS,
              verticalGap: AppSpacing.paddingS,
              children:
                  roomBeds.map((bed) => _buildBedItem(context, bed)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required int totalBeds,
    required int occupied,
    required int vacant,
    required int pending,
    required int maintenance,
  }) {
    final theme = Theme.of(context);
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bed_rounded, color: theme.primaryColor, size: 20),
                const SizedBox(width: 8),
                HeadingSmall(text: 'Beds Overview'),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildMiniStat(context, '$totalBeds', 'Total',
                      Icons.inventory_2, theme.primaryColor),
                ),
                Expanded(
                  child: _buildMiniStat(context, '$occupied', 'Occupied',
                      Icons.person, const Color(0xFF4CAF50)),
                ),
                Expanded(
                  child: _buildMiniStat(context, '$vacant', 'Vacant',
                      Icons.bed_outlined, const Color(0xFFFFB300)),
                ),
                Expanded(
                  child: _buildMiniStat(context, '$pending', 'Pending',
                      Icons.schedule, const Color(0xFFFFA726)),
                ),
                Expanded(
                  child: _buildMiniStat(context, '$maintenance', 'Maint.',
                      Icons.build, const Color(0xFFEF5350)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(BuildContext context, String value, String label,
      IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          HeadingSmall(text: value, color: color),
          const SizedBox(height: 2),
          CaptionText(text: label, color: color.withValues(alpha: 0.9)),
        ],
      ),
    );
  }

  List<Widget> _buildRoomPlaceholders(BuildContext context) {
    return List.generate(2, (roomIdx) {
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
        child: AdaptiveCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeadingSmall(text: '—'),
                    CaptionText(
                        text: '0/0 occupied',
                        color: Theme.of(context).primaryColor),
                  ],
                ),
                const SizedBox(height: AppSpacing.paddingM),
                ResponsiveGrid(
                  targetTileWidth: 120,
                  horizontalGap: AppSpacing.paddingS,
                  verticalGap: AppSpacing.paddingS,
                  children: List.generate(
                      4, (bedIdx) => _buildBedPlaceholder(context)),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildBedPlaceholder(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.dividerColor.withValues(alpha: 0.5);
    final muted =
        theme.textTheme.bodySmall?.color?.withOpacity(0.35) ?? Colors.grey;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingS),
      decoration: BoxDecoration(
        color: muted.withValues(alpha: 0.1),
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 6),
          Icon(Icons.bed_outlined, color: muted, size: 22),
          const SizedBox(height: 6),
          HeadingSmall(text: '—', color: muted),
        ],
      ),
    );
  }

  // legacy legend chip removed (replaced by StatusChip)

  Widget _buildBedItem(BuildContext context, OwnerBed bed) {
    final theme = Theme.of(context);
    final statusColor = bed.statusColor;
    final bg = statusColor
        .withOpacity(theme.brightness == Brightness.dark ? 0.12 : 0.08);
    final border = statusColor;
    final icon = bed.isOccupied
        ? Icons.person
        : bed.isPending
            ? Icons.schedule
            : bed.isUnderMaintenance
                ? Icons.build
                : Icons.bed_outlined;

    String statusLabel = 'Vacant';
    if (bed.isOccupied) {
      statusLabel = 'Occupied';
    } else if (bed.isPending)
      statusLabel = 'Pending';
    else if (bed.isUnderMaintenance) statusLabel = 'Maint.';

    final tooltipText = StringBuffer()
      ..write('Bed ${bed.bedNumber} • $statusLabel')
      ..write(bed.guestName != null ? '\nGuest: ${bed.guestName}' : '')
      ..write(bed.occupiedSince != null
          ? '\nFrom: ${DateFormat('MMM d, y').format(bed.occupiedSince!)}'
          : '')
      ..write(bed.vacatingOn != null
          ? '\nTill: ${DateFormat('MMM d, y').format(bed.vacatingOn!)}'
          : '');

    return Tooltip(
      message: tooltipText.toString(),
      waitDuration: const Duration(milliseconds: 300),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(AppSpacing.paddingS),
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border, width: 1),
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    '',
                    style: TextStyle(fontSize: 0),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 6),
                  Icon(icon, color: statusColor, size: 22),
                  const SizedBox(height: 6),
                  HeadingSmall(text: bed.bedNumber, color: statusColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
