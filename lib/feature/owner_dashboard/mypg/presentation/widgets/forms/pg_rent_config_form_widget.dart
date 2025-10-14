// lib/feature/owner_dashboard/mypg/presentation/widgets/pg_rent_config_form_widget.dart

import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';

/// Rent Configuration Form Widget for PG Setup
class PgRentConfigFormWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Rent Configuration
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
                  final controller = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
                    child: TextInput(
                      controller: controller,
                      label: 'Rent for $sharingType (₹ per bed)',
                      hint: 'e.g., 5000',
                      keyboardType: TextInputType.number,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.paddingM),
        
        // Deposit Configuration
        AdaptiveCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingMedium(text: '💳 Security Deposit'),
                const SizedBox(height: AppSpacing.paddingM),
                
                TextInput(
                  controller: depositController,
                  label: 'Security Deposit (₹)',
                  hint: 'e.g., 10000',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.paddingM),
                
                BodyText(
                  text: 'Deposit Refund Policy:',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.paddingS),
                const BodyText(text: '• Full refund if notice ≥ 30 days'),
                const BodyText(text: '• 50% refund if notice ≥ 15 days'),
                const BodyText(text: '• No refund if notice < 15 days'),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.paddingM),
        
        // Maintenance Configuration
        AdaptiveCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingMedium(text: '🔧 Maintenance'),
                const SizedBox(height: AppSpacing.paddingM),
                
                DropdownButtonFormField<String>(
                  value: maintenanceType,
                  decoration: InputDecoration(
                    labelText: 'Maintenance Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM)),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  ),
                  items: const [
                    DropdownMenuItem(value: 'one-time', child: Text('One-time (Non-refundable)')),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly (Added to rent)')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      onMaintenanceTypeChanged(value);
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.paddingM),
                
                TextInput(
                  controller: maintenanceAmountController,
                  label: 'Maintenance Amount (₹)',
                  hint: 'e.g., 500',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.paddingM),
                
                BodyText(
                  text: maintenanceType == 'one-time' 
                      ? 'One-time maintenance fee will be charged upfront and is non-refundable.'
                      : 'Monthly maintenance fee will be added to the monthly rent.',
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
