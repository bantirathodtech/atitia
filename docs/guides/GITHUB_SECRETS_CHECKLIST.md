# 📋 GitHub Secrets Checklist for Deployment

## ✅ Currently Configured

### Android Publishing
- ✅ `ANDROID_KEYSTORE_BASE64` - Android keystore (base64 encoded)
- ✅ `ANDROID_KEYSTORE_PASSWORD` - Keystore password
- ✅ `ANDROID_KEY_ALIAS` - Key alias
- ✅ `ANDROID_KEY_PASSWORD` - Key password

---

## ❌ Missing Secrets (Required for Deployment)

### iOS Publishing (App Store Connect)

**Required for automated iOS deployment:**

1. **iOS Code Signing Certificate**
   - Secret Name: `IOS_CERTIFICATE_BASE64`
   - Description: iOS distribution certificate (.p12 file, base64 encoded)
   - How to get:
     - Export from Keychain Access on macOS
     - Convert to base64: `base64 -i certificate.p12 | pbcopy`

2. **Certificate Password**
   - Secret Name: `IOS_CERTIFICATE_PASSWORD`
   - Description: Password for the iOS certificate

3. **Provisioning Profile**
   - Secret Name: `IOS_PROVISIONING_PROFILE_BASE64`
   - Description: iOS provisioning profile (.mobileprovision file, base64 encoded)
   - How to get:
     - Download from Apple Developer Portal
     - Convert to base64: `base64 -i profile.mobileprovision | pbcopy`

4. **App Store Connect API Key (for automated upload)**
   - Secret Name: `APP_STORE_CONNECT_API_KEY_ID`
   - Description: App Store Connect API key ID
   - How to get: Create in [App Store Connect](https://appstoreconnect.apple.com/access/api)

5. **App Store Connect API Issuer**
   - Secret Name: `APP_STORE_CONNECT_API_ISSUER`
   - Description: App Store Connect API issuer ID

6. **App Store Connect API Key**
   - Secret Name: `APP_STORE_CONNECT_API_KEY`
   - Description: App Store Connect API key (.p8 file content, base64 encoded)

**Optional (for manual upload):**
- `APPLE_ID` - Your Apple ID email
- `APPLE_APP_SPECIFIC_PASSWORD` - App-specific password (if using Apple ID)

---

### Web Deployment (Firebase Hosting)

**Required for automated web deployment:**

1. **Firebase Service Account**
   - Secret Name: `FIREBASE_SERVICE_ACCOUNT_JSON`
   - Description: Firebase service account JSON (for Firebase Hosting deployment)
   - How to get:
     - Go to [Firebase Console](https://console.firebase.google.com/)
     - Project Settings → Service Accounts
     - Click "Generate new private key"
     - Copy the entire JSON content

---

## 📝 Quick Setup Guide

### Option 1: Skip Store Uploads (Build Only)

If you just want to build artifacts without uploading:
- ✅ **Android**: Already configured - will build AAB
- ✅ **iOS**: Will build IPA (may need manual signing setup)
- ✅ **Web**: Will build web assets (can deploy manually later)

**Action**: No additional secrets needed if you're okay with manual uploads.

---

### Option 2: Full Automated Deployment

For automated store uploads, configure:
1. **iOS Secrets** (6-8 secrets) - See above
2. **Firebase Service Account** (1 secret) - See above

**Note**: Android is already configured ✅

---

## 🔗 Useful Links

- [App Store Connect API Keys](https://appstoreconnect.apple.com/access/api)
- [Firebase Service Accounts](https://console.firebase.google.com/)
- [iOS Code Signing Guide](../docs/IOS_SIGNING_SETUP.md)

---

## ⚠️ Next Steps

1. **For iOS**: Follow [iOS Signing Setup Guide](../docs/IOS_SIGNING_SETUP.md)
2. **For Web**: Generate Firebase service account JSON
3. **For Android**: ✅ Already ready!

**Status**: Android ready ✅ | iOS pending ⏸️ | Web pending ⏸️

