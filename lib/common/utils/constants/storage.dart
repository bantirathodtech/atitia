/// Firebase Storage paths and bucket constants.
///
/// ## Purpose:
/// - Organized file storage structure
/// - Consistent path generation
/// - Easy storage management
///
/// ## Usage:
/// ```dart
/// FirebaseStorage.instance.ref(StorageConstants.profilePhotos)
/// ```
class StorageConstants {
  // MARK: - User Storage Paths
  // ==========================================

  /// User profile photos directory: 'profile_photos/'
  static const String profilePhotos = 'profile_photos/';

  /// User Aadhaar document storage: 'aadhaar_docs/'
  static const String aadhaarDocs = 'aadhaar_docs/';

  /// User identification documents: 'id_documents/'
  static const String idDocuments = 'id_documents/';

  // MARK: - Property Storage Paths
  // ==========================================

  /// PG property photos directory: 'pg_photos/'
  static const String pgPhotos = 'pg_photos/';

  /// PG license documents: 'pg_licenses/'
  static const String pgLicenses = 'pg_licenses/';

  /// PG amenity photos: 'amenity_photos/'
  static const String amenityPhotos = 'amenity_photos/';

  // MARK: - Food & Menu Storage Paths
  // ==========================================

  /// Food item photos directory: 'food_photos/'
  static const String foodPhotos = 'food_photos/';

  /// Menu category icons: 'menu_icons/'
  static const String menuIcons = 'menu_icons/';

  // MARK: - Temporary Storage Paths
  // ==========================================

  /// Temporary uploads (cleaned periodically): 'temp_uploads/'
  static const String tempUploads = 'temp_uploads/';

  /// Cache directory for optimized images: 'cache/'
  static const String cache = 'cache/';

  // MARK: - File Naming Conventions
  // ==========================================

  /// Generate profile photo path for user
  static String userProfilePath(String userId) {
    return '${profilePhotos}user_${userId}_profile.jpg';
  }

  /// Generate PG photo path for property
  static String pgPhotoPath(String pgId, int index) {
    return '${pgPhotos}pg_${pgId}_photo_$index.jpg';
  }

  /// Generate Aadhaar document path for user
  static String aadhaarPath(String userId) {
    return '${aadhaarDocs}user_${userId}_aadhaar.pdf';
  }
}
