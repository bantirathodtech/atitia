// lib/core/services/accessibility/accessibility_service.dart

import 'package:flutter/material.dart';

import '../../di/firebase/di/firebase_service_locator.dart';

/// Accessibility service for inclusive design
/// Provides accessibility features and screen reader support
class AccessibilityService {
  static final AccessibilityService _instance =
      AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  static AccessibilityService get instance => _instance;

  // Logger not available - removed for now
  final _analyticsService = getIt.analytics;

  bool _isScreenReaderEnabled = false;
  bool _isHighContrastEnabled = false;
  bool _isLargeTextEnabled = false;
  double _textScaleFactor = 1.0;
  String _preferredLanguage = 'en';

  /// Initialize accessibility service
  Future<void> initialize() async {
    try {
    // Logger not available: _logger call removed

      // Check system accessibility settings
      await _checkSystemAccessibilitySettings();

      await _analyticsService.logEvent(
        name: 'accessibility_service_initialized',
        parameters: {
          'screen_reader_enabled': _isScreenReaderEnabled,
          'high_contrast_enabled': _isHighContrastEnabled,
          'large_text_enabled': _isLargeTextEnabled,
          'text_scale_factor': _textScaleFactor,
          'preferred_language': _preferredLanguage,
        },
      );

    // Logger not available: _logger call removed
    } catch (e) {
    // Logger not available: _logger call removed
    }
  }

  /// Check system accessibility settings
  Future<void> _checkSystemAccessibilitySettings() async {
    // TODO: Implement actual system accessibility checks
    // This would involve checking platform-specific accessibility APIs
    _isScreenReaderEnabled = false;
    _isHighContrastEnabled = false;
    _isLargeTextEnabled = false;
    _textScaleFactor = 1.0;
  }

  /// Get accessibility-aware text style
  TextStyle getAccessibleTextStyle({
    required TextStyle baseStyle,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    final accessibleStyle = baseStyle.copyWith(
      fontSize: fontSize ?? (baseStyle.fontSize ?? 14) * _textScaleFactor,
      fontWeight: fontWeight ?? baseStyle.fontWeight,
      color: color ?? baseStyle.color,
    );

    // Increase font weight for high contrast mode
    if (_isHighContrastEnabled) {
      return accessibleStyle.copyWith(
        fontWeight: FontWeight.w600,
      );
    }

    return accessibleStyle;
  }

  /// Get accessibility-aware button style
  ButtonStyle getAccessibleButtonStyle({
    required ButtonStyle baseStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    double? minimumSize,
  }) {
    return baseStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(
        backgroundColor ??
            (baseStyle.backgroundColor?.resolve({}) ?? Colors.blue),
      ),
      foregroundColor: WidgetStateProperty.all(
        foregroundColor ??
            (baseStyle.foregroundColor?.resolve({}) ?? Colors.white),
      ),
      minimumSize: WidgetStateProperty.all(
        Size(minimumSize ?? 48,
            minimumSize ?? 48), // Minimum 48x48 for touch targets
      ),
      elevation: WidgetStateProperty.all(2.0), // Ensure sufficient elevation
    );
  }

