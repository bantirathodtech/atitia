# 🍎 iOS Code Signing Setup Guide

Complete guide for configuring iOS code signing for App Store distribution.

---

## 📋 **PREREQUISITES**

1. ✅ Apple Developer Account ($99/year)
2. ✅ Xcode installed (latest version recommended)
3. ✅ Valid Apple ID with Developer Program membership

---

## 🔐 **STEP 1: CREATE APP ID**

1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to **Certificates, Identifiers & Profiles**
3. Click **Identifiers** → **+** (Add new)
4. Select **App IDs** → **Continue**
5. Select **App** → **Continue**
6. Configure:
   - **Description:** Atitia PG Management
   - **Bundle ID:** `com.avishio.atitia` (Explicit)
   - **Capabilities:** Enable required capabilities:
     - Push Notifications
     - Sign in with Apple (if using)
     - Associated Domains (if needed)
7. Click **Continue** → **Register**

---

## 📜 **STEP 2: CREATE DISTRIBUTION CERTIFICATE**

### Option A: Using Xcode (Recommended - Automatic)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** target
3. Go to **Signing & Capabilities** tab
4. Select your **Team**
5. Xcode will automatically:
   - Create signing certificate
   - Create provisioning profile
   - Configure entitlements

### Option B: Manual Certificate Creation

1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to **Certificates, Identifiers & Profiles** → **Certificates**
3. Click **+** (Add new)
4. Select **App Store and Ad Hoc** → **Continue**
5. Upload CSR (Certificate Signing Request):
   - On Mac: Open **Keychain Access** → **Certificate Assistant** → **Request a Certificate**
   - Enter your email and name
   - Save CSR to disk
6. Upload the CSR file
7. Download the certificate
8. Double-click to install in Keychain

---

## 📦 **STEP 3: CREATE PROVISIONING PROFILE**

### Using Xcode (Automatic - Recommended)

Xcode will automatically create provisioning profiles when you select your team. Just ensure:

1. Open Xcode project
2. Select **Runner** → **Signing & Capabilities**
3. Select your **Team**
4. Xcode handles the rest automatically

### Manual Creation (If Needed)

1. Go to [Apple Developer Portal](https://developer.apple.com/account)
2. Navigate to **Certificates, Identifiers & Profiles** → **Profiles**
3. Click **+** (Add new)
4. Select **App Store** → **Continue**
5. Select App ID: `com.avishio.atitia` → **Continue**
6. Select Certificate → **Continue**
7. Enter Profile Name: "Atitia App Store"
8. Click **Generate** → **Download**
9. Double-click to install in Xcode

---

## ⚙️ **STEP 4: CONFIGURE IN XCODE**

1. **Open Project:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Select Runner Target:**
   - In Xcode, select **Runner** project (blue icon)
   - Select **Runner** target (under TARGETS)

3. **Configure Signing:**
   - Go to **Signing & Capabilities** tab
   - Check **Automatically manage signing**
   - Select your **Team**
   - Verify Bundle Identifier: `com.avishio.atitia`
   - Xcode will show "✓" when configured correctly

4. **Verify Provisioning Profile:**
   - Under **Signing & Capabilities**
   - Should show: "Atitia App Store" or similar
   - Status should be "Valid"

---

## 📝 **STEP 5: UPDATE INFO.PLIST**

Verify `ios/Runner/Info.plist` contains:

```xml
<key>CFBundleIdentifier</key>
<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>

<key>CFBundleName</key>
<string>Atitia</string>

<key>CFBundleDisplayName</key>
<string>Atitia</string>

<key>CFBundleVersion</key>
<string>$(FLUTTER_BUILD_NUMBER)</string>

<key>CFBundleShortVersionString</key>
<string>$(FLUTTER_BUILD_NAME)</string>
```

---

## 🔍 **STEP 6: VERIFY CONFIGURATION**

Run these checks:

```bash
# 1. Check Flutter setup
flutter doctor -v

# 2. Verify iOS setup
cd ios
pod install
cd ..

# 3. Build for device (test signing)
flutter build ios --release --no-codesign
```

---

## 📱 **STEP 7: BUILD FOR APP STORE**

### Method 1: Using Xcode (Recommended)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Any iOS Device (arm64)** or **Generic iOS Device**
3. Go to **Product** → **Archive**
4. Wait for archive to complete
5. Click **Distribute App**
6. Select **App Store Connect**
7. Follow the wizard to upload

### Method 2: Using Flutter CLI

```bash
# Build IPA
flutter build ipa --release

# Output location:
# build/ios/ipa/atitia.ipa

# Upload using Transporter app or Xcode
```

### Method 3: Using CI/CD (Automated)

The `.github/workflows/deploy.yml` will handle this automatically when you:
1. Add iOS secrets to GitHub
2. Create a version tag: `git tag v1.0.0 && git push origin v1.0.0`

---

## 🔐 **STEP 8: APP STORE CONNECT API KEY (For CI/CD)**

To enable automated deployments:

1. **Create API Key:**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Navigate to **Users and Access** → **Keys** → **App Store Connect API**
   - Click **+** to create new key
   - Name: "Atitia CI/CD"
   - Role: **App Manager** (or appropriate role)
   - Click **Generate**

2. **Save Credentials:**
   - **Key ID**: Copy this (e.g., `ABC123DEF4`)
   - **Issuer ID**: Copy this (UUID format)
   - **Download .p8 file**: Save securely (can only download once!)

3. **Add to GitHub Secrets:**
   - `APP_STORE_CONNECT_API_KEY_ID`: The Key ID
   - `APP_STORE_CONNECT_API_ISSUER`: The Issuer ID
   - `APP_STORE_CONNECT_API_KEY`: Content of .p8 file

See `docs/GITHUB_SECRETS_SETUP.md` for detailed instructions.

---

## ✅ **VERIFICATION CHECKLIST**

Before building for App Store:

- [ ] Apple Developer Account active ($99/year paid)
- [ ] App ID created: `com.avishio.atitia`
- [ ] Distribution certificate installed
- [ ] Provisioning profile created and installed
- [ ] Xcode project configured with correct Team
- [ ] Bundle identifier matches: `com.avishio.atitia`
- [ ] Build number incremented in `pubspec.yaml`
- [ ] Version number set in `pubspec.yaml`
- [ ] Info.plist configured correctly
- [ ] Test build completed successfully

---

## 🆘 **TROUBLESHOOTING**

### "No signing certificate found"

**Solution:**
1. Verify Team is selected in Xcode
2. Check Apple Developer account membership is active
3. Try: Xcode → Preferences → Accounts → Download Manual Profiles

### "Provisioning profile doesn't match"

**Solution:**
1. Ensure Bundle ID in Xcode matches App ID
2. Regenerate provisioning profile in Apple Developer Portal
3. In Xcode: Product → Clean Build Folder

### "Code signing is required"

**Solution:**
1. Select correct Team in Signing & Capabilities
2. Ensure "Automatically manage signing" is checked
3. Verify internet connection (for automatic signing)

### "Invalid Bundle Identifier"

**Solution:**
1. Verify Bundle ID is registered in Apple Developer Portal
2. Check Info.plist matches Xcode settings
3. Ensure no special characters in Bundle ID

---

## 📞 **SUPPORT**

**Apple Developer Support:**
- Portal: https://developer.apple.com/support
- Documentation: https://developer.apple.com/documentation

**Flutter iOS Deployment:**
- Docs: https://flutter.dev/docs/deployment/ios

---

**Last Updated:** $(date)  
**For:** Atitia v1.0.0+1

