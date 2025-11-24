// lib/common/widgets/cards/enhanced_card.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../../styles/colors.dart';
import '../animations/smooth_page_transition.dart';

/// 🎨 **ENHANCED CARD - PREMIUM VISUAL POLISH**
///
/// Beautiful card with gradients, shadows, and animations
/// Provides premium visual polish throughout the app
class EnhancedCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double elevation;
  final Color? backgroundColor;
  final Gradient? gradient;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool animateOnTap;
  final bool animateOnMount;
  final Duration animationDuration;
  final List<BoxShadow>? customShadows;

  const EnhancedCard({
    required this.child,
    this.padding,
    this.margin,
    this.elevation = 2,
    this.backgroundColor,
    this.gradient,
    this.borderRadius,
    this.onTap,
    this.animateOnTap = true,
    this.animateOnMount = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.customShadows,
    super.key,
  });

  @override
  State<EnhancedCard> createState() => _EnhancedCardState();
}

class _EnhancedCardState extends State<EnhancedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.animateOnMount) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.animateOnTap && widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.animateOnTap && widget.onTap != null) {
      _controller.forward();
      if (widget.onTap != null) {
        widget.onTap!();
      }
    }
  }

  void _handleTapCancel() {
    if (widget.animateOnTap && widget.onTap != null) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardContent = Container(
      margin: widget.margin ?? const EdgeInsets.all(AppSpacing.paddingS),
      decoration: BoxDecoration(
        color: widget.gradient == null
            ? (widget.backgroundColor ??
                (isDark
                    ? AppColors.darkInputFill
                    : theme.colorScheme.surface))
            : null,
        gradient: widget.gradient,
        borderRadius: widget.borderRadius ??
            BorderRadius.circular(AppSpacing.borderRadiusL),
        boxShadow: widget.customShadows ??
            [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                blurRadius: widget.elevation * 4,
                offset: Offset(0, widget.elevation * 2),
                spreadRadius: 0,
              ),
            ],
      ),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(AppSpacing.paddingM),
        child: widget.child,
      ),
    );

    Widget finalCard = cardContent;
    
    if (widget.animateOnMount) {
      finalCard = ScaleInAnimation(
        duration: widget.animationDuration,
        child: finalCard,
      );
    }

    if (widget.onTap == null) {
      return finalCard;
    }

    Widget interactiveCard = ScaleTransition(
      scale: _scaleAnimation,
      child: finalCard,
    );

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: interactiveCard,
    );
  }
}

/// Gradient card with animated gradient
class GradientCard extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const GradientCard({
    required this.child,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedCard(
      child: child,
      gradient: LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ),
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
      elevation: 4,
    );
  }
}

/// Elevated card with premium shadow
class ElevatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final double elevation;

  const ElevatedCard({
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
    this.elevation = 8,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return EnhancedCard(
      child: child,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      onTap: onTap,
      elevation: elevation,
      customShadows: [
        BoxShadow(
          color: theme.primaryColor.withValues(alpha: isDark ? 0.2 : 0.15),
          blurRadius: elevation * 3,
          offset: Offset(0, elevation),
          spreadRadius: -elevation * 0.5,
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
          blurRadius: elevation * 2,
          offset: Offset(0, elevation * 0.5),
          spreadRadius: 0,
        ),
      ],
    );
  }
}

