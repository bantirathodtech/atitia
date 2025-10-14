// lib/feature/owner_dashboard/mypg/presentation/widgets/pg_summary_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/heading_small.dart';
import '../../data/models/owner_pg_management_model.dart';

/// PG Summary Widget for final review before creation/update
class PgSummaryWidget extends StatelessWidget {
  final String pgName;
  final String address;
  final String city;
  final String state;
  final List<OwnerFloor> floors;
  final List<OwnerRoom> rooms;
  final List<OwnerBed> beds;
  final List<String> amenities;
  final List<String> photos;
  final Map<String, TextEditingController> rentControllers;
  final double depositAmount;
  final String maintenanceType;
  final double maintenanceAmount;

  const PgSummaryWidget({
    super.key,
    required this.pgName,
    required this.address,
    required this.city,
    required this.state,
    required this.floors,
    required this.rooms,
    required this.beds,
    required this.amenities,
    required this.photos,
    required this.rentControllers,
    required this.depositAmount,
    required this.maintenanceType,
    required this.maintenanceAmount,
  });

  double _calculateTotalRent() {
    double total = 0.0;
    for (final room in rooms) {
      final rentPerBed = room.rentPerBed ?? 0.0;
      total += rentPerBed * room.capacity;
    }
    if (maintenanceType == 'monthly') {
      total += maintenanceAmount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalRent = _calculateTotalRent();
    final totalBeds = beds.length;
    final totalRooms = rooms.length;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Basic Information Summary
          AdaptiveCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingMedium(text: '📋 Basic Information'),
                  const SizedBox(height: AppSpacing.paddingM),
                  _buildSummaryRow(
                      'PG Name', pgName.isEmpty ? 'Not specified' : pgName),
                  _buildSummaryRow(
                      'Address', address.isEmpty ? 'Not specified' : address),
                  _buildSummaryRow('Location', '$city, $state'),
                  _buildSummaryRow('Photos', '${photos.length} photos'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Structure Summary
          AdaptiveCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingMedium(text: '🏢 Structure'),
                  const SizedBox(height: AppSpacing.paddingM),
                  _buildSummaryRow('Total Floors', '${floors.length}'),
                  _buildSummaryRow('Total Rooms', '$totalRooms'),
                  _buildSummaryRow('Total Beds', '$totalBeds'),
                  if (floors.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.paddingM),
                    HeadingSmall(text: 'Floor Details:'),
                    const SizedBox(height: AppSpacing.paddingS),
                    ...floors.map((floor) {
                      final floorRooms =
                          rooms.where((r) => r.floorId == floor.id).toList();
                      final floorBeds =
                          beds.where((b) => b.floorId == floor.id).toList();
                      return Padding(
                        padding:
                            const EdgeInsets.only(bottom: AppSpacing.paddingS),
                        child: BodyText(
                          text:
                              '${floor.floorName}: ${floorRooms.length} rooms, ${floorBeds.length} beds',
                          color: Colors.grey[600],
                        ),
                      );
                    }).toList(),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Rent Configuration Summary
          AdaptiveCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingMedium(text: '💰 Rent Configuration'),
                  const SizedBox(height: AppSpacing.paddingM),

                  // Rent per sharing type
                  ...rentControllers.entries.map((entry) {
                    final sharingType = entry.key;
                    final rent = double.tryParse(entry.value.text) ?? 0.0;
                    return _buildSummaryRow(
                      'Rent for $sharingType',
                      rent > 0 ? '₹${rent.toStringAsFixed(0)}/bed' : 'Not set',
                    );
                  }).toList(),

                  _buildSummaryRow('Security Deposit',
                      '₹${depositAmount.toStringAsFixed(0)}'),
                  _buildSummaryRow('Maintenance',
                      '$maintenanceType - ₹${maintenanceAmount.toStringAsFixed(0)}'),

                  const SizedBox(height: AppSpacing.paddingM),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.paddingM),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusM),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BodyText(
                          text: 'Estimated Monthly Revenue:',
                        ),
                        BodyText(
                          text: '₹${totalRent.toStringAsFixed(0)}',
                          color: theme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Amenities Summary
          AdaptiveCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingMedium(text: '🧰 Amenities'),
                  const SizedBox(height: AppSpacing.paddingM),
                  _buildSummaryRow('Total Amenities', '${amenities.length}'),
                  if (amenities.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.paddingM),
                    BodyText(
                      text: amenities.join(', '),
                      color: Colors.grey[600],
                    ),
                  ] else ...[
                    const SizedBox(height: AppSpacing.paddingM),
                    BodyText(
                      text: 'No amenities selected',
                      color: Colors.grey[500],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.paddingM),

          // Final Review
          AdaptiveCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeadingMedium(text: '✅ Final Review'),
                  const SizedBox(height: AppSpacing.paddingM),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.paddingM),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusM),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green[600]),
                            const SizedBox(width: AppSpacing.paddingS),
                            BodyText(
                              text:
                                  'Ready to ${pgName.isEmpty ? 'create' : 'update'} your PG!',
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.paddingS),
                        BodyText(
                          text:
                              'Review all details above and click the button below to proceed.',
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.paddingXL),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: BodyText(
              text: '$label:',
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: BodyText(
              text: value,
            ),
          ),
        ],
      ),
    );
  }
}
