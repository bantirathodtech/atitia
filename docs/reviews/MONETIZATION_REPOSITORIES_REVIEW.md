# 📦 Monetization Repositories - Review & Testing Guide

## ✅ Completed Implementation

### 1. **OwnerSubscriptionRepository** (`lib/core/repositories/subscription/owner_subscription_repository.dart`)

#### **Core CRUD Operations**
- ✅ `createSubscription()` - Create new subscription with analytics
- ✅ `updateSubscription()` - Update existing subscription
- ✅ `getSubscription()` - Get subscription by ID
- ✅ `getActiveSubscription()` - Get active subscription for owner

#### **Streaming Operations**
- ✅ `streamSubscription()` - Real-time subscription updates for owner
- ✅ `streamAllSubscriptions()` - Stream all subscriptions for owner (history)

#### **Query Operations**
- ✅ `getAllSubscriptions()` - Get all subscriptions for owner
- ✅ `getExpiringSubscriptions()` - Get subscriptions expiring soon (default: 7 days)
- ✅ `getExpiredSubscriptions()` - Get expired subscriptions for auto-downgrade

#### **Business Logic**
- ✅ `cancelSubscription()` - Cancel subscription with reason tracking
- ✅ Authorization check (owner must own subscription)
- ✅ Auto-updates status to cancelled
- ✅ Sets autoRenew to false
- ✅ Analytics logging for cancellations

#### **Key Features**
- Dependency injection via `UnifiedServiceLocator`
- Real-time Firestore streams
- Comprehensive error handling
- Analytics event logging
- Null-safe date comparisons for sorting

---

### 2. **FeaturedListingRepository** (`lib/core/repositories/featured/featured_listing_repository.dart`)

#### **Core CRUD Operations**
- ✅ `createFeaturedListing()` - Create new featured listing with analytics
- ✅ `updateFeaturedListing()` - Update existing featured listing
- ✅ `getFeaturedListing()` - Get featured listing by ID
- ✅ `getActiveFeaturedListing()` - Get active featured listing for PG

#### **Query Operations**
- ✅ `isPGFeatured()` - Check if PG is currently featured
- ✅ `getActiveFeaturedPGIds()` - Get all active featured PG IDs (for filtering)
- ✅ `getExpiringFeaturedListings()` - Get listings expiring soon
- ✅ `getExpiredFeaturedListings()` - Get expired listings for cleanup

#### **Streaming Operations**
- ✅ `streamFeaturedListing()` - Real-time featured listing updates for PG
- ✅ `streamOwnerFeaturedListings()` - Stream all featured listings for owner
- ✅ `streamActiveFeaturedListings()` - Stream all active featured listings (for guest app)

#### **Business Logic**
- ✅ `cancelFeaturedListing()` - Cancel featured listing
- ✅ Authorization check (owner must own listing)
- ✅ Analytics logging

#### **Key Features**
- Optimized queries for active listings
- Real-time updates for guest app display
- Expiry tracking for automatic deactivation

---

### 3. **RevenueRepository** (`lib/core/repositories/revenue/revenue_repository.dart`)

#### **Core CRUD Operations**
- ✅ `createRevenueRecord()` - Create new revenue record with analytics
- ✅ `updateRevenueRecord()` - Update existing revenue record
- ✅ `getRevenueRecord()` - Get revenue record by ID

#### **Query Operations**
- ✅ `getOwnerRevenue()` - Get all revenue records for owner
- ✅ `getCompletedRevenue()` - Get completed revenue for owner
- ✅ `getRevenueByType()` - Get revenue by type (subscription/featured listing)
- ✅ `getPendingRevenue()` - Get pending revenue records

#### **Analytics & Reporting**
- ✅ `getTotalRevenue()` - Total revenue across all owners
- ✅ `getMonthlyRevenue(year, month)` - Revenue for specific month
- ✅ `getYearlyRevenue(year)` - Revenue for specific year
- ✅ `getRevenueBreakdownByType()` - Breakdown by subscription/featured/success fee
- ✅ `getMonthlyRevenueBreakdown()` - Monthly breakdown for charts

