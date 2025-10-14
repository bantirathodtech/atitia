/// Platform and environment detection constants.
///
/// ## Purpose:
/// - Conditionally execute code based on build environment
/// - Enable/disable features for specific environments
///
/// ## Usage:
/// ```dart
/// if (PlatformConstants.isDebug) {
///   // Debug-only code
/// }
/// ```
class PlatformConstants {
  // MARK: - Build Environment
  // ==========================================

  /// True when running in debug mode (development)
  ///
  /// ## Typical Use Cases:
  /// - Debug logging
  /// - Developer tools
  /// - Mock data
  static const bool isDebug = bool.fromEnvironment('dart.vm.product') == false;

  /// True when running in release mode (production)
  ///
  /// ## Typical Use Cases:
  /// - Analytics tracking
  /// - Production API endpoints
  /// - Performance optimizations
  static const bool isRelease = bool.fromEnvironment('dart.vm.product') == true;

  /// True when running in profile mode (performance testing)
  static const bool isProfile = bool.fromEnvironment('dart.vm.profile') == true;

  // MARK: - Platform Capabilities
  // ==========================================

  /// Maximum number of retry attempts for network operations
  static const int maxNetworkRetries = 3;

  /// Default timeout duration for API calls
  static const Duration apiTimeout = Duration(seconds: 30);

  /// Duration for showing temporary snackbars/toasts
  static const Duration snackbarDuration = Duration(seconds: 4);
}
