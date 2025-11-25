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

  /// Base URL for Atitia Google Sites
  static const String baseUrl = 'https://sites.google.com/view/atitia';

  // ==========================================================================
  // LEGAL & COMPLIANCE PAGES
  // ==========================================================================

  /// Privacy Policy URL - Required for app compliance
  static const String privacyPolicy = '$baseUrl/privacy-policy';

  /// Terms of Service URL - Required for app compliance
  static const String termsOfService = '$baseUrl/terms-of-service';

  /// Cancellation/Refund Policy URL - Required for Razorpay KYC
  static const String refundPolicy = '$baseUrl/cancellationrefund';

  // ==========================================================================
  // BUSINESS & INFORMATION PAGES
  // ==========================================================================

  /// Home page URL - Main landing page
  static const String home = '$baseUrl/home';

  /// About Us page URL - Required for Razorpay KYC
  static const String aboutUs = '$baseUrl/about-us';

  /// Contact Us page URL - Required for Razorpay KYC
  static const String contactUs = '$baseUrl/contact-us';

  /// Pricing page URL - Required for Razorpay KYC
  static const String pricing = '$baseUrl/pricing';

  // ==========================================================================
  // ACCOUNT MANAGEMENT PAGES
  // ==========================================================================

  /// Account Deletion page URL - GDPR/compliance requirement
  static const String accountDeletion = '$baseUrl/account-deletion';

  // ==========================================================================
  // UTILITY METHODS
  // ==========================================================================

  /// Get all legal/compliance URLs as a map
  static Map<String, String> get legalUrls => {
        'privacyPolicy': privacyPolicy,
        'termsOfService': termsOfService,
        'refundPolicy': refundPolicy,
        'accountDeletion': accountDeletion,
      };

  /// Get all business/information URLs as a map
  static Map<String, String> get businessUrls => {
        'home': home,
        'aboutUs': aboutUs,
        'contactUs': contactUs,
        'pricing': pricing,
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
