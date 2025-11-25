# 💰 Firebase Cost Optimization Guide

**Project:** Atitia PG Management App  
**Current Budget:** ₹3000/month  
**Goal:** Minimize Firebase costs while maintaining functionality

---

## 📊 Understanding Firebase Pricing (Free Tier Limits)

### Free Tier Limits (Spark Plan)
- **Firestore:**
  - 50,000 reads/day
  - 20,000 writes/day
  - 20,000 deletes/day
  - 1 GB storage

- **Cloud Functions:**
  - 2 million invocations/month
  - 400,000 GB-seconds compute time
  - 200,000 GHz-seconds compute time

- **Cloud Storage:**
  - 5 GB storage
  - 1 GB/day downloads

- **Network:**
  - 10 GB/month egress

---

## 🎯 Cost-Saving Strategies

### 1. FIRESTORE OPTIMIZATION (Biggest Cost Impact)

#### ✅ Use Pagination Instead of Loading All Documents

**Problem:** Loading all subscriptions/bookings at once costs 1 read per document
**Solution:** Implement pagination (limit to 10-20 items per page)

```dart
// ❌ BAD: Loads all documents
final snapshot = await FirebaseFirestore.instance
    .collection('owner_subscriptions')
    .get(); // Costs: 1000 reads for 1000 documents

// ✅ GOOD: Paginated queries
final snapshot = await FirebaseFirestore.instance
    .collection('owner_subscriptions')
    .limit(20) // Only loads 20 documents
    .get(); // Costs: 20 reads
```

**Action Items:**
- ✅ Implement pagination in subscription lists
- ✅ Implement pagination in featured listings
- ✅ Implement pagination in refund requests
- ✅ Limit admin dashboard queries (use date filters)

#### ✅ Cache Data Locally

**Use Local Storage for Frequently Accessed Data:**

```dart
// Cache subscription plans (rarely changes)
final cachedPlans = await _localStorage.get('subscription_plans');
if (cachedPlans != null) {
  return cachedPlans; // No Firestore read
}
// Only fetch from Firestore if cache expired
```

**Action Items:**
- ✅ Cache subscription plans (they rarely change)
- ✅ Cache user profile data
- ✅ Cache PG property data (with timestamp)

#### ✅ Use Composite Indexes Efficiently

**Problem:** Multiple queries without indexes are expensive
**Solution:** Ensure all queries use indexes

**Already Configured:**
- ✅ `refund_requests` indexes
- ✅ Other composite indexes in `firestore.indexes.json`

