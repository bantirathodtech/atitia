/// Asset paths and image constants for the entire application.
///
/// ## Usage:
/// ```dart
/// Image.asset(AssetConstants.appIcon)
/// Lottie.asset(AssetConstants.loadingAnimation)
/// ```
class AssetConstants {
  // MARK: - App Icons
  // ==========================================

  /// Main application icon
  static const String appIcon = 'assets/icons/app_icon.png';

  // MARK: - UI Icons
  // ==========================================

  /// Home screen navigation icon
  static const String homeIcon = 'assets/icons/home.png';

  /// User profile navigation icon
  static const String profileIcon = 'assets/icons/profile.png';

  /// Settings screen icon
  static const String settingsIcon = 'assets/icons/settings.png';

  /// Notifications bell icon
  static const String notificationIcon = 'assets/icons/notification.png';

  // MARK: - Images
  // ==========================================

  /// Default placeholder image when no image is available
  static const String placeholderImage = 'assets/images/placeholder.jpg';

  /// Error state image for fallback UI
  static const String errorImage = 'assets/images/error.png';

  // MARK: - Animations (Lottie)
  // ==========================================

  /// Loading indicator animation
  static const String loadingAnimation = 'assets/animations/loading.json';

  /// Success state confirmation animation
  static const String successAnimation = 'assets/animations/success.json';

  /// Error state animation
  static const String errorAnimation = 'assets/animations/error.json';
}
