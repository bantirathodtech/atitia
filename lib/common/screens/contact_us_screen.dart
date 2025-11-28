// ============================================================================
// Contact Us Screen
// ============================================================================
// Contact information screen accessible on all platforms
// ============================================================================

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants/app.dart';
import '../styles/colors.dart';
import '../styles/spacing.dart';
import '../widgets/app_bars/adaptive_app_bar.dart';
import '../widgets/cards/adaptive_card.dart';
import '../widgets/text/body_text.dart';
import '../widgets/text/heading_large.dart';
import '../widgets/text/heading_medium.dart';

/// Contact Us screen
class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: 'Contact Us',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingLarge(text: 'Contact Us'),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text:
                  'We are here to help! Reach out to us through any of the following channels:',
            ),
            const SizedBox(height: AppSpacing.paddingL),
            AdaptiveCard(
              padding: const EdgeInsets.all(AppSpacing.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildContactItem(
                    context,
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: AppConstants.supportEmail,
                    onTap: () => _sendEmail(context),
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  _buildContactItem(
                    context,
                    icon: Icons.phone,
                    title: 'Phone',
                    subtitle: '+91 7020797849',
                    onTap: () => _makePhoneCall(context),
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  _buildContactItem(
                    context,
                    icon: Icons.chat,
                    title: 'WhatsApp',
                    subtitle: '+91 7020797849',
                    onTap: () => _openWhatsApp(context),
                  ),
                  const SizedBox(height: AppSpacing.paddingM),
                  _buildContactItem(
                    context,
                    icon: Icons.location_on,
                    title: 'Address',
                    subtitle: 'Hitech City, Hyderabad, Telangana, India 500083',
                    onTap: null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.paddingL),
            HeadingMedium(text: 'Business Hours'),
            const SizedBox(height: AppSpacing.paddingS),
            AdaptiveCard(
              padding: const EdgeInsets.all(AppSpacing.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBusinessHour(
                      'Monday - Friday', '9:00 AM - 6:00 PM IST'),
                  const SizedBox(height: AppSpacing.paddingS),
                  _buildBusinessHour('Saturday', '10:00 AM - 4:00 PM IST'),
                  const SizedBox(height: AppSpacing.paddingS),
                  _buildBusinessHour('Sunday', 'Closed'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: title,
                    medium: true,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.paddingXS),
                  BodyText(text: subtitle),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessHour(String day, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BodyText(text: day, medium: true),
        BodyText(text: time),
      ],
    );
  }

  Future<void> _sendEmail(BuildContext context) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: AppConstants.supportEmail,
      query: 'subject=Contact Us - Atitia App',
    );
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (context.mounted) {
          _showError(context, 'Could not open email client');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to open email: $e');
      }
    }
  }

  Future<void> _makePhoneCall(BuildContext context) async {
    final phoneUri = Uri(scheme: 'tel', path: '+917020797849');
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        if (context.mounted) {
          _showError(context, 'Could not make phone call');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to make phone call: $e');
      }
    }
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    final whatsappUrl = Uri.parse('https://wa.me/917020797849');
    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          _showError(context, 'Could not open WhatsApp');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showError(context, 'Failed to open WhatsApp: $e');
      }
    }
  }

  void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
