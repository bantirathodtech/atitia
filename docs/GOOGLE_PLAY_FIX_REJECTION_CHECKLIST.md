# Google Play Rejection Fix Checklist

## Issue: App Rejected - Organization Account Required

**Problem**: Google Play requires an organization account because the app was flagged as a financial services app.

**Root Cause**: The app category or content declarations incorrectly mark this as a financial services app.

---

## ✅ Action Items

### 1. Update App Category

**Current Issue**: May be set to "Finance" category  
**Fix**: Change to appropriate category

**Steps**:
1. Go to **Play Console** → **Store presence** → **Store settings**
2. Find **App category**
3. Change from:
   - ❌ **Finance** or **Business & Finance**
4. Change to:
   - ✅ **Travel & Local** (RECOMMENDED)
   - OR ✅ **Business** (Alternative)

**Reason**: The app is an accommodation/booking platform, not a financial services app.

---

### 2. Update Content Declarations

**Location**: **Play Console** → **Store presence** → **App content**

#### A. Target Audience & Content
- ✅ Ensure **"Children and families"** is NOT selected (unless your app specifically targets children)
- ✅ Set to **"Everyone"** or appropriate age group

#### B. App Access
- ❌ Remove any mentions of **"Financial services"**, **"Banking"**, **"Loans"**, **"Investment"**
- ✅ Keep **"Users can make purchases"** if you process payments
- ✅ Mark as **"Rental/Booking platform"** or **"Property management"**

#### C. Content Ratings
- ✅ Select **"No objectionable content"** (if applicable)
- ✅ Answer questionnaire accurately based on your app's actual features

---

### 3. Update Data Safety Section

**Location**: **Play Console** → **App content** → **Data safety**

#### Financial Information
**Question**: "Does your app collect, share, or use financial information?"

**Answer Options**:
- ✅ **"Yes, for payment processing for goods/services"** (SELECT THIS)
  - Explanation: "App processes rent and deposit payments for PG accommodations through Razorpay payment gateway. Payments are processed by the third-party gateway, not stored by the app."

- ❌ Do NOT select:
  - "Yes, for financial services"
  - "Yes, for banking services"
  - "Yes, for loans or credit"

---

### 4. Update Store Listing

**Location**: **Play Console** → **Store presence** → **Main store listing**

#### A. Short Description (80 characters max)
**Current** (if any): May mention "financial" or "banking"  
**Recommended**:
```
PG accommodation management platform for owners and guests. Book, pay, manage.
```

#### B. Full Description (4,000 characters max)
**Remove**:
- ❌ "financial services"
- ❌ "banking"
- ❌ "wallet"
- ❌ "investment"
- ❌ "loan"

**Use Instead**:
- ✅ "accommodation booking"
- ✅ "PG management"
- ✅ "rent payment processing"
- ✅ "property rental platform"
- ✅ "booking and rental management"

**Recommended Description**:
```
Atitia is a comprehensive PG (Paying Guest) accommodation management platform designed to streamline the rental experience for both property owners and guests.

FOR PG OWNERS:
• Manage multiple PG properties
• Visual bed allocation with floor plans
• Real-time booking approvals
• Revenue tracking and financial reporting
• Guest management with payment history
• Weekly food menu setup
• Complaint and service request handling

FOR GUESTS:
• Discover PGs with advanced filters
• Easy booking request flow
• Secure payment processing for rent and deposits
• View your PG's food menu
• Submit and track complaints
• Manage your profile

The app facilitates payments for accommodation bookings through Razorpay, a secure third-party payment gateway. Payments are processed securely through the payment gateway and are used solely for rent and deposit transactions related to PG accommodation bookings.
```

---

### 5. Update Keywords/Tags

**Location**: **Play Console** → **Store presence** → **Store settings**

**Remove Keywords**:
- ❌ "finance", "banking", "wallet", "investment", "loan"

**Keep/Add Keywords**:
- ✅ "PG", "accommodation", "rental", "booking", "property management", "guest house", "hostel", "lodging"

---

### 6. Verify App Content Questionnaire

**Location**: **Play Console** → **Store presence** → **App content** → **Content ratings**

Answer these questions:

**Q: Does your app provide financial services?**
- ✅ **NO** (The app processes payments for accommodations, but does not provide financial services like banking, loans, or investments)

**Q: Does your app offer banking services?**
- ✅ **NO**

**Q: Does your app offer loans or credit?**
- ✅ **NO**

**Q: Does your app process payments?**
- ✅ **YES** - For goods/services (rental accommodations)

---

### 7. Submit Update

After making all changes:

1. **Save** all changes in Play Console
2. **Create a new release** (version 1.0.1 or higher)
3. **Submit for review**
4. **Add a note in the review notes**:
   ```
   Updated app category and content declarations to accurately reflect that this is an accommodation booking platform, not a financial services app. The app processes payments for rental accommodations through a third-party payment gateway (Razorpay) only.
   ```

---

## ✅ Verification Checklist

Before submitting, verify:

- [ ] App category is set to **"Travel & Local"** or **"Business"** (NOT "Finance")
- [ ] Content declarations do NOT mention **"Financial services"** or **"Banking"**
- [ ] Data Safety section correctly describes payment processing for goods/services
- [ ] Store listing does NOT mention **"financial services"**, **"banking"**, **"wallet"**, **"investment"**
- [ ] App description focuses on **"accommodation"**, **"booking"**, **"rental"** terminology
- [ ] All changes are saved in Play Console

---

## 📝 Appeal Message (if needed)

If the rejection persists after making these changes, you can submit an appeal with this message:

```
This app is a PG (Paying Guest) accommodation booking and management platform. It facilitates rental payments for accommodations through a third-party payment gateway (Razorpay), similar to how Airbnb or Booking.com process payments. The app does not provide financial services such as banking, loans, investments, or cryptocurrency services.

I have updated the app category to "Travel & Local" and removed all financial services declarations. The app should not require an organization account as it is not a financial services app.

The app's primary function is:
- Property owners managing PG accommodations
- Guests booking and paying for accommodations
- Payment processing for rent/deposits (handled by Razorpay gateway)

This is clearly a booking/accommodation platform, not a financial services app. Please review the updated category and content declarations.
```

---

## 🔄 Next Steps

1. Complete all checklist items above
2. Create new release (version bump)
3. Submit for review
4. Wait 1-3 days for review
5. If still rejected, submit appeal with the message above

---

**Last Updated**: November 2025