  /// Get accessibility-aware card style
  CardTheme getAccessibleCardTheme() {
    return CardTheme(
      elevation: _isHighContrastEnabled ? 4.0 : 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: _isHighContrastEnabled
            ? BorderSide(color: Colors.grey.shade400, width: 1.0)
            : BorderSide.none,
      ),
    );
  }

  /// Get accessibility-aware input decoration
  InputDecoration getAccessibleInputDecoration({
    required String labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: _isHighContrastEnabled
              ? Colors.grey.shade600
              : Colors.grey.shade300,
          width: _isHighContrastEnabled ? 2.0 : 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: _isHighContrastEnabled ? Colors.blue.shade800 : Colors.blue,
          width: _isHighContrastEnabled ? 3.0 : 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.red,
          width: _isHighContrastEnabled ? 3.0 : 2.0,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: _isLargeTextEnabled ? 20.0 : 16.0,
      ),
    );
  }

  /// Create accessible button
  Widget createAccessibleButton({
    required String text,
    required VoidCallback onPressed,
    ButtonStyle? style,
    Widget? icon,
    String? semanticLabel,
    String? tooltip,
  }) {
    return Semantics(
      label: semanticLabel ?? text,
      hint: tooltip,
      button: true,
      child: ElevatedButton(
        onPressed: onPressed,
        style: style,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon,
              const SizedBox(width: 8.0),
            ],
            Text(text),
          ],
        ),
      ),
    );
  }

  /// Create accessible text field
  Widget createAccessibleTextField({
    required String labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel ?? labelText,
      textField: true,
      child: TextFormField(
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: getAccessibleInputDecoration(
          labelText: labelText,
          hintText: hintText,
          helperText: helperText,
          errorText: errorText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  /// Create accessible card
  Widget createAccessibleCard({
    required Widget child,
    VoidCallback? onTap,
    String? semanticLabel,
    String? hint,
  }) {
    return Semantics(
      label: semanticLabel,
      hint: hint,
      button: onTap != null,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: child,
          ),
        ),
      ),
    );
  }

  /// Create accessible list tile
  Widget createAccessibleListTile({
    required String title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    String? semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel ?? title,
      hint: subtitle,
      button: onTap != null,
      child: ListTile(
        leading: leading,
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: _isLargeTextEnabled ? 12.0 : 8.0,
        ),
      ),
    );
  }

  /// Create accessible image
  Widget createAccessibleImage({
    required String imageUrl,
    required String semanticLabel,
    double? width,
    double? height,
    BoxFit? fit,
    String? errorSemanticLabel,
  }) {
    return Semantics(
      label: semanticLabel,
      image: true,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Semantics(
            label: errorSemanticLabel ?? 'Image failed to load',
            child: Container(
              width: width,
              height: height,
              color: Colors.grey.shade300,
              child: const Icon(Icons.broken_image),
            ),
          );
        },
      ),
    );
  }

  /// Create accessible progress indicator
  Widget createAccessibleProgressIndicator({
    required double value,
    String? semanticLabel,
    Color? color,
  }) {
    return Semantics(
      label: semanticLabel ?? 'Progress: ${(value * 100).toInt()}%',
      child: LinearProgressIndicator(
        value: value,
        color: color,
        backgroundColor: _isHighContrastEnabled
            ? Colors.grey.shade600
            : Colors.grey.shade300,
      ),
    );
  }

  /// Create accessible switch
  Widget createAccessibleSwitch({
    required bool value,
    required ValueChanged<bool> onChanged,
    String? semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel ?? 'Switch',
      toggled: value,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor:
            _isHighContrastEnabled ? Colors.blue.shade800 : Colors.blue,
      ),
    );
  }

  /// Create accessible checkbox
  Widget createAccessibleCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    String? semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel ?? 'Checkbox',
      checked: value,
      child: Checkbox(
        value: value,
        onChanged: onChanged,
        activeColor:
            _isHighContrastEnabled ? Colors.blue.shade800 : Colors.blue,
      ),
    );
  }

  /// Create accessible radio button
  Widget createAccessibleRadio<T>({
    required T value,
    required T groupValue,
    required ValueChanged<T?> onChanged,
    String? semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel ?? 'Radio button',
      checked: value == groupValue,
      child: Radio<T>(
        value: value,
        // TODO: Update to RadioGroup when Flutter version supports it
        // ignore: deprecated_member_use
        groupValue: groupValue,
        // ignore: deprecated_member_use
        onChanged: onChanged,
        activeColor:
            _isHighContrastEnabled ? Colors.blue.shade800 : Colors.blue,
      ),
    );
  }

  /// Create accessible dialog
  Widget createAccessibleDialog({
    required String title,
    required String content,
    List<Widget>? actions,
    String? semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel ?? title,
      child: AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  /// Create accessible snackbar
  void showAccessibleSnackBar({
    required BuildContext context,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Semantics(
          label: message,
          child: Text(message),
        ),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                onPressed: onAction,
              )
            : null,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  /// Get accessibility settings
  Map<String, dynamic> getAccessibilitySettings() {
    return {
      'screenReaderEnabled': _isScreenReaderEnabled,
      'highContrastEnabled': _isHighContrastEnabled,
      'largeTextEnabled': _isLargeTextEnabled,
      'textScaleFactor': _textScaleFactor,
      'preferredLanguage': _preferredLanguage,
    };
  }

  /// Update accessibility settings
  void updateAccessibilitySettings({
    bool? screenReaderEnabled,
    bool? highContrastEnabled,
    bool? largeTextEnabled,
    double? textScaleFactor,
    String? preferredLanguage,
  }) {
    if (screenReaderEnabled != null) {
      _isScreenReaderEnabled = screenReaderEnabled;
    }
    if (highContrastEnabled != null) {
      _isHighContrastEnabled = highContrastEnabled;
    }
    if (largeTextEnabled != null) _isLargeTextEnabled = largeTextEnabled;
    if (textScaleFactor != null) _textScaleFactor = textScaleFactor;
    if (preferredLanguage != null) _preferredLanguage = preferredLanguage;

    // Logger not available: _logger call removed
  }

  /// Check if accessibility features are enabled
  bool get isAccessibilityEnabled =>
      _isScreenReaderEnabled || _isHighContrastEnabled || _isLargeTextEnabled;

  /// Get recommended minimum touch target size
  double get minimumTouchTargetSize => _isLargeTextEnabled ? 56.0 : 48.0;

  /// Get recommended text size
  double get recommendedTextSize => _isLargeTextEnabled ? 18.0 : 14.0;

  /// Get recommended icon size
  double get recommendedIconSize => _isLargeTextEnabled ? 28.0 : 24.0;
}
