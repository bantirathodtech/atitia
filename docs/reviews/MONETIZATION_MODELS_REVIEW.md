# 📊 Monetization Models - Review & Testing Guide

## ✅ Completed Implementation

### 1. **Data Models Created**

#### **SubscriptionPlanModel** (`lib/core/models/subscription/subscription_plan_model.dart`)
- **Purpose**: Defines subscription plan tiers with pricing and features
- **Tiers**: Free, Premium, Enterprise
- **Key Features**:
  - Enum `SubscriptionTier` with display names
  - Predefined plans with pricing (Free: ₹0, Premium: ₹499/month, Enterprise: ₹999/month)
  - Feature lists per tier
  - Max PG limits (Free: 1, Premium/Enterprise: Unlimited)
  - Yearly pricing with savings calculation
  - Helper methods: `canAddPG()`, `formattedMonthlyPrice`, `formattedYearlyPrice`

#### **OwnerSubscriptionModel** (`lib/core/models/subscription/owner_subscription_model.dart`)
- **Purpose**: Tracks owner subscription details and status
- **Key Fields**:
  - `subscriptionId`, `ownerId`, `tier`, `status`
  - `billingPeriod` (monthly/yearly)
  - `startDate`, `endDate`, `nextBillingDate`
  - `amountPaid`, `paymentId`, `orderId`
  - `autoRenew`, `cancelledAt`, `cancellationReason`
- **Status Enum**: `active`, `expired`, `cancelled`, `pendingPayment`, `gracePeriod`
- **Helper Methods**:
  - `isActive` - Check if subscription is currently active
  - `isExpired` - Check if subscription has expired
  - `isInGracePeriod` - Check if in 7-day grace period
  - `daysUntilExpiry` - Days remaining
  - `canRenew`, `canCancel` - Action permissions

#### **FeaturedListingModel** (`lib/core/models/featured/featured_listing_model.dart`)
- **Purpose**: Tracks featured PG listings with duration and payment
- **Key Fields**:
  - `featuredListingId`, `pgId`, `ownerId`
  - `status` (active, expired, cancelled, pending)
  - `startDate`, `endDate`, `durationMonths`
  - `amountPaid`, `paymentId`, `orderId`
- **Pricing**:
  - 1 Month: ₹299
  - 3 Months: ₹799 (~₹266/month, save ₹98)
  - 6 Months: ₹1499 (~₹250/month, save ₹294)
- **Helper Methods**:
  - `isActive` - Check if currently featured
  - `daysUntilExpiry` - Days remaining
  - `getPriceForDuration()` - Static pricing lookup

#### **RevenueRecordModel** (`lib/core/models/revenue/revenue_record_model.dart`)
- **Purpose**: Tracks all app revenue (subscriptions, featured listings)
- **Key Fields**:
  - `revenueId`, `type`, `ownerId`, `amount`
  - `status` (pending, completed, failed, refunded)
  - `paymentId`, `orderId`
  - `subscriptionId`, `featuredListingId` (if applicable)
  - `paymentDate`
- **Revenue Types**: `subscription`, `featuredListing`, `successFee` (future)
- **Helper Methods**:
  - `isCompleted`, `isPending`, `isFailed`
  - `formattedAmount` - Formatted currency
  - `monthYear`, `year` - Grouping helpers

### 2. **Updated Existing Models**

#### **OwnerProfileModel** (`lib/feature/owner_dashboard/profile/data/models/owner_profile_model.dart`)
- **Added Fields**:
  - `subscriptionTier` (String?) - 'free', 'premium', 'enterprise'
  - `subscriptionStatus` (String?) - 'active', 'expired', etc.
  - `subscriptionEndDate` (DateTime?) - When subscription expires
- **New Helper Methods**:
  - `hasActiveSubscription` - Check if subscription is active
  - `hasPremiumSubscription` - Check if premium/enterprise
  - `canAddPG(int currentPGCount)` - Check if can add more PGs

#### **GuestPgModel** (`lib/feature/guest_dashboard/pgs/data/models/guest_pg_model.dart`)
- **Added Fields**:
  - `isFeatured` (bool) - Whether PG is currently featured
  - `featuredUntil` (DateTime?) - Date until which PG is featured
- **New Helper Method**:
  - `isCurrentlyFeatured` - Check if featured and not expired

### 3. **Firestore Constants Updated**

#### **New Collections** (`lib/common/utils/constants/firestore.dart`)
- `ownerSubscriptions` - Subscription records
- `featuredListings` - Featured listing records
- `revenueRecords` - Revenue tracking

---

## 🧪 Testing Checklist

### **Unit Testing**

#### **SubscriptionPlanModel Tests**
- [ ] Test all three tiers (Free, Premium, Enterprise)
- [ ] Test `canAddPG()` with different PG counts
- [ ] Test pricing formatting (monthly/yearly)
- [ ] Test yearly savings calculation
- [ ] Test `getPlanByTier()` and `getPlanById()`

#### **OwnerSubscriptionModel Tests**
- [ ] Test status checks (`isActive`, `isExpired`, `isInGracePeriod`)
- [ ] Test `daysUntilExpiry` calculation
- [ ] Test `canRenew` and `canCancel` logic
- [ ] Test Firestore serialization/deserialization
- [ ] Test date handling (startDate, endDate, nextBillingDate)

#### **FeaturedListingModel Tests**
- [ ] Test pricing for all durations (1, 3, 6 months)
- [ ] Test `isActive` and `isExpired` checks
- [ ] Test `daysUntilExpiry` calculation
- [ ] Test Firestore serialization/deserialization

