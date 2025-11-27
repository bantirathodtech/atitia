# 🔧 Razorpay KYC Issues - Resolution Guide

**Date:** November 26, 2024  
**Status:** Action Required

---

## 📋 Issues Identified

Razorpay has flagged two issues in your KYC submission:

1. **Playstore URL** - App needs to be live with screenshots
2. **Business Model** - Alternative contact number required

---

## 🚨 Issue 1: Playstore URL

### Problem
> "Please ensure that the app is live, fully functional, and registered on the Play Store, and that it includes at least one screenshot so we can proceed further."

### Solution Steps

#### Step 1: Verify App is Published on Play Store

1. **Check if app is live:**
   - Visit: `https://play.google.com/store/apps/details?id=com.avishio.atitia`
   - If you see "App not found" or "Not available", the app is not published yet

2. **If app is NOT published:**
   - Go to Google Play Console: https://play.google.com/console
   - Navigate to your app: **Atitia** (`com.avishio.atitia`)
   - Check the app status:
     - **Draft**: App is not published
     - **In Review**: App is being reviewed
     - **Published**: App is live ✅

#### Step 2: Ensure App Has Screenshots

**Minimum Requirement:** At least 1 screenshot (Razorpay requirement)  
**Play Store Requirement:** Minimum 2 screenshots

1. **Go to Play Console:**
   - Navigate to: **Store presence → Main store listing**

2. **Check Screenshots Section:**
   - Scroll to **"Phone screenshots"**
   - Verify you have at least 2 screenshots uploaded
   - If missing, upload screenshots from: `screenshots/play_store/` directory

3. **Upload Screenshots (if needed):**
   - **Recommended Size:** 1080 x 1920 pixels (or 1440 x 2560)
   - **Format:** PNG or JPG
   - **Minimum:** 2 screenshots
   - **Maximum:** 8 screenshots

4. **Screenshot Priority:**
   - **Screenshot 1:** Guest Dashboard (PG listings)
   - **Screenshot 2:** PG Details Screen
   - **Screenshot 3:** Owner Dashboard (optional but recommended)

5. **Save Changes:**
   - Click **"Save"** at the bottom
   - Wait for changes to be processed (usually instant)

#### Step 3: Verify App is Fully Functional

1. **Test the Play Store URL:**
   - Visit: `https://play.google.com/store/apps/details?id=com.avishio.atitia`
   - Ensure the page loads correctly
   - Verify screenshots are visible
   - Check that "Install" button is available

2. **Test App Installation:**
   - Install the app from Play Store
   - Verify it opens and functions correctly
   - Test key features (login, browsing, etc.)

#### Step 4: Update Razorpay Dashboard

1. **Log in to Razorpay Dashboard:**
   - Go to: https://dashboard.razorpay.com
   - Navigate to: **Settings → Account & Settings → KYC**

2. **Update Play Store URL:**
   - Find the field: **"Playstore Url"** or **"App URL"**
   - Enter/Verify: `https://play.google.com/store/apps/details?id=com.avishio.atitia`
   - Save changes

3. **Re-submit KYC (if needed):**
   - If there's a "Resubmit" or "Update" button, click it
   - Add a note: "App is now live on Play Store with screenshots"

---

## 📞 Issue 2: Business Model - Contact Number

### Problem
> "We tried reaching the registered mobile number 7020797849 but we understand you might be busy. Please provide us with an alternative contact number."

### Solution Steps

#### Step 1: Prepare Alternative Contact Number

**Options:**
- Use a different mobile number that you can answer
- Use a landline number (if available)
- Use a business phone number
- Ensure the number is:
  - ✅ Active and working
  - ✅ Accessible during business hours (9 AM - 6 PM IST)
  - ✅ Can receive calls and SMS
  - ✅ You can answer immediately when Razorpay calls

#### Step 2: Update Razorpay Dashboard

1. **Log in to Razorpay Dashboard:**
   - Go to: https://dashboard.razorpay.com
   - Navigate to: **Settings → Account & Settings → KYC**

2. **Find Business Model Section:**
   - Look for: **"Business Model"** or **"Contact Information"**
   - Find the field: **"Alternative Contact Number"** or **"Secondary Contact Number"**

3. **Add Alternative Contact Number:**
   - Enter your alternative number (with country code)
   - Format: `+91-XXXXXXXXXX` (for India)
   - Example: `+91-9876543210`

4. **If no "Alternative" field exists:**
   - Update the primary contact number
   - Or contact Razorpay support to add alternative number

#### Step 3: Contact Razorpay Support (If Needed)

If you cannot find the field to add an alternative number:

1. **Raise a Support Ticket:**
   - Go to: https://razorpay.com/support/
   - Or email: support@razorpay.com
   - Subject: "KYC - Alternative Contact Number Required"

