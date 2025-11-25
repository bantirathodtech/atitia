# Subscription Renewal Automation

This document describes the subscription renewal automation system implemented for the Atitia app.

## Overview

The subscription renewal automation system automatically:
1. **Sends renewal reminders** to owners before their subscription expires (7, 3, and 1 day before)
2. **Moves expired subscriptions to grace period** (7 days after expiry)
3. **Auto-downgrades subscriptions** to Free tier after grace period ends
4. **Updates owner profiles** with subscription tier changes

## Architecture

The system consists of two components:

### 1. Cloud Functions (Server-Side)

**Location:** `functions/src/index.ts`

A scheduled Cloud Function runs daily at 9:00 AM UTC to:
- Check all active subscriptions
- Identify subscriptions expiring in 7, 3, or 1 day
- Send renewal reminder notifications
- Move expired subscriptions to grace period
- Auto-downgrade subscriptions after grace period

**Function Name:** `checkSubscriptionRenewals`

**Schedule:** Daily at 9:00 AM UTC (`0 9 * * *`)

### 2. Flutter Service (Client-Side)

**Location:** `lib/core/services/subscription/subscription_renewal_service.dart`

A Flutter service that can be called manually or integrated with app lifecycle to:
- Check subscription renewal status
- Process renewal reminders
- Handle grace period transitions
- Perform auto-downgrades

This serves as a backup/fallback mechanism and can be used for on-demand checks.

## Features

### Renewal Reminders

Reminders are sent at three intervals:
- **7 days before expiry**: "Subscription Renewal Reminder"
- **3 days before expiry**: "Subscription Expiring Soon"
- **1 day before expiry**: "Last Day to Renew"

Each reminder includes:
- Subscription tier
- Days until expiry
- Link to renewal action
- Expiry date

### Grace Period

After a subscription expires:
1. Status is changed to `gracePeriod`
2. Owner receives a notification about the grace period
3. Owner has 7 days to renew before downgrade
4. All premium features remain available during grace period

### Auto-Downgrade

After the grace period (7 days after expiry):
1. Subscription status is changed to `expired`
2. `autoRenew` is set to `false`
3. Cancellation reason is set to "Auto-downgraded after grace period"
4. Owner profile subscription tier is updated to `free`
5. Owner receives a notification about the downgrade

## Configuration

### Grace Period Duration

The grace period is configured as **7 days** by default. This can be modified in:

- **Cloud Functions:** `functions/src/index.ts` → `GRACE_PERIOD_DAYS`
- **Flutter Service:** `lib/core/services/subscription/subscription_renewal_service.dart` → `gracePeriodDays`

### Reminder Intervals

Reminders are sent at:
- 7 days before expiry
- 3 days before expiry
- 1 day before expiry

These intervals can be modified in:

- **Cloud Functions:** `functions/src/index.ts` → `REMINDER_DAYS`
- **Flutter Service:** `lib/core/services/subscription/subscription_renewal_service.dart` → `reminderDays`

### Schedule

The Cloud Function runs daily at 9:00 AM UTC. To change the schedule, modify:

```typescript
.schedule("0 9 * * *") // Cron expression
.timeZone("UTC")
```

Cron expression format: `minute hour day month day-of-week`

Examples:
- `0 9 * * *` - Daily at 9:00 AM UTC
- `0 12 * * *` - Daily at 12:00 PM UTC
- `0 0 * * *` - Daily at midnight UTC

## Deployment

### Prerequisites

1. **Node.js 18+** installed
2. **Firebase CLI** installed and configured
3. **Firebase project** set up

### Steps

1. **Install dependencies:**
   ```bash
   cd functions
   npm install
   ```

2. **Build TypeScript:**
   ```bash
   npm run build
   ```

3. **Test locally (optional):**
   ```bash
   npm run serve
   ```
   This starts the Firebase emulator with Functions.

4. **Deploy to Firebase:**
   ```bash
   # From project root
   firebase deploy --only functions
   ```

   Or deploy specific function:
   ```bash
   firebase deploy --only functions:checkSubscriptionRenewals
   ```

### Verification

After deployment, verify the function is running:

1. **Check Firebase Console:**
   - Go to Firebase Console → Functions
   - Verify `checkSubscriptionRenewals` is listed
   - Check the schedule is set correctly

2. **Check logs:**
   ```bash
   firebase functions:log
   ```

