# 🔥 Test Firebase Setup Guide

**Purpose:** Test your app with a separate Firebase project before using production Firebase.

---

## 🎯 Quick Start

### Step 1: Create Test Firebase Project

1. Go to: https://console.firebase.google.com/
2. Click **"Add project"** or **"Create a project"**
3. Name it: `atitia-test` (or any name you prefer)
4. Follow the setup wizard
5. **Optional:** Disable Google Analytics for test project

### Step 2: Get Test Firebase Credentials

1. In Firebase Console, click **⚙️ Project Settings**
2. Scroll to **"Your apps"** section
3. Add apps for each platform (Web, Android, iOS) if not already added
4. For each app, copy the credentials (see below)

### Step 3: Run App with Test Firebase

**Option A: Environment Variable (Recommended)**
```bash
export USE_TEST_FIREBASE=true
export FIREBASE_TEST_PROJECT_ID=your-test-project-id
export FIREBASE_TEST_PROJECT_NUMBER=your-test-project-number
export FIREBASE_TEST_STORAGE_BUCKET=your-test-project-id.firebasestorage.app
export FIREBASE_TEST_AUTH_DOMAIN=your-test-project-id.firebaseapp.com
export FIREBASE_TEST_WEB_API_KEY=your-test-web-api-key
export FIREBASE_TEST_ANDROID_API_KEY=your-test-android-api-key
export FIREBASE_TEST_IOS_API_KEY=your-test-ios-api-key
export FIREBASE_TEST_WEB_APP_ID=1:PROJECT_NUMBER:web:APP_ID
export FIREBASE_TEST_ANDROID_APP_ID=1:PROJECT_NUMBER:android:APP_ID
export FIREBASE_TEST_IOS_APP_ID=1:PROJECT_NUMBER:ios:APP_ID
export FIREBASE_TEST_MESSAGING_SENDER_ID=PROJECT_NUMBER

flutter run
```

**Option B: Build-Time (Dart Define)**
```bash
flutter run --dart-define=USE_TEST_FIREBASE=true \
  --dart-define=FIREBASE_TEST_PROJECT_ID=your-test-project-id \
  --dart-define=FIREBASE_TEST_PROJECT_NUMBER=your-test-project-number \
  --dart-define=FIREBASE_TEST_STORAGE_BUCKET=your-test-project-id.firebasestorage.app \
  --dart-define=FIREBASE_TEST_AUTH_DOMAIN=your-test-project-id.firebaseapp.com \
  --dart-define=FIREBASE_TEST_WEB_API_KEY=your-test-web-api-key \
  --dart-define=FIREBASE_TEST_ANDROID_API_KEY=your-test-android-api-key \
  --dart-define=FIREBASE_TEST_IOS_API_KEY=your-test-ios-api-key \
  --dart-define=FIREBASE_TEST_WEB_APP_ID=1:PROJECT_NUMBER:web:APP_ID \
  --dart-define=FIREBASE_TEST_ANDROID_APP_ID=1:PROJECT_NUMBER:android:APP_ID \
  --dart-define=FIREBASE_TEST_IOS_APP_ID=1:PROJECT_NUMBER:ios:APP_ID \
  --dart-define=FIREBASE_TEST_MESSAGING_SENDER_ID=PROJECT_NUMBER
```

**Option C: Use Production Firebase (Default)**
```bash
flutter run
# No environment variables needed - uses production Firebase
```

---

## 📋 Where to Find Test Firebase Credentials

### Web App Credentials

1. Firebase Console → ⚙️ Project Settings
2. Scroll to **"Your apps"** → Click **Web app** (or add one)
3. Copy from config snippet:
   - **API Key:** `apiKey: "AIzaSy..."`
   - **App ID:** `appId: "1:PROJECT_NUMBER:web:APP_ID"`
   - **Measurement ID:** `measurementId: "G-XXXXXXXXXX"` (if Analytics enabled)

### Android App Credentials

1. Firebase Console → ⚙️ Project Settings
2. Scroll to **"Your apps"** → Click **Android app** (or add one)
3. Download `google-services.json` or copy from config snippet:
   - **API Key:** `apiKey: "AIzaSy..."`
   - **App ID:** `appId: "1:PROJECT_NUMBER:android:APP_ID"`
   - **Package Name:** `package_name: "com.avishio.atitia"`

