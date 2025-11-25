// lib/common/widgets/errors/enhanced_error_message.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../text/body_text.dart';
import '../text/heading_medium.dart';

/// 🎨 **ENHANCED ERROR MESSAGE - USER-FRIENDLY & ACTIONABLE**
///
/// Beautiful error messages with clear actions, helpful context, and recovery suggestions
/// Provides premium UX for error handling
class EnhancedErrorMessage extends StatelessWidget {
  final String title;
  final String message;
  final String? suggestion;
  final IconData? icon;
  final Color? iconColor;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final ErrorType errorType;

  const EnhancedErrorMessage({
    required this.title,
    required this.message,
    this.suggestion,
    this.icon,
    this.iconColor,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.errorType = ErrorType.standard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final errorColor = iconColor ?? theme.colorScheme.error;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      decoration: BoxDecoration(
        color: errorColor.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(
          color: errorColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.paddingS),
                decoration: BoxDecoration(
                  color: errorColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon ?? _getIconForType(errorType),
                  color: errorColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.paddingM),
              Expanded(
                child: HeadingMedium(
                  text: title,
                  color: errorColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.paddingM),
          BodyText(
            text: message,
            color: theme.textTheme.bodyMedium?.color,
          ),
          if (suggestion != null) ...[
            const SizedBox(height: AppSpacing.paddingS),
            Container(
              padding: const EdgeInsets.all(AppSpacing.paddingM),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    size: 20,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: AppSpacing.paddingS),
                  Expanded(
                    child: BodyText(
                      text: suggestion!,
                      small: true,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (primaryActionLabel != null || secondaryActionLabel != null) ...[
            const SizedBox(height: AppSpacing.paddingM),
            Wrap(
              spacing: AppSpacing.paddingM,
              runSpacing: AppSpacing.paddingS,
              children: [
                if (primaryActionLabel != null && onPrimaryAction != null)
                  PrimaryButton(
                    onPressed: onPrimaryAction,
                    label: primaryActionLabel!,
                    icon: _getActionIconForType(errorType),
                  ),
                if (secondaryActionLabel != null && onSecondaryAction != null)
                  SecondaryButton(
                    onPressed: onSecondaryAction,
                    label: secondaryActionLabel!,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _getIconForType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.permission:
        return Icons.lock_outline;
      case ErrorType.notFound:
        return Icons.search_off;
      case ErrorType.timeout:
        return Icons.schedule;
      case ErrorType.validation:
        return Icons.error_outline;
      case ErrorType.server:
        return Icons.cloud_off;
      case ErrorType.standard:
        return Icons.error_outline;
    }
  }

  IconData _getActionIconForType(ErrorType type) {
    switch (type) {
      case ErrorType.network:
        return Icons.refresh;
      case ErrorType.permission:
        return Icons.settings;
      case ErrorType.notFound:
        return Icons.search;
      case ErrorType.timeout:
        return Icons.refresh;
      case ErrorType.validation:
        return Icons.edit;
      case ErrorType.server:
        return Icons.refresh;
      case ErrorType.standard:
        return Icons.refresh;
    }
  }
}

enum ErrorType {
  standard,
  network,
  permission,
  notFound,
  timeout,
  validation,
  server,
}

/// Predefined error messages for common scenarios
class ErrorMessages {
  static Widget network({
    required BuildContext context,
    VoidCallback? onRetry,
    String? customMessage,
  }) {
    return EnhancedErrorMessage(
      title: 'No Internet Connection',
      message: customMessage ??
          'Please check your internet connection and try again.',
      suggestion: 'Make sure you\'re connected to Wi-Fi or mobile data.',
      errorType: ErrorType.network,
      primaryActionLabel: 'Retry',
      onPrimaryAction: onRetry,
    );
  }

  static Widget permission({
    required BuildContext context,
    String? resource,
    VoidCallback? onGrantPermission,
  }) {
    return EnhancedErrorMessage(
      title: 'Permission Required',
      message: resource != null
          ? 'We need permission to access $resource to continue.'
          : 'We need permission to continue.',
      suggestion:
          'Please grant the required permission in your device settings.',
      errorType: ErrorType.permission,
      primaryActionLabel: 'Grant Permission',
      onPrimaryAction: onGrantPermission,
      secondaryActionLabel: 'Learn More',
      onSecondaryAction: () {
        // Show help dialog
      },
    );
  }

  static Widget notFound({
    required BuildContext context,
    String? item,
    VoidCallback? onSearch,
  }) {
    return EnhancedErrorMessage(
      title: 'Not Found',
      message: item != null
          ? 'We couldn\'t find "$item".'
          : 'We couldn\'t find what you\'re looking for.',
      suggestion:
          'Try searching with different keywords or check your spelling.',
      errorType: ErrorType.notFound,
      primaryActionLabel: 'Search Again',
      onPrimaryAction: onSearch,
    );
  }

  static Widget timeout({
    required BuildContext context,
    VoidCallback? onRetry,
  }) {
    return EnhancedErrorMessage(
      title: 'Request Timed Out',
      message: 'The request took too long to complete. Please try again.',
      suggestion:
          'This usually happens when the server is slow or your connection is weak.',
      errorType: ErrorType.timeout,
      primaryActionLabel: 'Retry',
      onPrimaryAction: onRetry,
    );
  }

  static Widget validation({
    required BuildContext context,
    String? field,
    String? message,
    VoidCallback? onFix,
  }) {
    return EnhancedErrorMessage(
      title: 'Invalid Input',
      message: message ??
          (field != null
              ? 'Please check the "$field" field and try again.'
              : 'Please check your input and try again.'),
      suggestion: 'Make sure all required fields are filled correctly.',
      errorType: ErrorType.validation,
      primaryActionLabel: 'Fix Now',
      onPrimaryAction: onFix,
    );
  }

  static Widget server({
    required BuildContext context,
    VoidCallback? onRetry,
  }) {
    return EnhancedErrorMessage(
      title: 'Server Error',
      message: 'Something went wrong on our end. We\'re working to fix it.',
      suggestion:
          'Please try again in a few moments. If the problem persists, contact support.',
      errorType: ErrorType.server,
      primaryActionLabel: 'Retry',
      onPrimaryAction: onRetry,
      secondaryActionLabel: 'Contact Support',
      onSecondaryAction: () {
        // Open support/help screen
      },
    );
  }
}

/// Snackbar-style error message
class ErrorSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final theme = Theme.of(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.onError,
            ),
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: BodyText(
                text: message,
                color: theme.colorScheme.onError,
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        ),
        margin: const EdgeInsets.all(AppSpacing.paddingM),
        duration: duration,
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: theme.colorScheme.onError,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}
