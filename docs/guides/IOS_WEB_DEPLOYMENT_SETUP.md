# 🍎🌐 iOS & Web Deployment Setup Guide

Complete step-by-step guide to configure iOS and Web deployment for automated CI/CD.

---

## 📋 Overview

**Goal**: Set up automated deployment for iOS App Store and Firebase Hosting (Web)

**Time Required**: 
- iOS: ~30-60 minutes (first time)
- Web: ~15-20 minutes

**Prerequisites**:
- ✅ Apple Developer Account ($99/year) - for iOS
- ✅ Firebase project access - for Web
- ✅ GitHub repository access - for adding secrets

---

## 🍎 PART 1: iOS Deployment Setup

### Step 1: Verify iOS Project Configuration ✅

**Already configured:**
- ✅ Bundle ID: `com.avishio.atitia`
- ✅ Project ID: `atitia-87925`
- ✅ Firebase configured

**Verify:**
```bash
# Check iOS project
cat ios/Runner/Info.plist | grep -i bundle
```

---

### Step 2: Create iOS Certificate & Provisioning Profile

#### Option A: Using Xcode (Recommended - Easiest)

1. **Open Xcode Project:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configure Signing:**
   - Select **Runner** project (blue icon)
   - Select **Runner** target
   - Go to **Signing & Capabilities** tab
   - Check **"Automatically manage signing"**
   - Select your **Team** (Apple Developer account)
   - Xcode will automatically:
     - ✅ Create/Download certificate
     - ✅ Create/Download provisioning profile
     - ✅ Configure entitlements

3. **Verify:**
   - Bundle Identifier: `com.avishio.atitia`
   - Team: Your Apple Developer team
   - Status: Should show "✓" (valid)

#### Option B: Manual Certificate Creation

See `docs/IOS_SIGNING_SETUP.md` for detailed manual steps.

---

### Step 3: Export Certificate & Provisioning Profile for CI/CD

Once Xcode has created everything, export for GitHub Actions:

#### Export Certificate (.p12):

1. **Open Keychain Access:**
   - Press `Cmd + Space` → Search "Keychain Access"
   - Go to **Login** keychain
   - Find certificate named: "Apple Distribution: [Your Name]" or "iPhone Distribution: [Your Name]"

2. **Export Certificate:**
   - Right-click certificate → **Export "[Certificate Name]"**
   - Choose format: **Personal Information Exchange (.p12)**
   - Set a password (remember this!)
   - Save as: `atitia-distribution.p12`

3. **Convert to Base64:**
   ```bash
   base64 -i atitia-distribution.p12 | pbcopy
   ```
   This copies base64 string to clipboard - save it!

#### Export Provisioning Profile:

1. **In Xcode:**
   - Go to **Preferences** → **Accounts**
   - Select your Apple ID
   - Click **Download Manual Profiles**
   - Wait for download

2. **Find Profile:**
   - Profiles are in: `~/Library/MobileDevice/Provisioning Profiles/`
   - Look for file matching: `com.avishio.atitia`

3. **Convert to Base64:**
   ```bash
   # Find the profile
   ls ~/Library/MobileDevice/Provisioning\ Profiles/
   
   # Copy the profile path and convert
   base64 -i "/Users/[YOUR_USER]/Library/MobileDevice/Provisioning Profiles/[PROFILE_UUID].mobileprovision" | pbcopy
   ```
   Save this base64 string!

---

### Step 4: Create App Store Connect API Key

For automated uploads to App Store Connect:

1. **Go to App Store Connect:**
   - https://appstoreconnect.apple.com
   - Sign in with your Apple ID

2. **Create API Key:**
   - Navigate to **Users and Access** → **Keys** → **App Store Connect API**
   - Click **+** (Generate API Key)
   - **Name**: "Atitia CI/CD"
   - **Access**: **App Manager** (or **Admin** if you have access)
   - Click **Generate**

3. **Save Credentials (IMPORTANT - Can only download once!):**
   - **Key ID**: Copy this (e.g., `ABC123DEF4`)
   - **Issuer ID**: Copy this (UUID format, found at top of Keys page)
   - **Download .p8 file**: Click **Download API Key** → Save securely!

4. **Convert .p8 to Base64:**
   ```bash
   base64 -i AuthKey_ABC123DEF4.p8 | pbcopy
   ```
   Save this base64 string!

---

### Step 5: Add iOS Secrets to GitHub

Go to: **https://github.com/bantirathodtech/atitia/settings/secrets/actions**

Add these secrets:

1. **`IOS_CERTIFICATE_BASE64`**
   - Value: The base64 string from Step 3 (certificate)
   - Description: "iOS distribution certificate (P12, base64 encoded)"

2. **`IOS_CERTIFICATE_PASSWORD`**
   - Value: The password you set when exporting P12
   - Description: "Password for iOS distribution certificate"

3. **`IOS_PROVISIONING_PROFILE_BASE64`**
   - Value: The base64 string from Step 3 (provisioning profile)
   - Description: "iOS App Store provisioning profile (base64 encoded)"

4. **`APP_STORE_CONNECT_API_KEY_ID`**
   - Value: The Key ID from Step 4
   - Description: "App Store Connect API Key ID"

