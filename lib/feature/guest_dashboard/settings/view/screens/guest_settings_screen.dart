// ============================================================================
// Guest Settings Screen
// ============================================================================
// Settings screen for guest users to manage app preferences
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../common/widgets/dropdowns/language_selector.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../core/app/theme/theme_provider.dart';
import '../../../shared/widgets/guest_drawer.dart';

/// Settings screen for guests
class GuestSettingsScreen extends StatelessWidget {
  const GuestSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdaptiveAppBar(
        title: 'Settings',
      ),
      drawer: const GuestDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              title: 'Appearance',
              children: [
                _buildThemeSelector(context),
                const SizedBox(height: AppSpacing.paddingM),
                _buildLanguageSelector(context),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              context,
              title: 'Notifications',
              children: [
                _buildSwitchTile(
                  context,
                  title: 'Push Notifications',
                  subtitle: 'Receive notifications on your device',
                  value: true,
                  onChanged: (value) {},
                ),
                const SizedBox(height: AppSpacing.paddingS),
                _buildSwitchTile(
                  context,
                  title: 'Email Notifications',
                  subtitle: 'Receive notifications via email',
                  value: false,
                  onChanged: (value) {},
                ),
                const SizedBox(height: AppSpacing.paddingS),
                _buildSwitchTile(
                  context,
                  title: 'Payment Reminders',
                  subtitle: 'Get reminders for pending payments',
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              context,
              title: 'Data & Privacy',
              children: [
                _buildListTile(
                  context,
                  title: 'Privacy Policy',
                  icon: Icons.privacy_tip_outlined,
                  onTap: () {
                    // TODO: Navigate to privacy policy
                  },
                ),
                const SizedBox(height: AppSpacing.paddingS),
                _buildListTile(
                  context,
                  title: 'Terms of Service',
                  icon: Icons.description_outlined,
                  onTap: () {
                    // TODO: Navigate to terms of service
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              context,
              title: 'About',
              children: [
                _buildInfoTile(
                  context,
                  title: 'App Version',
                  value: '1.0.0',
                ),
                const SizedBox(height: AppSpacing.paddingS),
                _buildInfoTile(
                  context,
                  title: 'Build Number',
                  value: '1',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingMedium(text: title),
        const SizedBox(height: AppSpacing.paddingM),
        AdaptiveCard(
          padding: const EdgeInsets.all(AppSpacing.paddingM),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: 'Theme',
                    medium: true,
                  ),
                  const SizedBox(height: 4),
                  CaptionText(
                    text: 'Choose your preferred theme',
                  ),
                ],
              ),
              Icon(
                themeProvider.themeModeIcon,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text('Light'),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text('System'),
                icon: Icon(Icons.brightness_auto),
              ),
            ],
            selected: {themeProvider.themeMode},
            onSelectionChanged: (Set<ThemeMode> selection) {
              themeProvider.setThemeMode(selection.first);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BodyText(
                    text: 'Language',
                    medium: true,
                  ),
                  const SizedBox(height: 4),
                  CaptionText(
                    text: 'Select your preferred language',
                  ),
                ],
              ),
              const Icon(
                Icons.language,
                color: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          const LanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AdaptiveCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BodyText(
                  text: title,
                  medium: true,
                ),
                const SizedBox(height: 4),
                CaptionText(text: subtitle),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return AdaptiveCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: BodyText(text: title, medium: true),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return AdaptiveCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BodyText(text: title, medium: true),
          BodyText(text: value),
        ],
      ),
    );
  }
}
