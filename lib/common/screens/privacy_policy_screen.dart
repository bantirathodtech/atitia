// ============================================================================
// Privacy Policy Screen
// ============================================================================
// Simple screen displaying privacy policy content
// ============================================================================

import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/spacing.dart';
import '../widgets/app_bars/adaptive_app_bar.dart';
import '../widgets/cards/adaptive_card.dart';
import '../widgets/text/body_text.dart';
import '../widgets/text/heading_large.dart';

/// Privacy Policy screen
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Privacy Policy',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingLarge(text: 'Privacy Policy'),
            const SizedBox(height: AppSpacing.paddingM),
            AdaptiveCard(
              padding: const EdgeInsets.all(AppSpacing.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Last Updated',
                    'November 2025',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '1. Information We Collect',
                    'We collect information that you provide directly to us, including:\n'
                        '• Personal information (name, email, phone number)\n'
                        '• PG booking and payment information\n'
                        '• Profile and preference data\n'
                        '• Communication records with property owners',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '2. How We Use Your Information',
                    'We use the information we collect to:\n'
                        '• Provide, maintain, and improve our services\n'
                        '• Process transactions and send related information\n'
                        '• Send technical notices and support messages\n'
                        '• Respond to your comments and questions',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '3. Information Sharing',
                    'We do not sell, trade, or rent your personal information. We may share your information only:\n'
                        '• With property owners for booking purposes\n'
                        '• To comply with legal obligations\n'
                        '• To protect our rights and safety',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '4. Data Security',
                    'We implement appropriate security measures to protect your personal information. However, no method of transmission over the internet is 100% secure.',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '5. Your Rights',
                    'You have the right to:\n'
                        '• Access your personal information\n'
                        '• Correct inaccurate data\n'
                        '• Request deletion of your data\n'
                        '• Opt-out of certain communications',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '6. Contact Us',
                    'If you have questions about this Privacy Policy, please contact us at:\n\n'
                        'Email: privacy@atitia.com\n'
                        'Phone: +91 1234567890',
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