#### **RevenueRecordModel Tests**
- [ ] Test all revenue types
- [ ] Test all payment statuses
- [ ] Test `monthYear` and `year` grouping
- [ ] Test Firestore serialization/deserialization

#### **OwnerProfileModel Updates Tests**
- [ ] Test subscription helper methods
- [ ] Test `canAddPG()` with different tiers
- [ ] Test Firestore serialization with new fields

#### **GuestPgModel Updates Tests**
- [ ] Test `isCurrentlyFeatured` logic
- [ ] Test Firestore serialization with new fields

---

## 📝 Manual Testing Steps

### **1. Model Instantiation**
```dart
// Test SubscriptionPlanModel
final freePlan = SubscriptionPlanModel.freePlan;
print(freePlan.maxPGs); // Should be 1
print(freePlan.canAddPG(0)); // Should be true
print(freePlan.canAddPG(1)); // Should be false

// Test OwnerSubscriptionModel
final subscription = OwnerSubscriptionModel(
  subscriptionId: 'sub_123',
  ownerId: 'owner_123',
  tier: SubscriptionTier.premium,
  status: SubscriptionStatus.active,
  billingPeriod: BillingPeriod.monthly,
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 30)),
);
print(subscription.isActive); // Should be true
print(subscription.daysUntilExpiry); // Should be 30

// Test FeaturedListingModel
final featured = FeaturedListingModel(
  featuredListingId: 'feat_123',
  pgId: 'pg_123',
  ownerId: 'owner_123',
  status: FeaturedListingStatus.active,
  startDate: DateTime.now(),
  endDate: DateTime.now().add(Duration(days: 30)),
  durationMonths: 1,
);
print(featured.isActive); // Should be true
print(FeaturedListingModel.getPriceForDuration(1)); // Should be 299.0

// Test RevenueRecordModel
final revenue = RevenueRecordModel(
  revenueId: 'rev_123',
  type: RevenueType.subscription,
  ownerId: 'owner_123',
  amount: 499.0,
  status: PaymentStatus.completed,
  paymentDate: DateTime.now(),
  subscriptionId: 'sub_123',
);
print(revenue.isCompleted); // Should be true
print(revenue.formattedAmount); // Should be '₹499.00'
```

### **2. Firestore Serialization**
```dart
// Test toMap() and fromMap()
final subscription = OwnerSubscriptionModel(...);
final map = subscription.toMap();
final restored = OwnerSubscriptionModel.fromMap(map);
assert(subscription.subscriptionId == restored.subscriptionId);
```

### **3. Integration with Existing Models**
```dart
// Test OwnerProfile with subscription fields
final profile = OwnerProfile(
  ownerId: 'owner_123',
  // ... other fields
  subscriptionTier: 'premium',
  subscriptionStatus: 'active',
  subscriptionEndDate: DateTime.now().add(Duration(days: 30)),
);
print(profile.hasActiveSubscription); // Should be true
print(profile.canAddPG(0)); // Should be true (premium allows unlimited)

// Test GuestPgModel with featured fields
final pg = GuestPgModel(
  pgId: 'pg_123',
  // ... other fields
  isFeatured: true,
  featuredUntil: DateTime.now().add(Duration(days: 30)),
);
print(pg.isCurrentlyFeatured); // Should be true
```

---

## 🔍 Code Review Points

### **✅ What Looks Good**
1. **Consistent Patterns**: All models follow the same structure as existing models
2. **Type Safety**: Proper use of enums and null-safety
3. **Helper Methods**: Useful business logic methods added
4. **Documentation**: Clear comments and documentation
5. **Error Handling**: Proper date handling and null checks
6. **Firestore Integration**: Proper use of `DateServiceConverter` for dates

### **⚠️ Things to Verify**
1. **Default Values**: Ensure default tier is `free` for new owners
2. **Migration**: Existing owners should default to `free` tier
3. **Date Handling**: Test timezone handling for subscription dates
4. **Enum Values**: Verify enum string values match Firestore expectations

### **💡 Potential Improvements**
1. **Validation**: Add validation for subscription amounts and dates
2. **Constants**: Consider extracting pricing constants to a config file
3. **Helper Extensions**: Add extension methods for common checks
4. **Tests**: Add comprehensive unit tests for all models

---

## 📋 Next Steps (After Review)

1. **Create Repositories**
   - `OwnerSubscriptionRepository`
   - `FeaturedListingRepository`
   - `RevenueRepository`

2. **Create Services**
   - `AppSubscriptionPaymentService` (for app's Razorpay account)
   - `SubscriptionManagementService`

3. **Create ViewModels**
   - `OwnerSubscriptionViewModel`

4. **Create UI Screens**
   - Subscription management screen
   - Plan comparison screen
   - Featured listing management screen

5. **Firestore Rules**
   - Add security rules for new collections
   - Ensure proper access control

6. **Integration Testing**
   - Test subscription lifecycle (create, renew, cancel)
   - Test featured listing lifecycle
   - Test payment flows

---

## 🚀 Quick Start Testing

Run these commands to verify compilation:

```bash
# Check all monetization models
flutter analyze lib/core/models/subscription lib/core/models/featured lib/core/models/revenue

# Check updated models
flutter analyze lib/feature/owner_dashboard/profile/data/models/owner_profile_model.dart
flutter analyze lib/feature/guest_dashboard/pgs/data/models/guest_pg_model.dart

# Run all tests
flutter test
```

---

## 📚 Related Files

- **Models**: All in `lib/core/models/` subdirectories
- **Constants**: `lib/common/utils/constants/firestore.dart`
- **Updated Models**: OwnerProfile, GuestPgModel

---

**Status**: ✅ Models created and ready for review/testing  
**Next**: Create repositories and services after review approval

