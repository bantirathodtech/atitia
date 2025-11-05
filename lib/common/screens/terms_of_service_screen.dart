// ============================================================================
// Terms of Service Screen
// ============================================================================
// Simple screen displaying terms of service content
// ============================================================================

import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Terms of Service',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingLarge(text: 'Terms of Service'),
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
                    '1. Acceptance of Terms',
                    'By accessing and using the Atitia app, you accept and agree to be bound by these Terms of Service. If you do not agree, please do not use our services.',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '2. User Accounts',
                    'You are responsible for:\n'
                        '• Maintaining the confidentiality of your account\n'
                        '• All activities that occur under your account\n'
                        '• Providing accurate and complete information',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '3. Booking and Payments',
                    '• Booking requests are subject to owner approval\n'
                        '• Payment terms are as agreed with the property owner\n'
                        '• Refunds are subject to the property\'s cancellation policy\n'
                        '• We facilitate transactions but are not a party to the rental agreement',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '4. Property Owner Responsibilities',
                    'Property owners must:\n'
                        '• Provide accurate property information\n'
                        '• Honor confirmed bookings\n'
                        '• Maintain property standards\n'
                        '• Respond to guest inquiries promptly',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '5. Prohibited Activities',
                    'You agree not to:\n'
                        '• Use the service for illegal purposes\n'
                        '• Post false or misleading information\n'
                        '• Interfere with the app\'s functionality\n'
                        '• Attempt unauthorized access to the system',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '6. Limitation of Liability',
                    'Atitia provides the platform "as is" and is not liable for:\n'
                        '• Disputes between guests and property owners\n'
                        '• Property condition or safety issues\n'
                        '• Payment disputes or refunds\n'
                        '• Indirect or consequential damages',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '7. Changes to Terms',
                    'We reserve the right to modify these terms at any time. Continued use of the service constitutes acceptance of modified terms.',
                  ),
                  const SizedBox(height: AppSpacing.paddingL),
                  _buildSection(
                    '8. Contact Information',
                    'For questions about these Terms, contact us at:\n\n'
                        'Email: legal@atitia.com\n'
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
