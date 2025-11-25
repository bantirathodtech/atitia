/// Firestore collection and document path constants.
///
/// ## Purpose:
/// - Centralized Firestore collection names
/// - Consistent document referencing
/// - Easy database schema updates
///
/// ## Usage:
/// ```dart
/// FirebaseFirestore.instance.collection(FirestoreConstants.users)
/// ```
/// ```
class FirestoreConstants {
  // MARK: - User Collections
  // ==========================================

  /// Main users collection: 'users'
  static const String users = 'users';

  /// User profiles subcollection: 'user_profiles'
  static const String userProfiles = 'user_profiles';

  // MARK: - Property Collections
  // ==========================================

  /// PG properties collection: 'pgs'
  static const String pgs = 'pgs';

  /// PG amenities subcollection: 'amenities'
  static const String amenities = 'amenities';

  /// PG photos subcollection: 'photos'
  static const String photos = 'photos';

  // MARK: - Booking & Payment Collections
  // ==========================================

  /// Bookings collection: 'bookings'
  static const String bookings = 'bookings';

  /// Payments collection: 'payments'
  static const String payments = 'payments';

  /// Payment transactions subcollection: 'transactions'
  static const String transactions = 'transactions';

  /// Payment notifications collection: 'payment_notifications'
  static const String paymentNotifications = 'payment_notifications';

  /// Owner payment details collection: 'owner_payment_details'
  static const String ownerPaymentDetails = 'owner_payment_details';

  // MARK: - Food & Menu Collections
  // ==========================================

  /// Food menu collection: 'foods'
  static const String foods = 'foods';

  /// Food categories subcollection: 'categories'
  static const String categories = 'categories';

  /// Food orders collection: 'orders'
  static const String orders = 'orders';

  // MARK: - Support Collections
  // ==========================================

  /// User complaints collection: 'complaints'
  static const String complaints = 'complaints';

  /// Support tickets collection: 'support_tickets'
  static const String supportTickets = 'support_tickets';

  // MARK: - Application Data Collections
  // ==========================================

  /// App configuration collection: 'app_config'
  static const String appConfig = 'app_config';

  /// Cities and locations collection: 'cities'
  static const String cities = 'cities';

  /// Amenity types collection: 'amenity_types'
  static const String amenityTypes = 'amenity_types';

  // MARK: - Analytics Collections
  // ==========================================

  /// Revenue projections collection: 'revenue_projections'
  static const String revenueProjections = 'revenue_projections';

  /// Occupancy trends collection: 'occupancy_trends'
  static const String occupancyTrends = 'occupancy_trends';

  /// Maintenance tasks collection: 'maintenance_tasks'
  static const String maintenanceTasks = 'maintenance_tasks';

  /// Owner documents collection: 'owner_documents'
  static const String ownerDocuments = 'owner_documents';

  /// Notification preferences collection: 'notification_preferences'
  static const String notificationPreferences = 'notification_preferences';

  /// In-app notifications collection: 'notifications'
  static const String notifications = 'notifications';

  /// Bed change requests collection: 'bed_change_requests'
  static const String bedChangeRequests = 'bed_change_requests';

  // MARK: - Monetization Collections
  // ==========================================

  /// Owner subscriptions collection: 'owner_subscriptions'
  static const String ownerSubscriptions = 'owner_subscriptions';

  /// Featured listings collection: 'featured_listings'
  static const String featuredListings = 'featured_listings';

  /// Revenue records collection: 'revenue_records'
  static const String revenueRecords = 'revenue_records';

  /// Refund requests collection: 'refund_requests'
  static const String refundRequests = 'refund_requests';
}
