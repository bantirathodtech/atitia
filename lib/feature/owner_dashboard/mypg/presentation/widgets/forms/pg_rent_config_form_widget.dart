import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/dropdowns/adaptive_dropdown.dart';
import '../../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../../common/widgets/text/body_text.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: loc.pgRentConfigTitle),
        const SizedBox(height: AppSpacing.paddingL),

        // Rent for different sharing types
        ...rentControllers.entries.map((entry) {
          final sharingType = entry.key;
          final controller = entry.value;
          final displayName =
              loc.pgRentConfigSharingLabel(sharingType.replaceAll('-', ' '));

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
            child: TextInput(
              controller: controller,
              label: loc.pgRentConfigRentLabel(displayName),
              hint: loc.pgRentConfigRentHint,
              keyboardType: TextInputType.number,
            ),
          );
        }),

        const SizedBox(height: AppSpacing.paddingM),

        // Security Deposit
        TextInput(
          controller: depositController,
          label: loc.pgRentConfigDepositLabel,
          hint: loc.pgRentConfigDepositHint,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.paddingM),

        // Maintenance Type
        AdaptiveDropdown<String>(
          label: loc.pgRentConfigMaintenanceTypeLabel,
          value: maintenanceType,
          items: [
            DropdownMenuItem(
              value: 'one_time',
              child: Text(loc.pgRentConfigMaintenanceOneTime),
            ),
            DropdownMenuItem(
              value: 'monthly',
              child: Text(loc.pgRentConfigMaintenanceMonthly),
            ),
            DropdownMenuItem(
              value: 'quarterly',
              child: Text(loc.pgRentConfigMaintenanceQuarterly),
            ),
            DropdownMenuItem(
              value: 'yearly',
              child: Text(loc.pgRentConfigMaintenanceYearly),
            ),
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
          label: loc.pgRentConfigMaintenanceAmountLabel,
          hint: loc.pgRentConfigMaintenanceAmountHint,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.paddingL),

        // Deposit Refund Policy
        BodyText(
          text: loc.pgRentConfigRefundTitle,
        ),
        const SizedBox(height: AppSpacing.paddingS),
        BodyText(text: loc.pgRentConfigRefundFull),
        BodyText(text: loc.pgRentConfigRefundPartial),
        BodyText(text: loc.pgRentConfigRefundNone),
      ],
    );
  }
}