5. **`APP_STORE_CONNECT_API_ISSUER`**
   - Value: The Issuer ID from Step 4
   - Description: "App Store Connect API Issuer ID"

6. **`APP_STORE_CONNECT_API_KEY`**
   - Value: The base64 string from Step 4 (.p8 file)
   - Description: "App Store Connect API Key (P8, base64 encoded)"

---

## 🌐 PART 2: Web Deployment Setup (Firebase Hosting)

### Step 1: Verify Firebase Project ✅

**Already configured:**
- ✅ Project ID: `atitia-87925`
- ✅ Firebase initialized
- ✅ Web app configured

**Verify:**
```bash
# Check Firebase project
firebase projects:list
```

---

### Step 2: Create Firebase Service Account

1. **Go to Firebase Console:**
   - https://console.firebase.google.com
   - Select project: **atitia-87925**

2. **Create Service Account:**
   - Go to **Project Settings** (gear icon) → **Service Accounts**
   - Click **"Generate new private key"**
   - Click **"Generate key"** in the dialog
   - **IMPORTANT**: JSON file downloads automatically - save it securely!

3. **Enable Required APIs:**
   - Go to [Google Cloud Console](https://console.cloud.google.com)
   - Select project: **atitia-87925**
   - Enable APIs:
     - Firebase Hosting API
     - Cloud Build API (if using Cloud Build)

---

### Step 3: Initialize Firebase Hosting (If Not Done)

If Firebase Hosting is not set up:

```bash
# Install Firebase CLI (if not installed)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize hosting
firebase init hosting

# Follow prompts:
# - Select existing project: atitia-87925
# - Public directory: build/web
# - Single-page app: Yes
# - GitHub Actions: Yes
```

---

### Step 4: Add Web Secrets to GitHub

Go to: **https://github.com/bantirathodtech/atitia/settings/secrets/actions**

Add these secrets:

1. **`FIREBASE_SERVICE_ACCOUNT`**
   - Value: **Entire JSON content** from Step 2 (the downloaded JSON file)
   - Description: "Firebase service account JSON for hosting deployment"
   - **Note**: Paste the entire JSON object (starts with `{` and ends with `}`)

2. **`FIREBASE_PROJECT_ID`**
   - Value: `atitia-87925`
   - Description: "Firebase project ID"

---

## ✅ Verification Checklist

### iOS Setup:
- [ ] Apple Developer account active
- [ ] Certificate exported and converted to base64
- [ ] Provisioning profile exported and converted to base64
- [ ] App Store Connect API key created
- [ ] All 6 iOS secrets added to GitHub

### Web Setup:
- [ ] Firebase service account JSON downloaded
- [ ] Firebase Hosting initialized (if needed)
- [ ] Both web secrets added to GitHub

---

## 🚀 Test Deployment

Once all secrets are configured:

1. **Create Version Tag:**
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```

2. **Monitor Deployment:**
   - Go to: https://github.com/bantirathodtech/atitia/actions
   - Watch for: **🚀 Deploy to Stores - Production** workflow
   - Check all 3 platforms: Android ✅, iOS ✅, Web ✅

3. **Verify Builds:**
   - Android: AAB artifact should be created
   - iOS: IPA artifact should be created
   - Web: Should deploy to Firebase Hosting

---

## 🔧 Troubleshooting

### iOS Issues:

**"Code signing required"**
- Verify certificate and provisioning profile are correct
- Check Bundle ID matches: `com.avishio.atitia`
- Ensure App Store Connect API key has correct permissions

**"Invalid provisioning profile"**
- Regenerate provisioning profile in Apple Developer Portal
- Update `IOS_PROVISIONING_PROFILE_BASE64` secret

### Web Issues:

**"Firebase authentication failed"**
- Verify service account JSON is complete (entire JSON object)
- Check `FIREBASE_PROJECT_ID` matches project
- Ensure Firebase Hosting API is enabled

**"Deployment failed"**
- Check Firebase Hosting is initialized: `firebase init hosting`
- Verify `firebase.json` is configured correctly

---

## 📚 Additional Resources

- **iOS Signing Guide**: `docs/IOS_SIGNING_SETUP.md`
- **GitHub Secrets Setup**: `docs/GITHUB_SECRETS_SETUP.md`
- **Firebase Hosting Docs**: https://firebase.google.com/docs/hosting
- **App Store Connect API**: https://developer.apple.com/documentation/appstoreconnectapi

---

## 🎯 Quick Reference

### iOS Secrets (6 total):
- `IOS_CERTIFICATE_BASE64`
- `IOS_CERTIFICATE_PASSWORD`
- `IOS_PROVISIONING_PROFILE_BASE64`
- `APP_STORE_CONNECT_API_KEY_ID`
- `APP_STORE_CONNECT_API_ISSUER`
- `APP_STORE_CONNECT_API_KEY`

### Web Secrets (2 total):
- `FIREBASE_SERVICE_ACCOUNT` (JSON content)
- `FIREBASE_PROJECT_ID` (`atitia-87925`)

---

**Status**: Ready to configure! Follow steps above. ✅