#### **Streaming Operations**
- ✅ `streamOwnerRevenue()` - Real-time revenue updates for owner
- ✅ `streamAllRevenue()` - Stream all revenue (for admin dashboard)

#### **Key Features**
- Comprehensive revenue analytics
- Time-based filtering (monthly, yearly)
- Type-based breakdown for insights
- Optimized for admin dashboard queries

---

## 🧪 Testing Checklist

### **Unit Testing**

#### **OwnerSubscriptionRepository Tests**
- [ ] Test `createSubscription()` - Verify document creation and analytics
- [ ] Test `updateSubscription()` - Verify update and analytics
- [ ] Test `getSubscription()` - Verify retrieval by ID
- [ ] Test `getActiveSubscription()` - Verify active subscription query
- [ ] Test `streamSubscription()` - Verify real-time stream updates
- [ ] Test `cancelSubscription()` - Verify cancellation logic
- [ ] Test `getExpiringSubscriptions()` - Verify expiry date filtering
- [ ] Test `getExpiredSubscriptions()` - Verify expired subscription detection
- [ ] Test authorization checks in `cancelSubscription()`
- [ ] Test error handling for missing subscriptions

#### **FeaturedListingRepository Tests**
- [ ] Test `createFeaturedListing()` - Verify creation and analytics
- [ ] Test `getActiveFeaturedListing()` - Verify active listing query
- [ ] Test `isPGFeatured()` - Verify featured status check
- [ ] Test `streamActiveFeaturedListings()` - Verify stream for guest app
- [ ] Test `getActiveFeaturedPGIds()` - Verify ID list generation
- [ ] Test `cancelFeaturedListing()` - Verify cancellation
- [ ] Test `getExpiringFeaturedListings()` - Verify expiry tracking
- [ ] Test authorization checks
- [ ] Test multiple listings per PG (only one active)

#### **RevenueRepository Tests**
- [ ] Test `createRevenueRecord()` - Verify creation and analytics
- [ ] Test `getTotalRevenue()` - Verify sum calculation
- [ ] Test `getMonthlyRevenue()` - Verify month filtering
- [ ] Test `getYearlyRevenue()` - Verify year filtering
- [ ] Test `getRevenueBreakdownByType()` - Verify type aggregation
- [ ] Test `getMonthlyRevenueBreakdown()` - Verify monthly aggregation
- [ ] Test `getOwnerRevenue()` - Verify owner filtering
- [ ] Test `getCompletedRevenue()` - Verify status filtering
- [ ] Test `getPendingRevenue()` - Verify pending status

---

## 📝 Manual Testing Steps

### **1. Subscription Repository Testing**

```dart
// Initialize repository
final subscriptionRepo = OwnerSubscriptionRepository();

// Create subscription
final subscription = OwnerSubscriptionModel(
  subscriptionId: 'sub_test_${DateTime.now().millisecondsSinceEpoch}',
  ownerId: 'owner_test_123',
  tier: SubscriptionTier.premium,
  status: SubscriptionStatus.active,
  billingPeriod: BillingPeriod.monthly,
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 30)),
  amountPaid: 499.0,
  paymentId: 'pay_test_123',
  orderId: 'order_test_123',
);

final subId = await subscriptionRepo.createSubscription(subscription);
print('Created subscription: $subId');

// Get active subscription
final activeSub = await subscriptionRepo.getActiveSubscription('owner_test_123');
print('Active subscription: ${activeSub?.tier}');

// Stream subscription
subscriptionRepo.streamSubscription('owner_test_123').listen((sub) {
  print('Subscription updated: ${sub?.status}');
});

// Cancel subscription
await subscriptionRepo.cancelSubscription(
  subscriptionId: subId,
  ownerId: 'owner_test_123',
  reason: 'Testing cancellation',
);

// Get expiring subscriptions
final expiring = await subscriptionRepo.getExpiringSubscriptions(daysBeforeExpiry: 7);
print('Expiring subscriptions: ${expiring.length}');
```

