// lib/core/repositories/review_repository.dart

import '../../core/di/common/unified_service_locator.dart';
import '../../common/utils/date/converter/date_service_converter.dart';
import '../../core/interfaces/database/database_service_interface.dart';
import '../models/review_model.dart';

/// ⭐ **REVIEW REPOSITORY - PRODUCTION READY**
///
/// **Responsibilities:**
/// - CRUD operations for reviews
/// - Real-time review streams
/// - Review analytics and statistics
/// - Review moderation
/// Uses interface-based services for dependency injection (swappable backends)
class ReviewRepository {
  final IDatabaseService _databaseService;
  static const String _reviewsCollection = 'reviews';

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  ReviewRepository({
    IDatabaseService? databaseService,
  }) : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database;

  /// Create a new review
  Future<String> createReview(ReviewModel review) async {
    try {
      await _databaseService.setDocument(
        _reviewsCollection,
        review.reviewId,
        review.toMap(),
      );
      return review.reviewId;
    } catch (e) {
      throw Exception('Failed to create review: $e');
    }
  }

  /// Update an existing review
  Future<void> updateReview(ReviewModel review) async {
    try {
      await _databaseService.updateDocument(
        _reviewsCollection,
        review.reviewId,
        review.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }

  /// Get reviews for a specific PG
  Stream<List<ReviewModel>> streamPGReviews(String pgId, {int limit = 20}) {
    return _databaseService
        .getCollectionStreamWithFilter(_reviewsCollection, 'pgId', pgId)
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ReviewModel.fromMap(data);
          })
          .where((review) =>
              review.status == 'approved' && !review.isOwnerResponse)
          .toList()
        ..sort((a, b) => b.reviewDate.compareTo(a.reviewDate))
        ..take(limit);
    });
  }

  /// Get guest's reviews
  Stream<List<ReviewModel>> streamGuestReviews(String guestId) {
    // COST OPTIMIZATION: Limit to 20 reviews per stream
    return _databaseService
        .getCollectionStreamWithFilter(_reviewsCollection, 'guestId', guestId, limit: 20)
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReviewModel.fromMap(data);
      }).toList()
        ..sort((a, b) => b.reviewDate.compareTo(a.reviewDate));
    });
  }

  /// Get owner's reviews (for all their PGs)
  Stream<List<ReviewModel>> streamOwnerReviews(String ownerId) {
    // COST OPTIMIZATION: Limit to 30 reviews per stream
    return _databaseService
        .getCollectionStreamWithFilter(_reviewsCollection, 'ownerId', ownerId, limit: 30)
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ReviewModel.fromMap(data);
      }).toList()
        ..sort((a, b) => b.reviewDate.compareTo(a.reviewDate));
    });
  }

  /// Get review statistics for a PG
  Future<Map<String, dynamic>> getPGReviewStats(String pgId) async {
    try {
      // COST OPTIMIZATION: Limit to 100 reviews for stats calculation
      final reviews = await _databaseService.queryDocuments(
        _reviewsCollection,
        field: 'pgId',
        isEqualTo: pgId,
        limit: 100,
      );

      if (reviews.docs.isEmpty) {
        return {
          'totalReviews': 0,
          'averageRating': 0.0,
          'ratingDistribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
          'aspectRatings': {
            'cleanliness': 0.0,
            'amenities': 0.0,
            'location': 0.0,
            'food': 0.0,
            'staff': 0.0,
          },
        };
      }

      final approvedReviews = reviews.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ReviewModel.fromMap(data);
          })
          .where((review) =>
              review.status == 'approved' && !review.isOwnerResponse)
          .toList();

      if (approvedReviews.isEmpty) {
        return {
          'totalReviews': 0,
          'averageRating': 0.0,
          'ratingDistribution': {1: 0, 2: 0, 3: 0, 4: 0, 5: 0},
          'aspectRatings': {
            'cleanliness': 0.0,
            'amenities': 0.0,
            'location': 0.0,
            'food': 0.0,
            'staff': 0.0,
          },
        };
      }

      // Calculate average rating
      final totalRating = approvedReviews
          .map((review) => review.rating)
          .reduce((a, b) => a + b);
      final averageRating = totalRating / approvedReviews.length;

      // Calculate rating distribution
      final ratingDistribution = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      for (final review in approvedReviews) {
        final rating = review.rating.round();
        ratingDistribution[rating] = (ratingDistribution[rating] ?? 0) + 1;
      }

      // Calculate aspect ratings
      final aspectRatings = {
        'cleanliness': approvedReviews
                .map((review) => review.cleanlinessRating)
                .reduce((a, b) => a + b) /
            approvedReviews.length,
        'amenities': approvedReviews
                .map((review) => review.amenitiesRating)
                .reduce((a, b) => a + b) /
            approvedReviews.length,
        'location': approvedReviews
                .map((review) => review.locationRating)
                .reduce((a, b) => a + b) /
            approvedReviews.length,
        'food': approvedReviews
                .map((review) => review.foodRating)
                .reduce((a, b) => a + b) /
            approvedReviews.length,
        'staff': approvedReviews
                .map((review) => review.staffRating)
                .reduce((a, b) => a + b) /
            approvedReviews.length,
      };

      return {
        'totalReviews': approvedReviews.length,
        'averageRating': averageRating,
        'ratingDistribution': ratingDistribution,
        'aspectRatings': aspectRatings,
      };
    } catch (e) {
      throw Exception('Failed to get review statistics: $e');
    }
  }

  /// Vote on review helpfulness
  Future<void> voteReviewHelpful(
      String reviewId, String userId, bool isHelpful) async {
    try {
      // This would typically be handled by a separate votes collection
      // For now, we'll update the review directly
      final reviewDoc =
          await _databaseService.getDocument(_reviewsCollection, reviewId);
      if (reviewDoc.exists) {
        final data = reviewDoc.data() as Map<String, dynamic>;
        final review = ReviewModel.fromMap(data);
        final newHelpfulVotes =
            isHelpful ? review.helpfulVotes + 1 : review.helpfulVotes;

        await _databaseService.updateDocument(
          _reviewsCollection,
          reviewId,
          {
            'helpfulVotes': newHelpfulVotes,
            'totalVotes': review.totalVotes + 1
          },
        );
      }
    } catch (e) {
      throw Exception('Failed to vote on review: $e');
    }
  }

  /// Add owner response to review
  Future<void> addOwnerResponse(String reviewId, String response) async {
    try {
      await _databaseService.updateDocument(
        _reviewsCollection,
        reviewId,
        {
          'ownerResponse': response,
          'ownerResponseDate': DateServiceConverter.toService(DateTime.now()),
        },
      );
    } catch (e) {
      throw Exception('Failed to add owner response: $e');
    }
  }

  /// Moderate review (approve/reject)
  Future<void> moderateReview(String reviewId, String status) async {
    try {
      await _databaseService.updateDocument(
        _reviewsCollection,
        reviewId,
        {
          'status': status,
          'lastUpdated': DateServiceConverter.toService(DateTime.now()),
        },
      );
    } catch (e) {
      throw Exception('Failed to moderate review: $e');
    }
  }

  /// Check if guest has reviewed PG
  Future<bool> hasGuestReviewedPG(String guestId, String pgId) async {
    try {
      final reviews = await _databaseService.queryDocuments(
        _reviewsCollection,
        field: 'guestId',
        isEqualTo: guestId,
      );

      return reviews.docs.any((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final review = ReviewModel.fromMap(data);
        return review.pgId == pgId;
      });
    } catch (e) {
      throw Exception('Failed to check review status: $e');
    }
  }

  /// Get pending reviews for moderation
  Stream<List<ReviewModel>> streamPendingReviews() {
    // COST OPTIMIZATION: Limit to 50 pending reviews per stream
    return _databaseService
        .getCollectionStream(_reviewsCollection, limit: 50)
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ReviewModel.fromMap(data);
          })
          .where((review) => review.status == 'pending')
          .toList()
        ..sort((a, b) => b.reviewDate.compareTo(a.reviewDate));
    });
  }

  /// Delete review
  Future<void> deleteReview(String reviewId) async {
    try {
      await _databaseService.deleteDocument(_reviewsCollection, reviewId);
    } catch (e) {
      throw Exception('Failed to delete review: $e');
    }
  }

  /// Get recent reviews across all PGs
  Stream<List<ReviewModel>> streamRecentReviews({int limit = 10}) {
    // COST OPTIMIZATION: Limit query to requested limit (max 20)
    final queryLimit = limit > 20 ? 20 : limit;
    return _databaseService
        .getCollectionStream(_reviewsCollection, limit: queryLimit)
        .map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ReviewModel.fromMap(data);
          })
          .where((review) => review.status == 'approved')
          .toList()
        ..sort((a, b) => b.reviewDate.compareTo(a.reviewDate))
        ..take(limit);
    });
  }
}
