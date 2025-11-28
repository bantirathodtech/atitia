/// Web URLs for Atitia's public pages hosted on Google Sites.
///
/// ## Purpose:
/// - Centralized storage of all public web page URLs
/// - Used for legal compliance (Terms, Privacy, Refund Policy)
/// - User accessibility (Contact, About, Pricing)
/// - Razorpay KYC verification requirements
///
/// ## Usage:
/// ```dart
/// final url = WebUrls.privacyPolicy;
/// await WebUrlLauncher.openUrl(url);
/// ```
class WebUrls {
  WebUrls._(); // Private constructor to prevent instantiation

  // ==========================================================================
  // BASE URL
  // ==========================================================================

  /// Base URL for Atitia Firebase-hosted web app
  /// Used for Razorpay KYC verification and app store compliance
  static const String baseUrl = 'https://atitia-87925.web.app';

  // ==========================================================================
  // LEGAL & COMPLIANCE PAGES
  // ==========================================================================

  /// Privacy Policy URL - Required for app compliance
  /// Accessible at: https://atitia-87925.web.app/privacy-policy
  static const String privacyPolicy = '$baseUrl/privacy-policy';

  /// Terms of Service URL - Required for app compliance
  /// Accessible at: https://atitia-87925.web.app/terms-of-service
  static const String termsOfService = '$baseUrl/terms-of-service';

  /// Cancellation/Refund Policy URL - Required for Razorpay KYC
  /// Accessible at: https://atitia-87925.web.app/cancellation-refund
  static const String refundPolicy = '$baseUrl/cancellation-refund';

  // ==========================================================================
  // BUSINESS & INFORMATION PAGES
  // ==========================================================================

  /// Home page URL - Main landing page
  static const String home = baseUrl;

  /// Contact Us page URL - Required for Razorpay KYC
  /// Accessible at: https://atitia-87925.web.app/contact-us
  static const String contactUs = '$baseUrl/contact-us';

  // ==========================================================================
  // ACCOUNT MANAGEMENT PAGES
  // ==========================================================================

  // ==========================================================================
  // UTILITY METHODS
  // ==========================================================================

  /// Get all legal/compliance URLs as a map
  static Map<String, String> get legalUrls => {
        'privacyPolicy': privacyPolicy,
        'termsOfService': termsOfService,
        'refundPolicy': refundPolicy,
      };

  /// Get all business/information URLs as a map
  static Map<String, String> get businessUrls => {
        'home': home,
        'contactUs': contactUs,
      };

  /// Get all URLs as a single map
  static Map<String, String> get allUrls => {
        ...legalUrls,
        ...businessUrls,
      };

  /// Check if a URL is a valid Atitia web URL
  static bool isValidAtitiaUrl(String url) {
    return url.startsWith(baseUrl);
  }
}
