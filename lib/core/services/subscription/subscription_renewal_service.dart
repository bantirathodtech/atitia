// lib/core/services/subscription/subscription_renewal_service.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../di/common/unified_service_locator.dart';
import '../../repositories/subscription/owner_subscription_repository.dart';
import '../../repositories/notification_repository.dart';
import '../../models/subscription/owner_subscription_model.dart';
import '../../interfaces/analytics/analytics_service_interface.dart';
import '../../../feature/owner_dashboard/profile/data/repository/owner_profile_repository.dart';

/// Service for managing subscription renewals, reminders, and auto-downgrades
///
/// Features:
/// - Check for expiring subscriptions
/// - Send renewal reminders (7, 3, 1 days before expiry)
/// - Move subscriptions to grace period after expiry
/// - Auto-downgrade after grace period (7 days)
/// - Update owner profile subscription tier
class SubscriptionRenewalService {
  final OwnerSubscriptionRepository _subscriptionRepo;
  final NotificationRepository _notificationRepo;
  final OwnerProfileRepository _profileRepo;
  final IAnalyticsService _analyticsService;

  // Grace period duration in days
  static const int gracePeriodDays = 7;

  // Reminder intervals (days before expiry)
  static const List<int> reminderDays = [7, 3, 1];

  SubscriptionRenewalService({
    OwnerSubscriptionRepository? subscriptionRepo,
    NotificationRepository? notificationRepo,
    OwnerProfileRepository? profileRepo,
    IAnalyticsService? analyticsService,
  })  : _subscriptionRepo = subscriptionRepo ?? OwnerSubscriptionRepository(),
        _notificationRepo = notificationRepo ?? NotificationRepository(),
        _profileRepo = profileRepo ?? OwnerProfileRepository(),
        _analyticsService =
            analyticsService ?? UnifiedServiceLocator.serviceFactory.analytics;

  /// Check and process all expiring subscriptions
  /// This method should be called periodically (e.g., daily via Cloud Functions)
  Future<RenewalCheckResult> checkAndProcessRenewals() async {
    try {
      await _analyticsService.logEvent(
        name: 'subscription_renewal_check_started',
        parameters: {'timestamp': DateTime.now().toIso8601String()},
      );

      final results = RenewalCheckResult();

      // Check for subscriptions expiring in reminder days
      for (final daysBeforeExpiry in reminderDays) {
        final expiringSubscriptions =
            await _subscriptionRepo.getExpiringSubscriptions(
          daysBeforeExpiry: daysBeforeExpiry,
        );

        for (final subscription in expiringSubscriptions) {
          await _sendRenewalReminder(subscription, daysBeforeExpiry);
          results.remindersSent++;
        }
      }

      // Check for expired subscriptions that need grace period
      final expiredSubscriptions =
          await _subscriptionRepo.getExpiredSubscriptions();

      for (final subscription in expiredSubscriptions) {
        if (subscription.status == SubscriptionStatus.active) {
          // Move to grace period
          await _moveToGracePeriod(subscription);
          results.movedToGracePeriod++;
        } else if (subscription.isInGracePeriod) {
          // Check if grace period has ended
          final daysSinceExpiry =
              DateTime.now().difference(subscription.endDate).inDays;
          if (daysSinceExpiry > gracePeriodDays) {
            // Auto-downgrade
            await _autoDowngrade(subscription);
            results.downgraded++;
          }
        }
      }

      await _analyticsService.logEvent(
        name: 'subscription_renewal_check_completed',
        parameters: {
          'reminders_sent': results.remindersSent,
          'moved_to_grace_period': results.movedToGracePeriod,
          'downgraded': results.downgraded,
        },
      );

      return results;
    } catch (e) {
      await _analyticsService.logEvent(
        name: 'subscription_renewal_check_error',
        parameters: {'error': e.toString()},
      );
      rethrow;
    }
  }

  /// Send renewal reminder notification to owner
  Future<void> _sendRenewalReminder(
    OwnerSubscriptionModel subscription,
    int daysBeforeExpiry,
  ) async {
    try {
      // Get owner profile for notification details
      final ownerProfile =
          await _profileRepo.getOwnerProfile(subscription.ownerId);
      if (ownerProfile == null) {
        debugPrint(
            '⚠️ Owner profile not found for subscription reminder: ${subscription.ownerId}');
        return;
      }

      // Build reminder message based on days remaining
      String title;
      String body;

      if (daysBeforeExpiry == 7) {
        title = 'Subscription Renewal Reminder';
        body =
            'Your ${subscription.tier.displayName} subscription expires in 7 days. Renew now to continue enjoying premium features.';
      } else if (daysBeforeExpiry == 3) {
        title = 'Subscription Expiring Soon';
        body =
            'Your ${subscription.tier.displayName} subscription expires in 3 days. Don\'t miss out on premium features!';
      } else {
        title = 'Last Day to Renew';
        body =
            'Your ${subscription.tier.displayName} subscription expires today. Renew now to avoid service interruption.';
      }

      // Send notification
      await _notificationRepo.sendUserNotification(
        userId: subscription.ownerId,
        type: 'subscription_renewal_reminder',
        title: title,
        body: body,
        data: {
          'subscriptionId': subscription.subscriptionId,
          'tier': subscription.tier.firestoreValue,
          'daysBeforeExpiry': daysBeforeExpiry,
          'expiryDate': subscription.endDate.toIso8601String(),
          'action': 'renew_subscription',
        },
      );

      await _analyticsService.logEvent(
        name: 'subscription_renewal_reminder_sent',
        parameters: {
          'subscription_id': subscription.subscriptionId,
          'owner_id': subscription.ownerId,
          'days_before_expiry': daysBeforeExpiry,
          'tier': subscription.tier.firestoreValue,
        },
      );
    } catch (e) {
      debugPrint('❌ Error sending renewal reminder: $e');
      await _analyticsService.logEvent(
        name: 'subscription_renewal_reminder_error',
        parameters: {
          'subscription_id': subscription.subscriptionId,
          'error': e.toString(),
        },
      );
    }
  }

