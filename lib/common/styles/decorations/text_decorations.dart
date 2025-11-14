import 'package:flutter/material.dart';

import '../colors.dart';
import '../typography.dart';

/// Text decoration utilities for enhanced text styling
class TextDecorations {
  // MARK: - Text Shadow Effects
  // ==========================================

  /// Subtle text shadow for better readability - theme-aware via BuildContext
  static List<Shadow> subtle(BuildContext context, {Color? shadowColor}) {
    final defaultShadowColor =
        shadowColor ?? Theme.of(context).colorScheme.shadow;
    return [
      Shadow(
        color: defaultShadowColor.withValues(alpha: 0.1),
        offset: const Offset(1, 1),
        blurRadius: 2,
      ),
    ];
  }

  /// Strong text shadow for emphasis - theme-aware via BuildContext
  static List<Shadow> strong(BuildContext context, {Color? shadowColor}) {
    final defaultShadowColor =
        shadowColor ?? Theme.of(context).colorScheme.shadow;
    return [
      Shadow(
        color: defaultShadowColor.withValues(alpha: 0.3),
        offset: const Offset(2, 2),
        blurRadius: 4,
      ),
    ];
  }

  /// Glow effect for text
  static List<Shadow> glow({
    Color glowColor = AppColors.lightAccent,
    double blurRadius = 10.0,
  }) {
    return [
      Shadow(
        color: glowColor.withValues(alpha: 0.7),
        blurRadius: blurRadius,
        offset: Offset.zero,
      ),
      Shadow(
        color: glowColor.withValues(alpha: 0.5),
        blurRadius: blurRadius * 2,
        offset: Offset.zero,
      ),
    ];
  }

  // MARK: - Gradient Text Styles
  // ==========================================

  /// Create gradient text style
  static ShaderMask gradientText({
    required Gradient gradient,
    required TextStyle textStyle,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: Text(
        '',
        style: textStyle,
      ),
    );
  }

  /// Primary gradient for text
  static Gradient get primaryGradient => const LinearGradient(
        colors: [AppColors.lightPrimary, AppColors.lightAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  /// Success gradient for text
  static Gradient get successGradient => const LinearGradient(
        colors: [AppColors.success, AppColors.statusGreen],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // MARK: - Pre-styled Text Decorations
  // ==========================================

  /// Decoration for important headings - theme-aware via BuildContext
  static TextStyle headingDecoration(
    BuildContext context, {
    Color? color,
    bool withShadow = true,
  }) {
    return AppTypography.headingLarge.copyWith(
      color: color ??
          Theme.of(context).textTheme.headlineLarge?.color ??
          Theme.of(context).colorScheme.onSurface,
      shadows: withShadow ? subtle(context) : null,
    );
  }

  /// Decoration for highlighted text
  static TextStyle highlighted({
    Color backgroundColor = AppColors.lightAccent,
    Color? textColor,
    BuildContext? context,
  }) {
    final finalTextColor = textColor ??
        (context != null
            ? Theme.of(context).colorScheme.onPrimary
            : AppColors.textOnPrimary);
    return AppTypography.bodyMedium.copyWith(
      color: finalTextColor,
      backgroundColor: backgroundColor.withValues(alpha: 0.8),
      fontWeight: FontWeight.bold,
    );
  }

  /// Decoration for price text
  static TextStyle price({
    Color? color,
    bool isDiscounted = false,
    BuildContext? context,
  }) {
    final finalColor = color ??
        (context != null
            ? Theme.of(context).colorScheme.primary
            : AppColors.lightPrimary);
    return AppTypography.headingMedium.copyWith(
      color: finalColor,
      decoration: isDiscounted ? TextDecoration.lineThrough : null,
      decorationColor: context != null
          ? Theme.of(context).colorScheme.error
          : AppColors.error,
      decorationThickness: 2,
    );
  }

  /// Decoration for badge text
  static TextStyle badge({
    Color backgroundColor = AppColors.lightPrimary,
    Color? textColor,
    BuildContext? context,
  }) {
    final finalTextColor = textColor ??
        (context != null
            ? Theme.of(context).colorScheme.onPrimary
            : AppColors.textOnPrimary);
    return AppTypography.bodySmall.copyWith(
      color: finalTextColor,
      backgroundColor: backgroundColor,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    );
  }

  // MARK: - Rich Text Decorations
  // ==========================================

  /// Create rich text with different styles for parts
  static TextSpan richText({
    required List<String> texts,
    required List<TextStyle> styles,
    String separator = ' ',
  }) {
    assert(texts.length == styles.length);

    final spans = <TextSpan>[];
    for (int i = 0; i < texts.length; i++) {
      spans.add(TextSpan(text: texts[i], style: styles[i]));
      if (i < texts.length - 1) {
        spans.add(TextSpan(text: separator));
      }
    }

    return TextSpan(children: spans);
  }

  /// Highlight specific parts of text
  static TextSpan highlightParts({
    required String fullText,
    required List<String> highlightWords,
    TextStyle? baseStyle,
    TextStyle? highlightStyle,
  }) {
    final baseTextStyle = baseStyle ?? AppTypography.bodyMedium;
    final highlightTextStyle = highlightStyle ??
        baseTextStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.lightPrimary,
        );

    final spans = <TextSpan>[];
    String remainingText = fullText;

    for (final word in highlightWords) {
      final index = remainingText.toLowerCase().indexOf(word.toLowerCase());
      if (index != -1) {
        // Add text before highlight
        if (index > 0) {
          spans.add(TextSpan(
            text: remainingText.substring(0, index),
            style: baseTextStyle,
          ));
        }

        // Add highlighted text
        spans.add(TextSpan(
          text: remainingText.substring(index, index + word.length),
          style: highlightTextStyle,
        ));

        // Update remaining text
        remainingText = remainingText.substring(index + word.length);
      }
    }

    // Add any remaining text
    if (remainingText.isNotEmpty) {
      spans.add(TextSpan(text: remainingText, style: baseTextStyle));
    }

    return TextSpan(children: spans);
  }
}