**Action Items:**
- ✅ Monitor Firestore console for "missing index" warnings
- ✅ Add indexes as needed (they're free)

#### ✅ Batch Writes (Save Costs)

**Problem:** Each write costs 1 operation
**Solution:** Batch multiple writes into one operation

```dart
// ❌ BAD: Multiple individual writes (costs 3 writes)
await subscriptionRepo.update(sub1);
await subscriptionRepo.update(sub2);
await subscriptionRepo.update(sub3);

// ✅ GOOD: Batch write (costs 1 write)
final batch = FirebaseFirestore.instance.batch();
batch.update(sub1Ref, sub1Data);
batch.update(sub2Ref, sub2Data);
batch.update(sub3Ref, sub3Data);
await batch.commit(); // Costs: 1 write operation
```

**Action Items:**
- ✅ Use batch writes in refund processing
- ✅ Use batch writes when updating multiple subscriptions
- ✅ Use batch writes for bulk operations

#### ✅ Minimize Real-Time Listeners

**Problem:** Real-time listeners cost 1 read per document change
**Solution:** Use one-time fetches when real-time updates aren't needed

```dart
// ❌ BAD: Real-time listener (costs reads on every change)
FirebaseFirestore.instance
    .collection('subscriptions')
    .snapshots() // Listens to ALL changes

// ✅ GOOD: One-time fetch (costs reads only once)
FirebaseFirestore.instance
    .collection('subscriptions')
    .get(); // One-time read

// ✅ GOOD: Limited real-time listener
FirebaseFirestore.instance
    .collection('subscriptions')
    .where('ownerId', isEqualTo: userId)
    .limit(10) // Only listen to 10 documents
    .snapshots()
```

**Action Items:**
- ✅ Review all `.snapshots()` listeners
- ✅ Add `.limit()` to listeners when possible
- ✅ Use one-time fetches for static data
- ✅ Dispose listeners properly (prevent memory leaks)

#### ✅ Use Field-Level Queries (Project Only Needed Fields)

**Firestore doesn't support field projection, but:**
- ✅ Create separate collections for summary data
- ✅ Use Firestore subcollections for detailed data
- ✅ Keep frequently accessed data minimal

**Example:**
```dart
// Store summary data separately
// subscriptions_summary/{subscriptionId}
{
  "id": "...",
  "status": "active",
  "tier": "premium",
  "endDate": "..."
}
// Full data in: owner_subscriptions/{subscriptionId}
```

---

### 2. CLOUD FUNCTIONS OPTIMIZATION

#### ✅ Optimize Function Execution Time

**Current Function:** `checkSubscriptionRenewals`

**Optimizations:**
1. **Use Batch Queries:**
   ```typescript
   // Instead of multiple queries, combine them
   const subscriptions = await db
     .collection('owner_subscriptions')
     .where('status', 'in', ['active', 'gracePeriod'])
     .get();
   ```

2. **Process in Parallel:**
   ```typescript
   // Process multiple subscriptions in parallel
   await Promise.all(
     subscriptions.map(sub => processSubscription(sub))
   );
   ```

3. **Early Exit Conditions:**
   ```typescript
   // Exit early if no subscriptions to process
   if (subscriptions.empty) {
     return { success: true, processed: 0 };
   }
   ```

#### ✅ Set Function Timeout Appropriately

**Current:** Default timeout (540 seconds)
**Optimization:** Set shorter timeout for scheduled functions

```typescript
export const checkSubscriptionRenewals = onSchedule(
  {
    schedule: "0 9 * * *",
    timeZone: "UTC",
    timeoutSeconds: 60, // Reduce if function completes faster
  },
  async () => {
    // ...
  }
);
```

#### ✅ Use Function Memory Efficiently

**Current:** Default 256 MB
**Action:** Monitor and reduce if not needed

---

### 3. FIRESTORE SECURITY RULES OPTIMIZATION

#### ✅ Optimize Rule Evaluations

**Current Rules:** Well-structured ✅

**Tips:**
- ✅ Rules are evaluated for every query
- ✅ Use `exists()` checks efficiently
- ✅ Minimize nested rule checks

**Already Optimized:**
- ✅ Helper functions defined
- ✅ Early returns in rules

---

### 4. DATA STORAGE OPTIMIZATION

#### ✅ Delete Old/Unused Data

**Action Items:**
- ✅ Archive old refund requests (after 1 year)
- ✅ Delete expired subscriptions (after grace period)
- ✅ Clean up old revenue records (keep only last 2 years)

**Example:**
```dart
// Archive old refund requests
if (refundRequest.createdAt < oneYearAgo) {
  await archiveRefundRequest(refundRequest);
  await deleteRefundRequest(refundRequest.id);
}
```

#### ✅ Compress Image Storage

**Already Using:** Supabase Storage (more cost-effective) ✅

**Keep:**
- ✅ Use Supabase for images (not Firebase Storage)
- ✅ Compress images before upload
- ✅ Use thumbnail sizes for lists

#### ✅ Minimize Document Size

**Tips:**
- ✅ Store only necessary fields
- ✅ Use subcollections for large data
- ✅ Store URLs instead of base64 images

---

### 5. NETWORK OPTIMIZATION

#### ✅ Enable Firestore Caching

```dart
// Enable persistence
FirebaseFirestore.instance.settings = Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

#### ✅ Use Offline-First Approach

**Already Implemented:** Some offline capabilities ✅

**Enhance:**
- ✅ Cache frequently accessed data
- ✅ Sync only when online
- ✅ Batch offline writes

---

### 6. MONITORING & ALERTS

#### ✅ Set Up Usage Alerts

**Already Configured:** Budget alerts at 50%, 90%, 100% ✅

**Additional Monitoring:**
1. **Firestore Usage:**
   - Monitor daily reads/writes
   - Set alerts at 80% of free tier (40,000 reads/day)

2. **Cloud Functions:**
   - Monitor invocations
   - Set alert at 1.5M invocations/month (75% of free tier)

3. **Storage:**
   - Monitor storage growth
   - Set alert at 4 GB (80% of free tier)

#### ✅ Review Costs Weekly

**Check:**
- Firebase Console → Usage and billing
- Daily Firestore reads/writes
- Cloud Functions invocations
- Storage usage

---

## 📋 QUICK WINS (Implement First)

### Priority 1: High Impact (Do Immediately)

1. ✅ **Add Pagination to Lists**
   - Subscription lists
   - Featured listing lists
   - Refund request lists
   - **Savings:** 80-90% reduction in reads

2. ✅ **Review Real-Time Listeners**
   - Add `.limit()` to all listeners
   - Replace listeners with one-time fetches where real-time isn't needed
   - **Savings:** 50-70% reduction in reads

3. ✅ **Cache Static Data**
   - Subscription plans
   - User profiles
   - **Savings:** 60-80% reduction in reads

### Priority 2: Medium Impact (Do This Week)

4. ✅ **Implement Batch Writes**
   - Refund processing
   - Bulk subscription updates
   - **Savings:** 60-70% reduction in writes

5. ✅ **Optimize Cloud Function**
   - Batch queries
   - Parallel processing
   - **Savings:** 30-40% reduction in execution time

### Priority 3: Ongoing (Monitor Regularly)

6. ✅ **Clean Up Old Data**
   - Archive old refunds
   - Delete expired subscriptions
   - **Savings:** Reduced storage costs

7. ✅ **Monitor Usage Daily**
   - Check Firebase Console
   - Review expensive queries
   - **Savings:** Early problem detection

---

## 🎯 EXPECTED COST REDUCTIONS

### Before Optimization:
- Firestore reads: ~100,000/day (2x free tier)
- Estimated cost: ₹2,000-3,000/month

### After Optimization:
- Firestore reads: ~20,000-30,000/day (within free tier)
- Estimated cost: ₹0-500/month (mostly free tier)

**Potential Savings:** 80-90% cost reduction

---

## 📊 MONITORING DASHBOARD

### Key Metrics to Watch:

1. **Firestore:**
   - Daily reads: Target < 40,000/day
   - Daily writes: Target < 15,000/day
   - Storage: Target < 4 GB

2. **Cloud Functions:**
   - Monthly invocations: Target < 1.5M/month
   - Execution time: Monitor for spikes

3. **Network:**
   - Monthly egress: Target < 8 GB/month

---

## 🔧 IMPLEMENTATION CHECKLIST

### Week 1: Critical Optimizations
- [ ] Add pagination to all list screens
- [ ] Review and optimize real-time listeners
- [ ] Implement local caching for static data
- [ ] Set up usage monitoring alerts

### Week 2: Medium Optimizations
- [ ] Implement batch writes
- [ ] Optimize Cloud Function queries
- [ ] Review and optimize security rules

### Week 3: Cleanup
- [ ] Archive old data
- [ ] Clean up unused collections
- [ ] Document optimization patterns

---

## 💡 BEST PRACTICES

1. **Always use `.limit()` on queries**
2. **Cache data that rarely changes**
3. **Use batch operations for multiple writes**
4. **Monitor usage daily**
5. **Set up alerts early**
6. **Review expensive queries monthly**
7. **Archive instead of delete (for audit)**
8. **Use indexes for all queries**

---

## 🚨 RED FLAGS (Cost Spikes)

Watch out for:
- ❌ Queries without `.limit()`
- ❌ Real-time listeners without filters
- ❌ Loading all documents in a collection
- ❌ Not disposing listeners (memory leaks)
- ❌ Frequent full collection scans
- ❌ Missing composite indexes (causes expensive queries)

---

## 📞 QUICK REFERENCE

**Free Tier Limits:**
- Firestore: 50K reads/day, 20K writes/day
- Functions: 2M invocations/month
- Storage: 5 GB
- Network: 10 GB/month

**Cost Reduction Targets:**
- Firestore reads: < 40K/day (80% of free tier)
- Stay within free tier: ₹0/month
- Exceed free tier: Pay-as-you-go

**Monitoring:**
- Firebase Console: https://console.firebase.google.com/project/atitia-87925/usage
- Daily checks recommended

---

**Next Steps:**
1. ✅ Review current code for pagination opportunities
2. ✅ Implement caching for static data
3. ✅ Optimize real-time listeners
4. ✅ Set up usage monitoring

**Goal:** Stay within free tier limits (₹0/month costs) while maintaining full functionality.

