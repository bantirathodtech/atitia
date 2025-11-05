# Scripts Directory

This directory contains utility scripts for managing the Atitia app.

## Available Scripts

### 1. `store_credentials_example.dart`

Example script demonstrating how to store Google OAuth credentials in secure storage.

**Usage:**
```bash
dart run scripts/store_credentials_example.dart
```

**What it does:**
- Shows how to use `CredentialStorageHelper` to store credentials
- Checks current stored credentials
- Demonstrates storing individual credentials
- Demonstrates storing all credentials at once

**Note:** Replace placeholder values with your actual credentials from Google Cloud Console before running.

### 2. `verify_credentials.dart`

Verification script to check if Google OAuth credentials are properly stored and can be loaded.

**Usage:**
```bash
dart run scripts/verify_credentials.dart
```

**What it does:**
- Checks if credentials are stored in secure storage
- Tests loading credentials from secure storage
- Validates that credentials are not placeholders
- Tests async credential validation

**Output:**
- ✅ Shows which credentials are properly configured
- ❌ Shows which credentials are missing or invalid
- Provides next steps if credentials are missing

## Quick Start

### Step 1: Store Your Credentials

Edit `store_credentials_example.dart` and replace the placeholder values:

```dart
await helper.storeGoogleWebClientId('your-actual-web-client-id.apps.googleusercontent.com');
await helper.storeGoogleAndroidClientId('your-actual-android-client-id.apps.googleusercontent.com');
await helper.storeGoogleIosClientId('your-actual-ios-client-id.apps.googleusercontent.com');
await helper.storeGoogleClientSecret('GOCSPX-your-actual-client-secret');
```

Then run:
```bash
dart run scripts/store_credentials_example.dart
```

### Step 2: Verify Credentials

Run the verification script to ensure everything is working:

```bash
dart run scripts/verify_credentials.dart
```

### Step 3: Test the App

The app will automatically load credentials from secure storage when it starts. No additional configuration needed!

## Where to Get Credentials

1. Go to: https://console.cloud.google.com/apis/credentials?project=atitia-87925
2. Click on your OAuth 2.0 Client ID
3. Copy the Client ID and Client Secret

## Troubleshooting

### Scripts Won't Run

Make sure you're in the project root directory:
```bash
cd /path/to/atitia
```

### Credentials Not Loading

1. Run `verify_credentials.dart` to see what's missing
2. Check that credentials are stored: `dart run scripts/verify_credentials.dart`
3. Ensure credentials don't contain placeholders like `YOUR_` or `REPLACE_WITH`

### Permission Errors

If you get permission errors, ensure:
- You have write access to the secure storage
- The app has proper permissions on the device/emulator

## Related Documentation

- `CREDENTIAL_STORAGE_GUIDE.md` - Detailed guide on credential storage
- `GOOGLE_CLIENT_SECRET_SETUP.md` - Step-by-step setup instructions
- `lib/common/utils/security/credential_storage_helper.dart` - Source code

