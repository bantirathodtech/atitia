// ============================================================================
// Owner Settings Screen
// ============================================================================
// Settings screen for owner users to manage app preferences
// ============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../common/styles/colors.dart';
import '../../../../../common/styles/spacing.dart';
import '../../../../../common/utils/constants/routes.dart';
import '../../../../../common/widgets/app_bars/adaptive_app_bar.dart';
import '../../../shared/widgets/owner_drawer.dart';
import '../../../../../common/widgets/text/heading_medium.dart';
import '../../../../../common/widgets/text/body_text.dart';
import '../../../../../common/widgets/text/caption_text.dart';
import '../../../../../common/widgets/cards/adaptive_card.dart';
import '../../../../../core/app/theme/theme_provider.dart';
import '../../../../../common/widgets/dropdowns/language_selector.dart';
import '../../../../../core/services/localization/internationalization_service.dart';

/// Settings screen for owners
class OwnerSettingsScreen extends StatelessWidget {
  const OwnerSettingsScreen({super.key});

  static final InternationalizationService _i18n =
      InternationalizationService.instance;

  static String _text(String key, String fallback,
      {Map<String, dynamic>? parameters}) {
    final translated = _i18n.translate(key, parameters: parameters);
    if (translated.isEmpty || translated == key) {
      var result = fallback;
      parameters?.forEach((paramKey, value) {
        result = result.replaceAll('{$paramKey}', value.toString());
      });
      return result;
    }
    return translated;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: loc.settings,
      ),
      drawer: const OwnerDrawer(
        currentTabIndex: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              title: loc.appearance,
              children: [
                _buildThemeSelector(context, loc),
                const SizedBox(height: AppSpacing.paddingM),
                _buildLanguageSelector(context, loc),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              context,
              title: loc.notifications,
              children: [
                _buildSwitchTile(
                  context,
                  title: loc.pushNotifications,
                  subtitle: loc.receiveNotificationsOnYourDevice,
                  value: true,
                  onChanged: (value) {},
                ),
                const SizedBox(height: AppSpacing.paddingS),
                _buildSwitchTile(
                  context,
                  title: loc.emailNotifications,
                  subtitle: loc.receiveNotificationsViaEmail,
                  value: false,
                  onChanged: (value) {},
                ),
                const SizedBox(height: AppSpacing.paddingS),
                _buildSwitchTile(
                  context,
                  title: loc.paymentReminders,
                  subtitle: loc.getRemindersForPendingPayments,
                  value: true,
                  onChanged: (value) {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              context,
              title: loc.dataPrivacy,
              children: [
                _buildListTile(
                  context,
                  title: loc.privacyPolicy,
                  icon: Icons.privacy_tip_outlined,
                  onTap: () {
                    context.push(AppRoutes.privacyPolicy);
                  },
                ),
                const SizedBox(height: AppSpacing.paddingS),
                _buildListTile(
                  context,
                  title: loc.termsOfService,
                  icon: Icons.description_outlined,
                  onTap: () {
                    context.push(AppRoutes.termsOfService);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingL),
            _buildSection(
              context,
              title: loc.about,
              children: [
                _buildInfoTile(
                  context,
                  title: loc.appVersion,
                  value: _text('ownerSettingsAppVersionValue', '1.0.0'),
                ),
                const SizedBox(height: AppSpacing.paddingS),
                _buildInfoTile(
                  context,
                  title: loc.buildNumber,
                  value: _text('ownerSettingsBuildNumberValue', '1'),
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

  Widget _buildThemeSelector(BuildContext context, AppLocalizations loc) {
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
                    text: loc.theme,
                    medium: true,
                  ),
                  const SizedBox(height: 4),
                  CaptionText(
                    text: loc.chooseYourPreferredTheme,
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
            segments: [
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text(loc.themeLight),
                icon: const Icon(Icons.light_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text(loc.themeDark),
                icon: const Icon(Icons.dark_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text(loc.themeSystem),
                icon: const Icon(Icons.brightness_auto),
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

  Widget _buildLanguageSelector(BuildContext context, AppLocalizations loc) {
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
                    text: loc.language,
                    medium: true,
                  ),
                  const SizedBox(height: 4),
                  CaptionText(
                    text: loc.selectPreferredLanguage,
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
            thumbColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary;
              }
              return null;
            }),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
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
