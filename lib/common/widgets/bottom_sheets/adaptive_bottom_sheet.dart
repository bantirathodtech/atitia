import 'package:flutter/material.dart';

import '../../lifecycle/stateless/adaptive_stateless_widget.dart';
import '../../styles/spacing.dart';

class AdaptiveBottomSheet extends AdaptiveStatelessWidget {
  final Widget child;
  final String? title;
  final bool showDragHandle;
  final bool isScrollControlled;
  final Color? backgroundColor;

  const AdaptiveBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showDragHandle = true,
    this.isScrollControlled = false,
    this.backgroundColor,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool showDragHandle = true,
    bool isScrollControlled = false,
    Color? backgroundColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.borderRadiusL),
        ),
      ),
      builder: (context) => AdaptiveBottomSheet(
        title: title,
        showDragHandle: showDragHandle,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor,
        child: child,
      ),
    );
  }

  @override
  Widget buildAdaptive(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle) _buildDragHandle(isDark),
          if (title != null) _buildTitle(context),
          child,
        ],
      ),
    );
  }

  Widget _buildDragHandle(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.paddingM),
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[600] : Colors.grey[400],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.paddingL),
      child: Text(
        title!,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    );
  }
}
