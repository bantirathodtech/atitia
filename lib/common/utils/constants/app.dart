import '../../../core/services/localization/internationalization_service.dart';
import 'web_urls.dart';

/// Application-specific business rules and constants.
///
/// ## Purpose:
/// - PG rental application business logic
/// - Feature-specific configurations
/// - App behavior constants
///
/// ## Note:
/// These constants are specific to Atitia PG rental app
/// For generic constants, see other constant files
class AppConstants {
  // MARK: - Application Configuration
  // ==========================================

  /// Application name displayed to users
  // static const String appName = 'Atitia';

  /// Application version for display
  static const String appVersion = '1.0.0';

  /// Support email for user assistance
  static const String supportEmail = 'bantirathodtech@gmail.com';

  /// Public privacy policy URL hosted for regulatory compliance
  /// @deprecated Use WebUrls.privacyPolicy instead
  /// This will be removed in a future version
  @Deprecated('Use WebUrls.privacyPolicy instead')
  static const String privacyPolicyUrl = WebUrls.privacyPolicy;

  // MARK: - Business Rules
  // ==========================================

  /// Maximum allowed profile photo size (5MB)
  static const int maxProfilePhotoSize = 5 * 1024 * 1024;

  /// Maximum allowed Aadhaar document size (10MB)
  static const int maxAadhaarFileSize = 10 * 1024 * 1024;

  /// OTP timeout duration in seconds
  static const int otpTimeoutSeconds = 60;

  /// Minimum booking duration in days
  static const int minBookingDays = 30;

  /// Maximum advance booking in days (3 months)
  static const int maxAdvanceBookingDays = 90;

  // MARK: - UI/UX Constants
  // ==========================================

  /// Default padding used throughout the app
  static const double defaultPadding = 16.0;

  /// Card border radius for consistent corners
  static const double cardBorderRadius = 12.0;

  /// App bar elevation for material design
  static const double appBarElevation = 2.0;

  /// Bottom navigation bar height
  static const double bottomNavBarHeight = 64.0;

  // MARK: - Feature Flags
  // ==========================================

  /// Enable/disable phone authentication
  static const bool enablePhoneAuth = true;

  /// Enable/disable Aadhaar verification
  static const bool enableAadhaarVerification = true;

  /// Enable/disable online payments
  static const bool enableOnlinePayments = true;

  /// Enable/disable food ordering
  static const bool enableFoodOrdering = true;

  // MARK: - Performance & Limits
  // ==========================================

  /// Maximum images per PG listing
  static const int maxPGImages = 10;

  /// Maximum complaints per user per month
  static const int maxComplaintsPerMonth = 5;

  /// Pagination limit for lists
  static const int paginationLimit = 20;

  /// Search debounce duration in milliseconds
  static const int searchDebounceMs = 500;

  // MARK: - Validation Messages
  // ==========================================

  /// Error message for required fields
  static String get requiredFieldError =>
      InternationalizationService.instance.translate('requiredFieldError');

  /// Error message for invalid phone numbers
  static String get invalidPhoneError =>
      InternationalizationService.instance.translate('invalidPhoneError');

  /// Error message for file size limits
  static String get fileSizeError =>
      InternationalizationService.instance.translate('fileSizeExceeded');
}
