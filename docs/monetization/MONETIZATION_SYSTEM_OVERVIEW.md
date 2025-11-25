# Monetization System Overview

## Introduction

This document provides a comprehensive overview of the monetization system implemented in the Atitia app. The system enables revenue generation through subscription plans and featured listings while maintaining a freemium model for property owners.

## Architecture

### 1. Subscription System

#### Collections
- **`owner_subscriptions`** - Stores owner subscription records

#### Data Models
- **`OwnerSubscriptionModel`** - Subscription details, tier, billing period, status
- **`SubscriptionPlanModel`** - Plan configuration with features and pricing
- **`SubscriptionTier`** - Enum: free, premium, enterprise
- **`SubscriptionStatus`** - Enum: active, expired, cancelled, pendingPayment, gracePeriod
- **`BillingPeriod`** - Enum: monthly, yearly

#### Features
- **Free Tier**: 1 PG maximum
- **Premium Tier**: Unlimited PGs, ₹499/month or ₹4990/year (~2 months free)
- **Enterprise Tier**: Unlimited PGs + dedicated support, ₹999/month or ₹9990/year

#### Repositories
- **`OwnerSubscriptionRepository`** - CRUD operations, active subscription queries, streaming

#### ViewModels
- **`OwnerSubscriptionViewModel`** - Manages subscription state, purchases, cancellations

#### UI Screens
- **`OwnerSubscriptionPlansScreen`** - View and select subscription plans
- **`OwnerSubscriptionManagementScreen`** - Manage current subscription, view history

### 2. Featured Listings System

#### Collections
- **`featured_listings`** - Stores featured PG listing records

#### Data Models
- **`FeaturedListingModel`** - Featured listing details, duration, status
- **`FeaturedListingStatus`** - Enum: active, expired, cancelled, pending

#### Pricing
- **1 Month**: ₹299
- **3 Months**: ₹799 (~₹266/month, save ₹98)
- **6 Months**: ₹1499 (~₹250/month, save ₹294)

#### Repositories
- **`FeaturedListingRepository`** - CRUD operations, active listings queries, streaming

#### ViewModels
- **`OwnerFeaturedListingViewModel`** - Manages featured listing purchases and management

#### UI Screens
- **`OwnerFeaturedListingPurchaseScreen`** - Purchase featured listing for a PG
- **`OwnerFeaturedListingManagementScreen`** - View and manage featured listings

#### Integration
- Featured PGs appear at the top of guest PG listings
- Featured badge displayed on PG cards
- Real-time sorting in guest dashboard

### 3. Revenue Tracking System

#### Collections
- **`revenue_records`** - Tracks all app revenue transactions

#### Data Models
- **`RevenueRecordModel`** - Revenue transaction details
- **`RevenueType`** - Enum: subscription, featuredListing
- **`PaymentStatus`** - Enum: pending, completed, failed, refunded

#### Repositories
- **`RevenueRepository`** - CRUD operations, revenue queries by owner/type

#### Features
- Automatic revenue record creation on successful payments
- Tracks both subscription and featured listing revenue
- Owner-specific revenue queries
- Admin revenue analytics

## Payment Integration

### Payment Service
- **`AppSubscriptionPaymentService`** - Handles Razorpay integration
- Supports subscription and featured listing payments
- Payment success/failure callbacks
- Automatic revenue record creation

### Configuration
- Razorpay key stored in Firebase Remote Config (`app_razorpay_key`)
- Fallback to environment config if Remote Config unavailable

## Security Rules

### Firestore Security Rules

#### Owner Subscriptions
```javascript
match /owner_subscriptions/{subscriptionId} {
  allow read: if isAuthenticated() && (
    resource.data.ownerId == request.auth.uid || isAdmin()
  );
  allow create: if isAuthenticated() && 
                   request.resource.data.ownerId == request.auth.uid;
  allow update: if isAuthenticated() && (
    resource.data.ownerId == request.auth.uid || isAdmin()
  );
}
```

#### Featured Listings
```javascript
match /featured_listings/{featuredListingId} {
  allow read: if isAuthenticated(); // All authenticated users can read
  allow create: if isAuthenticated() && 
                   request.resource.data.ownerId == request.auth.uid;
  allow update: if isAuthenticated() && (
    resource.data.ownerId == request.auth.uid || isAdmin()
  );
}
```

