// ============================================================================
// Privacy Policy Screen
// ============================================================================
// Simple screen displaying privacy policy content
// ============================================================================

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../l10n/app_localizations.dart';
import '../utils/constants/app.dart';
import '../styles/colors.dart';
import '../styles/spacing.dart';
import '../widgets/app_bars/adaptive_app_bar.dart';
import '../widgets/cards/adaptive_card.dart';
import '../widgets/buttons/secondary_button.dart';
import '../widgets/text/body_text.dart';
import '../widgets/text/heading_large.dart';

/// Privacy Policy screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: loc.privacyPolicyTitle,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingLarge(text: loc.privacyPolicyTitle),
            const SizedBox(height: AppSpacing.paddingM),
            SecondaryButton(
              label: loc.privacyPolicyViewOnlineButton,
              icon: Icons.open_in_new,
              onPressed: () => _openPrivacyPolicyUrl(context),
            ),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text:
                  loc.privacyPolicyHostedNotice(AppConstants.privacyPolicyUrl),
            ),
            const SizedBox(height: AppSpacing.paddingM),
            AdaptiveCard(
              padding: const EdgeInsets.all(AppSpacing.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    loc.privacyPolicyLastUpdatedLabel,
                    loc.privacyPolicyLastUpdatedDate,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.privacyPolicySection1Title,
                    loc.privacyPolicySection1Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.privacyPolicySection2Title,
                    loc.privacyPolicySection2Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.privacyPolicySection3Title,
                    loc.privacyPolicySection3Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.privacyPolicySection4Title,
                    loc.privacyPolicySection4Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.privacyPolicySection5Title,
                    loc.privacyPolicySection5Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.privacyPolicySection6Title,
                    loc.privacyPolicySection6Content,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPrivacyPolicyUrl(BuildContext context) async {
    final uri = Uri.parse(AppConstants.privacyPolicyUrl);
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.privacyPolicyOpenLinkError)),
      );
    }
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BodyText(
          text: title,
          medium: true,
          color: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.paddingS),
        BodyText(text: content),
      ],
    );
  }
}
