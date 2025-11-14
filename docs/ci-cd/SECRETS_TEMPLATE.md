# 🔐 Required GitHub Secrets Template

This document lists all required and optional secrets for the CI/CD pipeline.

## Required Secrets

### Android Deployment
- `ANDROID_KEYSTORE_BASE64` - Base64 encoded keystore file (for release builds)
- `ANDROID_KEYSTORE_PASSWORD` - Keystore password
- `ANDROID_KEY_ALIAS` - Key alias name
- `ANDROID_KEY_PASSWORD` - Key password

### iOS Deployment
- `IOS_CERTIFICATE_BASE64` - Base64 encoded .p12 certificate file
- `IOS_CERTIFICATE_PASSWORD` - Certificate password
- `IOS_PROVISIONING_PROFILE_BASE64` - Base64 encoded .mobileprovision file
- `APPLE_ID` - Apple ID for App Store Connect (optional)
- `APPLE_APP_SPECIFIC_PASSWORD` - App-specific password (optional)

### Store Credentials
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` - Google Play service account JSON (for automated upload)
- `APP_STORE_CONNECT_API_KEY_ID` - App Store Connect API key ID (optional)
- `APP_STORE_CONNECT_API_ISSUER` - App Store Connect API issuer (optional)
- `APP_STORE_CONNECT_API_KEY` - App Store Connect API key (optional)

### Web Deployment
- `FIREBASE_SERVICE_ACCOUNT` - Firebase service account JSON
- `FIREBASE_PROJECT_ID` - Firebase project ID

### Test Coverage
- Coverage reports are generated automatically and uploaded as artifacts (no secrets required)

## How to Add Secrets

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add each secret with the exact name listed above

## Base64 Encoding

To encode files for secrets:

```bash
# Android keystore
base64 -i android/keystore.jks | pbcopy  # macOS
base64 -i android/keystore.jks | xclip  # Linux

# iOS certificate
base64 -i certificate.p12 | pbcopy

# iOS provisioning profile
base64 -i profile.mobileprovision | pbcopy
```

## Security Notes

- ⚠️ Never commit secrets to the repository
- ⚠️ Rotate secrets regularly
- ⚠️ Use least-privilege access for service accounts
- ⚠️ Review secret access logs periodically

