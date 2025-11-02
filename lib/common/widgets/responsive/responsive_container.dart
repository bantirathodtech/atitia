import 'package:flutter/material.dart';
import '../../utils/responsive/responsive_breakpoints.dart';
import '../../utils/responsive/platform_adaptations.dart';
import '../../utils/responsive/responsive_layout_builder.dart';

/// Responsive container that adapts its layout based on screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;
  final bool centerContent;
  final double? maxWidth;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.alignment,
    this.constraints,
    this.centerContent = false,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, layoutType, screenSize) {
        return _buildResponsiveContainer(context, layoutType, screenSize);
      },
    );
  }

  Widget _buildResponsiveContainer(
      BuildContext context, ResponsiveLayoutType layoutType, Size screenSize) {
    final responsivePadding = _getResponsivePadding(layoutType);
    final responsiveMargin = _getResponsiveMargin(layoutType);
    final responsiveMaxWidth = _getResponsiveMaxWidth(layoutType, screenSize);

    Widget containerChild = child;

    // Center content if requested
    if (centerContent) {
      containerChild = Center(child: child);
    }

    // Apply responsive constraints
    if (responsiveMaxWidth != null) {
      containerChild = ConstrainedBox(
        constraints: BoxConstraints(maxWidth: responsiveMaxWidth),
        child: containerChild,
      );
    }

    return Container(
      padding: padding ?? responsivePadding,
      margin: margin ?? responsiveMargin,
      color: color,
      decoration: decoration,
      width: width,
      height: height,
      alignment: alignment,
      constraints: constraints,
      child: containerChild,
    );
  }

  EdgeInsets _getResponsivePadding(ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return const EdgeInsets.all(16.0);
      case ResponsiveLayoutType.tablet:
        return const EdgeInsets.all(24.0);
      case ResponsiveLayoutType.desktop:
        return const EdgeInsets.all(32.0);
      case ResponsiveLayoutType.largeDesktop:
        return const EdgeInsets.all(48.0);
    }
  }

  EdgeInsets _getResponsiveMargin(ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return const EdgeInsets.all(8.0);
      case ResponsiveLayoutType.tablet:
        return const EdgeInsets.all(16.0);
      case ResponsiveLayoutType.desktop:
        return const EdgeInsets.all(24.0);
      case ResponsiveLayoutType.largeDesktop:
        return const EdgeInsets.all(32.0);
    }
  }

  double? _getResponsiveMaxWidth(
      ResponsiveLayoutType layoutType, Size screenSize) {
    if (maxWidth != null) return maxWidth;

    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return screenSize.width;
      case ResponsiveLayoutType.tablet:
        return 800.0;
      case ResponsiveLayoutType.desktop:
        return 1200.0;
      case ResponsiveLayoutType.largeDesktop:
        return 1600.0;
    }
  }
}

