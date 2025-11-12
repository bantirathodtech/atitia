// ============================================================================
// Guest Help & Support Screen
// ============================================================================
// Help and support screen for guest users
// ============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/constants/app.dart';
import '../../../../../common/utils/constants/routes.dart';
import '../../../../../common/utils/responsive/responsive_breakpoints.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/buttons/secondary_button.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/guest_drawer.dart';

/// Help and support screen for guests
class GuestHelpScreen extends StatelessWidget {
  const GuestHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: loc.guestHelpTitle,
      ),
      drawer: const GuestDrawer(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.sizeOf(context).width;
          final isTabletOrLarger = screenWidth >= ResponsiveBreakpoints.tablet;

          // Use two-column layout for tablet/desktop
          if (isTabletOrLarger && constraints.maxWidth >= 900) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth >= 1200
                    ? AppSpacing.paddingXL
                    : AppSpacing.paddingL,
                vertical: AppSpacing.paddingL,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column: Quick Help & Contact (primary actions)
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildQuickHelpSection(context, emphasized: true),
                        const SizedBox(height: AppSpacing.paddingL),
                        _buildContactSection(context, emphasized: true),
                        const SizedBox(height: AppSpacing.paddingL),
                        _buildResourcesSection(context),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.paddingL),
                  // Right column: FAQ (reference material)
                  Expanded(
                    flex: 1,
                    child: _buildFaqSection(context),
                  ),
                ],
              ),
            );
          }

          // Single column layout for mobile
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveBreakpoints.getPadding(screenWidth),
              vertical: AppSpacing.paddingL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuickHelpSection(context, emphasized: true),
                const SizedBox(height: AppSpacing.paddingL),
                _buildFaqSection(context),
                const SizedBox(height: AppSpacing.paddingL),
                _buildContactSection(context, emphasized: true),
                const SizedBox(height: AppSpacing.paddingL),
                _buildResourcesSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickHelpSection(BuildContext context,
      {bool emphasized = false}) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Semantics(
      header: true,
      child: AdaptiveCard(
        padding: EdgeInsets.all(
            emphasized ? AppSpacing.paddingXL : AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (emphasized)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.paddingS),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusS),
                    ),
                    child: Icon(
                      Icons.lightbulb_outline,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                if (emphasized) const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: HeadingMedium(text: loc.guestHelpQuickHelp),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text: loc.guestHelpHeroSubtitle,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            _buildHelpItem(
              context,
              icon: Icons.video_library,
              title: loc.guestHelpVideosTitle,
              subtitle: loc.guestHelpVideosSubtitle,
              onTap: () async {
                // Open video tutorials URL
                final Uri url = Uri.parse('https://www.youtube.com/@atitia');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(loc.guestHelpUnableToOpenVideos),
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
              title: loc.guestHelpDocsTitle,
              subtitle: loc.guestHelpDocsSubtitle,
              onTap: () async {
                // Open documentation URL
                final Uri url = Uri.parse('https://docs.atitia.com');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(loc.guestHelpUnableToOpenDocs),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final faqs = [
      {
        'question': loc.guestHelpFaqBookQuestion,
        'answer': loc.guestHelpFaqBookAnswer,
      },
      {
        'question': loc.guestHelpFaqStatusQuestion,
        'answer': loc.guestHelpFaqStatusAnswer,
      },
      {
        'question': loc.guestHelpFaqPaymentQuestion,
        'answer': loc.guestHelpFaqPaymentAnswer,
      },
      {
        'question': loc.guestHelpFaqProfileQuestion,
        'answer': loc.guestHelpFaqProfileAnswer,
      },
      {
        'question': loc.guestHelpFaqComplaintQuestion,
        'answer': loc.guestHelpFaqComplaintAnswer,
      },
    ];

    return Semantics(
      header: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingMedium(text: loc.guestHelpFaqTitle),
          const SizedBox(height: AppSpacing.paddingM),
          ...faqs.asMap().entries.map((entry) {
            final index = entry.key;
            final faq = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < faqs.length - 1 ? AppSpacing.paddingS : 0,
              ),
              child: _buildFaqCard(context, faq),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFaqCard(
    BuildContext context,
    Map<String, String> faq,
  ) {
    return Semantics(
      button: true,
      expanded: false,
      child: AdaptiveCard(
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
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, {bool emphasized = false}) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Semantics(
      header: true,
      child: AdaptiveCard(
        padding: EdgeInsets.all(
            emphasized ? AppSpacing.paddingXL : AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (emphasized)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.paddingS),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius:
                          BorderRadius.circular(AppSpacing.borderRadiusS),
                    ),
                    child: Icon(
                      Icons.support_agent,
                      color: theme.colorScheme.onSecondaryContainer,
                      size: 20,
                    ),
                  ),
                if (emphasized) const SizedBox(width: AppSpacing.paddingM),
                Expanded(
                  child: HeadingMedium(text: loc.guestHelpContactTitle),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            BodyText(
              text: loc.guestHelpContactSubtitle,
            ),
            const SizedBox(height: AppSpacing.paddingM),
            _buildContactItem(
              context,
              icon: Icons.email,
              title: loc.guestHelpEmailTitle,
              subtitle: AppConstants.supportEmail,
              onTap: () async {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: AppConstants.supportEmail,
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
              title: loc.guestHelpPhoneTitle,
              subtitle: '+91 1234567890',
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
              title: loc.guestHelpChatTitle,
              subtitle: loc.guestHelpChatSubtitle,
              onTap: () async {
                // Try WhatsApp first
                final Uri whatsappUrl = Uri.parse('https://wa.me/917020797849');
                bool whatsappLaunched = false;

                if (await canLaunchUrl(whatsappUrl)) {
                  try {
                    await launchUrl(whatsappUrl,
                        mode: LaunchMode.externalApplication);
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
                    await launchUrl(webChatUrl,
                        mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(loc.guestHelpUnableToOpenChat),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
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
          HeadingMedium(text: loc.guestHelpResourcesTitle),
          const SizedBox(height: AppSpacing.paddingM),
          SecondaryButton(
            label: loc.guestHelpPrivacyPolicy,
            icon: Icons.privacy_tip,
            onPressed: () {
              context.push(AppRoutes.privacyPolicy);
            },
          ),
          const SizedBox(height: AppSpacing.paddingS),
          SecondaryButton(
            label: loc.guestHelpTermsOfService,
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
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      child: AdaptiveCard(
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
                  const SizedBox(height: AppSpacing.paddingXS),
                  CaptionText(text: subtitle),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
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
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: '$title: $subtitle',
      child: AdaptiveCard(
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
                  const SizedBox(height: AppSpacing.paddingXS),
                  CaptionText(text: subtitle),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
