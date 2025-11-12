# 📱 Google Play Store Account Setup - Step by Step

## Overview

This guide will help you create a Google Play Console account and set it up for publishing your Atitia app.

**Time:** ~30-45 minutes  
**Cost:** $25 one-time registration fee (Google Play Developer Program)

---

## Step 1: Create Google Account (If Needed)

### 1.1 Check if you have a Google account
- Go to: https://accounts.google.com
- Sign in with your email

### 1.2 If you don't have one:
1. Go to: https://accounts.google.com/signup
2. Fill in your details
3. Verify your email
4. Done ✅

**Time:** 5 minutes

---

## Step 2: Create Google Play Developer Account

### 2.1 Go to Google Play Console
- Visit: https://play.google.com/console
- Sign in with your Google account

### 2.2 Accept Developer Agreement
1. Click **"Get Started"** or **"Create Account"**
2. Read and accept the **Developer Distribution Agreement**
3. Check the box to agree
4. Click **"Continue"**

### 2.3 Pay Registration Fee
- **Cost:** $25 USD (one-time, lifetime)
- **Payment:** Credit card or debit card
- **Note:** This is a one-time fee, not recurring

**Steps:**
1. Click **"Pay Registration Fee"**
2. Enter payment details
3. Complete payment
4. Wait for confirmation (usually instant)

**Time:** 5-10 minutes

### 2.4 Complete Account Setup
1. Fill in your **developer name** (what users will see)
   - Example: "Atitia" or "Your Company Name"
2. Fill in your **contact details**
   - Email address
   - Phone number
3. Select your **country/region**
4. Click **"Complete Registration"**

**Time:** 5 minutes

### 2.5 Verify Account
- Google will send a verification email
- Check your email and click the verification link
- Account is now active ✅

**Time:** 2-5 minutes

---

## Step 3: Create Your First App

### 3.1 Create App
1. In Google Play Console, click **"Create app"**
2. Fill in app details:

   **App name:**
   - Enter: `Atitia`
   - (or whatever you want to name it)

   **Default language:**
   - Select: `English (United States)` or your preferred language

   **App or game:**
   - Select: **App**

   **Free or paid:**
   - Select: **Free** (or Paid if you want to charge)

   **Declarations:**
   - Check the boxes (if applicable)
   - Click **"Create app"**

**Time:** 5 minutes

### 3.2 App Dashboard
- You'll see your app dashboard
- App ID will be: `com.avishio.atitia` (matches your app)
- Status: **Draft** (not published yet)

---

## Step 4: Complete App Listing (Minimum Required)

### 4.1 Basic App Information
Go to: **Store presence → Main store listing**

**Required fields:**
1. **App name:** `Atitia` (or your choice)
2. **Short description:** (80 characters max)
   - Example: "PG management app for owners and guests"
3. **Full description:** (4000 characters max)
   - Describe your app features
   - Can be simple for now

**Time:** 10 minutes

### 4.2 Graphics (Required)
Go to: **Store presence → Main store listing → Graphics**

**Required:**
1. **App icon:** 512x512 PNG
   - Upload your app icon
   - If you don't have one, use a simple placeholder for now

2. **Feature graphic:** 1024x500 PNG
   - Promotional banner
   - Can be simple for now

3. **Screenshots:** At least 2 phone screenshots
   - Minimum: 2 screenshots
   - Recommended: 4-8 screenshots
   - Size: Any (Android will resize)

**Time:** 10-15 minutes (or use placeholders)

### 4.3 Content Rating
Go to: **Policy → Content rating**

1. Click **"Start questionnaire"**
2. Answer questions about your app content
3. Most questions are simple yes/no
4. Submit

**Time:** 5 minutes

### 4.4 Privacy Policy (If Required)
Go to: **Policy → Privacy policy**

- If your app collects user data, you need a privacy policy URL
- For now, you can use a simple GitHub Pages URL or any URL
- Or create a simple privacy policy page

**Time:** 5 minutes (or skip if not required)

---

## Step 5: Set Up App Signing (Important!)

### 5.1 Go to App Signing
- Navigate to: **Release → Setup → App signing**

### 5.2 Google Play App Signing
- Google will handle app signing automatically
- You can use Google's managed signing (recommended)
- Or upload your own keystore

**For CI/CD, we recommend:**
- Use Google Play App Signing (managed by Google)
- Upload your upload keystore (or let Google generate one)

**Time:** 5 minutes

---

