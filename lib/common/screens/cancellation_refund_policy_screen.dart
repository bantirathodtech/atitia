// ============================================================================
// Cancellation and Refund Policy Screen
// ============================================================================
// Cancellation and refund policy screen accessible on all platforms
// ============================================================================

import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/spacing.dart';
import '../widgets/app_bars/adaptive_app_bar.dart';
import '../widgets/cards/adaptive_card.dart';
import '../widgets/text/body_text.dart';
import '../widgets/text/heading_large.dart';

/// Cancellation and Refund Policy screen
class CancellationRefundPolicyScreen extends StatelessWidget {
  const CancellationRefundPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Cancellation & Refund Policy',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingLarge(text: 'Cancellation & Refund Policy'),
            const SizedBox(height: AppSpacing.paddingS),
            BodyText(
              text: 'Last Updated: November 2025',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              title: '1. Booking Cancellation',
              content:
                  '''Guests may cancel their booking requests at any time before owner approval. Once a booking is approved by the property owner, cancellation terms apply as specified in the property's cancellation policy.

Cancellation requests must be submitted through the app or by contacting the property owner directly.''',
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              title: '2. Refund Eligibility',
              content:
                  '''Refunds are subject to the property owner's cancellation policy and may vary by property. Common refund scenarios:

• Full refund: Cancellation within 24-48 hours of booking (as per property policy)
• Partial refund: Cancellation after minimum stay period
• No refund: Cancellation beyond refund period or as specified by property owner

Refund processing time: 5-10 business days after approval.''',
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              title: '3. Payment Refunds',
              content:
                  '''All refunds will be processed to the original payment method used for the booking:

• Online payments: Refunded to the original payment gateway (Razorpay, UPI, etc.)
• Bank transfers: Refunded to the same bank account
• Cash payments: Refunded via bank transfer or as agreed with property owner

Refund processing fees may apply as per payment gateway terms.''',
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              title: '4. Owner Subscription & Featured Listing Refunds',
              content: '''Property owners may request refunds for:
• Subscription fees: Pro-rated refunds available within 7 days of purchase
• Featured listing purchases: Refundable within 48 hours if listing not published

All owner refund requests must be submitted through the app and are subject to admin approval.''',
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              title: '5. Processing Time',
              content: '''Refund processing times:

• Approval: 1-3 business days
• Processing: 5-10 business days after approval
• Bank transfer: Additional 2-3 business days

Total time: Typically 8-15 business days from refund request to receipt of funds.''',
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              title: '6. Disputes and Grievances',
              content: '''If you have concerns about your refund:

1. Contact the property owner directly
2. Submit a complaint through the app
3. Contact our support team at bantirathodtech@gmail.com

We will review all disputes fairly and in accordance with our terms of service.''',
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              title: '7. Contact Us',
              content: '''For questions about cancellations and refunds:

Email: bantirathodtech@gmail.com
Phone: +91 7020797849
WhatsApp: +91 7020797849

Business Hours: Monday - Friday, 9:00 AM - 6:00 PM IST''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: Column(
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
      ),
    );
  }
}
