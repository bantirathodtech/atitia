// lib/core/repositories/featured/featured_listing_repository.dart

import '../../di/common/unified_service_locator.dart';
import '../../../common/utils/constants/firestore.dart';
import '../../interfaces/analytics/analytics_service_interface.dart';
import '../../interfaces/database/database_service_interface.dart';
import '../../models/featured/featured_listing_model.dart';

/// Repository for managing featured PG listings
/// Handles featured listing CRUD operations, queries, and real-time streams
/// Uses interface-based services for dependency injection (swappable backends)
class FeaturedListingRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  FeaturedListingRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Create a new featured listing
  Future<String> createFeaturedListing(
      FeaturedListingModel featuredListing) async {
    try {
      await _databaseService.setDocument(
        FirestoreConstants.featuredListings,
        featuredListing.featuredListingId,
        featuredListing.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'featured_listing_created',
        parameters: {
          'featured_listing_id': featuredListing.featuredListingId,
          'pg_id': featuredListing.pgId,
          'owner_id': featuredListing.ownerId,
          'duration_months': featuredListing.durationMonths.toString(),
          'amount_paid': featuredListing.amountPaid.toString(),
        },
      );

      return featuredListing.featuredListingId;
    } catch (e) {
      throw Exception('Failed to create featured listing: $e');
    }
  }

  /// Update an existing featured listing
  Future<void> updateFeaturedListing(
      FeaturedListingModel featuredListing) async {
    try {
      await _databaseService.updateDocument(
        FirestoreConstants.featuredListings,
        featuredListing.featuredListingId,
        featuredListing.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'featured_listing_updated',
        parameters: {
          'featured_listing_id': featuredListing.featuredListingId,
          'status': featuredListing.status.firestoreValue,
        },
      );
    } catch (e) {
      throw Exception('Failed to update featured listing: $e');
    }
  }

  /// Get featured listing by ID
  Future<FeaturedListingModel?> getFeaturedListing(
      String featuredListingId) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.featuredListings,
        featuredListingId,
      );

      if (!doc.exists) {
        return null;
      }

      return FeaturedListingModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get featured listing: $e');
    }
  }

  /// Get active featured listing for a PG
  Future<FeaturedListingModel?> getActiveFeaturedListing(String pgId) async {
    try {
      final listings = await _databaseService.queryDocuments(
        FirestoreConstants.featuredListings,
        field: 'pgId',
        isEqualTo: pgId,
      );

      if (listings.docs.isEmpty) {
        return null;
      }

      // Find active featured listing
      for (final doc in listings.docs) {
        final listing = FeaturedListingModel.fromMap(
            doc.data() as Map<String, dynamic>);
        if (listing.isActive) {
          return listing;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get active featured listing: $e');
    }
  }

  /// Check if a PG is currently featured
  Future<bool> isPGFeatured(String pgId) async {
    final listing = await getActiveFeaturedListing(pgId);
    return listing != null && listing.isActive;
  }

  /// Stream featured listing for a PG (real-time updates)
  Stream<FeaturedListingModel?> streamFeaturedListing(String pgId) {
    return _databaseService
        .getCollectionStreamWithFilter(
          FirestoreConstants.featuredListings,
          'pgId',
          pgId,
        )
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }

      // Return the most recent active featured listing
      final listings = snapshot.docs
          .map((doc) => FeaturedListingModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

      // Find active listing
      try {
        return listings.firstWhere((listing) => listing.isActive);
      } catch (e) {
        return null;
      }
    });
  }

  /// Stream all featured listings for an owner
  Stream<List<FeaturedListingModel>> streamOwnerFeaturedListings(
      String ownerId) {
    return _databaseService
        .getCollectionStreamWithFilter(
          FirestoreConstants.featuredListings,
          'ownerId',
          ownerId,
        )
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FeaturedListingModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    });
  }

  /// Get all active featured listings (for guest app display)
  Stream<List<FeaturedListingModel>> streamActiveFeaturedListings() {
    return _databaseService
        .getCollectionStream(FirestoreConstants.featuredListings)
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FeaturedListingModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .where((listing) => listing.isActive)
          .toList()
        ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    });
  }

  /// Get all active featured PG IDs
  Future<List<String>> getActiveFeaturedPGIds() async {
    try {
      final listings = await _databaseService.queryDocuments(
        FirestoreConstants.featuredListings,
        field: 'status',
        isEqualTo: FeaturedListingStatus.active.firestoreValue,
      );

      final now = DateTime.now();
      return listings.docs
          .map((doc) => FeaturedListingModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .where((listing) =>
              listing.status == FeaturedListingStatus.active &&
              listing.endDate.isAfter(now))
          .map((listing) => listing.pgId)
          .toList();
    } catch (e) {
      throw Exception('Failed to get active featured PG IDs: $e');
    }
  }

  /// Cancel a featured listing
  Future<void> cancelFeaturedListing({
    required String featuredListingId,
    required String ownerId,
  }) async {
    try {
      final listing = await getFeaturedListing(featuredListingId);
      if (listing == null) {
        throw Exception('Featured listing not found');
      }

      if (listing.ownerId != ownerId) {
        throw Exception('Unauthorized: Listing does not belong to owner');
      }

      final cancelledListing = listing.copyWith(
        status: FeaturedListingStatus.cancelled,
      );

      await updateFeaturedListing(cancelledListing);

      await _analyticsService.logEvent(
        name: 'featured_listing_cancelled',
        parameters: {
          'featured_listing_id': featuredListingId,
          'owner_id': ownerId,
          'pg_id': listing.pgId,
        },
      );
    } catch (e) {
      throw Exception('Failed to cancel featured listing: $e');
    }
  }

  /// Get expiring featured listings (for renewal reminders)
  Future<List<FeaturedListingModel>> getExpiringFeaturedListings({
    int daysBeforeExpiry = 7,
  }) async {
    try {
      final now = DateTime.now();
      final expiryThreshold = now.add(Duration(days: daysBeforeExpiry));

      final activeListings = await _databaseService.queryDocuments(
        FirestoreConstants.featuredListings,
        field: 'status',
        isEqualTo: FeaturedListingStatus.active.firestoreValue,
      );

      return activeListings.docs
          .map((doc) => FeaturedListingModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .where((listing) =>
              listing.status == FeaturedListingStatus.active &&
              listing.endDate.isBefore(expiryThreshold) &&
              listing.endDate.isAfter(now))
          .toList();
    } catch (e) {
      throw Exception('Failed to get expiring featured listings: $e');
    }
  }

  /// Get expired featured listings that need to be deactivated
  Future<List<FeaturedListingModel>> getExpiredFeaturedListings() async {
    try {
      final now = DateTime.now();

      final activeListings = await _databaseService.queryDocuments(
        FirestoreConstants.featuredListings,
        field: 'status',
        isEqualTo: FeaturedListingStatus.active.firestoreValue,
      );

      final expired = activeListings.docs
          .map((doc) => FeaturedListingModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .where((listing) =>
              listing.status == FeaturedListingStatus.active &&
              listing.endDate.isBefore(now))
          .toList();

      return expired;
    } catch (e) {
      throw Exception('Failed to get expired featured listings: $e');
    }
  }

  /// Get all featured listings (admin-level access)
  /// Returns all featured listings across all owners for admin dashboard
  Future<List<FeaturedListingModel>> getAllFeaturedListingsAdmin() async {
    try {
      // Use stream first to get all, then convert to list
      final snapshot = await _databaseService
          .getCollectionStream(FirestoreConstants.featuredListings)
          .first;

      return snapshot.docs
          .map((doc) => FeaturedListingModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    } catch (e) {
      throw Exception('Failed to get all featured listings: $e');
    }
  }

  /// Stream all featured listings (admin-level access)
  /// Returns real-time stream of all featured listings across all owners
  Stream<List<FeaturedListingModel>> streamAllFeaturedListingsAdmin() {
    return _databaseService
        .getCollectionStream(FirestoreConstants.featuredListings)
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => FeaturedListingModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    });
  }

  /// Get active featured listings count (admin-level)
  Future<int> getActiveFeaturedListingsCount() async {
    try {
      final listings = await _databaseService.queryDocuments(
        FirestoreConstants.featuredListings,
        field: 'status',
        isEqualTo: FeaturedListingStatus.active.firestoreValue,
      );

      final now = DateTime.now();
      return listings.docs
          .map((doc) => FeaturedListingModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .where((listing) =>
              listing.status == FeaturedListingStatus.active &&
              listing.endDate.isAfter(now))
          .length;
    } catch (e) {
      throw Exception('Failed to get active featured listings count: $e');
    }
  }
}