/// Responsive card that adapts its styling based on screen size and platform
class ResponsiveCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool interactive;

  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.onTap,
    this.interactive = true,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, layoutType, screenSize) {
        return _buildResponsiveCard(context, layoutType);
      },
    );
  }

  Widget _buildResponsiveCard(
      BuildContext context, ResponsiveLayoutType layoutType) {
    final responsiveElevation = _getResponsiveElevation(layoutType);
    final responsiveBorderRadius =
        _getResponsiveBorderRadius(context, layoutType);
    final responsivePadding = _getResponsivePadding(layoutType);

    Widget cardChild = Padding(
      padding: padding ?? responsivePadding,
      child: child,
    );

    if (interactive && onTap != null) {
      cardChild = InkWell(
        onTap: onTap,
        borderRadius: responsiveBorderRadius,
        child: cardChild,
      );
    }

    return Container(
      margin: margin,
      child: Card(
        color: color,
        elevation: elevation ?? responsiveElevation,
        shape: RoundedRectangleBorder(
          borderRadius: responsiveBorderRadius,
        ),
        child: cardChild,
      ),
    );
  }

  double _getResponsiveElevation(ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return 2.0;
      case ResponsiveLayoutType.tablet:
        return 4.0;
      case ResponsiveLayoutType.desktop:
        return 6.0;
      case ResponsiveLayoutType.largeDesktop:
        return 8.0;
    }
  }

  BorderRadius _getResponsiveBorderRadius(
      BuildContext context, ResponsiveLayoutType layoutType) {
    if (borderRadius != null) return borderRadius!;

    final platformBorderRadius =
        PlatformAdaptations.getPlatformBorderRadius(context);

    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return platformBorderRadius;
      case ResponsiveLayoutType.tablet:
        return BorderRadius.circular(platformBorderRadius.topLeft.x + 4);
      case ResponsiveLayoutType.desktop:
        return BorderRadius.circular(platformBorderRadius.topLeft.x + 8);
      case ResponsiveLayoutType.largeDesktop:
        return BorderRadius.circular(platformBorderRadius.topLeft.x + 12);
    }
  }

  EdgeInsets _getResponsivePadding(ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return const EdgeInsets.all(16.0);
      case ResponsiveLayoutType.tablet:
        return const EdgeInsets.all(20.0);
      case ResponsiveLayoutType.desktop:
        return const EdgeInsets.all(24.0);
      case ResponsiveLayoutType.largeDesktop:
        return const EdgeInsets.all(28.0);
    }
  }
}

/// Responsive grid container that adapts column count based on screen size
class ResponsiveGridContainer extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int? crossAxisCount;
  final double? childAspectRatio;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const ResponsiveGridContainer({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.crossAxisCount,
    this.childAspectRatio,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, layoutType, screenSize) {
        return _buildResponsiveGrid(context, layoutType);
      },
    );
  }

  Widget _buildResponsiveGrid(
      BuildContext context, ResponsiveLayoutType layoutType) {
    final columns = crossAxisCount ?? _getResponsiveColumnCount(layoutType);
    final responsivePadding = _getResponsivePadding(layoutType);

    return Container(
      padding: padding ?? responsivePadding,
      margin: margin,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: spacing,
          mainAxisSpacing: runSpacing,
          childAspectRatio: childAspectRatio ?? 1.0,
        ),
        itemCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }

  int _getResponsiveColumnCount(ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return 1;
      case ResponsiveLayoutType.tablet:
        return 2;
      case ResponsiveLayoutType.desktop:
        return 3;
      case ResponsiveLayoutType.largeDesktop:
        return 4;
    }
  }

  EdgeInsets _getResponsivePadding(ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return const EdgeInsets.all(16.0);
      case ResponsiveLayoutType.tablet:
        return const EdgeInsets.all(20.0);
      case ResponsiveLayoutType.desktop:
        return const EdgeInsets.all(24.0);
      case ResponsiveLayoutType.largeDesktop:
        return const EdgeInsets.all(28.0);
    }
  }
}

/// Responsive list container that adapts its layout based on screen size
class ResponsiveListContainer extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const ResponsiveListContainer({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.padding,
    this.margin,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      builder: (context, layoutType, screenSize) {
        return _buildResponsiveList(context, layoutType);
      },
    );
  }

  Widget _buildResponsiveList(
      BuildContext context, ResponsiveLayoutType layoutType) {
    final responsivePadding = _getResponsivePadding(layoutType);

    return Container(
      padding: padding ?? responsivePadding,
      margin: margin,
      child: ListView.separated(
        shrinkWrap: shrinkWrap,
        physics: physics,
        itemCount: children.length,
        separatorBuilder: (context, index) => SizedBox(height: spacing),
        itemBuilder: (context, index) => children[index],
      ),
    );
  }

  EdgeInsets _getResponsivePadding(ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return const EdgeInsets.all(16.0);
      case ResponsiveLayoutType.tablet:
        return const EdgeInsets.all(20.0);
      case ResponsiveLayoutType.desktop:
        return const EdgeInsets.all(24.0);
      case ResponsiveLayoutType.largeDesktop:
        return const EdgeInsets.all(28.0);
    }
  }
}