## Step 6: Create Service Account (For CI/CD)

### 6.1 Go to API Access
- Navigate to: **Setup → API access**
- Click **"Create new service account"**

### 6.2 Create Service Account
1. Click the link that says **"Google Cloud Console"**
2. This opens Google Cloud Console in a new tab
3. Click **"Create Service Account"**

### 6.3 Fill Service Account Details
1. **Service account name:** `atitia-play-uploader`
2. **Service account ID:** (auto-generated)
3. **Description:** `Service account for CI/CD app uploads`
4. Click **"Create and Continue"**

### 6.4 Grant Access
1. **Role:** Select **"Service Account User"**
2. Click **"Continue"**
3. Click **"Done"**

### 6.5 Create Key
1. Click on the service account you just created
2. Go to **"Keys"** tab
3. Click **"Add Key"** → **"Create new key"**
4. Select **JSON** format
5. Click **"Create"**
6. **JSON file downloads automatically** ⚠️ Save this file!

**Time:** 10 minutes

### 6.6 Grant Play Console Access
1. Go back to Google Play Console
2. In **API access** page, find your service account
3. Click **"Grant access"**
4. Select permissions:
   - ✅ **View app information**
   - ✅ **Manage production releases**
   - ✅ **Manage testing track releases** (optional)
5. Click **"Invite user"**

**Time:** 5 minutes

---

## Step 7: Add Service Account to GitHub Secrets

### 7.1 Open JSON File
- Open the JSON file you downloaded in Step 6.5
- Copy the entire content

### 7.2 Add to GitHub Secrets
1. Go to: https://github.com/bantirathodtech/atitia/settings/secrets/actions
2. Click **"New repository secret"**
3. **Name:** `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`
4. **Secret:** Paste the entire JSON file content
5. Click **"Add secret"**

**Time:** 2 minutes

---

## Step 8: Verify Setup

### 8.1 Check Your Setup
✅ Google Play Developer account created  
✅ App created in Play Console  
✅ App listing filled (minimum required)  
✅ Service account created  
✅ Service account JSON saved  
✅ Service account added to GitHub secrets  

### 8.2 Test CI/CD
You're now ready to publish via CI/CD!

---

## 🎯 Quick Checklist

Before publishing, make sure you have:

- [ ] Google Play Developer account ($25 paid)
- [ ] App created in Play Console
- [ ] App name entered
- [ ] Short description entered
- [ ] Full description entered
- [ ] App icon uploaded (512x512)
- [ ] Feature graphic uploaded (1024x500)
- [ ] At least 2 screenshots uploaded
- [ ] Content rating completed
- [ ] Privacy policy URL (if required)
- [ ] Service account created
- [ ] Service account JSON downloaded
- [ ] Service account granted access in Play Console
- [ ] Service account JSON added to GitHub secrets

---

## 📝 Next Steps (After Setup)

Once setup is complete:

1. **Trigger CI/CD deploy:**
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. **Or manually trigger:**
   - Go to: Actions → Deploy workflow
   - Click "Run workflow"
   - Enter version: `v1.0.0`
   - Run

3. **Monitor deployment:**
   - Watch GitHub Actions
   - Check Play Console for upload status

4. **Submit for review:**
   - Once AAB is uploaded, go to Play Console
   - Review the release
   - Submit for review

**Google reviews in 1-7 days, then your app is live!**

---

## ⚠️ Important Notes

1. **Registration Fee:** $25 one-time, lifetime fee
2. **Review Time:** 1-7 days for first submission
3. **Service Account:** Keep JSON file secure, never commit to Git
4. **App Signing:** Google Play App Signing is recommended (managed by Google)
5. **Updates:** After first publish, updates are faster (usually same day)

---

## 🆘 Troubleshooting

### Issue: "Service account access denied"
**Fix:** Make sure you granted access in Play Console (Step 6.6)

### Issue: "JSON file invalid"
**Fix:** Make sure you copied the entire JSON content, including all brackets

### Issue: "App not found"
**Fix:** Make sure app ID in Play Console matches `com.avishio.atitia`

### Issue: "Missing required information"
**Fix:** Complete all required fields in Store presence → Main store listing

---

## ✅ Ready to Publish!

Once you complete these steps, your CI/CD pipeline will automatically:
1. Build AAB (release)
2. Upload to Google Play Store
3. Deploy to internal/test track (or production if configured)

**You're ready to publish! 🚀**

---

*Questions? Let me know and I'll help you through any step!*

