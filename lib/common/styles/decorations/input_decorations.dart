import 'package:flutter/material.dart';

import '../colors.dart';
import '../spacing.dart';
import '../typography.dart';
import 'border_decorations.dart';

/// Consistent input field decorations for forms and text fields
class InputDecorations {
  // MARK: - Text Field Decorations
  // ==========================================

  /// Standard text field decoration - theme-aware via BuildContext
  static InputDecoration textField(
    BuildContext context, {
    String? labelText,
    String? hintText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
    bool isRequired = false,
  }) {
    return InputDecoration(
      labelText: isRequired ? '$labelText *' : labelText,
      hintText: hintText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabled: enabled,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.all(AppSpacing.paddingM),
      // In the textField method, update the border sections:
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        borderSide: BorderDecorations.standard(context),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        borderSide: BorderDecorations.standard(context),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        borderSide: BorderSide(
          color: AppColors.lightPrimary,
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        borderSide: BorderDecorations.error, // Now using BorderSide
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        borderSide: BorderDecorations.error
            .copyWith(width: 2.0), // Now using BorderSide
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
        borderSide: BorderSide(
          color: AppColors.outline,
          width: 1.0,
        ),
      ),
      labelStyle: AppTypography.inputLabel.copyWith(
        color: enabled ? null : AppColors.textTertiary,
      ),
      hintStyle: AppTypography.input.copyWith(
        color: AppColors.textTertiary,
      ),
      errorStyle: AppTypography.bodySmall.copyWith(
        color: AppColors.error,
      ),
      filled: true,
      fillColor: enabled ? AppColors.lightInputFill : AppColors.surfaceVariant,
    );
  }

  /// Search field decoration
  static InputDecoration search({
    String hintText = 'Search...',
    VoidCallback? onClear,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: const Icon(Icons.search, size: 20),
      suffixIcon: onClear != null
          ? IconButton(
              icon: const Icon(Icons.clear, size: 18),
              onPressed: onClear,
            )
          : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingM,
        vertical: AppSpacing.paddingS,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        borderSide: BorderSide(
          color: AppColors.lightPrimary,
          width: 1.5,
        ),
      ),
      filled: true,
      fillColor: AppColors.lightInputFill,
      isDense: true,
    );
  }

  /// Outlined text field (no fill) - theme-aware via BuildContext
  static InputDecoration outlined(
    BuildContext context, {
    String? labelText,
    String? hintText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return textField(
      context,
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    ).copyWith(
      filled: false,
      fillColor: Colors.transparent,
    );
  }

  // MARK: - Specialized Input Decorations
  // ==========================================

  /// Phone number input decoration - theme-aware via BuildContext
  static InputDecoration phoneNumber(
    BuildContext context, {
    String? errorText,
    String countryCode = '+91',
  }) {
    return textField(
      context,
      labelText: 'Phone Number',
      hintText: 'Enter your phone number',
      errorText: errorText,
      prefixIcon: Padding(
        padding: const EdgeInsets.only(
            left: AppSpacing.paddingM, right: AppSpacing.paddingXS),
        child: Text(
          countryCode,
          style: AppTypography.input,
        ),
      ),
    );
  }

  /// Email input decoration - theme-aware via BuildContext
  static InputDecoration email(BuildContext context, {String? errorText}) {
    return textField(
      context,
      labelText: 'Email Address',
      hintText: 'Enter your email',
      errorText: errorText,
      prefixIcon: const Icon(Icons.email_outlined, size: 20),
    );
  }

  /// Password input decoration - theme-aware via BuildContext
  static InputDecoration password(
    BuildContext context, {
    String? errorText,
    bool obscureText = true,
    VoidCallback? onToggleVisibility,
  }) {
    return textField(
      context,
      labelText: 'Password',
      hintText: 'Enter your password',
      errorText: errorText,
      prefixIcon: const Icon(Icons.lock_outline, size: 20),
      suffixIcon: IconButton(
        icon: Icon(
          obscureText
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          size: 18,
        ),
        onPressed: onToggleVisibility,
      ),
    );
  }

  /// Amount input decoration - theme-aware via BuildContext
  static InputDecoration amount(BuildContext context, {String? errorText}) {
    return textField(
      context,
      labelText: 'Amount',
      hintText: '0.00',
      errorText: errorText,
      prefixIcon: const Padding(
        padding: EdgeInsets.only(
            left: AppSpacing.paddingM, right: AppSpacing.paddingXS),
        child: Text('₹',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // MARK: - Dropdown Decorations
  // ==========================================

  /// Dropdown form field decoration - theme-aware via BuildContext
  static InputDecoration dropdown(
    BuildContext context, {
    String? labelText,
    String? hintText,
    String? errorText,
    bool enabled = true,
  }) {
    return textField(
      context,
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      enabled: enabled,
    ).copyWith(
      suffixIcon: const Padding(
        padding: EdgeInsets.only(right: AppSpacing.paddingS),
        child: Icon(Icons.arrow_drop_down, size: 24),
      ),
    );
  }

  // MARK: - Validation States
  // ==========================================

  /// Success state decoration - theme-aware via BuildContext
  static InputDecoration success(
    BuildContext context, {
    String? labelText,
    String? hintText,
    String successText = 'Valid',
  }) {
    return textField(
      context,
      labelText: labelText,
      hintText: hintText,
    ).copyWith(
      suffixIcon:
          const Icon(Icons.check_circle, color: AppColors.success, size: 18),
      labelStyle: AppTypography.inputLabel.copyWith(color: AppColors.success),
    );
  }

  /// Warning state decoration - theme-aware via BuildContext
  static InputDecoration warning(
    BuildContext context, {
    String? labelText,
    String? hintText,
    String warningText = 'Needs attention',
  }) {
    return textField(
      context,
      labelText: labelText,
      hintText: hintText,
    ).copyWith(
      suffixIcon: const Icon(Icons.warning_amber,
          color: AppColors.statusOrange, size: 18),
      labelStyle:
          AppTypography.inputLabel.copyWith(color: AppColors.statusOrange),
    );
  }
}
