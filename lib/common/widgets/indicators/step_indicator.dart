// ============================================================================
// Step Indicator - Multi-Step Progress Display
// ============================================================================
// Beautiful animated step indicator for multi-step forms with theme support.
//
// FEATURES:
// - Visual progress tracking (completed, active, pending steps)
// - Smooth animations between steps
// - Theme-aware colors (adapts to light/dark mode)
// - Customizable colors via parameters
// - Step labels with responsive sizing
// - Connection lines between steps
//
// THEME SUPPORT:
// - Automatically adapts colors for day and night modes
// - Active step uses primary theme color
// - Completed steps use success color
// - Inactive steps use subtle grey (visible in both themes)
// - Text colors adapt to theme brightness
// ============================================================================

import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/colors.dart';
import '../../styles/spacing.dart';

/// Beautiful step indicator for multi-step forms
/// Shows current progress with visual feedback
class StepIndicator extends AdaptiveStatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? completedColor;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
    this.activeColor,
    this.inactiveColor,
    this.completedColor,
  });

  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    // Theme-aware default colors
    final active = activeColor ?? theme.primaryColor;
    final inactive = inactiveColor ?? (isDarkMode 
        ? AppColors.darkDivider  // Dark mode: lighter grey for visibility
        : AppColors.outline);     // Light mode: standard outline color
    final completed = completedColor ?? AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        children: List.generate(
          totalSteps,
          (index) {
            final isActive = index == currentStep;
            final isCompleted = index < currentStep;
            final stepNumber = index + 1;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // Step circle
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          width: isActive ? 40 : 32,
                          height: isActive ? 40 : 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? completed
                                : isActive
                                    ? active
                                    : inactive,
                            boxShadow: isActive
                                ? [
                                    BoxShadow(
                                      color: active.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: isCompleted
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Text(
                                    '$stepNumber',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: isActive
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: isActive ? 18 : 14,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        
                        // Step label with theme-aware text color
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: isActive ? 12 : 10,
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.normal,
                            // Theme-aware text color
                            color: isCompleted || isActive
                                ? theme.textTheme.bodyLarge?.color
                                : (isDarkMode 
                                    ? AppColors.textTertiary  // Dark mode: lighter grey
                                    : AppColors.textSecondary),  // Light mode: medium grey
                          ),
                          child: Text(
                            stepLabels[index],
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Connector line (except for last step)
                  if (index < totalSteps - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.only(bottom: 24),
                        color: isCompleted ? completed : inactive,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

