import 'package:flutter/material.dart';
import '../../common/styles/spacing.dart';
import '../../core/services/localization/internationalization_service.dart';
import '../../feature/guest_dashboard/pgs/data/models/guest_pg_model.dart';
import '../../feature/owner_dashboard/mypg/data/models/pg_room_model.dart';
import '../../l10n/app_localizations.dart';
import 'text/body_text.dart';
import 'text/heading_small.dart';

/// Utility map by sharingType summarizing the required info
typedef SharingSummary = Map<String, SharingTypeInfo>;

class SharingTypeInfo {
  final int roomCount, bedsCount, vacantBedsCount, pricePerBed;
  SharingTypeInfo(
      {required this.roomCount,
      required this.bedsCount,
      required this.vacantBedsCount,
      required this.pricePerBed});
}

SharingSummary getSharingSummary(GuestPgModel pg) {
  final Map<String, SharingTypeInfo> map = {};
  for (final floor in pg.floorStructure) {
    for (final PgRoomModel room in floor.rooms) {
      final t = room.sharingType;
      final info = map[t];
      map[t] = SharingTypeInfo(
          roomCount: (info?.roomCount ?? 0) + 1,
          bedsCount: (info?.bedsCount ?? 0) + room.bedsCount,
          vacantBedsCount: (info?.vacantBedsCount ?? 0) + room.vacantBedsCount,
          pricePerBed: room.pricePerBed);
    }
  }
  return map;
}

/// Compact horizontal row for cards
class SharingSummaryRow extends StatelessWidget {
  final GuestPgModel pg;
  const SharingSummaryRow({super.key, required this.pg});
  @override
  Widget build(BuildContext context) {
    final summary = getSharingSummary(pg);
    if (summary.isEmpty) {
      return const SizedBox.shrink();
    }
    final loc = AppLocalizations.of(context);
    final i18n = InternationalizationService.instance;
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: summary.entries.map((e) {
            final amount = i18n.formatCurrency(e.value.pricePerBed);
            final priceLabel = loc?.sharingPricePerBed(amount) ?? '$amount/bed';
            return Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.bed, size: 14, color: Colors.blueGrey),
                  const SizedBox(width: AppSpacing.paddingXS),
                  BodyText(text: e.key, small: true),
                  const SizedBox(width: AppSpacing.paddingS),
                  BodyText(
                    text: priceLabel,
                    color: Colors.indigo,
                    small: true,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Details table for the detail screen
class SharingSummaryTable extends StatelessWidget {
  final GuestPgModel pg;
  const SharingSummaryTable({super.key, required this.pg});
  @override
  Widget build(BuildContext context) {
    final summary = getSharingSummary(pg);
    if (summary.isEmpty) {
      final loc = AppLocalizations.of(context);
      return BodyText(
        text: loc?.noSharingInfoAvailable ?? 'No sharing info available.',
      );
    }
    final loc = AppLocalizations.of(context);
    final i18n = InternationalizationService.instance;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingSmall(
          text: loc?.sharingAndVacancy ?? 'Sharing & Vacancy',
          color: Colors.deepPurple,
        ),
        const SizedBox(height: AppSpacing.paddingS),
        Table(
          border: TableBorder.all(color: Colors.grey.shade200),
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
          },
          children: [
            TableRow(children: [
              _th(loc?.sharingColumn ?? 'Sharing'),
              _th(loc?.roomsColumn ?? 'Rooms'),
              _th(loc?.vacantBedsColumn ?? 'Vacant beds'),
              _th(loc?.rentPerBedColumn ?? 'Rent / bed'),
            ]),
            ...summary.entries.map((e) => TableRow(children: [
                  _td(e.key),
                  _td('${e.value.roomCount}'),
                  _td(loc?.vacantBedsAvailable ?? 'Available'),
                  _td(i18n.formatCurrency(e.value.pricePerBed)),
                ])),
          ],
        ),
      ],
    );
  }

  Widget _th(String text) => Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingS),
      child: BodyText(text: text, small: true, color: Colors.grey));
  Widget _td(String text) => Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingS),
      child: BodyText(text: text, small: true));
}
