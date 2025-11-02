import 'package:flutter/material.dart';
import '../../feature/guest_dashboard/pgs/data/models/guest_pg_model.dart';
import '../../feature/owner_dashboard/mypg/data/models/pg_room_model.dart';
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
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 8, right: 8, bottom: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: summary.entries.map((e) {
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
                  const SizedBox(width: 3),
                  BodyText(text: e.key, small: true),
                  const SizedBox(width: 8),
                  BodyText(
                      text: '₹${e.value.pricePerBed}/bed',
                      color: Colors.indigo,
                      small: true),
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
      return const BodyText(text: 'No sharing info available.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingSmall(text: 'Sharing & Vacancy', color: Colors.deepPurple),
        const SizedBox(height: 8),
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
              _th('Sharing'),
              _th('Rooms'),
              _th('Vacant Beds'),
              _th('Rent/bed'),
            ]),
            ...summary.entries.map((e) => TableRow(children: [
                  _td(e.key),
                  _td('${e.value.roomCount}'),
                  _td('Available'), // Hide vacant bed count
                  _td('₹${e.value.pricePerBed}'),
                ])),
          ],
        ),
      ],
    );
  }

  Widget _th(String text) => Padding(
      padding: const EdgeInsets.all(6),
      child: BodyText(text: text, small: true, color: Colors.grey));
  Widget _td(String text) => Padding(
      padding: const EdgeInsets.all(6),
      child: BodyText(text: text, small: true));
}
