# Google Play Console - Step-by-Step Update Guide

**For first-time users - Follow these exact steps to fix your app rejection**

---

## 📋 Overview

You need to update several sections in Google Play Console. Follow this guide step-by-step.

---

## ✅ STEP 1: Update App Category (Fix Organization Account Issue)

**Location**: Store presence → Store settings

### Steps:

1. **Login** to [Google Play Console](https://play.google.com/console)
2. **Click** on your app **"Atitia"**
3. In the left sidebar, **click** **"Store presence"** (expand if needed)
4. **Click** **"Store settings"**
5. **Find** **"App category"** section
6. **Click** the dropdown/button next to **"App category"**
7. **Select**: **"Travel & Local"** ✅
8. **Click** **"Save"** or **"Update"** button at the bottom

**Why**: This fixes the organization account requirement issue. Your app is a booking/accommodation platform, not a finance app.

---

## ✅ STEP 2: Complete Data Safety Questionnaire

**Location**: App content → Data safety

### Steps:

1. In the left sidebar, **click** **"App content"** (expand if needed)
2. **Click** **"Data safety"**
3. **Click** **"Start"** or **"Edit"** button
4. Answer each section:

#### A. Data Collection & Sharing
- **Question**: "Does your app collect, share, or use data?"
  - **Answer**: **"Yes"** ✅

#### B. Data Types
- **Question**: "What types of data does your app collect?"
  - **Select these**:
    - ✅ **Personal info** (Name, email, phone number)
    - ✅ **Financial info** (Payment info for purchases)
    - ✅ **Location** (Approximate location - if you use location for PG search)
    - ✅ **Photos and videos** (User profile photos, PG photos)
    - ✅ **Files and docs** (KYC documents, if applicable)

#### C. Financial Information
- **Question**: "Does your app collect, share, or use financial information?"
  - **Answer**: **"Yes"** ✅
- **Question**: "How is financial information used?"
  - **Select**: ✅ **"For payment processing for goods/services"**
- **Additional details**:
  - **Select**: ✅ **"Payment info"**
  - **How is it used?**: ✅ **"App functionality"**
  - **Is it collected?**: ✅ **"Yes"**
  - **Is it shared?**: ✅ **"Yes, shared with third parties"** (Razorpay)
  - **Data processing**: ✅ **"Processed by third parties"**

#### D. Data Encryption
- **Question**: "Is data encrypted in transit?"
  - **Answer**: **"Yes"** ✅

#### E. Data Deletion
- **Question**: "Can users request data deletion?"
  - **Answer**: **"Yes"** ✅ (if you have this feature) or **"No, users cannot request deletion"** (if not implemented yet)

5. **Click** **"Save"** at the bottom
6. **Click** **"Save"** again on the next screen to confirm

---

## ✅ STEP 3: Update Target Audience and Content

**Location**: App content → Target audience and content

### Steps:

1. In the left sidebar, **click** **"App content"** (expand if needed)
2. **Click** **"Target audience and content"**
3. **Click** **"Edit"** or **"Update"** button

#### A. Target Age Group
- **Question**: "What age group is your app designed for?"
  - **Select**: ✅ **"18 and older"** (if this is what you want)

#### B. App Content
- **Question**: "Does your app contain content that may not be suitable for all ages?"
  - **Answer**: **"No"** ✅ (unless your app has adult content)

#### C. Children's Privacy
- **Question**: "Is your app designed for families?"
  - **Answer**: **"No"** ✅ (unless specifically for families)

4. **Click** **"Save"** button

---

## ✅ STEP 4: Update App Access Instructions

**Location**: App content → App access

### Steps:

1. In the left sidebar, **click** **"App content"** (expand if needed)
2. **Click** **"App access"**
3. **Click** **"Edit"** or **"Update"** button

#### A. App Availability
- **Question**: "Is all or some functionality in your app restricted?"
  - **Answer**: **"No, all functionality is available"** ✅
  - OR if you require login: **"Yes, some functionality is restricted"** ✅
    - **Instructions**: Enter: "Users must create an account and log in to access booking and payment features. Phone number OTP verification is required for account creation."

#### B. Account Requirements
- If you selected "Yes" above:
  - **Question**: "How do users access the app?"
    - **Answer**: **"Users must register or log in to access the app"** ✅
  - **Question**: "What information is required for registration?"
    - **Select**: ✅ **"Phone number"**, ✅ **"Name"**, ✅ **"Email (optional)"**

4. **Click** **"Save"** button

---

## ✅ STEP 5: Update Financial Features Declaration

**Location**: App content → Financial features

### Steps:

1. In the left sidebar, **click** **"App content"** (expand if needed)
2. **Click** **"Financial features"** (or look for it in the App content section)
3. **Click** **"Edit"** or **"Update"** button

#### A. Financial Services
- **Question**: "Does your app provide financial services?"
  - **Answer**: **"No"** ✅

#### B. Banking Services
- **Question**: "Does your app offer banking services?"
  - **Answer**: **"No"** ✅

#### C. Payment Processing
- **Question**: "Does your app process payments?"
  - **Answer**: **"Yes"** ✅
  - **Question**: "What type of payments?"
    - **Select**: ✅ **"In-app purchases"** OR ✅ **"Payments for goods/services"**
    - **Explanation**: "The app processes payments for PG accommodation bookings (rent and deposits) through Razorpay payment gateway. Payments are processed by the third-party gateway for rental accommodations only."

#### D. Other Financial Features
- **Question**: "Does your app offer loans, credit, or investment services?"
  - **Answer**: **"No"** ✅

4. **Click** **"Save"** button

---

## ✅ STEP 6: Update Health Declaration

**Location**: App content → Health

### Steps:

1. In the left sidebar, **click** **"App content"** (expand if needed)
2. **Click** **"Health"** (or look for it in the App content section)
3. **Click** **"Edit"** or **"Update"** button

#### A. Health Apps
- **Question**: "Does your app provide health or medical services?"
  - **Answer**: **"No"** ✅

#### B. Medical Apps
- **Question**: "Is your app a medical app?"
  - **Answer**: **"No"** ✅

#### C. Human Subjects Research
- **Question**: "Does your app involve human subjects research?"
  - **Answer**: **"No"** ✅

4. **Click** **"Save"** button

---

## ✅ STEP 7: Update Government Apps Declaration

**Location**: App content → Government apps

### Steps:

1. In the left sidebar, **click** **"App content"** (expand if needed)
2. **Click** **"Government apps"** (or look for it in the App content section)
3. **Click** **"Edit"** or **"Update"** button

#### A. Government Apps
- **Question**: "Is your app developed by or on behalf of a government agency?"
  - **Answer**: **"No"** ✅

4. **Click** **"Save"** button

---

## ✅ STEP 8: Update Advertising ID Declaration

**Location**: App content → Ads declaration (or Advertising ID)

### Steps:

1. In the left sidebar, **click** **"App content"** (expand if needed)
2. **Click** **"Ads declaration"** or **"Advertising ID"**
3. **Click** **"Edit"** or **"Update"** button

#### A. Advertising ID Usage
- **Question**: "Does your app use an Advertising ID?"
  - **Answer**: **"Yes"** ✅ (because Firebase Analytics uses it)

#### B. Why Does Your App Use Advertising ID?
- **Select**: ✅ **"Analytics"** ONLY
  - Explanation: "Used to collect data about how users use your app, or how your app performs. For example, to see how many users are using a particular feature, to monitor app health, to diagnose and fix bugs or crashes, or to make future performance improvements."

- ❌ **DO NOT select**:
  - "Advertising or marketing" (you don't show ads)
  - "Personalization"
  - "Developer communications"

4. **Click** **"Save"** button

---

## ✅ STEP 9: Update Ads Declaration

**Location**: App content → Ads declaration

### Steps:

1. In the left sidebar, **click** **"App content"** (expand if needed)
2. **Click** **"Ads declaration"**
3. **Click** **"Edit"** or **"Update"** button

#### A. Ads in App
- **Question**: "Does your app show ads?"
  - **Answer**: **"No"** ✅

#### B. Ad Networks
- If you answered "No" above, you can skip this section
- If you answer "Yes" (which you shouldn't), you'll need to list ad networks

4. **Click** **"Save"** button

---

## ✅ STEP 10: Submit Content Rating Questionnaire

**Location**: App content → Content Rating

### Steps:

1. In the left sidebar, **click** **"App content"** (expand if needed)
2. **Click** **"Content Rating"**
3. **Click** **"Submit new questionnaire"** or **"Edit"** button
4. Answer all questions honestly:

#### A. General Questions
- **Question**: "Does your app contain violence, profanity, sexual content, or gambling?"
  - **Answer**: **"No"** ✅

- **Question**: "Does your app provide financial services?"
  - **Answer**: **"No"** ✅

- **Question**: "Does your app provide health services?"
  - **Answer**: **"No"** ✅

- **Question**: "Does your app require an internet connection?"
  - **Answer**: **"Yes"** ✅

- **Question**: "Does your app require user registration?"
  - **Answer**: **"Yes"** ✅

#### B. Specific Questions
- Answer all questions based on your app's actual features
- For most questions, answer **"No"** if the question doesn't apply
- For questions about bookings, rentals, payments for goods/services, answer **"Yes"** where applicable

5. **Click** **"Save"** or **"Calculate rating"** button
6. Review the rating that appears
7. **Click** **"Apply"** or **"Submit"** button

---

## ✅ STEP 11: Verify Privacy Policy URL

**Location**: App content → Privacy policy

### Steps:

1. In the left sidebar, **click** **"App content"** (expand if needed)
2. **Click** **"Privacy policy"**
3. **Check** if the URL is set to: `https://sites.google.com/view/atitiaprivacy/home`
4. If not set or incorrect:
   - **Click** **"Edit"** or **"Add"** button
   - **Enter** the URL: `https://sites.google.com/view/atitiaprivacy/home`
   - **Click** **"Save"** button
5. If already correct, **no action needed** ✅

---

## ✅ STEP 12: Review Store Listing

**Location**: Store presence → Main store listing

### Steps:

1. In the left sidebar, **click** **"Store presence"**
2. **Click** **"Main store listing"**
3. **Select** **"English (United States) - en-US"**
4. **Review** all fields:

#### A. Short Description (80 characters max)
**Recommended text**:
```
PG accommodation management platform for owners and guests. Book, pay, manage.
```

#### B. Full Description (4,000 characters max)
**Recommended text** (use what we discussed earlier):
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

**Important**: Make sure the description does NOT mention:
- ❌ "financial services"
- ❌ "banking"
- ❌ "wallet"
- ❌ "investment"

5. **Click** **"Save"** button

---

## ✅ STEP 13: Final Verification

### Check "What you've told us" Section

1. Go back to **"Publishing overview"** page
2. Scroll down to **"What you've told us"** section
3. **Verify** all items are updated:
   - ✅ App category: Travel & Local
   - ✅ App access instructions: Updated
   - ✅ Advertising ID declaration: Updated (Analytics only)
   - ✅ Government apps declaration: No
   - ✅ Financial features declaration: Updated (No financial services, only payment processing)
   - ✅ Health declaration: No
   - ✅ Data safety: Complete
   - ✅ Content rating: Submitted
   - ✅ Target audience: Updated

---

## ✅ STEP 14: Create New Release (Version Update)

**Location**: Production → Releases

### Steps:

1. In the left sidebar, **click** **"Release"** (expand if needed)
2. **Click** **"Production"** (or **"Closed testing"** if you're still in testing)
3. **Click** **"Create new release"** button
4. **Enter Release name**: `1.0.1` (or `1.0.0+2`)
5. **Release notes**: Enter the release notes (you already have these)
6. **Upload** the same `.aab` file (or rebuild if needed)
7. **Click** **"Save"** button
8. **Click** **"Review release"** button
9. **Review** all information
10. **Click** **"Start rollout to Production"** or **"Submit for review"** button

---

## ✅ STEP 15: Submit for Review

### Steps:

1. Go back to **"Publishing overview"** page
2. **Review** the **"Changes not yet sent for review"** section
3. **Check** that all required items are complete:
   - ✅ App category selected
   - ✅ Data safety complete
   - ✅ Content rating submitted
   - ✅ Privacy policy URL set
   - ✅ All declarations updated
4. **Click** **"Send for review"** button (if available)
5. **Or** go to **"Release"** → **"Production"** and click **"Submit for review"**

---

## 📝 Important Notes

1. **Save each section** as you complete it - don't wait until the end
2. **Don't rush** - take your time reading each question
3. **Answer honestly** - false information can lead to permanent ban
4. **Review everything** before submitting
5. **Wait for review** - Google typically reviews within 1-3 days

---

## 🔄 If Your App Is Still Rejected

If after making all these changes, your app is still rejected:

1. **Read the rejection reason** carefully
2. **Check** if you missed any of the above steps
3. **Submit an appeal** using the message from the previous guide
4. **Contact Google Play Support** if needed

---

## ✅ Checklist Summary

Before submitting, verify:

- [ ] App category set to **"Travel & Local"**
- [ ] Data safety questionnaire **complete**
- [ ] Target audience updated (18 and older)
- [ ] App access instructions updated
- [ ] Financial features declaration: **"No"** to financial services
- [ ] Health declaration: **"No"**
- [ ] Government apps declaration: **"No"**
- [ ] Advertising ID: **"Yes"** for Analytics only
- [ ] Ads declaration: **"No"** (app doesn't show ads)
- [ ] Content rating questionnaire submitted
- [ ] Privacy policy URL set correctly
- [ ] Store listing description updated (no financial services mentions)
- [ ] New release created
- [ ] All changes saved

---

**Good luck! Follow these steps carefully and your app should be approved.** 🚀