### **2. Featured Listing Repository Testing**

```dart
// Initialize repository
final featuredRepo = FeaturedListingRepository();

// Create featured listing
final featured = FeaturedListingModel(
  featuredListingId: 'feat_test_${DateTime.now().millisecondsSinceEpoch}',
  pgId: 'pg_test_123',
  ownerId: 'owner_test_123',
  status: FeaturedListingStatus.active,
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 30)),
  durationMonths: 1,
  amountPaid: 299.0,
  paymentId: 'pay_test_123',
  orderId: 'order_test_123',
);

final featId = await featuredRepo.createFeaturedListing(featured);
print('Created featured listing: $featId');

// Check if PG is featured
final isFeatured = await featuredRepo.isPGFeatured('pg_test_123');
print('PG is featured: $isFeatured');

// Get active featured listings (for guest app)
featuredRepo.streamActiveFeaturedListings().listen((listings) {
  print('Active featured listings: ${listings.length}');
});

// Get active featured PG IDs
final featuredPGIds = await featuredRepo.getActiveFeaturedPGIds();
print('Featured PG IDs: $featuredPGIds');

// Cancel featured listing
await featuredRepo.cancelFeaturedListing(
  featuredListingId: featId,
  ownerId: 'owner_test_123',
);
```

### **3. Revenue Repository Testing**

```dart
// Initialize repository
final revenueRepo = RevenueRepository();

// Create revenue record
final revenue = RevenueRecordModel(
  revenueId: 'rev_test_${DateTime.now().millisecondsSinceEpoch}',
  type: RevenueType.subscription,
  ownerId: 'owner_test_123',
  amount: 499.0,
  status: PaymentStatus.completed,
  paymentDate: DateTime.now(),
  subscriptionId: 'sub_test_123',
  paymentId: 'pay_test_123',
  orderId: 'order_test_123',
);

final revId = await revenueRepo.createRevenueRecord(revenue);
print('Created revenue record: $revId');

// Get total revenue
final totalRevenue = await revenueRepo.getTotalRevenue();
print('Total revenue: ₹$totalRevenue');

// Get monthly revenue
final monthlyRevenue = await revenueRepo.getMonthlyRevenue(2025, 1);
print('January 2025 revenue: ₹$monthlyRevenue');

// Get yearly revenue
final yearlyRevenue = await revenueRepo.getYearlyRevenue(2025);
print('2025 revenue: ₹$yearlyRevenue');

// Get revenue breakdown by type
final breakdown = await revenueRepo.getRevenueBreakdownByType();
breakdown.forEach((type, amount) {
  print('$type: ₹$amount');
});

// Get monthly revenue breakdown (for charts)
final monthlyBreakdown = await revenueRepo.getMonthlyRevenueBreakdown();
monthlyBreakdown.forEach((monthYear, amount) {
  print('$monthYear: ₹$amount');
});

// Stream owner revenue
revenueRepo.streamOwnerRevenue('owner_test_123').listen((revenues) {
  print('Owner revenue records: ${revenues.length}');
});
```

---

## 🔍 Code Review Points

### **✅ What Looks Good**

1. **Consistent Patterns**
   - All repositories follow the same structure
   - Similar error handling patterns
   - Consistent analytics logging

2. **Dependency Injection**
   - Proper use of `UnifiedServiceLocator`
   - Services can be injected for testing
   - Fallback to default services

3. **Real-time Updates**
   - Comprehensive stream support
   - Real-time subscriptions for UI updates
   - Optimized queries

4. **Error Handling**
   - Try-catch blocks in all operations
   - Meaningful error messages
   - Proper exception propagation

5. **Analytics Integration**
   - All critical operations logged
   - Useful parameters captured
   - Consistent event naming

6. **Query Optimization**
   - Efficient Firestore queries
   - Proper use of filters
   - Minimal data fetching

### **⚠️ Things to Verify**

1. **Date Handling**
   - Verify timezone handling in expiry queries
   - Test date comparisons across timezones
   - Ensure proper date serialization

