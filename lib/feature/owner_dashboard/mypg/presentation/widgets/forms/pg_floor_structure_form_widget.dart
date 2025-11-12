// lib/feature/owner_dashboard/mypg/presentation/widgets/pg_floor_structure_form_widget.dart

import 'package:flutter/material.dart';

import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/heading_small.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../data/models/owner_pg_management_model.dart';
// import 'package:uuid/uuid.dart'; // TODO: Add uuid package to pubspec.yaml

/// Floor Structure Form Widget for PG Setup
class PgFloorStructureFormWidget extends StatefulWidget {
  final List<OwnerFloor> floors;
  final List<OwnerRoom> rooms;
  final List<OwnerBed> beds;
  final Function(List<OwnerFloor>) onFloorsChanged;
  final Function(List<OwnerRoom>) onRoomsChanged;
  final Function(List<OwnerBed>) onBedsChanged;

  const PgFloorStructureFormWidget({
    super.key,
    required this.floors,
    required this.rooms,
    required this.beds,
    required this.onFloorsChanged,
    required this.onRoomsChanged,
    required this.onBedsChanged,
  });

  @override
  State<PgFloorStructureFormWidget> createState() =>
      _PgFloorStructureFormWidgetState();
}

class _PgFloorStructureFormWidgetState
    extends State<PgFloorStructureFormWidget> {
  // final Uuid _uuid = const Uuid(); // TODO: Add uuid package
  final _totalFloorsController = TextEditingController();

  @override
  void dispose() {
    _totalFloorsController.dispose();
    super.dispose();
  }

  void _generateFloorStructure() {
    final loc = AppLocalizations.of(context)!;
    final int inputFloors = int.tryParse(_totalFloorsController.text) ?? 0;
    if (inputFloors <= 0) return;

    final List<OwnerFloor> newFloors = [];
    final List<OwnerRoom> newRooms = [];
    final List<OwnerBed> newBeds = [];

    // Always start with Ground
    newFloors.add(OwnerFloor(
      id: 'floor_${DateTime.now().millisecondsSinceEpoch}_0',
      floorName: loc.pgFloorGroundLabel,
      floorNumber: 0,
      totalRooms: 0,
    ));

    // Add regular floors based on input
    // Input "1 floor" = Ground + First + Terrace
    // Input "2 floors" = Ground + First + Second + Terrace
    for (int i = 1; i <= inputFloors; i++) {
      newFloors.add(OwnerFloor(
        id: 'floor_${DateTime.now().millisecondsSinceEpoch}_$i',
        floorName: _ordinalLabel(i, loc), // First, Second, etc.
        floorNumber: i,
        totalRooms: 0,
      ));
    }

    // Always end with Terrace
    newFloors.add(OwnerFloor(
      id: 'floor_${DateTime.now().millisecondsSinceEpoch}_${inputFloors + 1}',
      floorName: loc.pgFloorTerraceLabel,
      floorNumber: inputFloors + 1,
      totalRooms: 0,
    ));

    widget.onFloorsChanged(newFloors);
    widget.onRoomsChanged(newRooms);
    widget.onBedsChanged(newBeds);
  }

  void _addRoomToFloor(OwnerFloor floor) {
    final roomId = 'room_${DateTime.now().millisecondsSinceEpoch}';

    // Get existing rooms for this specific floor only
    final existingRoomsForFloor =
        widget.rooms.where((r) => r.floorId == floor.id).length;
    final roomNumber = _generateRoomNumber(floor, existingRoomsForFloor + 1);

    // Add room to specific floor only

    final room = OwnerRoom(
      id: roomId,
      floorId: floor.id,
      roomNumber: roomNumber,
      capacity: 3, // Default 3-share
      rentPerBed: 0.0,
    );

    final newRooms = List<OwnerRoom>.from(widget.rooms)..add(room);
    widget.onRoomsChanged(newRooms);

    // Generate beds for the room
    _generateBedsForRoom(room);
  }

  /// Returns ordinal label for floor numbers per finalized naming scheme
  String _ordinalLabel(int n, AppLocalizations loc) {
    switch (n) {
      case 1:
        return loc.pgFloorFirstLabel;
      case 2:
        return loc.pgFloorSecondLabel;
      case 3:
        return loc.pgFloorThirdLabel;
      case 4:
        return loc.pgFloorFourthLabel;
      case 5:
        return loc.pgFloorFifthLabel;
      default:
        return loc.pgFloorNthLabel(n);
    }
  }

  String _generateRoomNumber(OwnerFloor floor, int roomIndex) {
    final loc = AppLocalizations.of(context)!;
    if (floor.floorNumber == 0) {
      // Ground: 001, 002, 003...
      return roomIndex.toString().padLeft(3, '0');
    } else if (floor.floorName == loc.pgFloorTerraceLabel) {
      // Terrace: (N+1)01, (N+1)02...
      return '${floor.floorNumber}${roomIndex.toString().padLeft(2, '0')}';
    } else {
      // Regular floors: n01, n02, n03... (e.g., First → 101, 102)
      return '${floor.floorNumber}${roomIndex.toString().padLeft(2, '0')}';
    }
  }

  void _generateBedsForRoom(OwnerRoom room) {
    final newBeds = <OwnerBed>[];

    for (int i = 1; i <= room.capacity; i++) {
      final bed = OwnerBed(
        id: 'bed_${DateTime.now().millisecondsSinceEpoch}_$i',
        roomId: room.id,
        floorId: room.floorId,
        bedNumber: AppLocalizations.of(context)!
            .pgFloorBedLabel(i), // Bed-1, Bed-2, ...
        status: 'vacant',
      );
      newBeds.add(bed);
    }

    final updatedBeds = List<OwnerBed>.from(widget.beds)..addAll(newBeds);
    widget.onBedsChanged(updatedBeds);
  }

  void _updateRoomCapacity(OwnerRoom room, int newCapacity) {
    final updatedRoom = OwnerRoom(
      id: room.id,
      floorId: room.floorId,
      roomNumber: room.roomNumber,
      capacity: newCapacity,
      rentPerBed: room.rentPerBed,
    );

    final newRooms =
        widget.rooms.map((r) => r.id == room.id ? updatedRoom : r).toList();
    widget.onRoomsChanged(newRooms);

    // Update beds
    final roomBeds = widget.beds.where((b) => b.roomId == room.id).toList();
    final otherBeds = widget.beds.where((b) => b.roomId != room.id).toList();

    if (newCapacity > roomBeds.length) {
      // Add new beds
      for (int i = roomBeds.length + 1; i <= newCapacity; i++) {
        final bed = OwnerBed(
          id: 'bed_${DateTime.now().millisecondsSinceEpoch}_$i',
          roomId: room.id,
          floorId: room.floorId,
          bedNumber: AppLocalizations.of(context)!.pgFloorBedLabel(i),
          status: 'vacant',
        );
        roomBeds.add(bed);
      }
    } else if (newCapacity < roomBeds.length) {
      // Remove excess beds
      roomBeds.removeRange(newCapacity, roomBeds.length);
    }

    widget.onBedsChanged([...otherBeds, ...roomBeds]);
  }

  void _removeRoom(OwnerRoom room) {
    final newRooms = widget.rooms.where((r) => r.id != room.id).toList();
    final newBeds = widget.beds.where((b) => b.roomId != room.id).toList();

    widget.onRoomsChanged(newRooms);
    widget.onBedsChanged(newBeds);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        // Floor Generation
        AdaptiveCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingMedium(text: loc.pgFloorStructureTitle),
                const SizedBox(height: AppSpacing.paddingM),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _totalFloorsController,
                        decoration: InputDecoration(
                          labelText: loc.pgFloorCountLabel,
                          hintText: loc.pgFloorCountHint,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.paddingM),
                    PrimaryButton(
                      onPressed: _generateFloorStructure,
                      label: loc.generateAction,
                      icon: Icons.auto_awesome,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.paddingS),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.paddingM),

        // Floors and Rooms
        ...widget.floors.map((floor) {
          final floorRooms =
              widget.rooms.where((r) => r.floorId == floor.id).toList();

          return Column(
            children: [
              AdaptiveCard(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.paddingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeadingSmall(text: floor.floorName),
                                const SizedBox(height: AppSpacing.paddingXS),
                                BodyText(
                                  text: loc.pgFloorRoomsBedsSummary(
                                    floorRooms.length,
                                    floorRooms.fold(
                                      0,
                                      (sum, room) => sum + room.capacity,
                                    ),
                                  ),
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 2),
                              ],
                            ),
                          ),
                          PrimaryButton(
                            onPressed: () => _addRoomToFloor(floor),
                            label: loc.pgFloorAddRoom,
                            icon: Icons.add,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.paddingM),

                      // Rooms in this floor
                      ...floorRooms.map((room) {
                        final roomBeds = widget.beds
                            .where((b) => b.roomId == room.id)
                            .toList();

                        return Container(
                          margin: const EdgeInsets.only(
                              bottom: AppSpacing.paddingS),
                          padding: const EdgeInsets.all(AppSpacing.paddingM),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius:
                                BorderRadius.circular(AppSpacing.borderRadiusM),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BodyText(
                                    text: loc.pgFloorRoomLabel(room.roomNumber),
                                  ),
                                  Row(
                                    children: [
                                      DropdownButton<int>(
                                        value: room.capacity,
                                        items: [1, 2, 3, 4, 5]
                                            .map((capacity) => DropdownMenuItem(
                                                  value: capacity,
                                                  child: Text(
                                                      loc.pgFloorCapacityOption(
                                                          capacity)),
                                                ))
                                            .toList(),
                                        onChanged: (capacity) {
                                          if (capacity != null) {
                                            _updateRoomCapacity(room, capacity);
                                          }
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => _removeRoom(room),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              BodyText(
                                text: loc.pgFloorBedsList(
                                  roomBeds.map((b) => b.bedNumber).join(', '),
                                ),
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        );
                      }),

                      if (floorRooms.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.paddingM),
                          child: Center(
                            child: BodyText(
                              text: loc.pgFloorNoRoomsMessage,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.paddingM),
            ],
          );
        }),

        if (widget.floors.isEmpty)
          AdaptiveCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingL),
              child: Column(
                children: [
                  Icon(Icons.home_work_outlined,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: AppSpacing.paddingM),
                  HeadingMedium(text: loc.pgFloorEmptyTitle),
                  const SizedBox(height: AppSpacing.paddingS),
                  BodyText(
                    text: loc.pgFloorEmptyMessage,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
