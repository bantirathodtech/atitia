import 'package:url_launcher/url_launcher.dart';

import 'constants/web_urls.dart';

/// Utility class for launching web URLs with error handling.
///
/// ## Purpose:
/// - Centralized URL launching logic
/// - Consistent error handling
/// - Support for showing error messages to users
///
/// ## Usage:
/// ```dart
/// await WebUrlLauncher.openUrl(WebUrls.privacyPolicy);
/// await WebUrlLauncher.openUrl(WebUrls.pricing, showError: true, context: context);
/// ```
class WebUrlLauncher {
  WebUrlLauncher._(); // Private constructor to prevent instantiation

  /// Open a web URL in external browser.
  ///
  /// [url] - The URL to open
  /// [mode] - Launch mode (default: externalApplication)
  /// [showError] - Whether to show error message if launch fails (requires context)
  /// [context] - BuildContext for showing error messages (optional)
  ///
  /// Returns true if URL was launched successfully, false otherwise.
  static Future<bool> openUrl(
    String url, {
    LaunchMode mode = LaunchMode.externalApplication,
    bool showError = false,
    dynamic context,
  }) async {
    try {
      final uri = Uri.parse(url);

      // Validate URL format
      if (!uri.hasScheme) {
        throw Exception('Invalid URL: missing scheme');
      }

      // Check if URL can be launched
      if (!await canLaunchUrl(uri)) {
        throw Exception('Cannot launch URL: $url');
      }

      // Launch URL
      final launched = await launchUrl(uri, mode: mode);

      if (!launched && showError && context != null) {
        _showError(context, 'Unable to open the link. Please try again.');
      }

      return launched;
    } catch (e) {
      if (showError && context != null) {
        _showError(
          context,
          'Unable to open the link: ${e.toString()}',
        );
      }
      return false;
    }
  }

  /// Open Privacy Policy page
  static Future<bool> openPrivacyPolicy({
    LaunchMode mode = LaunchMode.externalApplication,
    bool showError = false,
    dynamic context,
  }) =>
      openUrl(
        WebUrls.privacyPolicy,
        mode: mode,
        showError: showError,
        context: context,
      );

  /// Open Terms of Service page
  static Future<bool> openTermsOfService({
    LaunchMode mode = LaunchMode.externalApplication,
    bool showError = false,
    dynamic context,
  }) =>
      openUrl(
        WebUrls.termsOfService,
        mode: mode,
        showError: showError,
        context: context,
      );

  /// Open Refund Policy page
  static Future<bool> openRefundPolicy({
    LaunchMode mode = LaunchMode.externalApplication,
    bool showError = false,
    dynamic context,
  }) =>
      openUrl(
        WebUrls.refundPolicy,
        mode: mode,
        showError: showError,
        context: context,
      );

  /// Open Contact Us page
  static Future<bool> openContactUs({
    LaunchMode mode = LaunchMode.externalApplication,
    bool showError = false,
    dynamic context,
  }) =>
      openUrl(
        WebUrls.contactUs,
        mode: mode,
        showError: showError,
        context: context,
      );

  /// Open Home page
  static Future<bool> openHome({
    LaunchMode mode = LaunchMode.externalApplication,
    bool showError = false,
    dynamic context,
  }) =>
      openUrl(
        WebUrls.home,
        mode: mode,
        showError: showError,
        context: context,
      );

  /// Show error message to user
  /// Note: This is a placeholder. The caller should handle showing errors
  /// using ScaffoldMessenger or similar UI components.
  static void _showError(dynamic context, String message) {
    // Error display should be handled by the caller
    // This method exists for consistency but does not display errors
    // to avoid Flutter dependencies in this utility class
  }
}