2. **Email Template:**
   ```
   Subject: KYC - Alternative Contact Number Required

   Dear Razorpay Team,

   I received a KYC clarification request regarding my business model. 
   The registered mobile number 7020797849 was not reachable.

   Please find my alternative contact number below:
   
   Alternative Contact Number: +91-XXXXXXXXXX
   Name: BANTI SHANKAR RATHOD
   Email: bantirathodtech@gmail.com
   
   Please use this number for any KYC verification calls.
   
   Thank you,
   BANTI SHANKAR RATHOD
   ```

3. **Update via Dashboard Chat:**
   - Use the in-dashboard chat support
   - Request to add alternative contact number
   - Provide the new number

#### Step 4: Be Available for Verification Call

1. **Keep Phone Ready:**
   - Ensure alternative number is charged and active
   - Keep phone nearby during business hours
   - Answer immediately when Razorpay calls

2. **Expected Call Details:**
   - **Timing:** Usually during business hours (9 AM - 6 PM IST)
   - **Purpose:** Verify business model and operations
   - **Duration:** 5-10 minutes
   - **Questions:** About your business, app functionality, revenue model

3. **Prepare Answers:**
   - Business type: SaaS (Software as a Service)
   - Business model: Subscription-based PG management platform
   - Revenue: Monthly/yearly subscriptions from PG owners
   - App: Available on Play Store (`com.avishio.atitia`)

---

## ✅ Verification Checklist

### Play Store URL Issue
- [ ] App is published on Play Store
- [ ] App URL is accessible: `https://play.google.com/store/apps/details?id=com.avishio.atitia`
- [ ] At least 2 screenshots are uploaded on Play Store
- [ ] Screenshots are visible on the Play Store listing
- [ ] App can be installed and functions correctly
- [ ] Play Store URL is updated in Razorpay dashboard
- [ ] KYC resubmitted (if required)

### Contact Number Issue
- [ ] Alternative contact number is prepared and active
- [ ] Alternative number is added to Razorpay dashboard
- [ ] Support ticket raised (if dashboard update not possible)
- [ ] Phone is ready to receive calls during business hours
- [ ] Prepared answers for business model questions

---

## 🚀 Quick Action Steps (Priority Order)

### Immediate Actions (Today)

1. **Check Play Store Status:**
   ```bash
   # Visit this URL in browser:
   https://play.google.com/store/apps/details?id=com.avishio.atitia
   ```

2. **If app is not published:**
   - Publish app in Play Console
   - Upload at least 2 screenshots
   - Wait for app to go live (usually 1-2 hours)

3. **Add Alternative Contact Number:**
   - Log in to Razorpay dashboard
   - Add alternative contact number
   - Save changes

4. **Update Razorpay KYC:**
   - Verify Play Store URL is correct
   - Add note about screenshots being added
   - Resubmit KYC (if option available)

### Follow-up Actions (Within 24 Hours)

1. **Verify Everything:**
   - Confirm app is live with screenshots
   - Confirm alternative number is added
   - Test app installation from Play Store

2. **Contact Razorpay (if needed):**
   - Email support if dashboard update not possible
   - Request KYC review after fixes

3. **Be Available:**
   - Keep phone ready for verification call
   - Answer immediately when Razorpay calls

---

## 📞 Contact Information

**Your Details:**
- **Name:** BANTI SHANKAR RATHOD
- **Email:** bantirathodtech@gmail.com
- **Registered Number:** 7020797849
- **Alternative Number:** [TO BE ADDED]
- **App ID:** com.avishio.atitia
- **Play Store URL:** https://play.google.com/store/apps/details?id=com.avishio.atitia

**Razorpay Support:**
- **Email:** support@razorpay.com
- **Support Portal:** https://razorpay.com/support/
- **Dashboard:** https://dashboard.razorpay.com

---

## 📝 Notes

1. **Play Store Publishing:**
   - If app is in "Draft" status, you need to complete all required fields and submit for review
   - Review process takes 1-7 days
   - Once approved, app goes live immediately

2. **Screenshots:**
   - You have screenshots in: `screenshots/play_store/`
   - Use the latest screenshots from the most recent folder
   - Ensure screenshots show actual app functionality

3. **Contact Number:**
   - Use a number you can answer immediately
   - Ensure it's active and can receive calls
   - Keep it charged and nearby during business hours

4. **KYC Timeline:**
   - After fixing issues, Razorpay usually reviews within 2-3 business days
   - They may call for verification
   - Once approved, you'll receive live API keys

---

## 🎯 Success Criteria

You'll know the issues are resolved when:

1. ✅ Play Store URL shows live app with screenshots
2. ✅ Alternative contact number is added to Razorpay dashboard
3. ✅ Razorpay confirms receipt of updates
4. ✅ KYC status changes to "Under Review" or "Approved"
5. ✅ You receive verification call (if required) and answer successfully

---

**Last Updated:** November 26, 2024  
**Next Review:** After completing immediate actions

