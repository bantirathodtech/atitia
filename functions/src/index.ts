/**
 * Atitia Cloud Functions
 * 
 * Subscription Renewal Automation
 * - Scheduled function to check expiring subscriptions
 * - Send renewal reminders (7, 3, 1 days before expiry)
 * - Move expired subscriptions to grace period
 * - Auto-downgrade after grace period (7 days)
 */

import * as functions from "firebase-functions/v2";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

// Grace period duration in days
const GRACE_PERIOD_DAYS = 7;

// Reminder intervals (days before expiry)
const REMINDER_DAYS = [7, 3, 1];

/**
 * Scheduled function that runs daily at 9:00 AM UTC
 * Checks for expiring subscriptions and processes renewals
 */
export const checkSubscriptionRenewals = onSchedule(
  {
    schedule: "0 9 * * *", // Every day at 9:00 AM UTC
    timeZone: "UTC",
  },
  async () => {
    functions.logger.info("Starting subscription renewal check...");

    try {
      const results = {
        remindersSent: 0,
        movedToGracePeriod: 0,
        downgraded: 0,
      };

      // Check for subscriptions expiring in reminder days
      for (const daysBeforeExpiry of REMINDER_DAYS) {
        const expiringSubscriptions = await getExpiringSubscriptions(
          daysBeforeExpiry
        );

        for (const subscription of expiringSubscriptions) {
          await sendRenewalReminder(subscription, daysBeforeExpiry);
          results.remindersSent++;
        }
      }

      // Check for expired subscriptions that need grace period
      const expiredSubscriptions = await getExpiredSubscriptions();

      for (const subscription of expiredSubscriptions) {
        if (subscription.status === "active") {
          // Move to grace period
          await moveToGracePeriod(subscription);
          results.movedToGracePeriod++;
        }
      }

      // Check for grace period subscriptions that need downgrade
      const gracePeriodSubscriptions = await getGracePeriodSubscriptions();

      for (const subscription of gracePeriodSubscriptions) {
        // Check if grace period has ended
        const daysSinceExpiry = getDaysSinceExpiry(subscription.endDate);
        if (daysSinceExpiry > GRACE_PERIOD_DAYS) {
          // Auto-downgrade
          await autoDowngrade(subscription);
          results.downgraded++;
        }
      }

      functions.logger.info("Subscription renewal check completed", {
        ...results,
        timestamp: admin.firestore.Timestamp.now().toDate().toISOString(),
      });
    } catch (error) {
      functions.logger.error("Error in subscription renewal check:", error);
      throw error;
    }
  }
);

/**
 * Get subscriptions expiring within specified days
 */
async function getExpiringSubscriptions(
  daysBeforeExpiry: number
): Promise<any[]> {
  const now = new Date();
  const expiryThreshold = new Date(now);
  expiryThreshold.setDate(now.getDate() + daysBeforeExpiry);

  // Get all active subscriptions
  const subscriptionsSnapshot = await db
    .collection("owner_subscriptions")
    .where("status", "==", "active")
    .get();

  const expiringSubscriptions: any[] = [];

  for (const doc of subscriptionsSnapshot.docs) {
    const subscription = doc.data();
    const endDate = subscription.endDate?.toDate();

    if (
      endDate &&
      endDate > now &&
      endDate <= expiryThreshold &&
      subscription.status === "active"
    ) {
      expiringSubscriptions.push({
        id: doc.id,
        ...subscription,
        endDate,
      });
    }
  }

  return expiringSubscriptions;
}

/**
 * Get expired subscriptions that need processing
 */
async function getExpiredSubscriptions(): Promise<any[]> {
  const now = new Date();

  // Get active subscriptions
  const activeSubscriptions = await db
    .collection("owner_subscriptions")
    .where("status", "==", "active")
    .get();

  const expiredSubscriptions: any[] = [];

  for (const doc of activeSubscriptions.docs) {
    const subscription = doc.data();
    const endDate = subscription.endDate?.toDate();

    if (endDate && endDate < now && subscription.status === "active") {
      expiredSubscriptions.push({
        id: doc.id,
        ...subscription,
        endDate,
      });
    }
  }

  return expiredSubscriptions;
}

/**
 * Get subscriptions in grace period that may need downgrade
 */
async function getGracePeriodSubscriptions(): Promise<any[]> {
  // Get grace period subscriptions
  const gracePeriodSubscriptions = await db
    .collection("owner_subscriptions")
    .where("status", "==", "gracePeriod")
    .get();

  const subscriptions: any[] = [];

  for (const doc of gracePeriodSubscriptions.docs) {
    const subscription = doc.data();
    const endDate = subscription.endDate?.toDate();

    if (endDate) {
      subscriptions.push({
        id: doc.id,
        ...subscription,
        endDate,
      });
    }
  }

  return subscriptions;
}

/**
 * Send renewal reminder notification
 */
