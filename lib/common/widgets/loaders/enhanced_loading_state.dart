// lib/common/widgets/loaders/enhanced_loading_state.dart

import 'package:flutter/material.dart';
import '../../styles/spacing.dart';
import '../text/body_text.dart';
import 'shimmer_loader.dart';

/// 🎨 **ENHANCED LOADING STATE - POLISHED & CONSISTENT**
///
/// Beautiful loading state with animations, skeleton screens, and consistent styling
/// Used throughout the app for a premium loading experience
class EnhancedLoadingState extends StatelessWidget {
  final String? message;
  final LoadingType type;
  final bool showShimmer;
  final int shimmerItemCount;
  final Color? backgroundColor;

  const EnhancedLoadingState({
    this.message,
    this.type = LoadingType.centered,
    this.showShimmer = false,
    this.shimmerItemCount = 3,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.scaffoldBackgroundColor;

    switch (type) {
      case LoadingType.centered:
        return _buildCenteredLoader(context, theme, bgColor);
      case LoadingType.skeleton:
        return _buildSkeletonLoader(context, theme, bgColor);
      case LoadingType.inline:
        return _buildInlineLoader(context, theme);
      case LoadingType.fullscreen:
        return _buildFullscreenLoader(context, theme, bgColor);
    }
  }

  Widget _buildCenteredLoader(BuildContext context, ThemeData theme, Color bgColor) {
    return Container(
      color: bgColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedLoader(context, theme),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.paddingL),
              BodyText(
                text: message!,
                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                align: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader(BuildContext context, ThemeData theme, Color bgColor) {
    final padding = MediaQuery.of(context).size.width < 600
        ? const EdgeInsets.all(AppSpacing.paddingM)
        : const EdgeInsets.all(AppSpacing.paddingL);
    
    return Container(
      color: bgColor,
      padding: padding,
      child: showShimmer
          ? ListView.builder(
              itemCount: shimmerItemCount,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.paddingM),
                child: ShimmerLoader(
                  width: double.infinity,
                  height: 120,
                  borderRadius: AppSpacing.borderRadiusL,
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedLoader(context, theme),
                  if (message != null) ...[
                    const SizedBox(height: AppSpacing.paddingL),
                    BodyText(
                      text: message!,
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                      align: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildInlineLoader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.primaryColor,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(width: AppSpacing.paddingM),
            Expanded(
              child: BodyText(
                text: message!,
                small: true,
                color: theme.textTheme.bodySmall?.color,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFullscreenLoader(BuildContext context, ThemeData theme, Color bgColor) {
    return Container(
      color: bgColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedLoader(context, theme, size: 64),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.paddingXL),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.paddingXL),
                child: BodyText(
                  text: message!,
                  align: TextAlign.center,
                  color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLoader(BuildContext context, ThemeData theme, {double size = 48}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            theme.primaryColor.withValues(alpha: 0.2),
            theme.primaryColor.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.7,
          height: size * 0.7,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
          ),
        ),
      ),
    );
  }
}

enum LoadingType {
  centered, // Simple centered loader
  skeleton, // Shimmer skeleton screens
  inline, // Small inline loader
  fullscreen, // Large fullscreen loader
}

/// Enhanced loading overlay for dialogs and modals
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? backgroundColor;

  const LoadingOverlay({
    required this.isLoading,
    required this.child,
    this.message,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: (backgroundColor ?? Colors.black).withValues(alpha: 0.3),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.paddingXL),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: AppSpacing.paddingM),
                      BodyText(
                        text: message!,
                        align: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

