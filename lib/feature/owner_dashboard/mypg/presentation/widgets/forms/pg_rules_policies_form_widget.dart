import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../../common/widgets/dropdowns/adaptive_dropdown.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../common/widgets/grids/responsive_grid.dart';

/// Rules & Policies Form Widget
class PgRulesPoliciesFormWidget extends AdaptiveStatelessWidget {
  final TextEditingController entryTimingsController;
  final TextEditingController exitTimingsController;
  final TextEditingController guestPolicyController;
  final TextEditingController refundPolicyController;
  final TextEditingController noticePeriodController;
  final String? selectedSmokingPolicy;
  final String? selectedAlcoholPolicy;
  final Function(String?) onSmokingPolicyChanged;
  final Function(String?) onAlcoholPolicyChanged;

  const PgRulesPoliciesFormWidget({
    super.key,
    required this.entryTimingsController,
    required this.exitTimingsController,
    required this.guestPolicyController,
    required this.refundPolicyController,
    required this.noticePeriodController,
    required this.selectedSmokingPolicy,
    required this.selectedAlcoholPolicy,
    required this.onSmokingPolicyChanged,
    required this.onAlcoholPolicyChanged,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: 'Rules & Policies'),
        const SizedBox(height: AppSpacing.paddingL),
        
        ResponsiveGrid(
          targetTileWidth: 320,
          horizontalGap: AppSpacing.paddingM,
          verticalGap: AppSpacing.paddingM,
          childAspectRatio: 3.6,
          children: [
            TextInput(
              controller: entryTimingsController,
              label: 'Entry Timings',
              hint: 'e.g., 6:00 AM - 11:00 PM',
            ),
            TextInput(
              controller: exitTimingsController,
              label: 'Exit Timings',
              hint: 'e.g., 6:00 AM - 11:00 PM',
            ),
            AdaptiveDropdown<String>(
              label: 'Smoking Policy',
              value: selectedSmokingPolicy,
              items: const [
                DropdownMenuItem(value: 'Not Allowed', child: Text('Not Allowed')),
                DropdownMenuItem(value: 'Allowed', child: Text('Allowed')),
                DropdownMenuItem(value: 'Designated Areas Only', child: Text('Designated Areas Only')),
              ],
              onChanged: onSmokingPolicyChanged,
              hint: 'Select Policy',
            ),
            AdaptiveDropdown<String>(
              label: 'Alcohol Policy',
              value: selectedAlcoholPolicy,
              items: const [
                DropdownMenuItem(value: 'Not Allowed', child: Text('Not Allowed')),
                DropdownMenuItem(value: 'Allowed', child: Text('Allowed')),
                DropdownMenuItem(value: 'Designated Areas Only', child: Text('Designated Areas Only')),
              ],
              onChanged: onAlcoholPolicyChanged,
              hint: 'Select Policy',
            ),
            TextInput(
              controller: noticePeriodController,
              label: 'Notice Period (Days)',
              hint: 'e.g., 30',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        
        const SizedBox(height: AppSpacing.paddingM),
        
        TextInput(
          controller: guestPolicyController,
          label: 'Guest Policy',
          hint: 'Rules regarding guests, visitors, overnight stays, etc.',
          maxLines: 4,
          keyboardType: TextInputType.multiline,
        ),
        
        const SizedBox(height: AppSpacing.paddingM),
        
        TextInput(
          controller: refundPolicyController,
          label: 'Refund Policy',
          hint: 'Terms and conditions for refunds, deposits, cancellations, etc.',
          maxLines: 4,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}