async function sendRenewalReminder(
  subscription: any,
  daysBeforeExpiry: number
): Promise<void> {
  try {
    // Get owner profile
    const ownerProfileDoc = await db
      .collection("users")
      .doc(subscription.ownerId)
      .get();

    if (!ownerProfileDoc.exists) {
      functions.logger.warn(
        `Owner profile not found: ${subscription.ownerId}`
      );
      return;
    }

    const ownerProfile = ownerProfileDoc.data();
    if (!ownerProfile) return;

    // Build reminder message
    let title: string;
    let body: string;

    if (daysBeforeExpiry === 7) {
      title = "Subscription Renewal Reminder";
      body = `Your ${subscription.tier} subscription expires in 7 days. Renew now to continue enjoying premium features.`;
    } else if (daysBeforeExpiry === 3) {
      title = "Subscription Expiring Soon";
      body = `Your ${subscription.tier} subscription expires in 3 days. Don't miss out on premium features!`;
    } else {
      title = "Last Day to Renew";
      body = `Your ${subscription.tier} subscription expires today. Renew now to avoid service interruption.`;
    }

    // Create notification
    const notificationId = `${subscription.ownerId}_${Date.now()}_subscription_renewal_reminder`;

    await db.collection("notifications").doc(notificationId).set({
      id: notificationId,
      userId: subscription.ownerId,
      type: "subscription_renewal_reminder",
      title,
      body,
      data: {
        subscriptionId: subscription.id,
        tier: subscription.tier,
        daysBeforeExpiry,
        expiryDate: subscription.endDate.toISOString(),
        action: "renew_subscription",
      },
      read: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    functions.logger.info(
      `Renewal reminder sent to ${subscription.ownerId} (${daysBeforeExpiry} days)`
    );
  } catch (error) {
    functions.logger.error(
      `Error sending renewal reminder: ${error}`,
      subscription
    );
  }
}

/**
 * Move subscription to grace period
 */
async function moveToGracePeriod(subscription: any): Promise<void> {
  try {
    // Update subscription status
    await db
      .collection("owner_subscriptions")
      .doc(subscription.id)
      .update({
        status: "gracePeriod",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    // Update owner profile
    await db
      .collection("users")
      .doc(subscription.ownerId)
      .update({
        subscriptionStatus: "gracePeriod",
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    // Send grace period notification
    const gracePeriodEndDate = new Date(subscription.endDate);
    gracePeriodEndDate.setDate(gracePeriodEndDate.getDate() + GRACE_PERIOD_DAYS);

    const notificationId = `${subscription.ownerId}_${Date.now()}_subscription_grace_period`;

    await db.collection("notifications").doc(notificationId).set({
      id: notificationId,
      userId: subscription.ownerId,
      type: "subscription_grace_period",
      title: "Subscription in Grace Period",
      body: `Your ${subscription.tier} subscription has expired. You have 7 days to renew before downgrading to Free tier.`,
      data: {
        subscriptionId: subscription.id,
        tier: subscription.tier,
        gracePeriodEnds: gracePeriodEndDate.toISOString(),
        action: "renew_subscription",
      },
      read: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    functions.logger.info(
      `Subscription moved to grace period: ${subscription.id}`
    );
  } catch (error) {
    functions.logger.error(`Error moving to grace period: ${error}`);
    throw error;
  }
}

/**
 * Auto-downgrade subscription to Free tier
 */
async function autoDowngrade(subscription: any): Promise<void> {
  try {
    // Update subscription status
    await db
      .collection("owner_subscriptions")
      .doc(subscription.id)
      .update({
        status: "expired",
        autoRenew: false,
        cancellationReason: "Auto-downgraded after grace period",
        cancelledAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    // Update owner profile to Free tier
    await db
      .collection("users")
      .doc(subscription.ownerId)
      .update({
        subscriptionTier: "free",
        subscriptionStatus: "expired",
        subscriptionEndDate: admin.firestore.FieldValue.delete(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    // Send downgrade notification
    const notificationId = `${subscription.ownerId}_${Date.now()}_subscription_downgraded`;

    await db.collection("notifications").doc(notificationId).set({
      id: notificationId,
      userId: subscription.ownerId,
      type: "subscription_downgraded",
      title: "Subscription Downgraded",
      body: `Your ${subscription.tier} subscription has been downgraded to Free tier. Upgrade anytime to regain premium features.`,
      data: {
        subscriptionId: subscription.id,
        previousTier: subscription.tier,
        action: "upgrade_subscription",
      },
      read: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    functions.logger.info(`Subscription auto-downgraded: ${subscription.id}`);
  } catch (error) {
    functions.logger.error(`Error auto-downgrading subscription: ${error}`);
    throw error;
  }
}

/**
 * Helper function to get days since expiry
 */
function getDaysSinceExpiry(endDate: Date): number {
  const now = new Date();
  const diffTime = now.getTime() - endDate.getTime();
  return Math.floor(diffTime / (1000 * 60 * 60 * 24));
}

