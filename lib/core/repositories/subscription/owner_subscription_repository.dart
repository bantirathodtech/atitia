// lib/core/repositories/subscription/owner_subscription_repository.dart

import '../../di/common/unified_service_locator.dart';
import '../../../common/utils/constants/firestore.dart';
import '../../interfaces/analytics/analytics_service_interface.dart';
import '../../interfaces/database/database_service_interface.dart';
import '../../models/subscription/owner_subscription_model.dart';

/// Repository for managing owner subscriptions
/// Handles subscription CRUD operations, queries, and real-time streams
/// Uses interface-based services for dependency injection (swappable backends)
class OwnerSubscriptionRepository {
  final IDatabaseService _databaseService;
  final IAnalyticsService _analyticsService;

  /// Constructor with dependency injection
  /// If services are not provided, uses UnifiedServiceLocator as fallback
  OwnerSubscriptionRepository({
    IDatabaseService? databaseService,
    IAnalyticsService? analyticsService,
  })  : _databaseService =
            databaseService ?? UnifiedServiceLocator.serviceFactory.database,
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Create a new subscription
  Future<String> createSubscription(OwnerSubscriptionModel subscription) async {
    try {
      await _databaseService.setDocument(
        FirestoreConstants.ownerSubscriptions,
        subscription.subscriptionId,
        subscription.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'subscription_created',
        parameters: {
          'subscription_id': subscription.subscriptionId,
          'owner_id': subscription.ownerId,
          'tier': subscription.tier.firestoreValue,
          'billing_period': subscription.billingPeriod.firestoreValue,
          'amount_paid': subscription.amountPaid.toString(),
        },
      );

      return subscription.subscriptionId;
    } catch (e) {
      throw Exception('Failed to create subscription: $e');
    }
  }

  /// Update an existing subscription
  Future<void> updateSubscription(OwnerSubscriptionModel subscription) async {
    try {
      await _databaseService.updateDocument(
        FirestoreConstants.ownerSubscriptions,
        subscription.subscriptionId,
        subscription.toMap(),
      );

      await _analyticsService.logEvent(
        name: 'subscription_updated',
        parameters: {
          'subscription_id': subscription.subscriptionId,
          'owner_id': subscription.ownerId,
          'status': subscription.status.firestoreValue,
        },
      );
    } catch (e) {
      throw Exception('Failed to update subscription: $e');
    }
  }

