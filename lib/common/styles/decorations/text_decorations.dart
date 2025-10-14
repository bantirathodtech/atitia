import 'package:flutter/material.dart';

import '../colors.dart';
import '../typography.dart';

/// Text decoration utilities for enhanced text styling
class TextDecorations {
  // MARK: - Text Shadow Effects
  // ==========================================

  /// Subtle text shadow for better readability
  static List<Shadow> subtle({Color? shadowColor}) {
    return [
      Shadow(
        color: shadowColor ?? Colors.black.withOpacity(0.1),
        offset: const Offset(1, 1),
        blurRadius: 2,
      ),
    ];
  }

  /// Strong text shadow for emphasis
  static List<Shadow> strong({Color? shadowColor}) {
    return [
      Shadow(
        color: shadowColor ?? Colors.black.withOpacity(0.3),
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
        color: glowColor.withOpacity(0.7),
        blurRadius: blurRadius,
        offset: Offset.zero,
      ),
      Shadow(
        color: glowColor.withOpacity(0.5),
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
        colors: [Colors.green, Colors.lightGreen],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // MARK: - Pre-styled Text Decorations
  // ==========================================

  /// Decoration for important headings
  static TextStyle headingDecoration({
    Color? color,
    bool withShadow = true,
  }) {
    return AppTypography.headingLarge.copyWith(
      color: color ?? AppColors.lightText,
      shadows: withShadow ? subtle() : null,
    );
  }

  /// Decoration for highlighted text
  static TextStyle highlighted({
    Color backgroundColor = AppColors.lightAccent,
    Color textColor = Colors.white,
  }) {
    return AppTypography.bodyMedium.copyWith(
      color: textColor,
      backgroundColor: backgroundColor.withOpacity(0.8),
      fontWeight: FontWeight.bold,
    );
  }

  /// Decoration for price text
  static TextStyle price({
    Color? color,
    bool isDiscounted = false,
  }) {
    return AppTypography.headingMedium.copyWith(
      color: color ?? AppColors.lightPrimary,
      decoration: isDiscounted ? TextDecoration.lineThrough : null,
      decorationColor: Colors.red,
      decorationThickness: 2,
    );
  }

  /// Decoration for badge text
  static TextStyle badge({
    Color backgroundColor = AppColors.lightPrimary,
    Color textColor = Colors.white,
  }) {
    return AppTypography.bodySmall.copyWith(
      color: textColor,
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
