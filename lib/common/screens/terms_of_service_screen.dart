// ============================================================================
// Terms of Service Screen
// ============================================================================
// Simple screen displaying terms of service content
// ============================================================================

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../styles/colors.dart';
import '../styles/spacing.dart';
import '../widgets/app_bars/adaptive_app_bar.dart';
import '../widgets/cards/adaptive_card.dart';
import '../widgets/text/body_text.dart';
import '../widgets/text/heading_large.dart';

/// Terms of Service screen
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AdaptiveAppBar(
        title: loc.termsOfServiceTitle,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingLarge(text: loc.termsOfServiceTitle),
            const SizedBox(height: AppSpacing.paddingM),
            AdaptiveCard(
              padding: const EdgeInsets.all(AppSpacing.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    loc.termsOfServiceLastUpdatedLabel,
                    loc.termsOfServiceLastUpdatedDate,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.termsOfServiceSection1Title,
                    loc.termsOfServiceSection1Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.termsOfServiceSection2Title,
                    loc.termsOfServiceSection2Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.termsOfServiceSection3Title,
                    loc.termsOfServiceSection3Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.termsOfServiceSection4Title,
                    loc.termsOfServiceSection4Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.termsOfServiceSection5Title,
                    loc.termsOfServiceSection5Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.termsOfServiceSection6Title,
                    loc.termsOfServiceSection6Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.termsOfServiceSection7Title,
                    loc.termsOfServiceSection7Content,
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    loc.termsOfServiceSection8Title,
                    loc.termsOfServiceSection8Content,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