  /// Get subscription by ID
  Future<OwnerSubscriptionModel?> getSubscription(String subscriptionId) async {
    try {
      final doc = await _databaseService.getDocument(
        FirestoreConstants.ownerSubscriptions,
        subscriptionId,
      );

      if (!doc.exists) {
        return null;
      }

      return OwnerSubscriptionModel.fromMap(
          doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get subscription: $e');
    }
  }

  /// Get active subscription for an owner
  Future<OwnerSubscriptionModel?> getActiveSubscription(String ownerId) async {
    try {
      final subscriptions = await _databaseService.queryDocuments(
        FirestoreConstants.ownerSubscriptions,
        field: 'ownerId',
        isEqualTo: ownerId,
      );

      if (subscriptions.docs.isEmpty) {
        return null;
      }

      // Find active subscription
      for (final doc in subscriptions.docs) {
        final subscription = OwnerSubscriptionModel.fromMap(
            doc.data() as Map<String, dynamic>);
        if (subscription.isActive) {
          return subscription;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get active subscription: $e');
    }
  }

  /// Stream subscription for an owner (real-time updates)
  Stream<OwnerSubscriptionModel?> streamSubscription(String ownerId) {
    return _databaseService
        .getCollectionStreamWithFilter(
          FirestoreConstants.ownerSubscriptions,
          'ownerId',
          ownerId,
        )
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return null;
      }

      // Return the most recent active subscription, or latest one
      final subscriptions = snapshot.docs
          .map((doc) => OwnerSubscriptionModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          final aDate = a.createdAt ?? DateTime(1970);
          final bDate = b.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });

      // Prefer active subscription
      final activeSubscription = subscriptions.firstWhere(
        (sub) => sub.isActive,
        orElse: () => subscriptions.first,
      );

      return activeSubscription;
    });
  }

  /// Stream all subscriptions for an owner
  Stream<List<OwnerSubscriptionModel>> streamAllSubscriptions(String ownerId) {
    return _databaseService
        .getCollectionStreamWithFilter(
          FirestoreConstants.ownerSubscriptions,
          'ownerId',
          ownerId,
        )
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OwnerSubscriptionModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          final aDate = a.createdAt ?? DateTime(1970);
          final bDate = b.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
    });
  }

  /// Get all subscriptions for an owner
  Future<List<OwnerSubscriptionModel>> getAllSubscriptions(String ownerId) async {
    try {
      final subscriptions = await _databaseService.queryDocuments(
        FirestoreConstants.ownerSubscriptions,
        field: 'ownerId',
        isEqualTo: ownerId,
      );

      return subscriptions.docs
          .map((doc) => OwnerSubscriptionModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          final aDate = a.createdAt ?? DateTime(1970);
          final bDate = b.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
    } catch (e) {
      throw Exception('Failed to get subscriptions: $e');
    }
  }

  /// Cancel a subscription
  Future<void> cancelSubscription({
    required String subscriptionId,
    required String ownerId,
    String? reason,
  }) async {
    try {
      final subscription = await getSubscription(subscriptionId);
      if (subscription == null) {
        throw Exception('Subscription not found');
      }

      if (subscription.ownerId != ownerId) {
        throw Exception('Unauthorized: Subscription does not belong to owner');
      }

      final cancelledSubscription = subscription.copyWith(
        status: SubscriptionStatus.cancelled,
        cancelledAt: DateTime.now(),
        cancellationReason: reason,
        autoRenew: false,
      );

      await updateSubscription(cancelledSubscription);

      await _analyticsService.logEvent(
        name: 'subscription_cancelled',
        parameters: {
          'subscription_id': subscriptionId,
          'owner_id': ownerId,
          'tier': subscription.tier.firestoreValue,
          'reason': reason ?? 'not_specified',
        },
      );
    } catch (e) {
      throw Exception('Failed to cancel subscription: $e');
    }
  }

  /// Get expiring subscriptions (for renewal reminders)
  Future<List<OwnerSubscriptionModel>> getExpiringSubscriptions({
    int daysBeforeExpiry = 7,
  }) async {
    try {
      final now = DateTime.now();
      final expiryThreshold = now.add(Duration(days: daysBeforeExpiry));

      final allSubscriptions = await _databaseService.queryDocuments(
        FirestoreConstants.ownerSubscriptions,
        field: 'status',
        isEqualTo: SubscriptionStatus.active.firestoreValue,
      );

      return allSubscriptions.docs
          .map((doc) => OwnerSubscriptionModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .where((subscription) =>
              subscription.status == SubscriptionStatus.active &&
              subscription.endDate.isBefore(expiryThreshold) &&
              subscription.endDate.isAfter(now))
          .toList();
    } catch (e) {
      throw Exception('Failed to get expiring subscriptions: $e');
    }
  }

  /// Get expired subscriptions that need to be downgraded
  Future<List<OwnerSubscriptionModel>> getExpiredSubscriptions() async {
    try {
      final now = DateTime.now();

      final activeSubscriptions = await _databaseService.queryDocuments(
        FirestoreConstants.ownerSubscriptions,
        field: 'status',
        isEqualTo: SubscriptionStatus.active.firestoreValue,
      );

      final expired = activeSubscriptions.docs
          .map((doc) => OwnerSubscriptionModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .where((subscription) =>
              subscription.status == SubscriptionStatus.active &&
              subscription.endDate.isBefore(now))
          .toList();

      return expired;
    } catch (e) {
      throw Exception('Failed to get expired subscriptions: $e');
    }
  }

  /// Get all subscriptions (admin-level access)
  /// Returns all subscriptions across all owners for admin dashboard
  Future<List<OwnerSubscriptionModel>> getAllSubscriptionsAdmin() async {
    try {
      // Use stream first to get all, then convert to list
      final snapshot = await _databaseService
          .getCollectionStream(FirestoreConstants.ownerSubscriptions)
          .first;

      return snapshot.docs
          .map((doc) => OwnerSubscriptionModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          final aDate = a.createdAt ?? DateTime(1970);
          final bDate = b.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
    } catch (e) {
      throw Exception('Failed to get all subscriptions: $e');
    }
  }

  /// Stream all subscriptions (admin-level access)
  /// Returns real-time stream of all subscriptions across all owners
  Stream<List<OwnerSubscriptionModel>> streamAllSubscriptionsAdmin() {
    return _databaseService
        .getCollectionStream(FirestoreConstants.ownerSubscriptions)
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OwnerSubscriptionModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) {
          final aDate = a.createdAt ?? DateTime(1970);
          final bDate = b.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
    });
  }

  /// Get active subscriptions count (admin-level)
  Future<int> getActiveSubscriptionsCount() async {
    try {
      final subscriptions = await _databaseService.queryDocuments(
        FirestoreConstants.ownerSubscriptions,
        field: 'status',
        isEqualTo: SubscriptionStatus.active.firestoreValue,
      );

      final now = DateTime.now();
      return subscriptions.docs
          .map((doc) => OwnerSubscriptionModel.fromMap(
              doc.data() as Map<String, dynamic>))
          .where((subscription) =>
              subscription.status == SubscriptionStatus.active &&
              subscription.endDate.isAfter(now))
          .length;
    } catch (e) {
      throw Exception('Failed to get active subscriptions count: $e');
    }
  }
}