  /// Move subscription to grace period
  Future<void> _moveToGracePeriod(OwnerSubscriptionModel subscription) async {
    try {
      final updatedSubscription = subscription.copyWith(
        status: SubscriptionStatus.gracePeriod,
      );

      await _subscriptionRepo.updateSubscription(updatedSubscription);

      // Update owner profile
      await _updateOwnerProfileSubscription(
        subscription.ownerId,
        subscription.tier.firestoreValue,
        SubscriptionStatus.gracePeriod.firestoreValue,
        subscription.endDate,
      );

      // Send grace period notification
      final ownerProfile =
          await _profileRepo.getOwnerProfile(subscription.ownerId);
      if (ownerProfile != null) {
        await _notificationRepo.sendUserNotification(
          userId: subscription.ownerId,
          type: 'subscription_grace_period',
          title: 'Subscription in Grace Period',
          body:
              'Your ${subscription.tier.displayName} subscription has expired. You have 7 days to renew before downgrading to Free tier.',
          data: {
            'subscriptionId': subscription.subscriptionId,
            'tier': subscription.tier.firestoreValue,
            'gracePeriodEnds': subscription.endDate
                .add(Duration(days: gracePeriodDays))
                .toIso8601String(),
            'action': 'renew_subscription',
          },
        );
      }

      await _analyticsService.logEvent(
        name: 'subscription_moved_to_grace_period',
        parameters: {
          'subscription_id': subscription.subscriptionId,
          'owner_id': subscription.ownerId,
          'tier': subscription.tier.firestoreValue,
        },
      );
    } catch (e) {
      debugPrint('❌ Error moving subscription to grace period: $e');
      rethrow;
    }
  }

  /// Auto-downgrade subscription to Free tier after grace period
  Future<void> _autoDowngrade(OwnerSubscriptionModel subscription) async {
    try {
      final updatedSubscription = subscription.copyWith(
        status: SubscriptionStatus.expired,
        autoRenew: false,
        cancellationReason: 'Auto-downgraded after grace period',
        cancelledAt: DateTime.now(),
      );

      await _subscriptionRepo.updateSubscription(updatedSubscription);

      // Update owner profile to Free tier
      await _updateOwnerProfileSubscription(
        subscription.ownerId,
        'free',
        SubscriptionStatus.expired.firestoreValue,
        null, // No expiry date for free tier
      );

      // Send downgrade notification
      final ownerProfile =
          await _profileRepo.getOwnerProfile(subscription.ownerId);
      if (ownerProfile != null) {
        await _notificationRepo.sendUserNotification(
          userId: subscription.ownerId,
          type: 'subscription_downgraded',
          title: 'Subscription Downgraded',
          body:
              'Your ${subscription.tier.displayName} subscription has been downgraded to Free tier. Upgrade anytime to regain premium features.',
          data: {
            'subscriptionId': subscription.subscriptionId,
            'previousTier': subscription.tier.firestoreValue,
            'action': 'upgrade_subscription',
          },
        );
      }

      await _analyticsService.logEvent(
        name: 'subscription_auto_downgraded',
        parameters: {
          'subscription_id': subscription.subscriptionId,
          'owner_id': subscription.ownerId,
          'previous_tier': subscription.tier.firestoreValue,
        },
      );

      debugPrint(
          '✅ Auto-downgraded subscription: ${subscription.subscriptionId}');
    } catch (e) {
      debugPrint('❌ Error auto-downgrading subscription: $e');
      rethrow;
    }
  }

  /// Update owner profile subscription information
  Future<void> _updateOwnerProfileSubscription(
    String ownerId,
    String? tier,
    String? status,
    DateTime? endDate,
  ) async {
    try {
      final profile = await _profileRepo.getOwnerProfile(ownerId);
      if (profile == null) {
        debugPrint(
            '⚠️ Owner profile not found for subscription update: $ownerId');
        return;
      }

      // Prepare update data
      final updateData = <String, dynamic>{
        'subscriptionTier': tier,
        'subscriptionStatus': status,
      };

      // Add end date if provided (convert to Firestore Timestamp format)
      if (endDate != null) {
        updateData['subscriptionEndDate'] = Timestamp.fromDate(endDate);
      } else {
        // Clear end date if not provided
        updateData['subscriptionEndDate'] = FieldValue.delete();
      }

      // Update profile in Firestore
      await _profileRepo.updateOwnerProfile(ownerId, updateData);

      await _analyticsService.logEvent(
        name: 'owner_profile_subscription_updated',
        parameters: {
          'owner_id': ownerId,
          'new_tier': tier ?? 'null',
          'new_status': status ?? 'null',
        },
      );
    } catch (e) {
      debugPrint('❌ Error updating owner profile subscription: $e');
      // Don't rethrow - this is not critical for renewal process
    }
  }
}

/// Result of a renewal check operation
class RenewalCheckResult {
  int remindersSent = 0;
  int movedToGracePeriod = 0;
  int downgraded = 0;

  int get totalProcessed => remindersSent + movedToGracePeriod + downgraded;

  @override
  String toString() {
    return 'RenewalCheckResult(reminders: $remindersSent, gracePeriod: $movedToGracePeriod, downgraded: $downgraded)';
  }
}
