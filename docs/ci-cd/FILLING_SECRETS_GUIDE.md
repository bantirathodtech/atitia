# 📝 Complete Guide: Filling in Your Secrets

This guide helps you fill in all the secret values in your `.secrets/` folder.

---

## 🤖 Android Secrets

### 1. `keystore.jks`
**Location:** `.secrets/android/keystore.jks`

**If you already have a keystore:**
```bash
# Copy your existing keystore file
cp /path/to/your/keystore.jks .secrets/android/keystore.jks
```

**If you need to create a new keystore:**
```bash
cd .secrets/android
keytool -genkey -v -keystore keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias atitia-release
```

**If you have base64 encoded keystore:**
```bash
# If you have ANDROID_KEYSTORE_BASE64 file, decode it:
base64 -d .secrets/android/ANDROID_KEYSTORE_BASE64 > .secrets/android/keystore.jks
```

---

### 2. `keystore.properties`
**Location:** `.secrets/android/keystore.properties`

**Edit the file and fill in:**
```properties
storeFile=keystore.jks
storePassword=YOUR_ACTUAL_KEYSTORE_PASSWORD
keyAlias=atitia-release
keyPassword=YOUR_ACTUAL_KEY_PASSWORD
```

**Or if you have individual files:**
- Copy password from `ANDROID_KEYSTORE_PASSWORD` → `storePassword`
- Copy alias from `ANDROID_KEY_ALIAS` → `keyAlias`
- Copy password from `ANDROID_KEY_PASSWORD` → `keyPassword`

---

### 3. `service_account.json`
**Location:** `.secrets/android/service_account.json`

**If you already have it:**
- You already have this file with content! ✅
- It's your Google Play Console service account JSON

**If you need to get it:**
1. Go to [Google Play Console](https://play.google.com/console)
2. Navigate to **Setup** → **API access**
3. Create service account or use existing
4. Download JSON key file
5. Save as `.secrets/android/service_account.json`

---

## 🌐 Web/Firebase Secrets

### 1. `firebase_service_account.json`
**Location:** `.secrets/web/firebase_service_account.json`

**You already have this!** ✅
- Found in: `.secrets/android/FIREBASE_SERVICE_ACCOUNT`
- The organize script will copy it to the right place

**If you need to get it fresh:**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select project: `atitia-87925`
3. **Project Settings** → **Service Accounts**
4. Click **Generate New Private Key**
5. Download JSON file
6. Save as `.secrets/web/firebase_service_account.json`

---

### 2. `firebase_project_id.txt`
**Location:** `.secrets/web/firebase_project_id.txt`

**Your project ID is:** `atitia-87925`

**Create the file:**
```bash
echo "atitia-87925" > .secrets/web/firebase_project_id.txt
```

**Or it will be auto-created from `config/firebase.json`**

---

## 🍎 iOS Secrets (Optional - for future)

### 1. `Certificates.p12`
**Location:** `.secrets/ios/Certificates.p12`

**How to get:**
1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Download distribution certificate
3. Import to Keychain Access (macOS)
4. Export as `.p12` with password
5. Save as `.secrets/ios/Certificates.p12`

**Or if you have base64:**
```bash
base64 -d .secrets/ios/IOS_CERTIFICATE_BASE64 > .secrets/ios/Certificates.p12
```

---

### 2. `certificate_password.txt`
**Location:** `.secrets/ios/certificate_password.txt`

**Edit and add:**
```
YOUR_IOS_CERTIFICATE_PASSWORD
```

---

### 3. `ProvisionProfile.mobileprovision`
**Location:** `.secrets/ios/ProvisionProfile.mobileprovision`

**How to get:**
1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Download App Store provisioning profile
3. Save as `.secrets/ios/ProvisionProfile.mobileprovision`

**Or if you have base64:**
```bash
base64 -d .secrets/ios/IOS_PROVISIONING_PROFILE_BASE64 > .secrets/ios/ProvisionProfile.mobileprovision
```

---

### 4. `AppStoreConnect_APIKey.p8`
**Location:** `.secrets/ios/AppStoreConnect_APIKey.p8`

**How to get:**
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. **Users and Access** → **Keys** → **App Store Connect API**
3. Generate new API key
4. Download `.p8` file immediately (only shown once!)
5. Save as `.secrets/ios/AppStoreConnect_APIKey.p8`

**If you already have the content:**
- Copy from `.secrets/ios/APP_STORE_CONNECT_API_KEY` to `.secrets/ios/AppStoreConnect_APIKey.p8`

---

### 5. `appstore_api_key_id.txt`
**Location:** `.secrets/ios/appstore_api_key_id.txt`

**From the API key you created:**
- The Key ID is shown in App Store Connect
- Or in the filename of the `.p8` file (e.g., `AuthKey_ABC123XYZ.p8` → `ABC123XYZ`)

**Create file:**
```bash
echo "YOUR_KEY_ID" > .secrets/ios/appstore_api_key_id.txt
```

---

### 6. `appstore_api_issuer.txt`
**Location:** `.secrets/ios/appstore_api_issuer.txt`

**From Apple Developer account:**
- Issuer ID is shown in App Store Connect → Users and Access → Keys
- Usually a UUID format

**Create file:**
```bash
echo "YOUR_ISSUER_ID" > .secrets/ios/appstore_api_issuer.txt
```

---

### 7. `exportOptions.plist`
**Location:** `.secrets/ios/exportOptions.plist`

**Edit the template:**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>  <!-- Replace this -->
    <key>signingStyle</key>
    <string>automatic</string>
</dict>
</plist>
```

**Find Team ID:**
- [Apple Developer Portal](https://developer.apple.com/account) → Membership

---

## 💻 macOS Secrets (Optional - for future)

Same structure as iOS:
- `Certificates.p12`
- `certificate_password.txt`
- `ProvisionProfile.provisionprofile`
- `exportOptions.plist`

---

## 🔑 Other Secrets

### API Keys
**Location:** `.secrets/api-keys/`

Add any third-party API keys here:
- Razorpay
- Stripe
- Analytics services
- etc.

---

### Environment Variables
**Location:** `.secrets/common/.env`

```bash
# Firebase
FIREBASE_PROJECT_ID=atitia-87925

# API Keys
RAZORPAY_KEY_ID=rzp_xxxxx
RAZORPAY_KEY_SECRET=xxxxx

# Add more as needed
```

---

## ✅ Verification Steps

After filling in secrets:

1. **Run organization script:**
   ```bash
   bash scripts/organize-secrets-complete.sh
   ```

2. **Verify local secrets:**
   ```bash
   bash scripts/verify-secrets-local.sh
   ```

3. **Create backup:**
   ```bash
   bash scripts/backup-secrets.sh
   ```

4. **Check inventory:**
   - Update `.secrets/INVENTORY.md` with checkmarks

---

## 🆘 Need Help?

- **Android keystore lost?** → Must generate new (old app updates will fail)
- **iOS certificate lost?** → Regenerate via Apple Developer Portal
- **Firebase key lost?** → Regenerate via Firebase Console
- **App Store Connect API key lost?** → Cannot re-download, must create new

---

**Last Updated:** 2025-01-27

