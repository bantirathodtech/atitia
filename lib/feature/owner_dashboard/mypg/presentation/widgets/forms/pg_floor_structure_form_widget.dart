// lib/feature/owner_dashboard/mypg/presentation/widgets/pg_floor_structure_form_widget.dart

import 'package:flutter/material.dart';

import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/buttons/primary_button.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/heading_small.dart';
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
    final int inputFloors = int.tryParse(_totalFloorsController.text) ?? 0;
    if (inputFloors <= 0) return;

    final List<OwnerFloor> newFloors = [];
    final List<OwnerRoom> newRooms = [];
    final List<OwnerBed> newBeds = [];

    // Always start with Ground Floor
    newFloors.add(OwnerFloor(
      id: 'floor_${DateTime.now().millisecondsSinceEpoch}_0',
      floorName: 'Ground Floor',
      floorNumber: 0,
      totalRooms: 0,
    ));

    // Add regular floors based on input
    // Input "1 floor" = Ground + Floor 1 + Terrace
    // Input "2 floors" = Ground + Floor 1 + Floor 2 + Terrace
    for (int i = 1; i <= inputFloors; i++) {
      newFloors.add(OwnerFloor(
        id: 'floor_${DateTime.now().millisecondsSinceEpoch}_$i',
        floorName: 'Floor $i',
        floorNumber: i,
        totalRooms: 0,
      ));
    }

    // Always end with Terrace
    newFloors.add(OwnerFloor(
      id: 'floor_${DateTime.now().millisecondsSinceEpoch}_${inputFloors + 1}',
      floorName: 'Terrace',
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

  String _generateRoomNumber(OwnerFloor floor, int roomIndex) {
    if (floor.floorNumber == 0) {
      // Ground Floor: G001, G002, G003...
      return 'G${roomIndex.toString().padLeft(3, '0')}';
    } else if (floor.floorName == 'Terrace') {
      // Terrace: T001, T002, T003...
      return 'T${roomIndex.toString().padLeft(3, '0')}';
    } else {
      // Regular Floors: F101, F102, F103... (F = Floor)
      return 'F${floor.floorNumber}${roomIndex.toString().padLeft(2, '0')}';
    }
  }

  void _generateBedsForRoom(OwnerRoom room) {
    final newBeds = <OwnerBed>[];

    for (int i = 1; i <= room.capacity; i++) {
      final bed = OwnerBed(
        id: 'bed_${DateTime.now().millisecondsSinceEpoch}_$i',
        roomId: room.id,
        floorId: room.floorId,
        bedNumber: 'Bed $i', // Bed 1, Bed 2, Bed 3...
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
          bedNumber: 'Bed $i',
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
    return Column(
      children: [
        // Floor Generation
        AdaptiveCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingMedium(text: '🏢 Floor Structure'),
                const SizedBox(height: AppSpacing.paddingM),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _totalFloorsController,
                        decoration: const InputDecoration(
                          labelText: 'Number of Regular Floors',
                          hintText: 'e.g., 1',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.paddingM),
                    PrimaryButton(
                      onPressed: _generateFloorStructure,
                      label: 'Generate',
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
                                const SizedBox(height: 4),
                                BodyText(
                                  text:
                                      '${floorRooms.length} rooms • ${floorRooms.fold(0, (sum, room) => sum + room.capacity)} beds',
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 2),
                              ],
                            ),
                          ),
                          PrimaryButton(
                            onPressed: () => _addRoomToFloor(floor),
                            label: 'Add Room',
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
                                  BodyText(text: 'Room ${room.roomNumber}'),
                                  Row(
                                    children: [
                                      DropdownButton<int>(
                                        value: room.capacity,
                                        items: [1, 2, 3, 4, 5]
                                            .map((capacity) => DropdownMenuItem(
                                                  value: capacity,
                                                  child:
                                                      Text('$capacity-share'),
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
                                text:
                                    'Beds: ${roomBeds.map((b) => b.bedNumber).join(', ')}',
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      if (floorRooms.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(AppSpacing.paddingM),
                          child: Center(
                            child: BodyText(
                              text:
                                  'No rooms added yet. Click "Add Room" to get started.',
                              color: Colors.grey,
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
        }).toList(),

        if (widget.floors.isEmpty)
          AdaptiveCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingL),
              child: Column(
                children: [
                  Icon(Icons.home_work_outlined,
                      size: 64, color: Colors.grey[400]),
                  const SizedBox(height: AppSpacing.paddingM),
                  const HeadingMedium(text: 'No Floors Generated'),
                  const SizedBox(height: AppSpacing.paddingS),
                  const BodyText(
                    text:
                        'Enter the number of floors and click "Generate" to create your floor structure.',
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
