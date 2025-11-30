# 🔥 Test Firebase - Quick Start

**Goal:** Test your app with a separate Firebase project before using production.

---

## ✅ What's Already Done

- ✅ Code updated to support test Firebase
- ✅ Environment variable support added
- ✅ Production Firebase remains default

---

## 🚀 Quick Steps

### 1. Create Test Firebase Project

1. Go to: https://console.firebase.google.com/
2. Click **"Add project"**
3. Name: `atitia-test` (or any name)
4. Follow wizard (disable Analytics if you want)

### 2. Get Test Credentials

**In Firebase Console → ⚙️ Project Settings:**

**For each platform (Web, Android, iOS):**
- Click on the app (or add one)
- Copy the credentials from config snippet

**You need:**
- Project ID
- Project Number (Messaging Sender ID)
- Web API Key + App ID
- Android API Key + App ID
- iOS API Key + App ID

### 3. Run with Test Firebase

**Simple way (set environment variables):**
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

### 4. Switch Back to Production

**Just remove the environment variable:**
```bash
unset USE_TEST_FIREBASE
flutter run
# Now uses production Firebase
```

---

## 📝 Save Test Credentials

**Update `.secrets/firebase/test-firebase-config.json`** with your test credentials for backup.

---

## ✅ Verify It's Working

**Check console logs:**
- Should show: `✅ Firebase initialized with project: your-test-project-id`

**Check Firebase Console:**
- Test data should appear in your test Firebase project
- Production data should NOT be affected

---

## 📚 Full Guide

See `TEST_FIREBASE_SETUP_GUIDE.md` for detailed instructions.

---

**Status:** ✅ Ready to use | ⏳ Need to create test Firebase project