3. **Test manually (optional):**
   - In Firebase Console, go to Functions
   - Click on `checkSubscriptionRenewals`
   - Click "Trigger" to test manually

## Usage

### From Flutter App

The Flutter service can be called manually if needed:

```dart
import 'package:atitia/core/services/subscription/subscription_renewal_service.dart';

// Initialize service
final renewalService = SubscriptionRenewalService();

// Check and process renewals
final result = await renewalService.checkAndProcessRenewals();

print('Reminders sent: ${result.remindersSent}');
print('Moved to grace period: ${result.movedToGracePeriod}');
print('Downgraded: ${result.downgraded}');
```

**Note:** The Cloud Function handles this automatically, so manual calls are usually not necessary.

## Monitoring

### Cloud Functions Logs

View logs in Firebase Console:
1. Go to Firebase Console → Functions
2. Click on `checkSubscriptionRenewals`
3. View execution logs

Or via CLI:
```bash
firebase functions:log --only checkSubscriptionRenewals
```

### Analytics Events

The system logs analytics events:

- `subscription_renewal_check_started`
- `subscription_renewal_check_completed`
- `subscription_renewal_check_error`
- `subscription_renewal_reminder_sent`
- `subscription_moved_to_grace_period`
- `subscription_auto_downgraded`
- `owner_profile_subscription_updated`

View these in Firebase Analytics → Events.

### Notification Tracking

All notifications are stored in the `notifications` collection with:
- `type`: Notification type (e.g., `subscription_renewal_reminder`)
- `userId`: Owner ID
- `data`: Additional metadata

## Troubleshooting

### Function Not Running

1. **Check schedule:** Verify the cron expression is correct
2. **Check timezone:** Ensure UTC timezone is appropriate
3. **Check logs:** Review Firebase Functions logs for errors
4. **Check permissions:** Ensure Cloud Functions have Firestore read/write permissions

### Notifications Not Sent

1. **Check owner profile:** Ensure owner profile exists
2. **Check notification collection:** Verify notifications are being created
3. **Check app notification settings:** Ensure owner has notifications enabled

### Auto-Downgrade Not Working

1. **Check grace period calculation:** Verify days since expiry calculation
2. **Check subscription status:** Ensure status is `gracePeriod` before downgrade
3. **Check owner profile update:** Verify profile update is successful

### Date/Time Issues

1. **Timezone consistency:** Ensure all dates use UTC
2. **Date parsing:** Verify Firestore Timestamp conversion
3. **Schedule timezone:** Ensure Cloud Function schedule timezone matches expectations

## Testing

### Manual Testing

1. **Create test subscription:**
   - Create a subscription with `endDate` set to tomorrow
   - Status should be `active`

2. **Trigger renewal check:**
   - Manually trigger `checkSubscriptionRenewals` function
   - Or wait for scheduled execution

3. **Verify results:**
   - Check notifications collection for reminder
   - Verify subscription status changes

### Testing Grace Period

1. **Create expired subscription:**
   - Create subscription with `endDate` in the past
   - Status should be `active`

2. **Trigger renewal check:**
   - Function should move subscription to `gracePeriod`
   - Owner should receive grace period notification

3. **Test auto-downgrade:**
   - Wait 7 days (or modify code for testing)
   - Trigger renewal check again
   - Subscription should be downgraded to `free`

## Best Practices

1. **Monitor execution:** Regularly check Cloud Functions logs
2. **Handle errors gracefully:** Ensure errors don't break the entire process
3. **Test changes:** Test schedule changes in a development environment first
4. **Backup data:** Keep backups before making significant changes
5. **Document changes:** Update this document when modifying configuration

## Future Enhancements

Potential improvements:
- [ ] Email notifications in addition to in-app notifications
- [ ] SMS notifications for urgent reminders
- [ ] Configurable grace period per subscription tier
- [ ] Webhook notifications for third-party integrations
- [ ] Retry mechanism for failed operations
- [ ] Batch processing for large numbers of subscriptions
- [ ] Custom reminder messages per subscription tier

## Support

For issues or questions:
1. Check Firebase Functions logs
2. Review analytics events
3. Check notification delivery status
4. Contact development team

## Related Documentation

- [Monetization System Overview](./MONETIZATION_SYSTEM_OVERVIEW.md)
- [Implementation Checklist](./IMPLEMENTATION_CHECKLIST.md)
- [Firebase Functions Documentation](https://firebase.google.com/docs/functions)