2. **Concurrency**
   - Test multiple simultaneous subscriptions
   - Verify stream subscriptions don't leak
   - Check for race conditions in status updates

3. **Edge Cases**
   - What happens if subscription expires while querying?
   - Multiple active subscriptions (shouldn't happen, but verify)
   - Missing documents in streams

4. **Performance**
   - Test with large datasets
   - Verify query performance with indexes
   - Check stream efficiency

5. **Authorization**
   - Verify all authorization checks work
   - Test unauthorized access attempts
   - Check owner ID validation

### **💡 Potential Improvements**

1. **Caching**
   - Consider caching active subscriptions
   - Cache featured PG IDs for better performance
   - Invalidate cache on updates

2. **Batch Operations**
   - Add batch update for expired subscriptions
   - Batch create for multiple featured listings
   - Bulk status updates

3. **Pagination**
   - Add pagination for revenue queries
   - Limit stream results
   - Cursor-based pagination for large datasets

4. **Validation**
   - Add input validation before Firestore operations
   - Validate subscription dates (endDate > startDate)
   - Verify amounts are positive

5. **Transactions**
   - Use Firestore transactions for critical operations
   - Ensure atomic subscription updates
   - Prevent race conditions

---

## 🔗 Integration Points

### **Dependencies**
- ✅ Uses `IDatabaseService` interface
- ✅ Uses `IAnalyticsService` interface
- ✅ Uses `FirestoreConstants` for collection names
- ✅ Uses model classes from `lib/core/models/`

### **Used By (Future)**
- ViewModels (subscription, featured listing management)
- Services (payment processing, subscription management)
- UI screens (subscription management, revenue dashboard)

---

## 📋 Next Steps (After Review)

1. **Create Services**
   - `AppSubscriptionPaymentService` - Handle Razorpay payments
   - `SubscriptionManagementService` - Business logic for subscriptions
   - `FeaturedListingService` - Business logic for featured listings

2. **Create ViewModels**
   - `OwnerSubscriptionViewModel` - Subscription state management
   - `FeaturedListingViewModel` - Featured listing state management

3. **Firestore Indexes**
   - Create indexes for common queries
   - Index on `ownerId` + `status` for subscriptions
   - Index on `status` + `endDate` for expiry queries
   - Index on `type` + `status` for revenue queries

4. **Security Rules** ✅ **COMPLETED**
   - ✅ Added Firestore security rules for all new collections
   - ✅ Owners can only access their own subscriptions
   - ✅ Featured listings: owners create/manage, all can read (for guest app)
   - ✅ Revenue records: owners can read their own, admins can manage all
   - Rules added to `config/firestore.rules`

5. **Testing**
   - Write comprehensive unit tests
   - Integration tests for critical flows
   - Mock services for testing

---

## 🚀 Quick Start Testing

Run these commands to verify compilation:

```bash
# Check all repositories
flutter analyze lib/core/repositories/subscription lib/core/repositories/featured lib/core/repositories/revenue

# Run tests (after creating test files)
flutter test test/repositories/

# Check for any unused imports or code
dart analyze lib/core/repositories/
```

---

## 📚 Related Files

- **Repositories**: All in `lib/core/repositories/` subdirectories
- **Models**: `lib/core/models/subscription/`, `featured/`, `revenue/`
- **Constants**: `lib/common/utils/constants/firestore.dart`
- **Interfaces**: `lib/core/interfaces/database/`, `analytics/`

---

## 🎯 Repository Comparison

| Feature | Subscription | Featured Listing | Revenue |
|---------|-------------|------------------|---------|
| CRUD Operations | ✅ | ✅ | ✅ |
| Real-time Streams | ✅ | ✅ | ✅ |
| Analytics Queries | ✅ | ✅ | ✅ |
| Expiry Tracking | ✅ | ✅ | ❌ |
| Authorization | ✅ | ✅ | ❌ (Admin) |
| Complex Aggregations | ❌ | ❌ | ✅ |

---

**Status**: ✅ Repositories created and ready for review/testing  
**Next**: Create services and ViewModels after review approval

