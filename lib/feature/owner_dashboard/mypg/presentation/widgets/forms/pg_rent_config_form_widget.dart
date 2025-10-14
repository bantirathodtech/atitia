import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../../common/widgets/dropdowns/adaptive_dropdown.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';

/// Rent Configuration Form Widget
class PgRentConfigFormWidget extends AdaptiveStatelessWidget {
  final Map<String, TextEditingController> rentControllers;
  final TextEditingController depositController;
  final String maintenanceType;
  final TextEditingController maintenanceAmountController;
  final Function(String) onMaintenanceTypeChanged;

  const PgRentConfigFormWidget({
    super.key,
    required this.rentControllers,
    required this.depositController,
    required this.maintenanceType,
    required this.maintenanceAmountController,
    required this.onMaintenanceTypeChanged,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: 'Rent Configuration'),
        const SizedBox(height: AppSpacing.paddingL),
        
        // Rent for different sharing types
        ...rentControllers.entries.map((entry) {
          final sharingType = entry.key;
          final controller = entry.value;
          final displayName = sharingType.replaceAll('-', ' ').toUpperCase();
          
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
            child: TextInput(
              controller: controller,
              label: 'Rent for $displayName (₹)',
              hint: 'e.g., 8000',
              keyboardType: TextInputType.number,
            ),
          );
        }).toList(),
        
        const SizedBox(height: AppSpacing.paddingM),
        
        // Security Deposit
        TextInput(
          controller: depositController,
          label: 'Security Deposit (₹)',
          hint: 'e.g., 10000',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.paddingM),
        
        // Maintenance Type
        AdaptiveDropdown<String>(
          label: 'Maintenance Type',
          value: maintenanceType,
          items: const [
            DropdownMenuItem(value: 'one_time', child: Text('One Time')),
            DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
            DropdownMenuItem(value: 'quarterly', child: Text('Quarterly')),
            DropdownMenuItem(value: 'yearly', child: Text('Yearly')),
          ],
          onChanged: (value) {
            if (value != null) {
              onMaintenanceTypeChanged(value);
            }
          },
        ),
        const SizedBox(height: AppSpacing.paddingM),
        
        // Maintenance Amount
        TextInput(
          controller: maintenanceAmountController,
          label: 'Maintenance Amount (₹)',
          hint: 'e.g., 500',
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.paddingL),
        
        // Deposit Refund Policy
        BodyText(
          text: 'Deposit Refund Policy:',
        ),
        const SizedBox(height: AppSpacing.paddingS),
        const BodyText(text: '• Full refund if notice ≥ 30 days'),
        const BodyText(text: '• 50% refund if notice ≥ 15 days'),
        const BodyText(text: '• No refund if notice < 15 days'),
      ],
    );
  }
}