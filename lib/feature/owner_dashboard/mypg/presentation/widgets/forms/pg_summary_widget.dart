import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/text/heading_small.dart';
import '../../../data/models/owner_pg_management_model.dart';

/// PG Summary Widget
class PgSummaryWidget extends AdaptiveStatelessWidget {
  final String pgName;
  final String address;
  final String city;
  final String state;
  final List<OwnerFloor> floors;
  final List<OwnerRoom> rooms;
  final List<OwnerBed> beds;
  final Map<String, TextEditingController> rentControllers;
  final double depositAmount;
  final String maintenanceType;
  final double maintenanceAmount;
  final List<String> selectedAmenities;
  final List<String> uploadedPhotos;

  const PgSummaryWidget({
    super.key,
    required this.pgName,
    required this.address,
    required this.city,
    required this.state,
    required this.floors,
    required this.rooms,
    required this.beds,
    required this.rentControllers,
    required this.depositAmount,
    required this.maintenanceType,
    required this.maintenanceAmount,
    required this.selectedAmenities,
    required this.uploadedPhotos,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final totalRent = _calculateTotalRent();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: 'PG Summary'),
        const SizedBox(height: AppSpacing.paddingL),

        // Basic Information
        _buildSummaryCard(
          context,
          'Basic Information',
          [
            _buildSummaryRow(
                'PG Name', pgName.isNotEmpty ? pgName : 'Not specified'),
            _buildSummaryRow(
                'Address', address.isNotEmpty ? address : 'Not specified'),
            _buildSummaryRow('Location', '$city, $state'),
          ],
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Floor Structure
        _buildSummaryCard(
          context,
          'Floor Structure',
          [
            _buildSummaryRow('Total Floors', '${floors.length}'),
            _buildSummaryRow('Total Rooms', '${rooms.length}'),
            _buildSummaryRow('Total Beds', '${beds.length}'),
          ],
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Rent Information
        _buildSummaryCard(
          context,
          'Rent Information',
          [
            _buildSummaryRow('Estimated Monthly Revenue',
                '₹${totalRent.toStringAsFixed(0)}'),
            _buildSummaryRow(
                'Security Deposit', '₹${depositAmount.toStringAsFixed(0)}'),
            _buildSummaryRow('Maintenance',
                '$maintenanceType - ₹${maintenanceAmount.toStringAsFixed(0)}'),
          ],
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Amenities
        _buildSummaryCard(
          context,
          'Amenities',
          [
            _buildSummaryRow(
                'Selected Amenities', '${selectedAmenities.length}'),
            if (selectedAmenities.isNotEmpty)
              _buildSummaryRow('List', selectedAmenities.join(', ')),
          ],
        ),

        const SizedBox(height: AppSpacing.paddingM),

        // Photos
        _buildSummaryCard(
          context,
          'Photos',
          [
            _buildSummaryRow('Uploaded Photos', '${uploadedPhotos.length}'),
          ],
        ),

        const SizedBox(height: AppSpacing.paddingL),

        // Ready to Create/Update
        AdaptiveCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingL),
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
                      'Review all details above and click the save button to proceed.',
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      BuildContext context, String title, List<Widget> children) {
    return AdaptiveCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingSmall(text: title),
            const SizedBox(height: AppSpacing.paddingM),
            ...children,
          ],
        ),
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

  double _calculateTotalRent() {
    double total = 0;
    for (final entry in rentControllers.entries) {
      final rent = double.tryParse(entry.value.text) ?? 0;
      total += rent;
    }
    return total;
  }
}
