// lib/common/widgets/indicators/enhanced_empty_state.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';
import '../text/body_text.dart';
import '../text/heading_medium.dart';

/// 🎨 **ENHANCED EMPTY STATE - POLISHED & CONSISTENT**
///
/// Beautiful empty state with illustrations, animations, and consistent styling
/// Used throughout the app for premium empty state experience
class EnhancedEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final String? illustrationAsset; // Path to illustration asset
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final Color? iconColor;
  final EmptyStateType type;

  const EnhancedEmptyState({
    required this.title,
    required this.message,
    this.icon,
    this.illustrationAsset,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.iconColor,
    this.type = EmptyStateType.standard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = this.iconColor ?? theme.primaryColor.withValues(alpha: 0.6);
    final padding = MediaQuery.of(context).size.width < 600
        ? const EdgeInsets.all(AppSpacing.paddingM)
        : const EdgeInsets.all(AppSpacing.paddingL);

    return Container(
      padding: padding,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: AppSpacing.paddingXL),
              _buildIllustration(context, theme, iconColor),
              const SizedBox(height: AppSpacing.paddingXL),
              _buildContent(context, theme),
              const SizedBox(height: AppSpacing.paddingXL),
              if (primaryActionLabel != null || secondaryActionLabel != null)
                _buildActions(context),
              const SizedBox(height: AppSpacing.paddingXL),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(BuildContext context, ThemeData theme, Color iconColor) {
    // Use illustration asset if provided, otherwise use icon
    if (illustrationAsset != null) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              theme.primaryColor.withValues(alpha: 0.1),
              theme.primaryColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Image.asset(
          illustrationAsset!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _buildIcon(context, iconColor),
        ),
      );
    }

    return _buildIcon(context, iconColor);
  }

  Widget _buildIcon(BuildContext context, Color iconColor) {
    final icon = this.icon ?? Icons.inbox_outlined;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: iconColor.withValues(alpha: 0.1),
        border: Border.all(
          color: iconColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        size: 64,
        color: iconColor,
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        HeadingMedium(
          text: title,
          align: TextAlign.center,
          color: theme.textTheme.headlineMedium?.color,
        ),
        const SizedBox(height: AppSpacing.paddingM),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingXL),
          child: BodyText(
            text: message,
            align: TextAlign.center,
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingXL),
      child: Column(
        children: [
          if (primaryActionLabel != null && onPrimaryAction != null)
            PrimaryButton(
              onPressed: onPrimaryAction,
              label: primaryActionLabel!,
            ),
          if (primaryActionLabel != null && secondaryActionLabel != null)
            const SizedBox(height: AppSpacing.paddingM),
          if (secondaryActionLabel != null && onSecondaryAction != null)
            SecondaryButton(
              onPressed: onSecondaryAction,
              label: secondaryActionLabel!,
            ),
        ],
      ),
    );
  }
}

enum EmptyStateType {
  standard,
  minimal,
  detailed,
}

/// Predefined empty states for common scenarios
class EmptyStates {
  static Widget noData({
    required BuildContext context,
    String? title,
    String? message,
    VoidCallback? onRefresh,
  }) {
    return EnhancedEmptyState(
      title: title ?? 'No Data Available',
      message: message ?? 'There\'s nothing to display here yet.',
      icon: Icons.inbox_outlined,
      primaryActionLabel: 'Refresh',
      onPrimaryAction: onRefresh,
      type: EmptyStateType.standard,
    );
  }

  static Widget noSearchResults({
    required BuildContext context,
    String? query,
    VoidCallback? onClearSearch,
  }) {
    return EnhancedEmptyState(
      title: 'No Results Found',
      message: query != null
          ? 'We couldn\'t find anything matching "$query". Try a different search term.'
          : 'We couldn\'t find anything matching your search.',
      icon: Icons.search_off,
      primaryActionLabel: 'Clear Search',
      onPrimaryAction: onClearSearch,
      type: EmptyStateType.standard,
    );
  }

  static Widget error({
    required BuildContext context,
    String? message,
    VoidCallback? onRetry,
  }) {
    final theme = Theme.of(context);
    return EnhancedEmptyState(
      title: 'Something Went Wrong',
      message: message ?? 'We encountered an error. Please try again.',
      icon: Icons.error_outline,
      iconColor: theme.colorScheme.error,
      primaryActionLabel: 'Try Again',
      onPrimaryAction: onRetry,
      type: EmptyStateType.standard,
    );
  }

  static Widget noConnection({
    required BuildContext context,
    VoidCallback? onRetry,
  }) {
    final theme = Theme.of(context);
    return EnhancedEmptyState(
      title: 'No Internet Connection',
      message: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off,
      iconColor: theme.colorScheme.error,
      primaryActionLabel: 'Retry',
      onPrimaryAction: onRetry,
      type: EmptyStateType.standard,
    );
  }
}

