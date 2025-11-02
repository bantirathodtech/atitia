import 'package:flutter/material.dart';
import '../../utils/responsive/responsive_breakpoints.dart';
import '../../utils/responsive/platform_adaptations.dart';

/// Responsive app bar that adapts to different screen sizes and platforms
class ResponsiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool showThemeToggle;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;

  const ResponsiveAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.showThemeToggle = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.flexibleSpace,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final layoutType = ResponsiveBreakpoints.getLayoutType(screenWidth);

    // Adapt app bar based on screen size and platform
    return _buildResponsiveAppBar(context, layoutType);
  }

  Widget _buildResponsiveAppBar(
      BuildContext context, ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return _buildMobileAppBar(context);
      case ResponsiveLayoutType.tablet:
        return _buildTabletAppBar(context);
      case ResponsiveLayoutType.desktop:
        return _buildDesktopAppBar(context);
      case ResponsiveLayoutType.largeDesktop:
        return _buildLargeDesktopAppBar(context);
    }
  }

  Widget _buildMobileAppBar(BuildContext context) {
    return AppBar(
      title: Text(title),
      leading: leading ?? (showBackButton ? const BackButton() : null),
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation ?? PlatformAdaptations.getPlatformElevation(context),
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      toolbarHeight: PlatformAdaptations.getAppBarHeight(context),
    );
  }

  Widget _buildTabletAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      leading: leading ?? (showBackButton ? const BackButton() : null),
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation ?? PlatformAdaptations.getPlatformElevation(context),
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      toolbarHeight: PlatformAdaptations.getAppBarHeight(context) + 8,
    );
  }

  Widget _buildDesktopAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      leading: leading ?? (showBackButton ? const BackButton() : null),
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation ?? PlatformAdaptations.getPlatformElevation(context),
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      toolbarHeight: PlatformAdaptations.getAppBarHeight(context) + 16,
    );
  }

  Widget _buildLargeDesktopAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineLarge,
      ),
      leading: leading ?? (showBackButton ? const BackButton() : null),
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation ?? PlatformAdaptations.getPlatformElevation(context),
      flexibleSpace: flexibleSpace,
      bottom: bottom,
      toolbarHeight: PlatformAdaptations.getAppBarHeight(context) + 24,
    );
  }

  @override
  Size get preferredSize {
    // Return a default size, actual size will be determined by the platform
    return const Size.fromHeight(kToolbarHeight);
  }
}

/// Responsive bottom navigation bar that adapts to different screen sizes
class ResponsiveBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;

  const ResponsiveBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final layoutType = ResponsiveBreakpoints.getLayoutType(screenWidth);

    // Hide bottom navigation on desktop platforms
    if (PlatformAdaptations.isDesktop) {
      return const SizedBox.shrink();
    }

    return _buildResponsiveBottomNavigationBar(context, layoutType);
  }

  Widget _buildResponsiveBottomNavigationBar(
      BuildContext context, ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return _buildMobileBottomNavigationBar(context);
      case ResponsiveLayoutType.tablet:
        return _buildTabletBottomNavigationBar(context);
      case ResponsiveLayoutType.desktop:
      case ResponsiveLayoutType.largeDesktop:
        return const SizedBox.shrink(); // No bottom navigation on desktop
    }
  }

  Widget _buildMobileBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      elevation: elevation,
      selectedFontSize: 12,
      unselectedFontSize: 12,
    );
  }

  Widget _buildTabletBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      elevation: elevation,
      selectedFontSize: 14,
      unselectedFontSize: 14,
    );
  }
}

/// Responsive drawer that adapts to different screen sizes
class ResponsiveDrawer extends StatelessWidget {
  final Widget child;
  final double? width;
  final Color? backgroundColor;
  final double? elevation;

  const ResponsiveDrawer({
    super.key,
    required this.child,
    this.width,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final layoutType = ResponsiveBreakpoints.getLayoutType(screenWidth);

    return _buildResponsiveDrawer(context, layoutType);
  }

  Widget _buildResponsiveDrawer(
      BuildContext context, ResponsiveLayoutType layoutType) {
    switch (layoutType) {
      case ResponsiveLayoutType.mobile:
        return _buildMobileDrawer(context);
      case ResponsiveLayoutType.tablet:
        return _buildTabletDrawer(context);
      case ResponsiveLayoutType.desktop:
        return _buildDesktopDrawer(context);
      case ResponsiveLayoutType.largeDesktop:
        return _buildLargeDesktopDrawer(context);
    }
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      width: width ?? 280,
      backgroundColor: backgroundColor,
      elevation: elevation ?? 16.0,
      child: child,
    );
  }

  Widget _buildTabletDrawer(BuildContext context) {
    return Drawer(
      width: width ?? 320,
      backgroundColor: backgroundColor,
      elevation: elevation ?? 16.0,
      child: child,
    );
  }

  Widget _buildDesktopDrawer(BuildContext context) {
    return Drawer(
      width: width ?? 360,
      backgroundColor: backgroundColor,
      elevation: elevation ?? 16.0,
      child: child,
    );
  }

  Widget _buildLargeDesktopDrawer(BuildContext context) {
    return Drawer(
      width: width ?? 400,
      backgroundColor: backgroundColor,
      elevation: elevation ?? 16.0,
      child: child,
    );
  }
}
