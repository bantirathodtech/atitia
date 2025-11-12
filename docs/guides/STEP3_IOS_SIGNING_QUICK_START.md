# 🍎 Step 3: iOS Signing Setup - Quick Start

**Status:** Ready to configure iOS code signing for App Store deployment.

---

## 📋 **What You Need**

1. ✅ Apple Developer Account ($99/year)
2. ✅ Xcode installed (latest version)
3. ✅ Valid Apple ID with Developer Program membership

---

## 🚀 **Quick Setup (5 Minutes)**

### **Option A: Automatic (Recommended)**

1. **Open Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Select Runner Target:**
   - Click **Runner** project (blue icon)
   - Select **Runner** target under TARGETS
   - Go to **Signing & Capabilities** tab

3. **Enable Automatic Signing:**
   - ✅ Check **"Automatically manage signing"**
   - Select your **Team** (your Apple Developer account)
   - Bundle ID: `com.avishio.atitia` (should be pre-filled)

4. **Xcode Will Automatically:**
   - ✅ Create signing certificate
   - ✅ Create provisioning profile
   - ✅ Configure entitlements

5. **Verify:**
   - You should see ✅ green checkmarks
   - No errors in signing section

---

### **Option B: Manual Setup** (If automatic fails)

See detailed guide: `docs/IOS_SIGNING_SETUP.md`

---

## 🔐 **Export Certificates for CI/CD**

After Xcode sets up signing, export for GitHub Secrets:

### **1. Export Certificate (.p12)**

```bash
# Open Keychain Access
open /Applications/Utilities/Keychain\ Access.app

# Find your "Apple Distribution" certificate
# Right-click → Export "Apple Distribution: Your Name"
# Save as .p12 file with password
# Note: Remember the password you set!
```

### **2. Export Provisioning Profile**

```bash
# Location: ~/Library/MobileDevice/Provisioning Profiles/
# Find profile ending in .mobileprovision
# Copy it (this is your provisioning profile)
```

### **3. Convert to Base64 for GitHub Secrets**

```bash
# Certificate
base64 -i YourCertificate.p12 | tr -d '\n' > certificate_base64.txt

# Provisioning Profile
base64 -i YourProfile.mobileprovision | tr -d '\n' > profile_base64.txt
```

---

## 🔑 **GitHub Secrets Needed**

Add these to: https://github.com/bantirathodtech/atitia/settings/secrets/actions

| Secret Name | Value | How to Get |
|------------|-------|------------|
| `IOS_CERTIFICATE_BASE64` | Base64 of .p12 file | Export from Keychain, convert to base64 |
| `IOS_CERTIFICATE_PASSWORD` | Password you set when exporting | The password you used when exporting .p12 |
| `IOS_PROVISIONING_PROFILE_BASE64` | Base64 of .mobileprovision | Export from Xcode, convert to base64 |
| `APP_STORE_CONNECT_API_KEY_ID` | API Key ID | App Store Connect → Users and Access → Keys |
| `APP_STORE_CONNECT_API_ISSUER` | API Issuer UUID | Same location as above |
| `APP_STORE_CONNECT_API_KEY` | Base64 of .p8 file | Download API key, convert to base64 |
| `APPLE_ID` | Your Apple ID email | Your Apple Developer account email |
| `APPLE_APP_SPECIFIC_PASSWORD` | App-specific password | Generate at appleid.apple.com |

---

## 📝 **Detailed Steps**

### **Step 1: Open in Xcode**
```bash
cd /Users/apple/Development/ProjectsFlutter/com.charyatani/atitia
open ios/Runner.xcworkspace
```

### **Step 2: Configure Signing**
1. Select **Runner** target
2. Go to **Signing & Capabilities**
3. Enable **"Automatically manage signing"**
4. Select your **Team**
5. Verify Bundle ID: `com.avishio.atitia`

### **Step 3: Export for CI/CD**
After Xcode creates certificates:

1. **Export Certificate:**
   - Open Keychain Access
   - Find "Apple Distribution: [Your Name]"
   - Right-click → Export
   - Save as `.p12` with password

2. **Get Provisioning Profile:**
   - Location: `~/Library/MobileDevice/Provisioning Profiles/`
   - Find `.mobileprovision` file

3. **Create App Store Connect API Key:**
   - Go to: https://appstoreconnect.apple.com
   - Users and Access → Keys
   - Generate new key with "App Manager" role
   - Download `.p8` key file

### **Step 4: Add to GitHub Secrets**
- Convert files to base64
- Add all 8 secrets listed above

---

## ✅ **Verification**

After setup, test locally:

```bash
# Build iOS (will test signing)
flutter build ios --release --no-codesign
```

---

## 🎯 **Next Steps**

1. ✅ Set up signing in Xcode (automatic)
2. ✅ Export certificates
3. ✅ Create App Store Connect API key
4. ✅ Add GitHub secrets
5. ✅ Test iOS build in CI/CD

---

**Need help?** See detailed guide: `docs/IOS_SIGNING_SETUP.md`

