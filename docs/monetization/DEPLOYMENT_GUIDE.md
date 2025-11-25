# Cloud Functions Deployment Guide

## Prerequisites

✅ **Completed:**
- Node.js v24.9.0 installed
- npm 11.6.0 installed
- Firebase CLI v14.17.0 installed
- Dependencies installed in `functions/` directory
- TypeScript code compiled successfully
- Root-level `firebase.json` created
- `.firebaserc` configured with project ID: `atitia-87925`

## Deployment Steps

### 1. Verify Firebase Project

```bash
# Check current Firebase project
firebase use

# Should show: Using atitia-87925 (default)
```

### 2. Deploy Cloud Functions

From the project root directory:

```bash
# Deploy all functions
firebase deploy --only functions

# Or deploy specific function
firebase deploy --only functions:checkSubscriptionRenewals
```

### 3. Verify Deployment

After deployment, verify in Firebase Console:

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: **atitia-87925**
3. Navigate to **Functions** section
4. Verify `checkSubscriptionRenewals` function is listed
5. Check the schedule shows: **Daily at 9:00 AM UTC**

### 4. Test the Function

#### Option 1: Manual Trigger (Firebase Console)
1. Go to Functions in Firebase Console
2. Click on `checkSubscriptionRenewals`
3. Click **"Trigger"** button to test manually
4. Check logs for execution results

#### Option 2: Check Logs
```bash
# View recent logs
firebase functions:log

# View logs for specific function
firebase functions:log --only checkSubscriptionRenewals
```

## Expected Output

After successful deployment, you should see:

```
✔  functions[checkSubscriptionRenewals(us-central1)] Successful update operation.

✔  Deploy complete!
```

## Post-Deployment Verification

### 1. Check Function Status

In Firebase Console → Functions:
- Function name: `checkSubscriptionRenewals`
- Status: **Active**
- Trigger: **Cloud Pub/Sub**
- Schedule: `0 9 * * *` (Daily at 9:00 AM UTC)
- Region: `us-central1` (default)

### 2. Test Subscription Renewal Flow

1. **Create a test subscription:**
   - Create an owner subscription in Firestore
   - Set `endDate` to tomorrow (for testing)
   - Set `status` to `"active"`

2. **Manually trigger function:**
   - Use Firebase Console or wait for scheduled run
   - Check for notifications in `notifications` collection
   - Verify subscription status updates

3. **Check logs:**
   ```bash
   firebase functions:log --only checkSubscriptionRenewals
   ```

### 3. Monitor Execution

The function will automatically run daily at 9:00 AM UTC. To monitor:

1. **Firebase Console:**
   - Functions → checkSubscriptionRenewals → Logs

2. **CLI:**
   ```bash
   firebase functions:log --only checkSubscriptionRenewals --limit 50
   ```

3. **Analytics:**
   - Check Firebase Analytics for events:
     - `subscription_renewal_check_started`
     - `subscription_renewal_check_completed`
     - `subscription_renewal_reminder_sent`
     - etc.

## Troubleshooting

### Deployment Fails

**Error: "Functions directory not found"**
- Ensure `functions/` directory exists in project root
- Check `firebase.json` has correct `source` path

**Error: "Build failed"**
- Run `npm run build` in `functions/` directory manually
- Check TypeScript errors
- Verify all dependencies are installed

**Error: "Permission denied"**
- Ensure you're logged into Firebase CLI: `firebase login`
- Verify you have permissions for project `atitia-87925`

### Function Not Running

**Schedule not working:**
- Check function schedule in Firebase Console
- Verify timezone is set to UTC
- Check Cloud Scheduler in Google Cloud Console

**Function errors:**
- Check logs in Firebase Console
- Verify Firestore security rules allow function access
- Check function has proper IAM permissions

### Notifications Not Sent

**Notifications not appearing:**
- Check `notifications` collection in Firestore
- Verify owner profile exists
- Check notification type matches expected format

**Notification delivery issues:**
- Verify app notification settings
- Check FCM configuration
- Review notification payload format

## Configuration Updates

### Change Schedule

Edit `functions/src/index.ts`:
```typescript
.schedule("0 9 * * *") // Change cron expression
```

Then redeploy:
```bash
firebase deploy --only functions:checkSubscriptionRenewals
```

### Change Grace Period

Edit `functions/src/index.ts`:
```typescript
const GRACE_PERIOD_DAYS = 7; // Change days
```

Then rebuild and redeploy:
```bash
cd functions
npm run build
cd ..
firebase deploy --only functions:checkSubscriptionRenewals
```

### Change Reminder Intervals

Edit `functions/src/index.ts`:
```typescript
const REMINDER_DAYS = [7, 3, 1]; // Modify array
```

Then rebuild and redeploy.

## Security

### Firestore Security Rules

Ensure your Firestore rules allow the Cloud Function to:
- Read from `owner_subscriptions` collection
- Write to `owner_subscriptions` collection
- Read from `users` collection
- Write to `users` collection
- Write to `notifications` collection

### IAM Permissions

The Cloud Function needs these permissions:
- Firestore: Read/Write access
- Cloud Scheduler: Execute scheduled jobs
- Cloud Logging: Write logs

These are typically granted automatically when deploying via Firebase CLI.

## Cost Considerations

### Cloud Functions Pricing

- **Invocation:** Free tier: 2 million invocations/month
- **Compute time:** Pay per GB-second (free tier: 400,000 GB-seconds/month)
- **Network egress:** Pay per GB (free tier: 5 GB/month)

### Estimated Costs

For subscription renewal automation:
- **1 execution/day** = ~30 executions/month
- **Duration:** ~2-5 seconds per execution
- **Memory:** 256MB (default)

**Estimated monthly cost:** $0.00 (within free tier)

For more details, see [Firebase Functions Pricing](https://firebase.google.com/pricing)

## Rollback

If you need to rollback:

1. **Disable function:**
   ```bash
   firebase functions:delete checkSubscriptionRenewals
   ```

2. **Redeploy previous version:**
   - Checkout previous Git commit
   - Redeploy function

3. **Or manually disable:**
   - Firebase Console → Functions
   - Click function → Disable

## Support

For issues:
1. Check Firebase Functions logs
2. Review [SUBSCRIPTION_RENEWAL_AUTOMATION.md](./SUBSCRIPTION_RENEWAL_AUTOMATION.md)
3. Check Firestore security rules
4. Verify IAM permissions
5. Contact development team

## Next Steps

After successful deployment:
1. ✅ Monitor first scheduled execution
2. ✅ Verify notifications are sent
3. ✅ Test grace period transition
4. ✅ Test auto-downgrade
5. ✅ Review analytics events
6. ✅ Set up alerts for errors

