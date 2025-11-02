// lib/common/widgets/notifications/notification_preferences_widget.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../../styles/typography.dart';
import '../text/heading_small.dart';
import '../text/body_text.dart';
import '../cards/adaptive_card.dart';
import '../../../core/services/firebase/messaging/enhanced_messaging_service.dart';

/// 🔔 **NOTIFICATION PREFERENCES WIDGET - PRODUCTION READY**
///
/// **Features:**
/// - Toggle notification categories
/// - Real-time preference updates
/// - Theme-aware styling
/// - Analytics tracking
class NotificationPreferencesWidget extends StatefulWidget {
  const NotificationPreferencesWidget({super.key});

  @override
  State<NotificationPreferencesWidget> createState() => _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState extends State<NotificationPreferencesWidget> {
  final _messagingService = enhancedMessagingService;
  Map<String, bool> _preferences = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() => _loading = true);
    final preferences = _messagingService.getNotificationPreferences();
    setState(() {
      _preferences = preferences;
      _loading = false;
    });
  }

  Future<void> _updatePreference(String key, bool value) async {
    setState(() => _preferences[key] = value);
    
    await _messagingService.updateNotificationPreferences(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return AdaptiveCard(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeadingSmall(
            text: 'Notification Preferences',
            color: theme.primaryColor,
          ),
          const SizedBox(height: AppSpacing.paddingM),
          BodyText(
            text: 'Choose which types of notifications you want to receive',
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: AppSpacing.paddingL),
          ..._buildNotificationToggles(context, isDarkMode),
        ],
      ),
    );
  }

  List<Widget> _buildNotificationToggles(BuildContext context, bool isDarkMode) {
    final notifications = [
      {
        'key': 'payment',
        'title': 'Payment Notifications',
        'subtitle': 'Rent reminders, payment confirmations',
        'icon': Icons.payment,
      },
      {
        'key': 'booking',
        'title': 'Booking Updates',
        'subtitle': 'Booking confirmations, status changes',
        'icon': Icons.event_available,
      },
      {
        'key': 'complaint',
        'title': 'Complaint Updates',
        'subtitle': 'Complaint responses, resolution updates',
        'icon': Icons.support_agent,
      },
      {
        'key': 'food',
        'title': 'Food Notifications',
        'subtitle': 'Menu updates, special meals',
        'icon': Icons.restaurant,
      },
      {
        'key': 'maintenance',
        'title': 'Maintenance Alerts',
        'subtitle': 'Scheduled maintenance, repairs',
        'icon': Icons.build,
      },
      {
        'key': 'general',
        'title': 'General Announcements',
        'subtitle': 'Important updates, announcements',
        'icon': Icons.campaign,
      },
    ];

    return notifications.map((notification) {
      final key = notification['key'] as String;
      final title = notification['title'] as String;
      final subtitle = notification['subtitle'] as String;
      final icon = notification['icon'] as IconData;
      final enabled = _preferences[key] ?? true;

      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingS),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: enabled,
              onChanged: (value) => _updatePreference(key, value),
              activeThumbColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      );
    }).toList();
  }
}

/// 🔔 **NOTIFICATION SETTINGS DIALOG**
class NotificationSettingsDialog extends StatefulWidget {
  const NotificationSettingsDialog({super.key});

  @override
  State<NotificationSettingsDialog> createState() => _NotificationSettingsDialogState();
}

class _NotificationSettingsDialogState extends State<NotificationSettingsDialog> {
  final _messagingService = enhancedMessagingService;
  Map<String, bool> _preferences = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    setState(() => _loading = true);
    final preferences = _messagingService.getNotificationPreferences();
    setState(() {
      _preferences = preferences;
      _loading = false;
    });
  }

  Future<void> _updatePreference(String key, bool value) async {
    setState(() => _preferences[key] = value);
    
    await _messagingService.updateNotificationPreferences(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDarkMode ? AppColors.darkCard : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        padding: const EdgeInsets.all(AppSpacing.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications,
                  color: theme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.paddingS),
                HeadingSmall(
                  text: 'Notification Settings',
                  color: theme.primaryColor,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.paddingM),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: _buildNotificationToggles(context, isDarkMode),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.paddingM),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildNotificationToggles(BuildContext context, bool isDarkMode) {
    final notifications = [
      {
        'key': 'payment',
        'title': 'Payment Notifications',
        'subtitle': 'Rent reminders, payment confirmations',
        'icon': Icons.payment,
      },
      {
        'key': 'booking',
        'title': 'Booking Updates',
        'subtitle': 'Booking confirmations, status changes',
        'icon': Icons.event_available,
      },
      {
        'key': 'complaint',
        'title': 'Complaint Updates',
        'subtitle': 'Complaint responses, resolution updates',
        'icon': Icons.support_agent,
      },
      {
        'key': 'food',
        'title': 'Food Notifications',
        'subtitle': 'Menu updates, special meals',
        'icon': Icons.restaurant,
      },
      {
        'key': 'maintenance',
        'title': 'Maintenance Alerts',
        'subtitle': 'Scheduled maintenance, repairs',
        'icon': Icons.build,
      },
      {
        'key': 'general',
        'title': 'General Announcements',
        'subtitle': 'Important updates, announcements',
        'icon': Icons.campaign,
      },
    ];

    return notifications.map((notification) {
      final key = notification['key'] as String;
      final title = notification['title'] as String;
      final subtitle = notification['subtitle'] as String;
      final icon = notification['icon'] as IconData;
      final enabled = _preferences[key] ?? true;

      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.paddingM),
        padding: const EdgeInsets.all(AppSpacing.paddingM),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkInputFill : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
          border: Border.all(
            color: isDarkMode ? AppColors.darkDivider : AppColors.outline,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingS),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusS),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: enabled,
              onChanged: (value) => _updatePreference(key, value),
              activeThumbColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      );
    }).toList();
  }
}
