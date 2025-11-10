// ============================================================================
// Owner Help & Support Screen
// ============================================================================
// Help and support screen for owner users
// ============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/constants/routes.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/owner_drawer.dart';

/// Help and support screen for owners
class OwnerHelpScreen extends StatelessWidget {
  const OwnerHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: loc.ownerHelpTitle,
      ),
      drawer: const OwnerDrawer(
        currentTabIndex: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickHelpSection(context),
            const SizedBox(height: AppSpacing.paddingL),
            _buildFaqSection(context),
            const SizedBox(height: AppSpacing.paddingL),
            _buildContactSection(context),
            const SizedBox(height: AppSpacing.paddingL),
            _buildResourcesSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickHelpSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(text: loc.ownerHelpQuickHelp),
          const SizedBox(height: AppSpacing.paddingM),
          BodyText(
            text: loc.ownerHelpHeroSubtitle,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildHelpItem(
            context,
            icon: Icons.video_library,
            title: loc.ownerHelpVideosTitle,
            subtitle: loc.ownerHelpVideosSubtitle,
            onTap: () async {
              // Open video tutorials URL
              final Uri url = Uri.parse('https://www.youtube.com/@atitia');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loc.ownerHelpUnableToOpenVideos),
                    ),
                  );
                }
              }
            },
          ),
          const SizedBox(height: AppSpacing.paddingS),
          _buildHelpItem(
            context,
            icon: Icons.article,
            title: loc.ownerHelpDocsTitle,
            subtitle: loc.ownerHelpDocsSubtitle,
            onTap: () async {
              // Open documentation URL
              final Uri url = Uri.parse('https://docs.atitia.com');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loc.ownerHelpUnableToOpenDocs),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final faqs = [
      {
        'question': loc.ownerHelpFaqAddPgQuestion,
        'answer': loc.ownerHelpFaqAddPgAnswer,
      },
      {
        'question': loc.ownerHelpFaqBookingsQuestion,
        'answer': loc.ownerHelpFaqBookingsAnswer,
      },
      {
        'question': loc.ownerHelpFaqPaymentsQuestion,
        'answer': loc.ownerHelpFaqPaymentsAnswer,
      },
      {
        'question': loc.ownerHelpFaqProfileQuestion,
        'answer': loc.ownerHelpFaqProfileAnswer,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: loc.ownerHelpFaqTitle),
        const SizedBox(height: AppSpacing.paddingM),
        ...faqs.map((faq) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.paddingS),
              child: _buildFaqCard(context, faq),
            )),
      ],
    );
  }

  Widget _buildFaqCard(
    BuildContext context,
    Map<String, String> faq,
  ) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: ExpansionTile(
        title: BodyText(
          text: faq['question']!,
          medium: true,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.paddingM),
            child: BodyText(text: faq['answer']!),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(text: loc.ownerHelpContactTitle),
          const SizedBox(height: AppSpacing.paddingM),
          BodyText(
            text: loc.ownerHelpContactSubtitle,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          _buildContactItem(
            context,
            icon: Icons.email,
            title: loc.ownerHelpEmailTitle,
            subtitle: 'support@atitia.com',
            onTap: () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'support@atitia.com',
                query: 'subject=Support Request',
              );
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              }
            },
          ),
          const SizedBox(height: AppSpacing.paddingS),
          _buildContactItem(
            context,
            icon: Icons.phone,
            title: loc.ownerHelpPhoneTitle,
            subtitle: '+91 9876543210',
            onTap: () async {
              final Uri phoneUri = Uri(scheme: 'tel', path: '+911234567890');
              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              }
            },
          ),
          const SizedBox(height: AppSpacing.paddingS),
          _buildContactItem(
            context,
            icon: Icons.chat,
            title: loc.ownerHelpChatTitle,
            subtitle: loc.ownerHelpChatSubtitle,
            onTap: () async {
              // Try WhatsApp first
              final Uri whatsappUrl = Uri.parse('https://wa.me/917020797849');
              bool whatsappLaunched = false;
              
              if (await canLaunchUrl(whatsappUrl)) {
                try {
                  await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                  whatsappLaunched = true;
                } catch (e) {
                  // WhatsApp failed, try fallback
                  whatsappLaunched = false;
                }
              }
              
              // Fallback to web chat if WhatsApp is not available
              if (!whatsappLaunched) {
                final Uri webChatUrl = Uri.parse('https://chat.atitia.com');
                if (await canLaunchUrl(webChatUrl)) {
                  await launchUrl(webChatUrl, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(loc.ownerHelpUnableToOpenChat),
                      ),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResourcesSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(text: loc.ownerHelpResourcesTitle),
          const SizedBox(height: AppSpacing.paddingM),
          SecondaryButton(
            label: loc.ownerHelpPrivacyPolicy,
            icon: Icons.privacy_tip,
            onPressed: () {
              context.push(AppRoutes.privacyPolicy);
            },
          ),
          const SizedBox(height: AppSpacing.paddingS),
          SecondaryButton(
            label: loc.ownerHelpTermsOfService,
            icon: Icons.description,
            onPressed: () {
              context.push(AppRoutes.termsOfService);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(text: title, medium: true),
                const SizedBox(height: 4),
                CaptionText(text: subtitle),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: AppSpacing.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(text: title, medium: true),
                const SizedBox(height: 4),
                CaptionText(text: subtitle),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

