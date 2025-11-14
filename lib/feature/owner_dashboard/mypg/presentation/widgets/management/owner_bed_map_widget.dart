// lib/features/owner_dashboard/mypg/presentation/widgets/owner_bed_map_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/styles/colors.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/grids/responsive_grid.dart';
import '../../../../../../common/widgets/text/caption_text.dart';
import '../../../../../../common/widgets/text/heading_small.dart';
import '../../../../../../common/widgets/chips/status_chip.dart';
import '../../../../../../core/services/localization/internationalization_service.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../data/models/owner_pg_management_model.dart';

/// Interactive bed map widget showing room and bed occupancy
class OwnerBedMapWidget extends StatelessWidget {
  final List<OwnerBed> beds;
  final List<OwnerRoom> rooms;
  final List<OwnerFloor> floors;

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  const OwnerBedMapWidget({
    required this.beds,
    required this.rooms,
    required this.floors,
    super.key,
  });

  String _bedStatusLabel(AppLocalizations? loc, OwnerBed bed) {
    if (bed.isOccupied) {
      return loc?.ownerBedMapStatusOccupiedLabel ??
          _text('ownerBedMapStatusOccupiedLabel', 'Occupied');
    }
    if (bed.isPending) {
      return loc?.ownerBedMapStatusPendingLabel ??
          _text('ownerBedMapStatusPendingLabel', 'Pending');
    }
    if (bed.isUnderMaintenance) {
      return loc?.ownerBedMapStatusMaintenanceLabel ??
          _text('ownerBedMapStatusMaintenanceLabel', 'Maint.');
    }
    return loc?.ownerBedMapStatusVacantLabel ??
        _text('ownerBedMapStatusVacantLabel', 'Vacant');
  }

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
          _buildOverviewCard(context, loc,
              totalBeds: totalBeds,
              occupied: occupied,
              vacant: vacant,
              pending: pending,
              maintenance: maintenance),
          const SizedBox(height: AppSpacing.paddingM),
          ..._buildRoomPlaceholders(context, loc),
        ],
      );
    }

    // Group beds by room
    final roomBeds = _groupBedsByRoom(beds);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      children: [
        _buildOverviewCard(context, loc,
            totalBeds: totalBeds,
            occupied: occupied,
            vacant: vacant,
            pending: pending,
            maintenance: maintenance),
        const SizedBox(height: AppSpacing.paddingM),
        ...roomBeds.keys.map((roomId) {
          final roomBedsList = roomBeds[roomId]!;
          final room = rooms.firstWhere((r) => r.id == roomId,
              orElse: () => OwnerRoom(
                  id: roomId,
                  floorId: '',
                  roomNumber: loc?.ownerBedMapRoomUnknown ??
                      _text('ownerBedMapRoomUnknown', 'Unknown')));

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
            child: _buildRoomCard(context, room, roomBedsList, loc),
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

  Widget _buildRoomCard(BuildContext context, OwnerRoom room,
      List<OwnerBed> roomBeds, AppLocalizations? loc) {
    final theme = Theme.of(context);
    final occupiedCount = roomBeds.where((b) => b.isOccupied).length;
    final vacantCount = roomBeds.where((b) => b.isVacant).length;
    final pendingCount = roomBeds.where((b) => b.isPending).length;
    final maintenanceCount = roomBeds.where((b) => b.isUnderMaintenance).length;
    final total = roomBeds.isEmpty ? 1 : roomBeds.length; // avoid /0
    final occupancy = occupiedCount / total;
    final occupancySummary = loc?.ownerBedMapOccupancySummary(
            occupiedCount, roomBeds.length, room.capacity) ??
        _text('ownerBedMapOccupancySummary',
            '{occupied}/{total} occupied • Capacity {capacity}',
            parameters: {
              'occupied': occupiedCount,
              'total': roomBeds.length,
              'capacity': room.capacity,
            });

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
                        text: occupancySummary,
                        color: theme.textTheme.bodySmall?.color ??
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
                  color: AppColors.success,
                  label: loc?.ownerBedMapStatusChipOccupied(occupiedCount) ??
                      _text('ownerBedMapStatusChipOccupied', 'Occupied {count}',
                          parameters: {'count': occupiedCount}),
                  icon: Icons.person,
                  paddingH: 16,
                  paddingV: 10,
                  iconSize: 18,
                  fontSize: 13,
                ),
                StatusChip(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5),
                  label: loc?.ownerBedMapStatusChipVacant(vacantCount) ??
                      _text('ownerBedMapStatusChipVacant', 'Vacant {count}',
                          parameters: {'count': vacantCount}),
                  icon: Icons.bed_outlined,
                  paddingH: 16,
                  paddingV: 10,
                  iconSize: 18,
                  fontSize: 13,
                ),
                StatusChip(
                  color: AppColors.warning,
                  label: loc?.ownerBedMapStatusChipPending(pendingCount) ??
                      _text('ownerBedMapStatusChipPending', 'Pending {count}',
                          parameters: {'count': pendingCount}),
                  icon: Icons.schedule,
                  paddingH: 16,
                  paddingV: 10,
                  iconSize: 18,
                  fontSize: 13,
                ),
                StatusChip(
                  color: AppColors.error,
                  label: loc?.ownerBedMapStatusChipMaintenance(
                          maintenanceCount) ??
                      _text(
                          'ownerBedMapStatusChipMaintenance', 'Maint. {count}',
                          parameters: {'count': maintenanceCount}),
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
              children: roomBeds
                  .map((bed) => _buildBedItem(context, bed, loc))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context,
    AppLocalizations? loc, {
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
                const SizedBox(width: AppSpacing.paddingS),
                HeadingSmall(
                    text: loc?.ownerBedMapBedsOverview ??
                        _text('ownerBedMapBedsOverview', 'Beds Overview')),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              children: [
                Expanded(
                  child: _buildMiniStat(
                      context,
                      '$totalBeds',
                      loc?.ownerBedMapMiniStatTotal ??
                          _text('ownerBedMapMiniStatTotal', 'Total'),
                      Icons.inventory_2,
                      theme.primaryColor),
                ),
                Expanded(
                  child: _buildMiniStat(
                      context,
                      '$occupied',
                      loc?.ownerBedMapMiniStatOccupied ??
                          _text('ownerBedMapMiniStatOccupied', 'Occupied'),
                      Icons.person,
                      AppColors.success),
                ),
                Expanded(
                  child: _buildMiniStat(
                      context,
                      '$vacant',
                      loc?.ownerBedMapMiniStatVacant ??
                          _text('ownerBedMapMiniStatVacant', 'Vacant'),
                      Icons.bed_outlined,
                      AppColors.warning),
                ),
                Expanded(
                  child: _buildMiniStat(
                      context,
                      '$pending',
                      loc?.ownerBedMapMiniStatPending ??
                          _text('ownerBedMapMiniStatPending', 'Pending'),
                      Icons.schedule,
                      AppColors.warning),
                ),
                Expanded(
                  child: _buildMiniStat(
                      context,
                      '$maintenance',
                      loc?.ownerBedMapMiniStatMaintenance ??
                          _text('ownerBedMapMiniStatMaintenance', 'Maint.'),
                      Icons.build,
                      AppColors.error),
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
      margin: const EdgeInsets.all(AppSpacing.paddingXS),
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: AppSpacing.paddingS),
          HeadingSmall(text: value, color: color),
          const SizedBox(height: 2),
          CaptionText(text: label, color: color.withValues(alpha: 0.9)),
        ],
      ),
    );
  }

  List<Widget> _buildRoomPlaceholders(
      BuildContext context, AppLocalizations? loc) {
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
                        text: loc?.ownerBedMapPlaceholderSummary(0, 0) ??
                            _text('ownerBedMapPlaceholderSummary',
                                '{occupied}/{total} occupied',
                                parameters: {'occupied': 0, 'total': 0}),
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
    final muted = theme.textTheme.bodySmall?.color?.withValues(alpha: 0.35) ??
        theme.colorScheme.onSurface.withValues(alpha: 0.35);
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
          const SizedBox(height: AppSpacing.paddingS),
          Icon(Icons.bed_outlined, color: muted, size: 22),
          const SizedBox(height: AppSpacing.paddingS),
          HeadingSmall(text: '—', color: muted),
        ],
      ),
    );
  }

  // legacy legend chip removed (replaced by StatusChip)

  Widget _buildBedItem(
      BuildContext context, OwnerBed bed, AppLocalizations? loc) {
    final theme = Theme.of(context);
    final statusColor = bed.statusColor;
    final bg = statusColor.withValues(
        alpha: theme.brightness == Brightness.dark ? 0.12 : 0.08);
    final border = statusColor;
    final icon = bed.isOccupied
        ? Icons.person
        : bed.isPending
            ? Icons.schedule
            : bed.isUnderMaintenance
                ? Icons.build
                : Icons.bed_outlined;

    final statusLabel = _bedStatusLabel(loc, bed);
    final dateFormat = DateFormat.yMMMd(loc?.localeName);
    final tooltipLines = <String>[
      loc?.ownerBedMapTooltipTitle(bed.bedNumber, statusLabel) ??
          _text('ownerBedMapTooltipTitle', 'Bed {bedNumber} • {status}',
              parameters: {'bedNumber': bed.bedNumber, 'status': statusLabel}),
    ];
    final guestName = bed.guestName?.trim();
    if (guestName != null && guestName.isNotEmpty) {
      tooltipLines.add(loc?.ownerBedMapTooltipGuest(guestName) ??
          _text('ownerBedMapTooltipGuest', 'Guest: {guest}',
              parameters: {'guest': guestName}));
    }
    if (bed.occupiedSince != null) {
      tooltipLines.add(
          loc?.ownerBedMapTooltipFrom(dateFormat.format(bed.occupiedSince!)) ??
              _text('ownerBedMapTooltipFrom', 'From: {date}',
                  parameters: {'date': dateFormat.format(bed.occupiedSince!)}));
    }
    if (bed.vacatingOn != null) {
      tooltipLines.add(
          loc?.ownerBedMapTooltipTill(dateFormat.format(bed.vacatingOn!)) ??
              _text('ownerBedMapTooltipTill', 'Till: {date}',
                  parameters: {'date': dateFormat.format(bed.vacatingOn!)}));
    }

    final tooltipText = tooltipLines.join('\n');

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
                  const SizedBox(height: AppSpacing.paddingS),
                  Icon(icon, color: statusColor, size: 22),
                  const SizedBox(height: AppSpacing.paddingS),
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