#### Revenue Records
```javascript
match /revenue_records/{revenueId} {
  allow read: if isAuthenticated() && (
    resource.data.ownerId == request.auth.uid || isAdmin()
  );
  allow list: if isAuthenticated() && isAdmin(); // Only admins can list all
  allow create: if isAuthenticated(); // Created by payment service
  allow update: if isAuthenticated() && isAdmin();
}
```

## Firestore Indexes

All queries use single-field filters, so no composite indexes are required:
- `owner_subscriptions`: Filtered by `ownerId` only
- `featured_listings`: Filtered by `ownerId`, `pgId`, or `status` (single fields)
- `revenue_records`: Filtered by `ownerId` or `type` (single fields)

Firestore automatically indexes single fields, so no additional indexes needed.

## Navigation

### Routes
- `/owner/subscription/plans` - Subscription plans screen
- `/owner/subscription/management` - Subscription management screen
- `/owner/featured/purchase` - Featured listing purchase screen
- `/owner/featured/management` - Featured listing management screen

### Navigation Service Methods
- `goToOwnerSubscriptionPlans()`
- `goToOwnerSubscriptionManagement()`
- `goToOwnerFeaturedListingPurchase()`
- `goToOwnerFeaturedListingManagement()`

### Drawer Menu Items
- "Subscription" - Opens subscription plans
- "Featured Listings" - Opens featured listing management

## Subscription Limits

### PG Creation Limits
- **Free Tier**: Maximum 1 PG
- **Premium/Enterprise**: Unlimited PGs (-1)

### Enforcement
- Check performed before creating new PG (not on edits or draft updates)
- Error dialog shown if limit reached
- Direct link to upgrade subscription plans

## Featured Listings Display

### Guest Dashboard Integration
- Featured PGs sorted to appear first in listings
- Featured badge with star icon and gradient styling
- Real-time updates when featured listings change

### Implementation
- `GuestPgViewModel` loads featured PG IDs on initialization
- Sorts filtered PGs list with featured first
- `GuestPgCard` displays featured badge conditionally

## Revenue Model

### Revenue Sources
1. **Subscription Revenue**: Monthly/yearly subscription fees
2. **Featured Listing Revenue**: One-time payments for featured listings

### Tax Considerations
- App-level payments handled by app
- Owners don't handle online payments (avoids Indian tax concerns)
- App income subject to personal income tax (until threshold)
- No GST registration required initially

## Analytics

### Events Tracked
- Subscription created/updated/cancelled
- Featured listing created/updated/cancelled
- Revenue record created
- Payment success/failure
- Subscription limit checks

## Error Handling

### Payment Errors
- Payment failure callbacks
- Retry mechanism for pending payments
- Clear error messages to users

### Subscription Errors
- Validation before purchase
- Subscription tier validation
- PG limit enforcement with clear messaging

## Future Enhancements

### Potential Additions
1. **Recurring Billing**: Automatic subscription renewals
2. **Payment Methods**: Additional payment gateways
3. **Discounts**: Promotional codes and discounts
4. **Revenue Analytics**: Admin dashboard for revenue tracking
5. **Trial Periods**: Free trial for premium features
6. **Usage-based Pricing**: Additional pricing models

## Testing Checklist

- [ ] Subscription plan purchase flow
- [ ] Subscription cancellation
- [ ] Featured listing purchase
- [ ] Featured listing cancellation
- [ ] Subscription tier limit enforcement
- [ ] Featured listings display in guest dashboard
- [ ] Payment success/failure handling
- [ ] Revenue record creation
- [ ] Navigation from drawer menu
- [ ] Security rules validation
- [ ] Real-time subscription updates
- [ ] Real-time featured listing updates

## Configuration Requirements

### Firebase Remote Config
- `app_razorpay_key` - Razorpay API key for app-level payments

### Firestore Collections
- `owner_subscriptions` - Already configured
- `featured_listings` - Already configured
- `revenue_records` - Already configured

### Security Rules
- All rules already configured in `config/firestore.rules`

## Support & Documentation

For questions or issues related to the monetization system:
1. Check this documentation
2. Review repository implementations
3. Check Firestore security rules
4. Verify Remote Config settings

## Version History

- **v1.0** (Current) - Initial monetization system implementation
  - Subscription plans (Free, Premium, Enterprise)
  - Featured listings
  - Revenue tracking
  - Payment integration (Razorpay)
  - Navigation integration
  - Security rules configuration

