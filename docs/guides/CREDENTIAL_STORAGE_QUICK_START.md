# 🔐 Credential Storage Quick Start Guide

## Overview

This guide shows you how to store credentials and verify they're working. The app automatically loads credentials when it starts.

## ✅ Step 1: Store Credentials

### Option A: Using the Example Script (Recommended)

1. **Get your credentials from Google Cloud Console:**
   - Go to: https://console.cloud.google.com/apis/credentials?project=atitia-87925
   - Copy your OAuth 2.0 Client IDs and Client Secret

2. **Edit the script:**
   ```bash
   # Open scripts/store_credentials_example.dart
   # Replace these placeholder values:
   ```

3. **Update with your actual credentials:**
   ```dart
   await helper.storeGoogleWebClientId('your-actual-web-client-id.apps.googleusercontent.com');
   await helper.storeGoogleAndroidClientId('your-actual-android-client-id.apps.googleusercontent.com');
   await helper.storeGoogleIosClientId('your-actual-ios-client-id.apps.googleusercontent.com');
   await helper.storeGoogleClientSecret('GOCSPX-your-actual-client-secret');
   ```

4. **Run the script:**
   ```bash
   dart run scripts/store_credentials_example.dart
   ```

### Option B: Using Flutter Code Directly

You can also store credentials programmatically in your app:

```dart
import 'package:atitia/common/utils/security/credential_storage_helper.dart';

final helper = CredentialStorageHelper();

// Store credentials
await helper.storeAllGoogleCredentials(
  webClientId: 'your-web-client-id.apps.googleusercontent.com',
  androidClientId: 'your-android-client-id.apps.googleusercontent.com',
  iosClientId: 'your-ios-client-id.apps.googleusercontent.com',
  clientSecret: 'GOCSPX-your-client-secret',
);
```

---

## ✅ Step 2: Verify Credentials

### Option A: Check in Debug Console

When you run the app, check the debug console for these messages:

```
✅ Google Sign-In initialized with credentials loaded from secure storage/environment
✅ Firestore: Offline persistence enabled
✅ Google Sign-In service initialized with credentials from secure storage
```

If you see these, credentials are loading correctly!

### Option B: Check Storage Directly

```dart
import 'package:atitia/common/utils/security/credential_storage_helper.dart';

final helper = CredentialStorageHelper();
final stored = await helper.checkStoredCredentials();

print('Web Client ID: ${stored['web_client_id'] ? "✅" : "❌"}');
print('Android Client ID: ${stored['android_client_id'] ? "✅" : "❌"}');
print('iOS Client ID: ${stored["ios_client_id"] ? "✅" : "❌"}');
print('Client Secret: ${stored["client_secret"] ? "✅" : "❌"}');
```

---

## ✅ Step 3: Run the App (Credentials Load Automatically)

### How It Works

When the app starts, here's what happens automatically:

1. **App Initialization (`main.dart`):**
   ```dart
   // Step 1: Validate environment
   await EnvironmentValidationService.validateEnvironment();
   
   // Step 2: Initialize Firebase services
   await FirebaseServiceInitializer.initialize();
   ```

2. **Firebase Service Initialization:**
   - `FirebaseServiceInitializer.initialize()` is called
   - This calls `getIt.auth.initialize()`
   - Which calls `_initializeGoogleSignIn()`

3. **Credential Loading:**
   ```dart
   // In FirebaseAuthService._initializeGoogleSignIn()
   final clientId = await _getClientIdAsync(); // Loads from secure storage
   final clientSecret = await _getClientSecretAsync(); // Loads from secure storage
   ```

4. **Priority Order:**
   - ✅ First: Try secure storage (`LocalStorageService`)
   - ✅ Second: Try environment variables (`String.fromEnvironment`)
   - ❌ Third: Throw exception if neither is configured

### Run the App

```bash
# For iOS
flutter run -d ios

# For Android
flutter run -d android

# For Web
flutter run -d chrome

# For macOS
flutter run -d macos
```

**Check the debug console** for credential loading messages!

---

## ✅ Step 4: Test Route Protection

### Run Integration Tests

```bash
flutter test test/integration/role_based_access_test.dart
```

### What the Tests Verify

The integration tests verify:
- ✅ Guests cannot access owner routes (redirected to guest dashboard)
- ✅ Owners cannot access guest routes (redirected to owner dashboard)
- ✅ Unauthenticated users are redirected to splash screen
- ✅ Authenticated guests can access guest routes
- ✅ Authenticated owners can access owner routes
- ✅ Route validation logic works correctly

### Test Results

The tests verify `RouteGuard` logic:
```dart
// Example test
expect(
  RouteGuard.getRedirectPath(AppRoutes.ownerHome, 'guest'),
  AppRoutes.guestHome, // Guest should be redirected
);
```

---

## 🔍 Troubleshooting

### Credentials Not Loading

**Symptom:** See warnings like:
```
⚠️ Google Sign-In initialization error: ...
❌ Google Web Client ID: Not configured
```

**Solution:**
1. Verify credentials are stored:
   ```dart
   final helper = CredentialStorageHelper();
   final stored = await helper.checkStoredCredentials();
   ```
2. Check credentials don't contain placeholders (`YOUR_`, `REPLACE_WITH`)
3. Ensure credentials are valid format

### App Won't Start

**Symptom:** App crashes or shows emergency fallback screen

**Solution:**
1. Check Firebase configuration is correct
2. Verify all required credentials are present
3. Check network connection (Firebase needs internet)
4. Review error logs in debug console

### Google Sign-In Not Working

**Symptom:** Google Sign-In button doesn't work or shows errors

**Solution:**
1. Verify credentials match your app's bundle ID/package name
2. Check OAuth consent screen is configured in Google Cloud Console
3. Ensure credentials are for the correct platform (web/Android/iOS)
4. Test on a real device (not simulator for iOS)

---

## 📝 Quick Reference

### Storage Keys

Credentials are stored with these keys:
- `google_web_client_id`
- `google_android_client_id`
- `google_ios_client_id`
- `google_client_secret`

### Loading Methods

```dart
// Load Web Client ID
final webId = await EnvironmentConfig.getGoogleSignInWebClientIdAsync();

// Load Android Client ID
final androidId = await EnvironmentConfig.getGoogleSignInAndroidClientIdAsync();

// Load iOS Client ID
final iosId = await EnvironmentConfig.getGoogleSignInIosClientIdAsync();

// Load Client Secret
final secret = await EnvironmentConfig.getGoogleSignInClientSecretAsync();

// Validate all credentials
final isValid = await EnvironmentConfig.validateCredentialsAsync();
```

---

## 🎯 Success Indicators

You'll know everything is working when you see:

1. **App starts successfully** ✅
2. **Debug console shows:**
   ```
   ✅ Firestore: Offline persistence enabled
   ✅ Google Sign-In initialized with credentials loaded from secure storage/environment
   ✅ Google Sign-In service initialized with credentials from secure storage
   ```
3. **Google Sign-In works** on the platform you're testing
4. **Integration tests pass:**
   ```
   All 8 tests passed
   ```

---

## 📚 Related Documentation

- `CREDENTIAL_STORAGE_GUIDE.md` - Detailed guide
- `scripts/README.md` - Scripts documentation
- `NEXT_STEPS_IMPLEMENTATION_SUMMARY.md` - Implementation summary
- `GOOGLE_CLIENT_SECRET_SETUP.md` - Google setup guide

---

*Last Updated: 2025-01-XX*

