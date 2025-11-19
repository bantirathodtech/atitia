// integration_test/config/screenshot_config.dart
//
// Configuration for automated screenshot capture
// Defines which screens to capture and their properties

/// Screenshot format enum
enum ScreenshotFormat { png, jpg }

/// Screenshot definition class
class ScreenshotDefinition {
  final String name;
  final String description;
  final String route;
  final Map<String, dynamic>? navigationSteps;
  final bool required;
  final int priority; // Lower number = higher priority

  const ScreenshotDefinition({
    required this.name,
    required this.description,
    required this.route,
    this.navigationSteps,
    this.required = true,
    this.priority = 0,
  });
}

/// Configuration for screenshot capture sessions
class ScreenshotConfig {
  /// Output directory for screenshots
  static const String outputDirectory = 'screenshots/play_store';

  /// Delay after navigation (milliseconds)
  static const int navigationDelayMs = 1500; // Reduced from 2000

  /// Delay after screenshot capture (milliseconds)
  static const int captureDelayMs = 300; // Reduced from 500

  /// Wait for animations timeout (seconds)
  static const int animationTimeoutSeconds = 5; // Reduced from 10

  /// Screenshot quality (0.0 to 1.0)
  static const double screenshotQuality = 1.0;

  /// Screenshot format
  static const ScreenshotFormat format = ScreenshotFormat.png;

  /// Guest flow screenshots
  static final List<ScreenshotDefinition> guestScreenshots = [
    ScreenshotDefinition(
      name: '01_guest_dashboard_pg_listings',
      description: 'Guest Dashboard - PG Listings Tab',
      route: '/guest',
      priority: 1,
      required: true,
    ),
    ScreenshotDefinition(
      name: '02_pg_details_screen',
      description: 'PG Details Screen with amenities and booking',
      route: '/guest/pgs',
      navigationSteps: {'action': 'tap_first_pg'},
      priority: 2,
      required: true,
    ),
    ScreenshotDefinition(
      name: '03_guest_booking_requests',
      description: 'Guest Booking Requests Screen',
      route: '/guest',
      navigationSteps: {'action': 'navigate_to_tab', 'tab_index': 4},
      priority: 3,
      required: false,
    ),
    ScreenshotDefinition(
      name: '04_guest_payment_history',
      description: 'Guest Payment History Screen',
      route: '/guest',
      navigationSteps: {'action': 'navigate_to_tab', 'tab_index': 2},
      priority: 4,
      required: false,
    ),
    ScreenshotDefinition(
      name: '05_guest_food_menu',
      description: 'Guest Food Menu Screen',
      route: '/guest',
      navigationSteps: {'action': 'navigate_to_tab', 'tab_index': 1},
      priority: 5,
      required: false,
    ),
    ScreenshotDefinition(
      name: '06_guest_complaints',
      description: 'Guest Complaints Screen',
      route: '/guest',
      navigationSteps: {'action': 'navigate_to_tab', 'tab_index': 3},
      priority: 6,
      required: false,
    ),
    ScreenshotDefinition(
      name: '07_guest_profile',
      description: 'Guest Profile Screen',
      route: '/guest/profile',
      navigationSteps: {'action': 'open_drawer'},
      priority: 7,
      required: false,
    ),
  ];

  /// Owner flow screenshots
  static final List<ScreenshotDefinition> ownerScreenshots = [
    ScreenshotDefinition(
      name: '01_owner_dashboard_overview',
      description: 'Owner Dashboard Overview with Analytics',
      route: '/owner',
      priority: 1,
      required: true,
    ),
    ScreenshotDefinition(
      name: '02_owner_pg_management',
      description: 'Owner PG Management Screen',
      route: '/owner',
      navigationSteps: {'action': 'navigate_to_tab', 'tab_index': 2},
      priority: 2,
      required: true,
    ),
    ScreenshotDefinition(
      name: '03_owner_guest_management',
      description: 'Owner Guest Management Screen',
      route: '/owner',
      navigationSteps: {'action': 'navigate_to_tab', 'tab_index': 3},
      priority: 3,
      required: false,
    ),
    ScreenshotDefinition(
      name: '04_owner_food_management',
      description: 'Owner Food Menu Management',
      route: '/owner',
      navigationSteps: {'action': 'navigate_to_tab', 'tab_index': 1},
      priority: 4,
      required: false,
    ),
    ScreenshotDefinition(
      name: '05_owner_analytics',
      description: 'Owner Analytics Dashboard',
      route: '/owner/analytics',
      priority: 5,
      required: false,
    ),
    ScreenshotDefinition(
      name: '06_owner_profile',
      description: 'Owner Profile Screen',
      route: '/owner/profile',
      navigationSteps: {'action': 'open_drawer'},
      priority: 6,
      required: false,
    ),
  ];

  /// All screenshots (guest + owner)
  static List<ScreenshotDefinition> get allScreenshots => [
        ...guestScreenshots,
        ...ownerScreenshots,
      ];

  /// Get screenshots by role
  static List<ScreenshotDefinition> getScreenshotsByRole(String role) {
    switch (role.toLowerCase()) {
      case 'guest':
        return guestScreenshots;
      case 'owner':
        return ownerScreenshots;
      default:
        return allScreenshots;
    }
  }

  /// Get required screenshots only
  static List<ScreenshotDefinition> getRequiredScreenshots(String role) {
    return getScreenshotsByRole(role).where((s) => s.required).toList()
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }
}
