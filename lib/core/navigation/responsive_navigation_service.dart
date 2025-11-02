import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../common/utils/responsive/responsive_breakpoints.dart';
import '../../common/utils/responsive/platform_adaptations.dart';

/// Responsive navigation service that adapts navigation based on screen size and platform
class ResponsiveNavigationService {
  static final ResponsiveNavigationService _instance =
      ResponsiveNavigationService._internal();
  factory ResponsiveNavigationService() => _instance;
  ResponsiveNavigationService._internal();

  /// Navigate to a screen with responsive adaptations
  void navigateTo(BuildContext context, String route, {Object? extra}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final layoutType = ResponsiveBreakpoints.getLayoutType(screenWidth);

    // Adapt navigation based on screen size
    if (layoutType == ResponsiveLayoutType.mobile) {
      _navigateMobile(context, route, extra: extra);
    } else if (layoutType == ResponsiveLayoutType.tablet) {
      _navigateTablet(context, route, extra: extra);
    } else {
      _navigateDesktop(context, route, extra: extra);
    }
  }

  /// Navigate with mobile-specific behavior
  void _navigateMobile(BuildContext context, String route, {Object? extra}) {
    context.push(route, extra: extra);
  }

  /// Navigate with tablet-specific behavior
  void _navigateTablet(BuildContext context, String route, {Object? extra}) {
    // On tablet, use pushReplacement for better UX
    context.pushReplacement(route, extra: extra);
  }

  /// Navigate with desktop-specific behavior
  void _navigateDesktop(BuildContext context, String route, {Object? extra}) {
    // On desktop, use push for better navigation stack management
    context.push(route, extra: extra);
  }

  /// Get responsive bottom navigation bar
  Widget getResponsiveBottomNavigationBar({
    required int currentIndex,
    required ValueChanged<int> onTap,
    required List<BottomNavigationBarItem> items,
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    double? elevation,
  }) {
    return ResponsiveBottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      elevation: elevation,
    );
  }

  /// Get responsive drawer
  Widget getResponsiveDrawer({
    required Widget child,
    double? width,
    Color? backgroundColor,
    double? elevation,
  }) {
    return ResponsiveDrawer(
      width: width,
      backgroundColor: backgroundColor,
      elevation: elevation,
      child: child,
    );
  }

  /// Get responsive app bar
  Widget getResponsiveAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    bool showBackButton = true,
    bool showThemeToggle = true,
    bool centerTitle = true,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
  }) {
    return ResponsiveAppBar(
      title: title,
      actions: actions,
      leading: leading,
      showBackButton: showBackButton,
      showThemeToggle: showThemeToggle,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      flexibleSpace: flexibleSpace,
      bottom: bottom,
    );
  }
}

/// Responsive bottom navigation bar
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

/// Responsive drawer
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

/// Responsive app bar
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
