// lib/common/widgets/dialogs/premium_upgrade_dialog.dart

import 'package:flutter/material.dart';

import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../text/heading_medium.dart';
import '../text/body_text.dart';
import '../text/caption_text.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/di/firebase/di/firebase_service_locator.dart';

/// Dialog shown when free-tier owners try to access premium features
/// Provides clear upgrade path and feature explanation
class PremiumUpgradeDialog extends StatelessWidget {
  final String featureName;
  final String? description;
  final List<String>? featureBenefits;

  const PremiumUpgradeDialog({
    super.key,
    required this.featureName,
    this.description,
    this.featureBenefits,
  });

  /// Show premium upgrade dialog
  static Future<void> show(
    BuildContext context, {
    required String featureName,
    String? description,
    List<String>? featureBenefits,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) => PremiumUpgradeDialog(
        featureName: featureName,
        description: description,
        featureBenefits: featureBenefits,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with premium badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.paddingS),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppSpacing.borderRadiusM),
                  ),
                  child: Icon(
                    Icons.star,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeadingMedium(text: 'Premium Feature'),
                      CaptionText(
                        text: featureName,
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),

            // Description
            if (description != null) ...[
              BodyText(
                text: description!,
                color: theme.textTheme.bodyMedium?.color,
              ),
              const SizedBox(height: AppSpacing.paddingM),
            ],

            // Benefits list
            if (featureBenefits != null && featureBenefits!.isNotEmpty) ...[
              BodyText(
                text: 'Upgrade to Premium to access:',
                color: theme.textTheme.bodyMedium?.color,
              ),
              const SizedBox(height: AppSpacing.paddingS),
              ...featureBenefits!.map((benefit) => Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.paddingM,
                      bottom: AppSpacing.paddingXS,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: AppSpacing.paddingS),
                        Expanded(
                          child: BodyText(
                            text: benefit,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: AppSpacing.paddingL),
            ],

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SecondaryButton(
                  onPressed: () => Navigator.of(context).pop(),
                  label: 'Cancel',
                ),
                const SizedBox(width: AppSpacing.paddingM),
                PrimaryButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    getIt<NavigationService>().goToOwnerSubscriptionPlans();
                  },
                  label: 'Upgrade Now',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
