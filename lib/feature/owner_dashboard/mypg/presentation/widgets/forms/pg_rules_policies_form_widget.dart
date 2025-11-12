import 'package:flutter/material.dart';

import '../../../../../../common/lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../../../../../common/styles/spacing.dart';
import '../../../../../../common/widgets/dropdowns/adaptive_dropdown.dart';
import '../../../../../../common/widgets/grids/responsive_grid.dart';
import '../../../../../../common/widgets/inputs/text_input.dart';
import '../../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../../l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: loc.pgRulesTitle),
        const SizedBox(height: AppSpacing.paddingL),
        ResponsiveGrid(
          targetTileWidth: 320,
          horizontalGap: AppSpacing.paddingM,
          verticalGap: AppSpacing.paddingM,
          childAspectRatio: 3.6,
          children: [
            TextInput(
              controller: entryTimingsController,
              label: loc.pgRulesEntryTimingsLabel,
              hint: loc.pgRulesTimingsHint,
            ),
            TextInput(
              controller: exitTimingsController,
              label: loc.pgRulesExitTimingsLabel,
              hint: loc.pgRulesTimingsHint,
            ),
            AdaptiveDropdown<String>(
              label: loc.pgRulesSmokingPolicyLabel,
              value: selectedSmokingPolicy,
              items: [
                DropdownMenuItem(
                    value: 'Not Allowed',
                    child: Text(loc.pgRulesPolicyNotAllowed)),
                DropdownMenuItem(
                    value: 'Allowed', child: Text(loc.pgRulesPolicyAllowed)),
                DropdownMenuItem(
                    value: 'Designated Areas Only',
                    child: Text(loc.pgRulesPolicyDesignatedAreas)),
              ],
              onChanged: onSmokingPolicyChanged,
              hint: loc.pgRulesPolicyHint,
            ),
            AdaptiveDropdown<String>(
              label: loc.pgRulesAlcoholPolicyLabel,
              value: selectedAlcoholPolicy,
              items: [
                DropdownMenuItem(
                    value: 'Not Allowed',
                    child: Text(loc.pgRulesPolicyNotAllowed)),
                DropdownMenuItem(
                    value: 'Allowed', child: Text(loc.pgRulesPolicyAllowed)),
                DropdownMenuItem(
                    value: 'Designated Areas Only',
                    child: Text(loc.pgRulesPolicyDesignatedAreas)),
              ],
              onChanged: onAlcoholPolicyChanged,
              hint: loc.pgRulesPolicyHint,
            ),
            TextInput(
              controller: noticePeriodController,
              label: loc.pgRulesNoticePeriodLabel,
              hint: loc.pgRulesNoticePeriodHint,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.paddingM),
        TextInput(
          controller: guestPolicyController,
          label: loc.pgRulesGuestPolicyLabel,
          hint: loc.pgRulesGuestPolicyHint,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(height: AppSpacing.paddingM),
        TextInput(
          controller: refundPolicyController,
          label: loc.pgRulesRefundPolicyLabel,
          hint: loc.pgRulesRefundPolicyHint,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