### iOS App Credentials

1. Firebase Console → ⚙️ Project Settings
2. Scroll to **"Your apps"** → Click **iOS app** (or add one)
3. Download `GoogleService-Info.plist` or copy from config snippet:
   - **API Key:** `API_KEY: "AIzaSy..."`
   - **App ID:** `GOOGLE_APP_ID: "1:PROJECT_NUMBER:ios:APP_ID"`
   - **Bundle ID:** `BUNDLE_ID: "com.avishio.atitia"`

### Project-Level Credentials

1. Firebase Console → ⚙️ Project Settings → **General** tab
2. Find:
   - **Project ID:** `your-test-project-id`
   - **Project Number:** `123456789012` (Messaging Sender ID)

---

## 🔄 Switching Back to Production

**Simply remove the environment variables:**
```bash
unset USE_TEST_FIREBASE
unset FIREBASE_TEST_PROJECT_ID
# ... unset all FIREBASE_TEST_* variables

flutter run
# Now uses production Firebase
```

---

## ✅ Verification

**Check which Firebase is being used:**
1. Run the app
2. Check console logs - should show:
   - `✅ Firebase initialized with project: atitia-87925` (production)
   - OR `✅ Firebase initialized with project: your-test-project-id` (test)

**Verify in Firebase Console:**
- Test Firebase: Check if test data appears in Firestore
- Production Firebase: Check if production data appears in Firestore

---

## 📝 Backup Test Credentials

**Save test credentials to `.secrets/firebase/test-firebase-config.json`:**

1. Open `.secrets/firebase/test-firebase-config.json`
2. Replace all `YOUR_TEST_*` placeholders with actual values
3. Save the file

**Example:**
```json
{
  "test": {
    "project_id": "atitia-test-12345",
    "project_number": "987654321098",
    "storage_bucket": "atitia-test-12345.firebasestorage.app",
    "auth_domain": "atitia-test-12345.firebaseapp.com",
    "web": {
      "api_key": "AIzaSyTest123...",
      "app_id": "1:987654321098:web:test123",
      "measurement_id": "G-TEST123"
    },
    "android": {
      "api_key": "AIzaSyTest456...",
      "app_id": "1:987654321098:android:test456"
    },
    "ios": {
      "api_key": "AIzaSyTest789...",
      "app_id": "1:987654321098:ios:test789"
    },
    "messaging_sender_id": "987654321098"
  }
}
```

---

## 🚀 Quick Test Script

**Create `test-firebase.sh`:**
```bash
#!/bin/bash
export USE_TEST_FIREBASE=true
export FIREBASE_TEST_PROJECT_ID=your-test-project-id
export FIREBASE_TEST_PROJECT_NUMBER=your-test-project-number
export FIREBASE_TEST_STORAGE_BUCKET=your-test-project-id.firebasestorage.app
export FIREBASE_TEST_AUTH_DOMAIN=your-test-project-id.firebaseapp.com
# ... add all other test credentials

flutter run
```

**Make it executable:**
```bash
chmod +x test-firebase.sh
./test-firebase.sh
```

---

## ⚠️ Important Notes

1. **Test Firebase is completely separate:**
   - Different database
   - Different storage
   - Different users
   - Test data won't affect production

2. **Always test with test Firebase first:**
   - Verify all features work
   - Test authentication
   - Test database operations
   - Test file uploads

3. **Switch to production only when ready:**
   - All features tested and working
   - Ready for release
   - Remove `USE_TEST_FIREBASE=true` environment variable

---

## 📋 Checklist

Before switching to production:

- [ ] Test Firebase project created
- [ ] All test credentials obtained
- [ ] App tested with test Firebase (`USE_TEST_FIREBASE=true`)
- [ ] Authentication working
- [ ] Database operations working
- [ ] File uploads working
- [ ] All features verified
- [ ] Ready to switch to production Firebase

---

**Status:** ✅ Test Firebase support added | ⏳ Need to create test Firebase project and get credentials

