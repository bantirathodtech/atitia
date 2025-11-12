# 🔐 Credential Storage Guide

## Overview

This guide explains how to store Google OAuth credentials securely in the Atitia app using the `CredentialStorageHelper` utility.

## Why Secure Storage?

- **Security**: Credentials are stored in FlutterSecureStorage (encrypted)
- **Runtime Loading**: Credentials are loaded at runtime, not at build time
- **Flexibility**: Can be updated without rebuilding the app
- **Git Safety**: Credentials never committed to version control

## Quick Start

### 1. Store Credentials in Secure Storage

```dart
import 'package:atitia/common/utils/security/credential_storage_helper.dart';

// Create helper instance
final helper = CredentialStorageHelper();

// Store Google OAuth credentials
await helper.storeGoogleWebClientId('your-web-client-id.apps.googleusercontent.com');
await helper.storeGoogleAndroidClientId('your-android-client-id.apps.googleusercontent.com');
await helper.storeGoogleIosClientId('your-ios-client-id.apps.googleusercontent.com');
await helper.storeGoogleClientSecret('GOCSPX-your-client-secret');
```

### 2. Store All Credentials at Once

```dart
final helper = CredentialStorageHelper();

final results = await helper.storeAllGoogleCredentials(
  webClientId: 'your-web-client-id.apps.googleusercontent.com',
  androidClientId: 'your-android-client-id.apps.googleusercontent.com',
  iosClientId: 'your-ios-client-id.apps.googleusercontent.com',
  clientSecret: 'GOCSPX-your-client-secret',
);

// Check results
results.forEach((key, success) {
  print('$key: ${success ? "✅ Stored" : "❌ Failed"}');
});
```

### 3. Check Stored Credentials

```dart
final helper = CredentialStorageHelper();
final stored = await helper.checkStoredCredentials();

print('Web Client ID: ${stored['web_client_id'] ? "✅" : "❌"}');
print('Android Client ID: ${stored['android_client_id'] ? "✅" : "❌"}');
print('iOS Client ID: ${stored['ios_client_id'] ? "✅" : "❌"}');
print('Client Secret: ${stored['client_secret'] ? "✅" : "❌"}');
```

### 4. Clear All Credentials

```dart
final helper = CredentialStorageHelper();
await helper.clearAllGoogleCredentials();
```

## How It Works

### Priority Order

When the app loads credentials, it follows this priority:

1. **Secure Storage** (highest priority)
   - Checks `LocalStorageService` for stored credentials
   - Keys: `google_web_client_id`, `google_android_client_id`, `google_ios_client_id`, `google_client_secret`

2. **Environment Variables** (fallback)
   - Uses `String.fromEnvironment()` for build-time configuration
   - Variables: `GOOGLE_SIGN_IN_WEB_CLIENT_ID`, `GOOGLE_SIGN_IN_ANDROID_CLIENT_ID`, etc.

3. **Exception** (if neither configured)
   - Throws exception with clear error message
   - Guides developer to configure credentials

### Automatic Loading

The app automatically loads credentials when:
- Firebase Auth service initializes
- Google Sign-In service initializes
- Environment validation runs

No manual loading needed - it happens automatically!

## Where to Get Credentials

### Google Cloud Console

1. Go to: https://console.cloud.google.com/apis/credentials?project=atitia-87925
2. Click on your OAuth 2.0 Client ID
3. Copy the Client ID and Client Secret

### Client IDs

- **Web Client ID**: Used for web platform
- **Android Client ID**: Used for Android app
- **iOS Client ID**: Used for iOS/macOS apps

### Client Secret

- **Required for**: Desktop platforms (macOS, Windows, Linux)
- **Not required for**: Mobile (Android/iOS) and Web
- **Format**: Starts with `GOCSPX-`

## Validation

The helper validates credentials before storing:

- **Client IDs**: Must contain `.apps.googleusercontent.com` or be at least 20 characters
- **Client Secret**: Must start with `GOCSPX-` or be at least 20 characters
- **Placeholders**: Rejects values containing `YOUR_` or `REPLACE_WITH`

## Troubleshooting

### Credentials Not Loading

1. **Check storage**: Use `checkStoredCredentials()` to verify
2. **Check environment variables**: Set during build if not using secure storage
3. **Check logs**: Look for `⚠️` warnings in debug output

### Invalid Format

- Ensure Client IDs end with `.apps.googleusercontent.com`
- Ensure Client Secret starts with `GOCSPX-`
- Remove any placeholders or `YOUR_` prefixes

### Credentials Not Working

- Verify credentials are correct in Google Cloud Console
- Check that credentials match your app's bundle ID/package name
- Ensure OAuth consent screen is configured

## Security Best Practices

1. ✅ **DO**: Store credentials in secure storage
2. ✅ **DO**: Use environment variables for CI/CD
3. ✅ **DO**: Validate credentials before storing
4. ❌ **DON'T**: Commit credentials to Git
5. ❌ **DON'T**: Hardcode credentials in code
6. ❌ **DON'T**: Log credentials in production

## Related Documentation

- `GOOGLE_CLIENT_SECRET_SETUP.md` - Detailed setup guide
- `GOOGLE_CLIENT_SECRET_STEP_BY_STEP.md` - Step-by-step instructions
- `.secrets/README.md` - Secure directory documentation
- `lib/common/utils/security/credential_storage_helper.dart` - Source code

