import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';

/// Responsive layout builder that adapts UI based on screen size and platform
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveLayoutType layoutType,
      Size screenSize) builder;
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveLayoutBuilder({
    super.key,
    required this.builder,
    this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final layoutType = ResponsiveBreakpoints.getLayoutType(screenSize.width);

    // Use specific layout widgets if provided
    if (mobile != null && layoutType == ResponsiveLayoutType.mobile) {
      return mobile!;
    }
    if (tablet != null && layoutType == ResponsiveLayoutType.tablet) {
      return tablet!;
    }
    if (desktop != null && layoutType == ResponsiveLayoutType.desktop) {
      return desktop!;
    }
    if (largeDesktop != null &&
        layoutType == ResponsiveLayoutType.largeDesktop) {
      return largeDesktop!;
    }

    // Use builder function
    return builder(context, layoutType, screenSize);
  }
}

/// Responsive wrapper that provides responsive context to child widgets
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final ResponsiveLayoutType? forceLayoutType;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.forceLayoutType,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final layoutType = forceLayoutType ??
        ResponsiveBreakpoints.getLayoutType(screenSize.width);

    return ResponsiveProvider(
      layoutType: layoutType,
      screenSize: screenSize,
      child: child,
    );
  }
}

/// Provider for responsive context
class ResponsiveProvider extends InheritedWidget {
  final ResponsiveLayoutType layoutType;
  final Size screenSize;

  const ResponsiveProvider({
    super.key,
    required this.layoutType,
    required this.screenSize,
    required super.child,
  });

  static ResponsiveProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResponsiveProvider>();
  }

  @override
  bool updateShouldNotify(ResponsiveProvider oldWidget) {
    return layoutType != oldWidget.layoutType ||
        screenSize != oldWidget.screenSize;
  }
}

/// Extension methods for responsive context
extension ResponsiveContextExtension on BuildContext {
  ResponsiveProvider? get responsive => ResponsiveProvider.of(this);

  ResponsiveLayoutType get layoutType =>
      responsive?.layoutType ?? ResponsiveLayoutType.mobile;
  Size get screenSize => responsive?.screenSize ?? Size.zero;
  double get screenWidth => responsive?.screenSize.width ?? 0;
  double get screenHeight => responsive?.screenSize.height ?? 0;

  bool get isMobile => layoutType == ResponsiveLayoutType.mobile;
  bool get isTablet => layoutType == ResponsiveLayoutType.tablet;
  bool get isDesktop => layoutType == ResponsiveLayoutType.desktop;
  bool get isLargeDesktop => layoutType == ResponsiveLayoutType.largeDesktop;

  double get responsivePadding => ResponsiveBreakpoints.getPadding(screenWidth);
  int get columnCount => ResponsiveBreakpoints.getColumnCount(screenWidth);
  double get fontScale => ResponsiveBreakpoints.getFontScale(screenWidth);
}

/// Responsive grid layout that adapts column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? crossAxisCount;
  final double? childAspectRatio;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.crossAxisCount,
    this.childAspectRatio,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final columns = crossAxisCount ?? context.columnCount;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: runSpacing,
        childAspectRatio: childAspectRatio ?? 1.0,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Responsive row layout that adapts based on screen size
class ResponsiveRow extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool wrap;

  const ResponsiveRow({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.wrap = false,
  });

  @override
  Widget build(BuildContext context) {
    if (wrap && context.isMobile) {
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: _getWrapAlignment(mainAxisAlignment),
        crossAxisAlignment: _getWrapCrossAlignment(crossAxisAlignment),
        children: children,
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _addSpacing(children, spacing),
    );
  }

  List<Widget> _addSpacing(List<Widget> children, double spacing) {
    if (children.isEmpty) return children;

    final List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(width: spacing));
      }
    }
    return spacedChildren;
  }

  WrapAlignment _getWrapAlignment(MainAxisAlignment alignment) {
    switch (alignment) {
      case MainAxisAlignment.start:
        return WrapAlignment.start;
      case MainAxisAlignment.end:
        return WrapAlignment.end;
      case MainAxisAlignment.center:
        return WrapAlignment.center;
      case MainAxisAlignment.spaceBetween:
        return WrapAlignment.spaceBetween;
      case MainAxisAlignment.spaceAround:
        return WrapAlignment.spaceAround;
      case MainAxisAlignment.spaceEvenly:
        return WrapAlignment.spaceEvenly;
    }
  }

  WrapCrossAlignment _getWrapCrossAlignment(CrossAxisAlignment alignment) {
    switch (alignment) {
      case CrossAxisAlignment.start:
        return WrapCrossAlignment.start;
      case CrossAxisAlignment.end:
        return WrapCrossAlignment.end;
      case CrossAxisAlignment.center:
        return WrapCrossAlignment.center;
      case CrossAxisAlignment.stretch:
        return WrapCrossAlignment.start;
      case CrossAxisAlignment.baseline:
        return WrapCrossAlignment.start;
    }
  }
}

/// Responsive column layout that adapts based on screen size
class ResponsiveColumn extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const ResponsiveColumn({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: _addSpacing(children, spacing),
    );
  }

  List<Widget> _addSpacing(List<Widget> children, double spacing) {
    if (children.isEmpty) return children;

    final List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: spacing));
      }
    }
    return spacedChildren;
  }
}
